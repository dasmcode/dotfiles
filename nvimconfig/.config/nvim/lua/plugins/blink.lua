return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },

	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {

		keymap = {
			preset = "enter",
		},

		cmdline = {
			keymap = { preset = "super-tab" },
			completion = { menu = { auto_show = true } },
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			menu = {
				-- draw = {
				-- 	columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				-- },
				border = "rounded",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = {
					border = "rounded",
					desired_min_width = 15,
				},
			},
			-- ghost_text = {
			-- 	enabled = true,
			-- },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			-- add vim-dadbod-completion to your completion providers
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		signature = {
			enabled = true,
		},
	},
}
