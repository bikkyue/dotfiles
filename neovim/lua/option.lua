local opt = vim.opt

-- 行番号の表示
opt.number = true
opt.relativenumber = true

-- タブとインデントの設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 検索設定
opt.ignorecase = true
opt.smartcase = true

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- 背景を透明にする
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  command = "if mode() != 'c' | checktime | endif",
})

-- 再読み込みされたら通知
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})
