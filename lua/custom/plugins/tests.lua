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
      "fredrikaverpil/neotest-golang",
      'leoluz/nvim-dap-go',
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
          require("neotest-golang")({
            -- Here we can set options for neotest-golang, e.g.
            -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
            dap_go_enabled = true, -- requires leoluz/nvim-dap-go
          }),
        },
      })

      require("which-key").add({
        { "<leader>ct", group = "[C]ode [T]ests" },
      })
    end,
  },
}