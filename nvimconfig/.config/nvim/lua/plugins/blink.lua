require("blink.cmp").setup({
  keymap = {
    preset = "enter",
  },

  cmdline = {
	  enabled = false,
  },

  appearance = {
	  nerd_font_variant = "mono",
  },

  completion = {
	  documentation = {
		  auto_show = true,
		  auto_show_delay_ms = 200,
	  },
	  ghost_text = {
		  enabled = true
	  },
  },

  sources = {
	  default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = {
	  implementation = "prefer_rust_with_warning",
  },
  signature = {
	  enabled = true
  },
})
