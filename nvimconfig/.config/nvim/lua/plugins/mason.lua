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
			-- "pylsp",
			"jsonls",
			"postgres-language-server",
			"basedpyright",

			--- Formatters
			"stylua",
			"black",
			"prettierd",
			"dockerfmt",
			"isort",

			--- Linters
			"kube-linter",
		},
	},
	dependencies = {
		{ "mason-org/mason-lspconfig.nvim", opts = {} },
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
