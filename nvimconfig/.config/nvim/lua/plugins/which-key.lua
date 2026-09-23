return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>w", proxy = "<c-w>", group = "windows" },
			{ "<leader>o", group = "Obsidian", icon =""},
			{ "<leader>l", group = "Lazy", icon ="󰒲"},
			{ "<leader>f", group = "Pickers", icon =""},
			{ "<leader>g", group = "Git Actions", icon =""},
			{ "<leader>u", group = "Toggles", icon =""},
			{ "<leader>b", group = "Buffers", icon =""},
			{ "<leader>r", group = "Search", icon =""},
			{ "<leader>x", group = "Trouble", icon ="🚦"},
		}
	},
	keys = {
		{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
	},
}
