return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	---@module 'obsidian'
	---@diagnostic disable-next-line: undefined-doc-name
	---@type obsidian.config
	opts = {
		picker = {
			name = "snacks.picker",
		},
		legacy_commands = false,
		workspaces = {
			{
				name = "b",
				path = "~/Documents/b",
			},
		},
	},
}
