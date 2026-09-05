return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        -- Enables component-aware auto-imports for React
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
        },
      },
    },
    config = function(_, opts)
      -- Shared keybinds for both TS and ESLint
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map_opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
        end,
      })

      -- Initialize TypeScript/React intelligence
      require("typescript-tools").setup(opts)

      -- Initialize ESLint engine to handle React hooks and code structure rules
      -- require("lspconfig").eslint.setup({
      --   on_attach = function(client, bufnr)
      --     -- Automatically triggers ESLint auto-fixes when saving React/TS files
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       buffer = bufnr,
      --       command = "EslintFixAll",
      --     })
      --   end,
      -- })
    end,
  },
}
