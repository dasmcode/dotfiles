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

			--- Formatters
			"stylua",
			"tectonic",
			"mmdc",
			"ruff",
			"prettierd",
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
