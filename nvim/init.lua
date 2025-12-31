
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function set_keywords_like_vim_default()
  local gui = "#ffff60" -- Vim default の Statement guifg
  local cterm = 11      -- Vim default の Statement ctermfg (bright yellow)

  local groups = {
    -- Vim syntax
    "Statement",
    "Keyword",

    -- Tree-sitter keyword-ish
    "@keyword",
    "@keyword.function",
    "@keyword.return",
    "@keyword.operator",
    "@keyword.conditional",
    "@keyword.repeat",
    "@keyword.exception",
    "@conditional",
    "@repeat",
    "@exception",
    "@label",
  }

  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, {
      fg = gui,
      ctermfg = cterm,
      bold = true,
      cterm = { bold = true },
    })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = set_keywords_like_vim_default })
vim.api.nvim_create_autocmd("VimEnter", { callback = set_keywords_like_vim_default })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
     { { import = "plugins" } }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
