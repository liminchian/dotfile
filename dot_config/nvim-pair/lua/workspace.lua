-- 位置：~/.config/nvim-think/lua/workspace.lua
--      ~/.config/nvim-pair/lua/workspace.lua（兩邊同一份）
--
-- 功能：
--   1. 不帶參數啟動 → 自動回到上次的目錄，並還原該目錄的 session（開過的檔案、視窗配置）
--   2. 帶一個資料夾啟動（think ~/proj）→ 切到該資料夾並還原它的 session
--   3. Open Recent：列出最近開過的資料夾，選了就整個切換過去
--
-- 指令：
--   :Open <dir>   開啟資料夾（會先存目前的 session）
--   :Recent       最近的資料夾
--   :Workspaces   workspace 選單（釘選 + 最近 + 自動掃描到的 git 專案）
--   :WorkspacePin   釘選 / 取消釘選目前的資料夾
-- 快捷鍵：
--   <C-A-o> / <leader>fp   Open Recent（Zed 的 Open Recent 也是 Ctrl+Alt+O）
--   <C-A-w> / <leader>pp   Workspace 選單；在選單裡按 Alt+p 釘選 / 取消釘選
--   <leader>pa             釘選目前的資料夾
-- 啟動時先跳出 workspace 選單：設定環境變數 NVIM_WORKSPACE_PICK=1
--   （launcher 的「Choose workspace…」動作就是這樣做的）

local M = {}

-- 要掃描 git 專案的根目錄，依你的習慣修改（不存在的會自動略過）
local WORKSPACE_ROOTS = { "~/projects", "~/code", "~/src", "~/dev", "~/work" }
local SCAN_DEPTH = 3
local SKIP_DIRS = { node_modules = true, target = true, [".cache"] = true, vendor = true, dist = true }

local state_dir = vim.fn.stdpath "state"
local recent_file = state_dir .. "/recent-dirs.json"
local MAX_RECENT = 30

-- 釘選清單兩個模式共用：~/.local/state/editor-workspaces/pinned.json
local shared_state = (vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")) .. "/editor-workspaces"
local pinned_file = shared_state .. "/pinned.json"

-- ── 工具 ──────────────────────────────────────────────

local function normalize(dir)
  if not dir or dir == "" then
    return nil
  end
  local p = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(dir), ":p"))
  if #p > 1 then
    p = p:gsub("/+$", "")
  end
  if vim.fn.isdirectory(p) == 0 then
    return nil
  end
  return p
end

local function worth_recording(dir)
  return dir and dir ~= "/" and dir ~= normalize(vim.env.HOME)
end

local function read_recent()
  local f = io.open(recent_file, "r")
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read "*a")
  f:close()
  if not ok or type(data) ~= "table" then
    return {}
  end
  -- 過濾掉已經不存在的資料夾
  return vim.tbl_filter(function(d)
    return vim.fn.isdirectory(d) == 1
  end, data)
end

local function push_recent(dir)
  dir = normalize(dir)
  if not worth_recording(dir) then
    return
  end
  local list = { dir }
  for _, d in ipairs(read_recent()) do
    if d ~= dir and #list < MAX_RECENT then
      table.insert(list, d)
    end
  end
  vim.fn.mkdir(state_dir, "p")
  local f = io.open(recent_file, "w")
  if f then
    f:write(vim.json.encode(list))
    f:close()
  end
end

local function has_file_buffers()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.bo[b].buftype == "" and vim.api.nvim_buf_get_name(b) ~= "" then
      return true
    end
  end
  return false
end

local function open_tree_if_empty()
  vim.schedule(function()
    if not has_file_buffers() then
      pcall(vim.cmd, "NvimTreeOpen")
    end
  end)
end

local function load_session_for(dir)
  vim.fn.chdir(dir)
  local ok, p = pcall(require, "persistence")
  if ok then
    p.load()
  end
  push_recent(dir)
  open_tree_if_empty()
end

-- ── 對外功能 ──────────────────────────────────────────

