
--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
local MiniIcons = require("mini.icons")
MiniPick.setup()
MiniExtra.setup()
MiniIcons.setup()

-- keymaps
vim.keymap.set("n", "<leader>fb", function()
  MiniPick.builtin.buffers()
end, { desc = "Open buffers" })

vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>fa", function() MiniPick.builtin.files({},{
	source = { cwd = vim.uv.os_homedir(),},
}) end, { desc = "Mini File Picker All" })
vim.keymap.set("n", "<leader>fG", function()
  MiniPick.builtin.grep(
    { pattern = vim.fn.expand("<cword>") },
    {
      source = {
        cwd = vim.uv.os_homedir(),
      },
    }
  )
end, { desc = "Global Grep (Home)" })
vim.keymap.set("n", "<leader>fg", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>fd", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>fk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })
