return {
	"nvim-mini/mini.files",
	lazy = false,
	version = false,
	config = function()
		local MiniFiles = require("mini.files")
		MiniFiles.setup({
			mappings = {
				go_in_plus = "<CR>",
				go_in = "L",
				go_out = "_",
				go_out_plus = "H",
			},
			options = { permanent_delete = false },
		})
	end,
	keys = {
		{ "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" } },
		{
			"<leader>-",
			function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				MiniFiles.reveal_cwd()
			end,
			{ desc = "Toggle into currently opened file" },
		},
	},
}
