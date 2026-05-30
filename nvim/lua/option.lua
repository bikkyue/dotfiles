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
