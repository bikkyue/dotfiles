return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha', -- latte / frappe / macchiato / mocha
      styles = {
        comments = {},
        conditionals = {},
      },
    })
    vim.cmd.colorscheme('catppuccin')
  end,
}
