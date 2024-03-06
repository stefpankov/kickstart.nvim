return {
  -- Linters
  {
    "mfussenegger/nvim-lint",
    config = function()
      -- [[ Configure linting ]]
      require('lint').linters_by_ft = {
        typescript = { 'eslint_d', },
        typescriptreact = { 'eslint_d', },
        javascript = { 'eslint_d', },
        javascriptreact = { 'eslint_d', },
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
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
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

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })

      vim.keymap.set("n", "<leader>cf", "<cmd>Format<cr>", { desc = "[C]ode [F]ormat" })
    end
  }
}
