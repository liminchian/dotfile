-- 位置：~/.config/nvim-think/init.lua
-- 以 NvChad starter 的 init.lua 為基礎，最後多載入 neovide 設定

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- 載入主題
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "semantic_tokens")

-- terminal_color_0..15 跟著 base46 主題（snacks terminal 不會自己載入；換主題時 base46 也不重載 term）
dofile(vim.g.base46_cache .. "term")
vim.api.nvim_create_autocmd("User", {
  pattern = "NvThemeReload",
  callback = function()
    dofile(vim.g.base46_cache .. "term")
  end,
})

require "options"
require "autocmds"
require "neovide"
require("workspace").setup()

vim.schedule(function()
  require "mappings"
end)
