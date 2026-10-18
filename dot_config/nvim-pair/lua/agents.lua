-- 位置：~/.config/nvim-pair/lua/agents.lua
-- pair 模式以 herdr 為主：一進來 herdr 就佔滿主視窗，agent 的分頁、workspace、狀態都交給 herdr
-- 開檔案（Ctrl+p 等）會把 herdr 換下去，Ctrl+Alt+a 隨時切回 herdr
-- Claude Code 在 herdr 的 pane 裡用 `claude --ide` 啟動，會自動連回 claudecode.nvim
--
--   <leader>aa / Ctrl+Alt+a  回到 herdr
--   <leader>ab  把目前檔案加給 Claude            <leader>as  送出選取範圍給 Claude（visual）
--   <leader>ay  接受 Claude 的 diff              <leader>an  拒絕 diff

local M = {}

-- 在目前視窗顯示 herdr（同一個 cwd 只會有一個 herdr terminal）
local function herdr()
  local term = require("snacks").terminal.get("herdr", { cwd = vim.fn.getcwd(), win = { position = "current" } })
  term:show()
  term:focus()
  vim.cmd.startinsert()
end

function M.setup()
  local map = vim.keymap.set

  map("n", "<leader>aa", herdr, { desc = "AI: herdr" })
  map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "AI: add current file" })
  map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "AI: send selection" })
  map("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "AI: accept diff" })
  map("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "AI: deny diff" })

  -- terminal 裡不能用 <leader>（空白鍵會延遲），改用 Ctrl+Alt+a
  map({ "n", "t" }, "<C-A-a>", herdr, { desc = "AI: herdr" })

  -- 啟動時（workspace 還原 session 之後）只留 herdr，session 還原的檔案（例如 README.md）一併關掉
  local function startup()
    herdr()
    vim.cmd "silent! only"
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].buflisted and vim.bo[b].buftype == "" and not vim.bo[b].modified then
        pcall(vim.api.nvim_buf_delete, b, {})
      end
    end
  end
  if vim.v.vim_did_enter == 1 then
    vim.schedule(startup)
  else
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = vim.schedule_wrap(startup) })
  end
end

return M
