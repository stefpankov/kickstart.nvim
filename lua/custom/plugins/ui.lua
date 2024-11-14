local Base = require('base.init')

local ui = {
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>m",  "",                                                                            desc = "[M]essages (Noice)" },
      { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
      { "<leader>ml", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
      { "<leader>mh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
      { "<leader>ma", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>md", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
      { "<leader>mt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
      { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      -- { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
      -- { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
      -- { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      -- { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      -- { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Base.ui.bufremove(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Base.ui.bufremove(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = Base.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return Base.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- {
  --   -- Set cokeline as bufferline
  --   "willothy/nvim-cokeline",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",       -- Required for v0.4.0+
  --     "nvim-tree/nvim-web-devicons", -- If you want devicons
  --     -- "stevearc/resession.nvim"      -- Optional, for persistent history
  --   },
  --   config = function()
  --     local is_picking_focus = require('cokeline.mappings').is_picking_focus
  --     local is_picking_close = require('cokeline.mappings').is_picking_close
  --     local get_hex = require('cokeline.hlgroups').get_hl_attr
  --
  --     local red = vim.g.terminal_color_1
  --     local yellow = vim.g.terminal_color_3
  --
  --     require('cokeline').setup({
  --       default_hl = {
  --         fg = function(buffer)
  --           return
  --               buffer.is_focused
  --               and get_hex('BufferCurrent', 'fg')
  --               or get_hex('BufferInactive', 'fg')
  --         end,
  --         bg = function(buffer)
  --           return
  --               buffer.is_focused
  --               and get_hex('BufferCurrent', 'bg')
  --               or get_hex('BufferInactive', 'bg')
  --         end,
  --       },
  --
  --       components = {
  --         {
  --           text = '',
  --           fg = function(buffer) return buffer.is_focused and get_hex('BufferCurrent', 'bg') or get_hex('Normal', 'bg') end,
  --           bg = function(buffer)
  --             return buffer.is_focused and get_hex('ColorColumn', 'bg') or
  --                 get_hex('ColorColumn', 'bg')
  --           end,
  --         },
  --         {
  --           text = ' ',
  --         },
  --         {
  --           text = function(buffer)
  --             return
  --                 (is_picking_focus() or is_picking_close())
  --                 and buffer.pick_letter .. ' '
  --                 or buffer.devicon.icon
  --           end,
  --           fg = function(buffer)
  --             return
  --                 (is_picking_focus() and yellow)
  --                 or (is_picking_close() and red)
  --                 or buffer.devicon.color
  --           end,
  --           italic = function()
  --             return
  --                 (is_picking_focus() or is_picking_close())
  --           end,
  --           bold = function()
  --             return
  --                 (is_picking_focus() or is_picking_close())
  --           end
  --         },
  --         {
  --           text = ' ',
  --         },
  --         {
  --           text = function(buffer) return buffer.filename .. ' ' end,
  --           bold = function(buffer) return buffer.is_focused end,
  --         },
  --         {
  --           text = function(buffer)
  --             return (buffer.diagnostics.errors > 0 and ' ') or ''
  --           end,
  --           fg = get_hex('DiagnosticError', 'fg')
  --         },
  --         {
  --           text = function(buffer)
  --             return (buffer.diagnostics.warnings > 0 and ' ') or ''
  --           end,
  --           fg = get_hex('DiagnosticWarn', 'fg')
  --         },
  --         {
  --           ---@param buffer Buffer
  --           text = function(buffer)
  --             if buffer.is_modified then
  --               return ""
  --             end
  --             -- return "󰅖"
  --             return '󰅗'
  --           end,
  --           on_click = function(_, _, _, _, buffer)
  --             buffer:delete()
  --           end,
  --         },
  --         -- {
  --         --   text = '󰅗',
  --         --   on_click = function(_, _, _, _, buffer)
  --         --     buffer:delete()
  --         --   end,
  --         -- },
  --         {
  --           text = ' ',
  --         },
  --         {
  --           text = '',
  --           fg = function(buffer) return buffer.is_focused and get_hex('BufferCurrent', 'bg') or get_hex('Normal', 'bg') end,
  --           bg = function(buffer)
  --             return buffer.is_focused and get_hex('ColorColumn', 'bg') or
  --                 get_hex('ColorColumn', 'bg')
  --           end,
  --         },
  --       },
  --     })
  --   end
  -- },
}

