return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"esmuellert/codediff.nvim",

		"m00qek/baleia.nvim",

		"folke/snacks.nvim",
	},
	cmd = "Neogit",
	opts = {
		graph_style = "kitty",
		disable_line_numbers = false,
		disable_relative_line_numbers = false,
		commit_editor = {
			staged_diff_split_kind = "vsplit",
		},
		integrations = {
			codediff = true, 
			snacks = true,
		},
		diff_viewer = "codediff",
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
	},
}
