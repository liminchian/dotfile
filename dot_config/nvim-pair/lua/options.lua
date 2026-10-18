-- 位置：~/.config/nvim-pair/lua/options.lua

require "nvchad.options"

local o = vim.opt
o.scrolloff = 8
o.cursorline = true
o.relativenumber = true
o.signcolumn = "yes"

vim.lsp.inlay_hint.enable(true)

-- herdr 每次啟動都會重開，session 不存 terminal buffer
o.sessionoptions:remove "terminal"
