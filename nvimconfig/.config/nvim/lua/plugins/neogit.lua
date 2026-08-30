return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"sindrets/diffview.nvim", -- optional

		"m00qek/baleia.nvim", -- optional

		"nvim-mini/mini.pick", -- optional
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
		{ "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit" },
		{ "<leader>gp", "<cmd>Neogit push<CR>", desc = "Git push" },
		{ "<leader>gl", "<cmd>Neogit pull<CR>", desc = "Git pull" },
	},
}
