-- 位置：~/.config/nvim-pair/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })

-- AI
map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI chat" })
map({ "n", "v" }, "<leader>ap", "<cmd>CodeCompanionActions<cr>", { desc = "AI actions" })
map("v", "<leader>ai", ":CodeCompanion ", { desc = "AI inline edit" })
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to AI chat" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
