-- 位置：~/.config/nvim-think/lua/chadrc.lua
-- think 模式：自己思考，沒有 AI，Zed 風格的精簡 UI

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin", -- Mocha
  -- 想讓 think 模式改成淺色，換成 Latte（名稱請先用 <leader>th 確認）：
  -- theme = "catppuccin-latte",

  -- rust-analyzer 等 LSP 的語意色彩（namespace/struct/macro… 各自分色）
  integrations = { "semantic_tokens" },

  -- 粗細分層：關鍵字/巨集粗體、參數斜體、註解斜體
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    Include = { bold = true },
    ["@keyword"] = { bold = true },
    ["@keyword.function"] = { bold = true },
    ["@keyword.return"] = { bold = true },
    ["@keyword.conditional"] = { bold = true },
    ["@keyword.repeat"] = { bold = true },
    ["@keyword.storage"] = { bold = true },
    ["@keyword.exception"] = { bold = true },
    ["@function.macro"] = { bold = true },
    ["@lsp.type.macro"] = { bold = true },
    ["@variable.parameter"] = { italic = true },
    ["@lsp.type.parameter"] = { italic = true },
    -- namespace 原本跟參數、屬性同為紅色，改成青色
    ["@module"] = { fg = "cyan" },
    ["@lsp.type.namespace"] = { fg = "cyan" },
    ["@lsp.type.property"] = { fg = "teal" },
  },

  -- semantic_tokens 沒定義的群組只能用 hl_add
  hl_add = {
    ["@lsp.typemod.function.declaration"] = { bold = true },
    ["@lsp.typemod.method.declaration"] = { bold = true },
    ["@lsp.mod.mutable"] = { underline = true }, -- Rust 的 mut 變數加底線
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
