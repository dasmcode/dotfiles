local bufferline = require("bufferline")
bufferline.setup({
	options = {
		mode = "buffers",
		separator_style = "slant",
		themable = true,
		diagnostics = "nvim_lsp",
		color_icons = true,
	},
	highlights = require("catppuccin.special.bufferline").get_theme(),
})

