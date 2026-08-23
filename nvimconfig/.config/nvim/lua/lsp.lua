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
    },
})

vim.lsp.enable({
	"lua_ls",
	"yamlls",
	"basedpyright",
	"ruff",
	"clangd",
	"bashls",
	"jsonls",
})
