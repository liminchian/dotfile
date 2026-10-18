-- 位置：~/.config/nvim-pair/lua/agents.lua
-- 右側面板跑 herdr：agent 的分頁、workspace、狀態側欄（working / blocked / done）都交給 herdr
-- Claude Code 在 herdr 的 pane 裡用 `claude --ide` 啟動，會自動連回 claudecode.nvim
-- Copilot 等其他 agent 直接在 herdr 裡開新 pane 跑
--
--   <leader>aa / Ctrl+Alt+a  開關 herdr 面板     <leader>af  聚焦到面板
--   <leader>ab  把目前檔案加給 Claude            <leader>as  送出選取範圍給 Claude（visual）
--   <leader>ay  接受 Claude 的 diff              <leader>an  拒絕 diff

local M = {}

local function herdr_opts()
  return { cwd = vim.fn.getcwd(), win = { position = "right", width = 0.45 } }
end

local function toggle()
  require("snacks").terminal.toggle("herdr", herdr_opts())
end

local function focus()
  local term = require("snacks").terminal.get("herdr", herdr_opts())
  term:show()
  term:focus()
  vim.cmd.startinsert()
end

function M.setup()
  local map = vim.keymap.set

  map("n", "<leader>aa", toggle, { desc = "AI: toggle herdr" })
  map("n", "<leader>af", focus, { desc = "AI: focus herdr" })
  map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "AI: add current file" })
  map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "AI: send selection" })
  map("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "AI: accept diff" })
  map("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "AI: deny diff" })

  -- terminal 裡不能用 <leader>（空白鍵會延遲），改用 Ctrl+Alt+a
  map({ "n", "t" }, "<C-A-a>", toggle, { desc = "AI: toggle herdr" })
end

return M
