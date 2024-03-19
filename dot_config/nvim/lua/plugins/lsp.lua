local plugins = {
	{ "elkowar/yuck.vim", lazy = false },

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
		dependencies = {
			{
				"folke/neoconf.nvim",
				cmd = "Neoconf",
			},
		},
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- lua stuff
				"lua-language-server",
				"stylua",

				-- web dev stuff
				"css-lsp",
				"tailwindcss-language-server",
				"rustywind",
				"html-lsp",
				"typescript-language-server",
				"deno",
				"prettier",

				-- rust
				"rust-analyzer",

				-- python
				"pyright",
				"black",
				"mypy",
				"ruff",
				"isort",

				-- general
				"taplo",
				"json-lsp",
				"yamlfmt",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- defaults
				"vim",
				"lua",
				"vimdoc",

				-- web dev
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",

				-- low level
				"c",
				"zig",

				-- document
				"markdown",
				"markdown_inline",

				-- high level
				"rust",
				"python",

				-- config
				"yuck",
				"rasi",
				"scss",
				"toml",
				"json",
				"yaml",
			},
		},
	},
}

return plugins
