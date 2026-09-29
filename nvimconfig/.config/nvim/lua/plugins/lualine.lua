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
			lualine_a = {
				{ "mode", separator = { right = "", left = "" } },
			},
			lualine_z = {
				{ "location", separator = { right = "", left = "" } },
			},
			lualine_c = {
				{
					"buffers",
					show_filename_only = true, -- Shows shortened relative path when set to false.
					hide_filename_extension = false, -- Hide filename extension when set to true.
					show_modified_status = true, -- Shows indicator when the buffer is modified.

					mode = 0, -- 0: Shows buffer name
					-- 1: Shows buffer index
					-- 2: Shows buffer name + buffer index
					-- 3: Shows buffer number
					-- 4: Shows buffer name + buffer number

					max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,

					symbols = {
						modified = " ●", -- Text to show when the buffer is modified
						alternate_file = "󱞩 ", -- Text to show to identify the alternate file
						directory = "", -- Text to show when the buffer is a directory
					},
				},
			},
			lualine_x = {
				{
					"lsp_status",
					icon = "",
					symbols = {
						spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
						done = "",
						separator = " ",
					},
					ignore_lsp = {},
					show_name = true,
				},
				{
					"fileformat",
					symbols = {
						unix = "",
						dos = "",
						mac = "",
					},
				},
				{
					"filetype",
					colored = true, -- Displays filetype icon in color if set to true
					icon_only = false, -- Display only an icon for filetype
					icon = { align = "right" }, -- Display filetype icon on the right hand side
				},
			},
		},
	},
}
