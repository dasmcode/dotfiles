return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
			themable = true,
			diagnostics = "nvim_lsp",
			color_icons = true,
		},
		highlights = require("catppuccin.special.bufferline").get_theme(),
	},
}
