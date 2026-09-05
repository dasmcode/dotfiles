return {
	"stevearc/conform.nvim",
	lazy = false,
	event = {"BufWritePre"},
	cmd = {"ConformInfo"},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			dockerfile = { "dockerfmt" },
			python = {"isort","ruff_format"},
			go = {"goimports", "gofumpt"},
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
		},
		-- format_on_save = {
		-- 	timeout_ms = 500,
		-- 	lsp_format = "fallback",
		-- },
	},
	keys = {
		{
			"<leader>fc",
			mode = { "n" },
			function()
				require("conform").format()
			end,
			desc = "Format current file",
		},
	},
}
