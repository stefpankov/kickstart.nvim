return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      -- "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "mrcjkb/rustaceanvim",
      "jfpedroza/neotest-elixir",
      'V13Axel/neotest-pest',
    },
    keys = {
      { "<leader>ctn", function() require("neotest").run.run() end, desc = "[C]ode [T]ests Run [N]earest" },
      {
        "<leader>ctf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "[C]ode [T]ests Run [F]ile"
      },
      {
        "<leader>ctd",
        function()
          require("neotest").run.run({ strategy = "dap", suite = false })
        end,
        desc = "[C]ode [T]ests [D]ebug Nearest"
      },
      {
        "<leader>cts", function()
        require("neotest").run.run({ suite = true })
      end, { desc = "[C]ode [T]ests Run [S]uite" }
      }
    },
    config = function()
      require("neotest").setup({
        adapters = {
          -- require('rustaceanvim.neotest'),
          require('neotest-elixir'),
          require('neotest-pest')({
            sail_enabled = function() return true end,
          }),
        },
      })

      require("which-key").add({
        { "<leader>ct", group = "[C]ode [T]ests" },
      })
    end,
  },
}