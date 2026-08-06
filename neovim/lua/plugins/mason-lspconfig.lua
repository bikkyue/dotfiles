return {
  'mason-org/mason-lspconfig.nvim',
  dependencies = {
    'mason-org/mason.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('mason-lspconfig').setup {
      ensure_installed = {
        -- 'rust_analyzer', -- Rust
        -- 'pyright', -- python
        'ts_ls', -- TypeScript
        -- 'astro', -- Astro
        -- 'jdtls', -- Java
        -- 'omnisharp', -- C#
        'marksman', -- Markdown
        'nil_ls', -- Nix
      },
      automatic_enable = true,
    }
  end,
}
