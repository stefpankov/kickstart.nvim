return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      local tabwidth = function()
        local style = ''
        if vim.bo.expandtab then style = '󱁐' end
        return vim.bo.shiftwidth .. "" .. style
      end
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' }
        },
        sections = {
          lualine_x = {
            tabwidth,
            'encoding',
          },
          lualine_y = {
            'fileformat',
            'filetype',
            'progress',
          },
        },
        extensions = {
          'lazy',
          'nvim-tree',
          'quickfix',
        },
        opts = function(_, opts)
          local trouble = require("trouble")
          local symbols = trouble.statusline({
            mode = "lsp_document_symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            -- The following line is needed to fix the background color
            -- Set it to the lualine section you want to use
            hl_group = "lualine_c_normal",
          })
          table.insert(opts.sections.lualine_c, {
            symbols.get,
            cond = symbols.has,
          })
        end
      })
    end
  },
}