return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	opts = {
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

		lsp_styles = {
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},

		integrations = {
			aerial = true,
			alpha = true,
			cmp = true,
			dashboard = true,
			flash = true,
			fzf = true,
			grug_far = true,
			headlines = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			leap = true,
			lsp_trouble = true,
			mason = true,
			navic = { enabled = true, custom_bg = "lualine" },
			neotest = true,
			neotree = true,
			noice = true,
			snacks = true,
			telescope = true,
			treesitter_context = true,
			which_key = true,
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
						},
					}
				end,
			},
		},
		specs = {
			{
				"akinsho/bufferline.nvim",
				optional = true,
				opts = function(_, opts)
					if (vim.g.colors_name or ""):find("catppuccin") then
						opts.highlights = require("catppuccin.special.bufferline").get_theme()
					end
				end,
			},
		},
	},
	config = function()
		vim.cmd.colorscheme("catppuccin-nvim")
		vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
	end,
}
