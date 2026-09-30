return {
	"nvim-mini/mini.trailspace",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local MiniTrailspace = require("mini.trailspace")
		MiniTrailspace.setup({
			only_in_normal_buffers = true,
		})
		vim.keymap.set("n", "<leader>cw", function() MiniTrailspace.trim() end, { desc = "Erase Whitespace" })
		vim.keymap.set("n", "<leader>cl", function() MiniTrailspace.trim_last_lines() end, { desc = "Erase Blank Lines" })
		vim.api.nvim_create_autocmd("CursorMoved",{
			pattern="*",
			callback=function ()
				MiniTrailspace.unhighlight()
			end
		})
	end,
	version = false,
}
