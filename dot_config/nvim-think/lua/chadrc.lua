-- 位置：~/.config/nvim-think/lua/chadrc.lua
-- think 模式：自己思考，沒有 AI，Zed 風格的精簡 UI

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin", -- Mocha
  -- 想讓 think 模式改成淺色，換成 Latte（名稱請先用 <leader>th 確認）：
  -- theme = "catppuccin-latte",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
  tabufline = {
    enabled = true,
    lazyload = true,
  },
  cmp = {
    style = "flat_dark",
  },
}

M.nvdash = {
  load_on_startup = false,
}

return M
