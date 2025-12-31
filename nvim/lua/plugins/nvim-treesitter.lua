return {
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    config = function()
      -- パーサーのインストール先を指定
      require'nvim-treesitter'.setup {
        -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
        install_dir = vim.fn.stdpath('data') .. '/site'
      }
      require'nvim-treesitter'.install { 'lua' }

      -- 自動ハイライトの有効化
      vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lua' },
      callback = function() 
        vim.treesitter.start() 
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      
      end,
      })

      vim.treesitter.language.register("bash", { "sh", "zsh" })
      
    end
  }
}