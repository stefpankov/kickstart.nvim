return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      local tabwidth = function ()
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
          'trouble',
          'lazy',
          'nvim-tree',
          'quickfix',
        }
      })
    end
  },
}