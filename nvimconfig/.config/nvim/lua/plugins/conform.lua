require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		dockerfile = { "dockerfmt" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.keymap.set("n", "<leader>fc", function()
	require("conform").format()
end, { desc = "Format current file" })
