return {
	"nvim-mini/mini.icons",
	lazy = false,
	version = false,
	config = function()
		require("mini.icons").setup({
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = { dotenv = { glyph = "", hl = "MiniIconsYellow" } },
		})
		require("mini.icons").mock_nvim_web_devicons()
	end,
}
