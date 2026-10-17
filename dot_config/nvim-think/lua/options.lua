-- 位置：~/.config/nvim-think/lua/options.lua

require "nvchad.options"

local o = vim.opt

o.cmdheight = 0          -- 底部不留 cmdline，交給 noice 的浮動視窗
o.scrolloff = 8
o.sidescrolloff = 8
o.cursorline = true
o.relativenumber = true
o.wrap = false
o.signcolumn = "yes"
o.fillchars = { eob = " " } -- 檔尾不顯示 ~

-- think 模式不顯示 inlay hints（型別、參數名等提示），保持畫面乾淨
-- 需要時用 <leader>cl 在目前檔案暫時打開
vim.lsp.inlay_hint.enable(false)
