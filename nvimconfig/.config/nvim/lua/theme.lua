vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }
-- require("catppuccin").setup({
--     auto_integrations = true,
-- })
require("catppuccin").setup({
	flavour = "mocha",

	transparent_background = false,
	term_colors = true,

	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = { "italic" },
		keywords = { "italic" },
		functions = {},
		variables = {},
	},

	auto_integrations = true,

	integrations = {
		blink_cmp = {
			style = "bordered",
		},
		gitsigns = { enabled = true },
		mini = {
			enabled = true,
			indentscope_color = "lavender",
		},
		diffview = true,
		neogit = true,
		lualine = {
			all = function(colors)
				---@type CtpIntegrationLualineOverride
				return {
					-- Specifying a normal-mode status line override for section a's background and b's foreground to use lavender like the main Catppuccin theme
					normal = {
						a = { bg = colors.lavender, gui = "italic" },
						b = { fg = colors.lavender },
					}
				}
			end
		},
	},
})

vim.cmd.colorscheme("catppuccin-nvim")
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
