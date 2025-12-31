return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    config = function()
      require("nvim-treesitter").install({
        "lua",
        "go",
        "markdown",
        "astro",
        "python",
        "bash",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.wo[args.buf].foldmethod = "expr"
          vim.wo[args.buf].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })

      vim.treesitter.language.register("bash", { "sh", "zsh" })
    end,
  },
}