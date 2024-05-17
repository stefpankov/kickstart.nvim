return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      -- "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mrcjkb/rustaceanvim",
      "jfpedroza/neotest-elixir",
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('rustaceanvim.neotest'),
          require('neotest-elixir')
        },
      })

      vim.keymap.set("n", "<leader>ctn", function()
        require("neotest").run.run()
      end, { desc = "[C]ode [T]ests Run [N]earest" })

      vim.keymap.set("n", "<leader>ctf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "[C]ode [T]ests Run [F]ile" })

      vim.keymap.set("n", "<leader>ctd", function()
        require("neotest").run.run({ strategy = "dap" })
      end, { desc = "[C]ode [T]ests [D]ebug Nearest" })

      require("which-key").register({
        ['<leader>ct'] = { name = '[C]ode [T]ests', _ = 'which_key_ignore' },
      })
    end,
  },
}