function M.open(dir)
  dir = normalize(dir)
  if not dir then
    vim.notify("不是資料夾", vim.log.levels.WARN)
    return
  end
  if dir == normalize(vim.fn.getcwd()) then
    return
  end

  -- 有沒存檔的 buffer 就不切換，避免資料遺失
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.bo[b].modified then
      vim.notify("還有未存檔的檔案，先 :wa 再切換", vim.log.levels.WARN)
      return
    end
  end

  local ok, p = pcall(require, "persistence")
  if ok then
    p.save()
  end
  pcall(vim.cmd, "NvimTreeClose")
  vim.cmd "silent! %bdelete"
  load_session_for(dir)
end

function M.recent()
  local cwd = normalize(vim.fn.getcwd())
  local list = vim.tbl_filter(function(d)
    return d ~= cwd
  end, read_recent())
  if #list == 0 then
    vim.notify("還沒有最近的資料夾", vim.log.levels.INFO)
    return
  end

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  pickers
    .new(require("telescope.themes").get_dropdown { previewer = false }, {
      prompt_title = "Open Recent",
      finder = finders.new_table {
        results = list,
        entry_maker = function(d)
          return {
            value = d,
            display = vim.fn.fnamemodify(d, ":~"),
            ordinal = d,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry then
            M.open(entry.value)
          end
        end)
        return true
      end,
    })
    :find()
end

-- ── Workspace 選單 ────────────────────────────────────

local function read_json_list(path)
  local f = io.open(path, "r")
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read "*a")
  f:close()
  return (ok and type(data) == "table") and data or {}
end

local function write_json_list(path, list)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local f = io.open(path, "w")
  if f then
    f:write(vim.json.encode(list))
    f:close()
  end
end

local function read_pinned()
  return vim.tbl_filter(function(d)
    return vim.fn.isdirectory(d) == 1
  end, read_json_list(pinned_file))
end

function M.toggle_pin(dir)
  dir = normalize(dir or vim.fn.getcwd())
  if not dir then
    return
  end
  local list, found = {}, false
  for _, d in ipairs(read_pinned()) do
    if d == dir then
      found = true
    else
      table.insert(list, d)
    end
  end
  if not found then
    table.insert(list, 1, dir)
  end
  write_json_list(pinned_file, list)
  vim.notify((found and "取消釘選 " or "已釘選 ") .. vim.fn.fnamemodify(dir, ":~"))
end

-- 掃描根目錄底下的 git 專案（找到 .git 就不再往下）
local function scan_projects()
  local found = {}
  for _, root in ipairs(WORKSPACE_ROOTS) do
    root = normalize(root)
    if root then
      if vim.uv.fs_stat(root .. "/.git") then
        table.insert(found, root)
      end
      local ok, iter = pcall(vim.fs.dir, root, {
        depth = SCAN_DEPTH,
        skip = function(name)
          local base = vim.fs.basename(name)
          if SKIP_DIRS[base] or base == ".git" then
            return false
          end
          -- 已經是 git 專案的資料夾就不再深入
          return not vim.uv.fs_stat(root .. "/" .. name .. "/.git")
        end,
      })
      if ok then
        for name, kind in iter do
          if kind == "directory" and vim.uv.fs_stat(root .. "/" .. name .. "/.git") then
            table.insert(found, root .. "/" .. name)
          end
        end
      end
    end
  end
  return found
end

