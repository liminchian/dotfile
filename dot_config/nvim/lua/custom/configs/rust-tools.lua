local rt = require "rust-tools"
local on_attach = require("plugins.configs.lspconfig").on_attach

rt.setup {
  server = {
    on_attach = on_attach,
    standalone = false,
  },
}

rt.inlay_hints.enable()
rt.expand_macro.expand_macro()
rt.hover_actions.hover_actions()
