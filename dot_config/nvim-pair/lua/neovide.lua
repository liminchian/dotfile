-- 位置：~/.config/nvim-pair/lua/neovide.lua
-- pair 模式：留白少、資訊密度高、游標特效開著

if not vim.g.neovide then
  return
end

vim.o.guifont = "VictorMono Nerd Font:h11"
vim.opt.linespace = 2

vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 6
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10

vim.g.neovide_refresh_rate = 144
vim.g.neovide_refresh_rate_idle = 5

vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_cursor_animation_length = 0.08
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_cursor_vfx_mode = "railgun"

vim.g.neovide_floating_corner_radius = 0.3
vim.g.neovide_floating_shadow = true

vim.g.neovide_hide_mouse_when_typing = true

-- 輸入法只在 insert / cmdline 啟用，normal mode 不會誤觸 fcitx5
vim.g.neovide_input_ime = false
local ime = vim.api.nvim_create_augroup("ImeInput", { clear = true })
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = ime,
  callback = function() vim.g.neovide_input_ime = true end,
})
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  group = ime,
  callback = function() vim.g.neovide_input_ime = false end,
})
