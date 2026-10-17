-- 位置：~/.config/nvim-think/lua/mappings.lua

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

-- 專注模式
map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
