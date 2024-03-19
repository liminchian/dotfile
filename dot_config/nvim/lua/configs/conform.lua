local options = {
  lsp_fallback = true,

  formatters_by_ft = {
    rust = { "rustfmt", "rustywind" },

    -- neovim
    lua = { "stylua" },

    -- general
    json = { "prettier" },
    yaml = { "yamlfmt" },
  },
}

require("conform").setup(options)
