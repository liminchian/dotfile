local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tailwindcss", "tsserver", "clangd", "pyright", "rust_analyzer", "taplo" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    userLanguages = {
      eelixir = "html-eex",
      eruby = "erb",
      rust = "html",
    },
  },
  filetypes = {
    "css",
    "scss",
    "sass",
    "postcss",
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "svelte",
    "vue",
    "rust",
  },
  root_dir = require("lspconfig").util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "windi.config.ts"
  ),
}

require("ufo").setup()

-- lspconfig.pyright.setup { blabla}
