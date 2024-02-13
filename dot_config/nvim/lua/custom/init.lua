-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

local autocmd = vim.api.nvim_create_autocmd
autocmd("VimLeave", { command = "set guicursor=a:hor100" })

vim.o.foldcolumn = '0'
vim.o.foldenable = true
