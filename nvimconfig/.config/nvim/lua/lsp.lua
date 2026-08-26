require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		--- Language servers
		"lua_ls",
		"docker-language-server",
		"yamlls",
		"clangd",
		"bashls",
		"pylsp",
		"jsonls",

		--- Formatters
		"stylua",
		"black",
		"prettierd",
		"dockerfmt",
		"isort",

		--- Linters
		"kube-linter",
	},
})
