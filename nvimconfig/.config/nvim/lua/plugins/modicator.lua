return {
	"mawkler/modicator.nvim",
	dependencies = "catppuccin/nvim",
	init = function()
		vim.o.cursorline = true
		vim.o.number = true
		vim.o.termguicolors = true
	end,
	opts = {
		show_warnings = true,
	},
}
