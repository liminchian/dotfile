local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

capabilities.textDocument.foldInRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

local lspconfig = require("lspconfig")
local servers =
	{ "html", "cssls", "tailwindcss", "tsserver", "clangd", "pyright", "rust_analyzer", "taplo", "lua_ls", "jsonls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
	fold_virt_text_handler = handler,
})

lspconfig.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true)
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
