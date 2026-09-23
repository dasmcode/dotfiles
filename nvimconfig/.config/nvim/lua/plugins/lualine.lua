return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {

		options = {
			theme = "catppuccin-nvim",
			globalstatus = true,
			component_separators = "",
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_c = { "buffers" },
			lualine_x = { "selectioncount", "lsp_status", "fileformat", "filetype" },
		},
	},
}
