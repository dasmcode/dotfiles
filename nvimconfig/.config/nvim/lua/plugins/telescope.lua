return {
	"nvim-telescope/telescope.nvim",
	version = "0.2.1",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				fzf = {},
			},
		})
		require("telescope").load_extension("fzf")
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader>en", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end, { desc = "Search in vim config directory" })

		vim.keymap.set("n", "<leader>ep", function()
			builtin.find_files({
				cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
			})
		end, { desc = "Search in lazy plugin directory" })
		require("config.telescope.multigrep").setup()
	end,
}
