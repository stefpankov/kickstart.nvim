return {
  -- Linters
  {
    "mfussenegger/nvim-lint",
    config = function ()
      -- [[ Configure linting ]]
      require('lint').linters_by_ft = {
        typescript = {'eslint_d',},
        typescriptreact = {'eslint_d',},
        javascript = {'eslint_d',},
        javascriptreact = {'eslint_d',},
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },

  {
    'stevearc/conform.nvim',
    config = function ()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
        },
      })

      vim.keymap.set("n", "<leader>cf", function ()
        require('conform').format()
      end, { desc = "[C]ode [F]ormat" })
    end
  }
}
