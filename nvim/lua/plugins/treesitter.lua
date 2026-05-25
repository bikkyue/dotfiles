return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'lua',
        'nix',
        'python',
        'rust',
        'javascript',
        'typescript',
        'astro',
      },
    }
  end,
}
