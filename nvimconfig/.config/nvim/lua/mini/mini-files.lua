
-- mini files ----
local MiniFiles = require("mini.files")
MiniFiles.setup({
	mappings = {
		go_in_plus = "<CR>",
		go_in = "L",
		go_out = "_",
		go_out_plus = "H",
	},
	options = {
		permanent_delete = false,
	},
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })
