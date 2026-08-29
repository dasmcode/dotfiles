vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1" },
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/flash.nvim",
	"https://github.com/abecodes/tabout.nvim",

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/meanderingprogrammer/render-markdown.nvim",

	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/lewis6991/gitsigns.nvim",

	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/akinsho/bufferline.nvim",
})
--- nvim treesitter ----
require("plugins.treesitter")

--- formatter ----
require("plugins.conform")

---  lsp_completion ----
require("lsp")
require("plugins.blink")

--- mini plugins ----
require("plugins.mini-ai")
require("plugins.mini-files")
require("plugins.mini-others")
require("plugins.mini-picker")
require("plugins.mini-clue")

---neo-git----
require("plugins.neogit")

---git signs----
require("plugins.git-signs")

---lualine and buffer line----
require("plugins.lualine")
require("plugins.bufferline")

require("plugins.flash")
require("plugins.tabout")
require("plugins.markdown")
