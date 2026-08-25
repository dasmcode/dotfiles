require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"yamlls",
		"clangd",
		"bashls",
		"stylua",
		"black",
		"jsonls",
		"pylsp",
		"kube-linter",
		"prettierd",
		"isort",
	},
})
-- vim.lsp.enable({
-- 	"pylsp",
-- 	"lua_ls",
-- 	"yamlls",
-- 	"basedpyright",
-- 	"ruff",
-- 	"clangd",
-- 	"bashls",
-- 	"jsonls",
-- })
