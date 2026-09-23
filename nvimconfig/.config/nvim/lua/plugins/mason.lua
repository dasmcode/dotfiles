return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			--- Language servers
			"lua_ls",
			"dockerfile-language-server",
			"docker-compose-language-service",
			"yamlls",
			"clangd",
			"bashls",
			"jsonls",
			"postgres-language-server",
			"basedpyright",
			"gopls",
			"typescript-language-server",
			"eslint-lsp",
			"taplo",

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
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				automatic_enable = {
					exclude = {
						-- Use Conform and nvim-lint for these tools instead.
						"stylua",
						"ruff",
					},
				},
			},
		},
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
