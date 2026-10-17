-- 位置：~/.config/nvim-think/lua/neovide.lua
-- think 模式：Zed 風格、安靜、留白多

if not vim.g.neovide then
  return
end

-- 字型：需要 Nerd Font 版本，NvChad 的圖示才會正常
vim.o.guifont = "VictorMono Nerd Font:h12"
vim.opt.linespace = 4

-- 內距：解決文字貼邊框的問題
vim.g.neovide_padding_top = 16
vim.g.neovide_padding_bottom = 12
vim.g.neovide_padding_left = 20
vim.g.neovide_padding_right = 20

-- 渲染：144Hz 螢幕
vim.g.neovide_refresh_rate = 144
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.1

-- 動畫：短而俐落，不拖尾
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_scroll_animation_far_lines = 1
vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.2
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_vfx_mode = ""

-- 浮動視窗：圓角、陰影、背景模糊
vim.g.neovide_floating_corner_radius = 0.3
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_hide_mouse_when_typing = true

-- 字體縮放：Ctrl+= / Ctrl+- / Ctrl+0
vim.g.neovide_scale_factor = 1.0
local function scale(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function() scale(1.1) end)
vim.keymap.set("n", "<C-->", function() scale(1 / 1.1) end)
vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end)

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
