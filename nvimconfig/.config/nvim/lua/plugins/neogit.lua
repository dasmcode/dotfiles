local neogit = require("neogit")

neogit.setup({
  integrations = {
    diffview = true,
  },

  disable_commit_confirmation = true,
})

-- keymaps --
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {
  desc = "Open Neogit",
})

vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", {
  desc = "Git commit",
})

vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", {
  desc = "Git push",
})

vim.keymap.set("n", "<leader>gl", "<cmd>Neogit pull<CR>", {
  desc = "Git pull",
})
