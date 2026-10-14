return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		render = "virtual",
		-- Nerd Font Material Design solid rounded-square swatch.
		virtual_symbol = "󱓻",
		virtual_symbol_position = "inline",
		virtual_symbol_suffix = " ",
		enable_named_colors = true,
		enable_tailwind = true,
	},
}
