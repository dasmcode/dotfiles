return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			--- Language servers
			"lua_ls",
			"docker-language-server",
			"yamlls",
			"clangd",
			"bashls",
			"jsonls",
			"postgres-language-server",
			"basedpyright",
			"gopls",
			"typescript-language-server",
			"eslint-lsp",

			--- Formatters
			"stylua",
			"tectonic",
			"mmdc",
			"isort",
			"ruff",
			"prettierd",
			"prettier",
			"dockerfmt",
			"gofumpt",
			"goimports",

			--- Linters
			"kube-linter",
			"hadolint",
			"yamllint",
		},
	},
	dependencies = {
		{ "mason-org/mason-lspconfig.nvim", opts = {} },
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
