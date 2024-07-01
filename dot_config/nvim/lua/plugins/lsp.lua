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
				config = function()
					require("neoconf").setup({})
				end,
			},
		},
	},

	{
		"williamboman/mason.nvim",
		lazy = true,
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
				"mypy",
				"ruff",

				-- general
				"taplo",
				"yamlfmt",
				"json-lsp",
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

	{
		"nvim-cmp",
		dependencies = {
			-- codeium
			{
				"Exafunction/codeium.nvim",
				cmd = "Codeium",
				build = ":Codeium Auth",
				opts = {},
			},
		},
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = "codeium",
				group_index = 1,
				priority = 100,
			})
		end,
	},
}

return plugins
