return {
	{ "nvim-mini/mini.ai", lazy = false, version = false, config = function() require("mini.ai").setup() end },
	{ "nvim-mini/mini.surround", lazy = false, version = false, config = function() require("mini.surround").setup() end },
	{ "nvim-mini/mini.move", lazy = false, version = false, config = function() require("mini.move").setup() end },
	{ "nvim-mini/mini.jump", lazy = false, version = false, config = function() require("mini.jump").setup() end },
}
