-- 位置：~/.config/nvim-pair/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })

-- AI（Claude Code）
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Claude: toggle" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude: focus" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Claude: add current file" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude: send selection" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude: deny diff" })

-- AI（GitHub Copilot CLI agent）
local function copilot_agent()
  require("snacks").terminal.toggle("copilot", {
    cwd = vim.fn.getcwd(),
    win = { position = "right", width = 0.38 },
  })
end
map("n", "<leader>ag", copilot_agent, { desc = "Copilot agent: toggle" })
-- terminal 裡不能用 <leader>（空白鍵會延遲），改用 Ctrl+Alt+g 收起面板
map({ "n", "t" }, "<C-A-g>", copilot_agent, { desc = "Copilot agent: toggle" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
