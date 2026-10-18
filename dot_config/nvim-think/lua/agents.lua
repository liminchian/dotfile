-- 位置：~/.config/nvim-think/lua/agents.lua
-- Claude Code 與 GitHub Copilot CLI 共用同一組 <leader>a 快捷鍵
-- 用 <leader>ax 切換「目前的 agent」，其他鍵都作用在目前的 agent 上
--
--   <leader>aa  開關面板          <leader>af  聚焦到面板
--   <leader>ab  加入目前檔案      <leader>as  送出選取範圍（visual）
--   <leader>ay  接受 diff         <leader>an  拒絕 diff
--   <leader>ax  切換 Claude ↔ Copilot
--   <leader>ac  直接開 Claude     <leader>ag  直接開 Copilot
--   Ctrl+Alt+a  在面板裡（terminal mode）收起面板

local M = {}

vim.g.ai_agent = vim.g.ai_agent or "claude"

-- ── Copilot CLI（snacks.terminal）──────────────────────

local copilot_opts = function(create)
  return {
    cwd = vim.fn.getcwd(),
    create = create,
    win = { position = "right", width = 0.38 },
  }
end

local function copilot_get(create)
  return require("snacks").terminal.get("copilot", copilot_opts(create))
end

-- 用 bracketed paste 送文字，多行內容不會被當成 Enter 提前送出
local function copilot_send(text)
  local term, created = copilot_get(true)
  if not term then
    return
  end
  term:show()
  local function send()
    local job = vim.b[term.buf].terminal_job_id
    if job then
      vim.fn.chansend(job, "\27[200~" .. text .. "\27[201~")
    end
    term:focus()
    vim.cmd.startinsert()
  end
  -- 剛啟動的 copilot 需要一點時間才能接收輸入
  if created then
    vim.defer_fn(send, 1500)
  else
    send()
  end
end

local function rel_path(buf)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf or 0), ":.")
end

local function visual_lines()
  local a, b = vim.fn.line "v", vim.fn.line "."
  if a > b then
    a, b = b, a
  end
  vim.api.nvim_feedkeys(vim.keycode "<Esc>", "nx", false)
  return a, b, vim.api.nvim_buf_get_lines(0, a - 1, b, false)
end

-- ── 兩個 agent 的實作 ────────────────────────────────

local agents = {
  claude = {
    name = "Claude Code",
    toggle = function() vim.cmd "ClaudeCode" end,
    focus = function() vim.cmd "ClaudeCodeFocus" end,
    add_file = function() vim.cmd "ClaudeCodeAdd %" end,
    send_selection = function() vim.cmd "ClaudeCodeSend" end,
    accept = function() vim.cmd "ClaudeCodeDiffAccept" end,
    deny = function() vim.cmd "ClaudeCodeDiffDeny" end,
  },

  copilot = {
    name = "Copilot",
    toggle = function()
      require("snacks").terminal.toggle("copilot", copilot_opts(true))
    end,
    focus = function()
      local term = copilot_get(true)
      term:show()
      term:focus()
      vim.cmd.startinsert()
    end,
    -- Copilot CLI 用 @路徑 引用檔案
    add_file = function()
      copilot_send("@" .. rel_path() .. " ")
    end,
    send_selection = function()
      local path, ft = rel_path(), vim.bo.filetype
      local a, b, lines = visual_lines()
      copilot_send(string.format(
        "@%s（第 %d-%d 行）\n```%s\n%s\n```\n",
        path, a, b, ft, table.concat(lines, "\n")
      ))
    end,
    -- Copilot CLI 在自己的面板裡確認修改，沒有 Neovim 內的 diff
    accept = function()
      vim.notify("Copilot 的修改請在它的面板裡確認", vim.log.levels.INFO)
    end,
    deny = function()
      vim.notify("Copilot 的修改請在它的面板裡確認", vim.log.levels.INFO)
    end,
  },
}

local function run(action)
  return function()
    agents[vim.g.ai_agent][action]()
  end
end

local function use(name)
  return function()
    vim.g.ai_agent = name
    agents[name].toggle()
  end
end

function M.current()
  return agents[vim.g.ai_agent].name
end

function M.setup()
  local map = vim.keymap.set

  map("n", "<leader>aa", run "toggle", { desc = "AI: toggle panel" })
  map("n", "<leader>af", run "focus", { desc = "AI: focus panel" })
  map("n", "<leader>ab", run "add_file", { desc = "AI: add current file" })
  map("x", "<leader>as", run "send_selection", { desc = "AI: send selection" })
  map("n", "<leader>ay", run "accept", { desc = "AI: accept diff" })
  map("n", "<leader>an", run "deny", { desc = "AI: deny diff" })

  map("n", "<leader>ax", function()
    vim.g.ai_agent = vim.g.ai_agent == "claude" and "copilot" or "claude"
    vim.notify("AI agent → " .. M.current())
  end, { desc = "AI: switch agent" })

  map("n", "<leader>ac", use "claude", { desc = "AI: open Claude Code" })
  map("n", "<leader>ag", use "copilot", { desc = "AI: open Copilot" })

  -- terminal 裡不能用 <leader>（空白鍵會延遲），改用 Ctrl+Alt+a
  map({ "n", "t" }, "<C-A-a>", run "toggle", { desc = "AI: toggle panel" })
end

return M
