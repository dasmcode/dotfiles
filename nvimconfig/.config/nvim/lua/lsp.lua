require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"yamlls",
		"basedpyright",
		"ruff",
		"clangd",
		"bashls",
		"jsonls",
		"pylsp",
	},
})

vim.lsp.enable({
	"pylsp",
	"lua_ls",
	"yamlls",
	"basedpyright",
	"ruff",
	"clangd",
	"bashls",
	"jsonls",
})
