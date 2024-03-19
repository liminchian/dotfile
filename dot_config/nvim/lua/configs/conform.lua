local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		rust = { "rustfmt" },
		html = { "rustywind" },

		-- neovim
		lua = { "stylua" },

		-- general
		toml = { "taplo" },
		json = { "prettier" },
		yaml = { "yamlfmt" },
	},
}

require("conform").setup(options)
