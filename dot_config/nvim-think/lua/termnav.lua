-- 位置：~/.config/nvim-think/lua/termnav.lua
--      ~/.config/nvim-pair/lua/termnav.lua（兩邊同一份）
--
-- 在 terminal / agent 面板裡：
--   Ctrl+h/j/k/l 按一次   → 照常送給 terminal（例如 shell 的 Ctrl+l 清畫面）
--   Ctrl+h/j/k/l 快速按兩次 → 直接跳出 terminal mode，移到該方向的視窗
-- 回到 terminal 視窗時自動進入 terminal mode，可以直接打字
--
-- Ctrl+\ 連按兩次 → 回到 normal mode
-- 編輯器裡的 Ctrl+h/j/k/l 維持 NvChad 原本的行為（按一次就換視窗）

local M = {}

-- 兩次按鍵之間的最長間隔（毫秒）；單按會延遲這麼久才送進 terminal
local TIMEOUT = 250

local DIRS = { ["<C-h>"] = "h", ["<C-j>"] = "j", ["<C-k>"] = "k", ["<C-l>"] = "l" }

local pending = {} -- key -> { timer, job }

local function clear(key)
  local p = pending[key]
  if p then
    p.timer:stop()
    p.timer:close()
    pending[key] = nil
  end
end

local function send(job, keys)
  if job then
    pcall(vim.fn.chansend, job, keys)
  end
end

local function handler(key, dir)
  local raw = vim.keycode(key)
  return function()
    local job = vim.b.terminal_job_id

    -- 第二次按：跳出並換視窗
    if pending[key] then
      clear(key)
      if vim.fn.winnr(dir) ~= vim.fn.winnr() then
        vim.cmd.stopinsert()
        vim.schedule(function()
          vim.cmd.wincmd(dir)
        end)
      else
        -- 那個方向沒有視窗，就當作兩次普通按鍵送出
        send(job, raw .. raw)
      end
      return
    end

    -- 第一次按：先等一下，看會不會有第二次
    local timer = vim.uv.new_timer()
    pending[key] = { timer = timer }
    timer:start(TIMEOUT, 0, vim.schedule_wrap(function()
      if pending[key] and pending[key].timer == timer then
        clear(key)
        send(job, raw)
      end
    end))
  end
end

function M.setup()
  for key, dir in pairs(DIRS) do
    vim.keymap.set("t", key, handler(key, dir), {
      desc = "Double-tap: leave terminal and go " .. dir,
    })
  end

  -- Ctrl+\ 連按兩次 → 回到 normal mode（取代原本的 Ctrl+\ Ctrl+n）
  -- 第二下放開 Ctrl 只按 \ 也可以
  local to_normal = { desc = "Terminal: to normal mode" }
  vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>", to_normal)
  vim.keymap.set("t", "<C-\\>\\", "<C-\\><C-n>", to_normal)

  -- 回到 terminal 視窗時自動進入 terminal mode
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("TermNavAutoInsert", { clear = true }),
    callback = function(ev)
      if vim.bo[ev.buf].buftype == "terminal" then
        vim.schedule(function()
          if vim.api.nvim_get_current_buf() == ev.buf and vim.fn.mode() ~= "t" then
            vim.cmd.startinsert()
          end
        end)
      end
    end,
  })
end

return M
