return {
	"nvim-mini/mini.comment",
	lazy = false,
	version = false,
	config = function()
		require("mini.comment").setup({
			mappings = {
				comment = "<leader>/", -- operator (works with motions)
				comment_visual = "<leader>/", -- visual selection
				comment_line = "<leader>//", -- current line
			},
		})
	end,
}
