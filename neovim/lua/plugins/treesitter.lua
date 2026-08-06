return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'lua',
        'nix',
        -- 'python',
        -- 'rust',
        'javascript',
        'typescript',
        -- 'astro',
        'markdown',
        'markdown_inline',
        'html',
        'css',
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function() pcall(vim.treesitter.start) end,
    })
  end,
}
