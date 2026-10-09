return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			diagnostics = {
				globals = {
					"vim",
					"Snacks",
					"dd",
					"hl",
				},
			},

			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},

			telemetry = {
				enable = false,
			},
		},
	},
}
