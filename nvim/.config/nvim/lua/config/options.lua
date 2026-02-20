local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Disable netrw (snacks.explorer replaces it)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
