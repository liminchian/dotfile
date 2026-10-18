-- 位置：~/.config/nvim-pair/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

-- Zed 習慣的快捷鍵
map("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("n", "<C-S-p>", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- 程式碼導航與 LSP（Zed 風格，見 zedkeys.lua）
require("zedkeys").setup()

-- terminal / agent 面板：連按兩次 Ctrl+h/j/k/l 跳出並換視窗（見 termnav.lua）
require("termnav").setup()

-- AI：右側 herdr 面板 + Claude IDE 橋接，<leader>a（見 agents.lua）
require("agents").setup()

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
