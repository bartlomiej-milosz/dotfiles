-- Left column and similar settings
vim.opt.number = true         -- Display line numbers
vim.opt.relativenumber = true -- Display relative line numbers
vim.opt.numberwidth = 4      -- Set width of line number column
vim.opt.signcolumn = "yes"    -- Always show sign column
vim.opt.scrolloff = 10        -- Number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8     -- Number of columns to keep to the left/right of cursor

-- Tab spacing/behavior
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.shiftwidth = 4     -- Number of spaces inserted for each indentation level
vim.opt.tabstop = 4        -- Number of spaces inserted for tab character
vim.opt.softtabstop = 4    -- Number of spaces inserted for <Tab> key
vim.opt.smartindent = true -- Enable smart indentation
vim.opt.breakindent = true -- Enable line breaking indentation

-- General Behaviors
vim.g.loaded_netrw = 1            -- Disable the built-in netrw plugin to avoid conflicts with modern alternatives
vim.g.loaded_netrwPlugin = 1
vim.opt.backup = false            -- Disable backup file creation
vim.opt.clipboard = "unnamedplus" -- Enable system clipboard access
vim.opt.conceallevel = 0          -- So that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"    -- Set file encoding to UTF-8
vim.opt.mouse = "a"               -- Enable mouse support
vim.opt.showmode = false          -- Hide mode display
vim.opt.splitbelow = true         -- Force horizontal splits below current window
vim.opt.splitright = true         -- Force vertical splits right of current window
vim.opt.termguicolors = true      -- Enable term GUI colors
vim.opt.timeoutlen = 1000         -- Set timeout for mapped sequences
vim.opt.undofile = true           -- Enable persistent undo
vim.opt.updatetime = 100          -- Set faster completion
vim.opt.writebackup = false       -- Prevent editing of files being edited elsewhere
vim.opt.cursorline = true         -- Highlight current line

-- Searching Behaviors
vim.opt.hlsearch = true   -- Highlight all matches in search
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true  -- Match case if explicitly stated

-- Text Wrap
vim.opt.wrap = true         -- Soft wraps lines (doesn’t insert newlines)
vim.opt.linebreak = true    -- Avoid breaking words in soft wrap
vim.opt.colorcolumn = "120" -- Visual guide at 80 chars
vim.opt.textwidth = 120     -- Only affects auto-inserted newlines while typing (not retroactively)

-- Ignore files
vim.opt.wildignore:append({
    ".DS_Store",
    "__pycache__",
    ".pytest_cache",
    ".ipynb_checkpoints",
    ".mypy_cache"
})
