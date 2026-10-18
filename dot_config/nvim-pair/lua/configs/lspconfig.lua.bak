-- 位置：~/.config/nvim-think/lua/configs/lspconfig.lua
--      ~/.config/nvim-pair/lua/configs/lspconfig.lua（兩邊同一份）
-- 需要 Neovim 0.11+（vim.lsp.config / vim.lsp.enable）

require("nvchad.configs.lspconfig").defaults()

-- rust-analyzer 建議用 rustup 裝的版本：rustup component add rust-analyzer
-- 它跟著 toolchain 走，兩個 NVIM_APPNAME 都能用，不必在各自的 mason 裡重裝
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      procMacro = { enable = true },
      inlayHints = {
        typeHints = { enable = true },
        parameterHints = { enable = true },
        chainingHints = { enable = true },
      },
    },
  },
})

local servers = {
  "rust_analyzer",
  "html",
  "cssls",
  -- 原本 ~/.config/nvim 有用到的其他 server 加在這裡，例如 "pyright", "lua_ls"
}

vim.lsp.enable(servers)
