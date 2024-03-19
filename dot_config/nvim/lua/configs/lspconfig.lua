local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls", "tailwindcss", "tsserver", "clangd", "pyright", "rust_analyzer", "taplo", "lua_ls",
  "jsonls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Without the loop, you would have to manually set up each LSP
--
-- lspconfig.html.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
--
-- lspconfig.cssls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

lspconfig.rust_analyzer.setup({
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(bufnr, true)
    configs.on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    ["rust_analyzer"] = {
      procMacro = {
        ignored = {
          leptos_macro = {
            "component",
            "server",
          },
        },
      },
    },
  },
})

lspconfig.tailwindcss.setup({
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
})
