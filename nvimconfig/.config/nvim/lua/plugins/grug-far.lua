return {
  "MagicDuck/grug-far.nvim",
  --- Ensure existing keymaps and opts remain unaffected
  config = function(_, opts)
    require("grug-far").setup(opts)
  end,
  keys = {
    {
      "<leader>rr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace Workspace",
    },
	{
      "<leader>rc",
      function()
        local grug = require("grug-far")
        grug.open({
			prefills = { paths = vim.fn.expand("%") },
		})
      end,
      mode = {"n"},
      desc = "Search and Replace",
    },
	{
      "<leader>rc",
      function()
        local grug = require("grug-far")
        grug.with_visual_selection({
			prefills = { paths = vim.fn.expand("%") },
		})
      end,
      mode = { "v" },
      desc = "Search and Replace Visual",
    },
  },
}
