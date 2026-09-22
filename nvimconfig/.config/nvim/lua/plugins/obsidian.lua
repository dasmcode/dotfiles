return {
	"obsidian-nvim/obsidian.nvim",
	ft = {"markdown","lua"},
	-- lazy = false,
	version = "*", -- use latest release, remove to use latest commit
	---@module 'obsidian'
	---@diagnostic disable-next-line: undefined-doc-name
	---@type obsidian.config
	opts = {
		picker = {
			name = "snacks.picker",
		},
		legacy_commands = false,
		-- Use the name entered in `:Obsidian new` as the filename
		-- instead of the default timestamp/random Zettelkasten ID.
		note_id_func = function(title)
			return title
		end,
		workspaces = {
			{
				name = "b",
				path = "~/Documents/b",
			},
		},
	},
	config = function(_, opts)
		local obsidian = require("obsidian")
		obsidian.setup(opts)

		-- `vim.fn.input({ completion = "file" })` displays paths in the
		-- command-line escaped (for example, `My\\ Notes`).  Obsidian uses
		-- that value as a note id, so unescape spaces before creating the note.
		local api = require("obsidian.api")
		local input = api.input
		api.input = function(prompt, input_opts)
			local result = input(prompt, input_opts)
			if result and input_opts and input_opts.completion == "file" then
				result = result:gsub("\\([ \\t])", "%1")
			end
			return result
		end
	end,
	keys = {
		{ "<leader>on", mode = { "n" }, "<cmd>Obsidian new<cr>", desc = "New Note" },
		{ "<leader>oo", mode = { "n" }, "<cmd>Obsidian open<cr>", desc = "Open Note in Obsidian" },
		{ "<leader>oh", mode = { "n" }, "<cmd>Obsidian help<cr>", desc = "Obsidian Help" },
		{ "<leader>og", mode = { "n" }, "<cmd>Obsidian helpgrep<cr>", desc = "Obsidian Help Grep" },
		{ "<leader>os", mode = { "n" }, "<cmd>Obsidian search<cr>", desc = "Search Notes Grep" },
		{ "<leader>ot", mode = { "n" }, "<cmd>Obsidian tags<cr>", desc = "Search Tags" },
		{ "<leader>oa", mode = { "n" }, "<cmd>Obsidian<cr>", desc = "Open Obsidian Commands Picker" },
	},
}
