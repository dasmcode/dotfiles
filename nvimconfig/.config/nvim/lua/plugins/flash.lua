local function flash_cmd(fn_name)
	return function()
		-- Requiring the module here ensures flash.nvim only loads when you actually press the key
		require("flash")[fn_name]()
	end
end

vim.keymap.set({ "n", "x", "o" }, "s", flash_cmd("jump"), { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", flash_cmd("treesitter"), { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", flash_cmd("remote"), { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", flash_cmd("treesitter_search"), { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", flash_cmd("toggle"), { desc = "Toggle Flash Search" })

-- Replicate the 'VeryLazy' event setup
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- Safe require in case the plugin is downloading during the first boot
		pcall(function()
			require("flash").setup({
				modes = {
					search = {
						enabled = true,
					},
					char = {
						jump_labels = true,
					},
				},
			})
		end)
	end,
})
