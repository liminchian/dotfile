local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		rust = { "rustfmt", "rustywind" },
		python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },

		-- neovim
		lua = { "stylua" },

		-- general
		json = { "prettier" },
		jsonc = { "deno_fmt" },
		yaml = { "yamlfmt" },
	},
}

require("conform").setup(options)
