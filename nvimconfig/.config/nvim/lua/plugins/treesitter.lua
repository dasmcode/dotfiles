return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"neovim-treesitter/treesitter-parser-registry",
			{
				"nvim-treesitter/nvim-treesitter-context",
				-- event = "LazyFile",
				opts = function()
					local tsc = require("treesitter-context")
					Snacks.toggle({
						name = "Treesitter Context",
						get = tsc.enabled,
						set = function(state)
							if state then
								tsc.enable()
							else
								tsc.disable()
							end
						end,
					}):map("<leader>ut")
					return { mode = "cursor", max_lines = 3 }
				end,
			},
		},
		config = function()
			local treesitter = require("nvim-treesitter")

			local ensure_installed = {
				"go",
				"rust",
				"typescript",
				"javascript",
				"tsx",
				"html",
				"css",
				"lua",
				"json",
				"bash",
				"http",
				"dockerfile",
				"python",
				"sql",
				"latex",
				"scss",
				"svelte",
				"typst",
				"vue",

				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
			}

			treesitter.install(ensure_installed)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = ensure_installed,
				callback = function()
					vim.treesitter.start() -- highlighting
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- folds
					vim.wo.foldmethod = "expr"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
				end,
			})
		end,
	},
}