function M.pick()
  local cwd = normalize(vim.fn.getcwd())
  local seen, items = {}, {}
  local function add(list, kind)
    for _, d in ipairs(list) do
      d = normalize(d)
      if d and not seen[d] then
        seen[d] = true
        table.insert(items, { dir = d, kind = kind, current = d == cwd })
      end
    end
  end
  add(read_pinned(), "pinned")
  add(read_recent(), "recent")
  local projects = scan_projects()
  table.sort(projects)
  add(projects, "project")

  if #items == 0 then
    vim.notify("找不到任何 workspace，請修改 workspace.lua 裡的 WORKSPACE_ROOTS", vim.log.levels.WARN)
    return
  end

  local icons = { pinned = "★", recent = "◷", project = "" }
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local entry_display = require "telescope.pickers.entry_display"

  local displayer = entry_display.create {
    separator = "  ",
    items = { { width = 2 }, { width = 28 }, { remaining = true } },
  }

  pickers
    .new(require("telescope.themes").get_dropdown { previewer = false, layout_config = { width = 0.6 } }, {
      prompt_title = "Workspaces   (Alt+p 釘選)",
      finder = finders.new_table {
        results = items,
        entry_maker = function(it)
          local name = vim.fs.basename(it.dir)
          return {
            value = it,
            ordinal = name .. " " .. it.dir,
            display = function()
              return displayer {
                { icons[it.kind], "TelescopeResultsSpecialComment" },
                { name .. (it.current and " •" or ""), it.current and "TelescopeMatching" or nil },
                { vim.fn.fnamemodify(it.dir, ":~"), "Comment" },
              }
            end,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(bufnr, map)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry then
            M.open(entry.value.dir)
          end
        end)
        map({ "i", "n" }, "<M-p>", function()
          local entry = action_state.get_selected_entry()
          if entry then
            actions.close(bufnr)
            M.toggle_pin(entry.value.dir)
            vim.schedule(M.pick)
          end
        end)
        return true
      end,
    })
    :find()
end

-- ── 啟動與離開 ────────────────────────────────────────

function M.setup()
  vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "folds" }

  local group = vim.api.nvim_create_augroup("Workspace", { clear = true })
  local from_stdin = false

  vim.api.nvim_create_autocmd("StdinReadPre", {
    group = group,
    callback = function()
      from_stdin = true
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    nested = true,
    callback = function()
      if from_stdin then
        return
      end
      local argc = vim.fn.argc()

      if argc == 0 and vim.env.NVIM_WORKSPACE_PICK == "1" then
        -- launcher 的「Choose workspace…」：先跳出選單
        vim.schedule(M.pick)
      elseif argc == 0 then
        -- launcher 或直接執行 think：回到上次的目錄
        local last = read_recent()[1]
        if last then
          load_session_for(last)
        end
      elseif argc == 1 then
        -- think ~/proj 或 think .
        local dir = normalize(vim.fn.argv(0))
        if dir then
          local dirbuf = vim.fn.bufnr(vim.fn.argv(0))
          load_session_for(dir)
          if dirbuf > 0 and vim.api.nvim_buf_is_valid(dirbuf) then
            pcall(vim.api.nvim_buf_delete, dirbuf, { force = true })
          end
        end
      end
    end,
  })

  -- 切換目錄（:cd、nvim-tree 換 root）時也記下來
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      push_recent(vim.fn.getcwd())
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      push_recent(vim.fn.getcwd())
    end,
  })

  -- 存 session 前先關掉檔案樹，避免還原時出現空白的 tree buffer
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceSavePre",
    callback = function()
      pcall(vim.cmd, "NvimTreeClose")
    end,
  })

  vim.api.nvim_create_user_command("Open", function(opts)
    M.open(opts.args)
  end, { nargs = 1, complete = "dir", desc = "Open folder" })

  vim.api.nvim_create_user_command("Recent", M.recent, { desc = "Open recent folder" })

  vim.keymap.set("n", "<C-A-o>", M.recent, { desc = "Open recent folder" })
  vim.keymap.set("n", "<leader>fp", M.recent, { desc = "Open recent folder" })

  vim.api.nvim_create_user_command("Workspaces", M.pick, { desc = "Pick workspace" })
  vim.api.nvim_create_user_command("WorkspacePin", function()
    M.toggle_pin()
  end, { desc = "Pin / unpin current folder" })

  vim.keymap.set("n", "<C-A-w>", M.pick, { desc = "Pick workspace" })
  vim.keymap.set("n", "<leader>pp", M.pick, { desc = "Pick workspace" })
  vim.keymap.set("n", "<leader>pa", function()
    M.toggle_pin()
  end, { desc = "Pin / unpin current workspace" })
end

return M
