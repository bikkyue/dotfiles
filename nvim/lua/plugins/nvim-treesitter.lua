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

      vim.treesitter.language.register("bash", { "sh", "zsh" })

      -- FileType: バッファに対して treesitter を開始（安全）
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- nvim-tree など特殊バッファは除外推奨
          local ft = vim.bo[args.buf].filetype
          if ft == "NvimTree" then
            return
          end
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- BufWinEnter/WinEnter: 「ウィンドウが存在する」タイミングで fold を設定（安全）
      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        callback = function()
          -- 現在ウィンドウに対して設定する（winid指定で壊さない）
          if vim.bo.filetype == "NvimTree" then
            return
          end
        end,
      })
    end,
  },
}