local opt                = vim.opt

-- ── Netrw (disabled — using mini.files instead) ──────────────
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- ── Line numbers ─────────────────────────────────────────────
opt.number               = true -- show absolute line number on current line
opt.relativenumber       = true -- show relative numbers on all other lines
opt.numberwidth          = 4 -- width of the number column
opt.signcolumn           = "yes" -- always show sign column (prevents layout shift)
opt.cursorline           = true -- highlight the current line

-- ── Indentation ──────────────────────────────────────────────
-- Per-filetype overrides (lua, sh) are handled in autocmds.lua
opt.expandtab            = true -- convert tabs to spaces
opt.shiftwidth           = 4 -- spaces per indentation level
opt.tabstop              = 4 -- spaces a tab character represents
opt.softtabstop          = 4 -- spaces inserted when pressing <Tab>
opt.smartindent          = true -- auto-indent new lines based on context
opt.shiftround           = true -- round indent to multiples of shiftwidth
opt.breakindent          = true -- wrapped lines preserve indentation

-- ── Search ───────────────────────────────────────────────────
opt.ignorecase           = true -- case-insensitive search by default
opt.smartcase            = true -- case-sensitive if query contains uppercase
opt.hlsearch             = true -- highlight all search matches (<Esc> clears them)
opt.incsearch            = true -- show matches incrementally while typing

-- ── Appearance ───────────────────────────────────────────────
opt.termguicolors        = true   -- enable 24-bit RGB colors
opt.showmode             = false  -- hide mode (statusline handles this)
opt.wrap                 = false  -- disable line wrapping (better for code)
opt.linebreak            = true   -- if wrap is enabled, break at word boundaries
opt.colorcolumn          = "100"  -- visual guide at 100 characters (PEP 8 / Go)
opt.scrolloff            = 10     -- keep 10 lines above/below cursor
opt.sidescrolloff        = 8      -- keep 8 columns left/right of cursor
opt.fillchars            = { eob = " " } -- hide ~ on empty lines below buffer
opt.conceallevel         = 0      -- show markup characters (e.g. ** in markdown)

-- ── Splits ───────────────────────────────────────────────────
opt.splitbelow           = true -- horizontal splits open below
opt.splitright           = true -- vertical splits open to the right

-- ── Files ────────────────────────────────────────────────────
opt.fileencoding         = "utf-8" -- file encoding
opt.undofile             = true -- persistent undo across sessions
opt.swapfile             = false -- no swap files
opt.backup               = false -- no backup files
opt.writebackup          = false -- no writebackup files

-- ── Performance ──────────────────────────────────────────────
opt.updatetime           = 250 -- faster CursorHold events (used by LSP highlights)
opt.timeoutlen           = 300 -- time to wait for a mapped sequence to complete

-- ── Completion ───────────────────────────────────────────────
opt.completeopt          = "menuone,noinsert,noselect" -- completion behaviour for mini.completion

-- ── Clipboard ────────────────────────────────────────────────
-- Requires: xclip/xsel on Linux, pbcopy/pbpaste on macOS (built-in)
opt.clipboard            = "unnamedplus" -- sync with system clipboard

-- ── Mouse ────────────────────────────────────────────────────
opt.mouse                = "a" -- enable mouse in all modes

-- ── Ignored files ────────────────────────────────────────────
opt.wildignore:append(".DS_Store")

-- ── Disable unused language providers ────────────────────────
-- Silences healthcheck warnings for Perl/Python/Ruby/Node remote plugins.
vim.g.loaded_perl_provider    = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_node_provider    = 0
