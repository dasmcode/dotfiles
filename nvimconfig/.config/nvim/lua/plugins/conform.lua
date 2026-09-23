return {
	"stevearc/conform.nvim",
	lazy = false,
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			toml = { "taplo" },
			dockerfile = { "dockerfmt" },
			python = { "isort", "ruff_format" },
			go = { "goimports", "gofumpt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
		},
		default_format_ops = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		}
	},
	keys = {
		{
			"<leader>cf",
			mode = { "n" },
			function()
				require("conform").format()
			end,
			desc = "Format current file",
		},
	},
}
