vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/christoomey/vim-tmux-navigator",
	{ src = "nvim-treesitter/nvim-treesitter", branch = "main" },
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "Saghen/blink.cmp", version="v1"},
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/NeogitOrg/neogit",
})


--- mini completions --- 
-- require("mini.completion").setup({
--     lsp_completion = {
--         auto_setup = true,
--     }
-- })

--- nvim treesitter ----
require("plugins.treesitter")

---  lsp_completion ----
require("lsp")
require("plugins.blink")


--- mini plugins ----
require("plugins.tabline")
require("plugins.mini-ai")
require("plugins.mini-statusline")
require("plugins.mini-files")
require("plugins.mini-others")
require("plugins.mini-picker")
require("plugins.neogit")


