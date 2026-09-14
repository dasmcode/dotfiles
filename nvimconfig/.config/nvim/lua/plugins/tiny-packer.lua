return {
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10, -- Low priority to catch other plugins' keybindings
		config = function()
			require("tiny-glimmer").setup({
				enabled = true,
				overwrite = {
					search = { enabled = true },
					undo = { enabled = true },
					redo = { enabled = true },
				},
			})
		end,
	},
	{

		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{
				"folke/snacks.nvim",
				opts = {
					terminal = {},
				},
			},
		},
		event = "LspAttach",
		opts = {
			-- Use Snacks for the action picker and Neovim's built-in diff preview.
			picker = "snacks",
			backend = "vim",
		},
		keys = {
			{
				"<leader>ca",
				mode = { "n", "x" },
				function()
					require("tiny-code-action").code_action()
				end,
				desc = "Code Action",
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "ghost",
				transparent_bg = true,
				options = {
					show_source = { enabled = true },
					multilines = { enabled = true },
					override_open_float = true,
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
}
