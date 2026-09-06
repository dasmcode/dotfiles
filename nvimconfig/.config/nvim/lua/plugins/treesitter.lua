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
					vim.api.nvim_create_autocmd("FileType", {
						callback = function(args)
							local lang = vim.treesitter.language.get_lang(args.match)

							if not lang then
								return
							end

							if not pcall(vim.treesitter.start, args.buf, lang) then
								return
							end

							vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
							vim.wo.foldmethod = "expr"
							vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end,
					})
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

			local parsers = {
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
				"yaml",
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

			treesitter.install(parsers)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)

					if not lang then
						return
					end

					if not pcall(vim.treesitter.start, args.buf, lang) then
						return
					end

					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldmethod = "expr"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
