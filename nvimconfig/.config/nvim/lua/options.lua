vim.g.netrw_banner = 0
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Enable soft wrapping (like VS Code's editor.wordWrap = "on")
vim.opt.wrap = true

-- Break lines at words rather than hard boundary characters
vim.opt.linebreak = true

-- Add a visual indicator at the beginning of wrapped lines
vim.opt.showbreak = "↳ "

-- Make j and k move by visual/display lines instead of physical lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Remap 0 and $ to move to the beginning and end of visual lines
vim.keymap.set("n", "0", "g0", { silent = true })
vim.keymap.set("n", "$", "g$", { silent = true })

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true
vim.opt.inccommand = "split"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")
vim.opt.clipboard:append("unnamedplus")
vim.opt.isfname:append("@-@")
-- vim.opt.guicursor = ""
vim.opt.scrolloff = 8

vim.opt.colorcolumn = "0"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0
vim.opt.termguicolors = true

-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	desc = "Highlight when yanking (copying) text",
-- 	callback = function()
-- 		vim.hl.on_yank()
-- 	end,
-- })
-- single global status line --
vim.opt.laststatus = 3

-- Automatically save the session when Neovim closes or changes files
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.diagnostic.config({
	-- Show the diagnostic message inline at the end of the affected line.
	virtual_text = {
		spacing = 2,
		prefix = "●",
	},

	-- Show an icon in the sign column.
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},

	-- Underline the problematic text.
	underline = true,
	severity_sort = true,

	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = "󰌵 ",
			}

---@diagnostic disable-next-line: missing-return-value
			return icons[diagnostic.severity] or "  "
		end,
	},
})

-- Yaml specific options
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "yaml.helm-values", "yaml.gitlab" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
		vim.opt_local.autoindent = true
		vim.opt_local.smartindent = false
		vim.opt_local.textwidth = 0
	end,
})
