return {
    "mfussenegger/nvim-lint",

    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "ruff" },
            dockerfile = { "hadolint" },
            yaml = { "yamllint" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
