local map            = vim.keymap.set

-- ── Leader ──────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── General ─────────────────────────────────────────────────

-- Clear search highlights on Escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Faster escape from insert mode
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Windows ──────────────────────────────────────────────────

-- Navigate between splits
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })

-- Create splits
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Window split vertical" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Window split horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Window equalize sizes" })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Window close" })

-- Resize splits with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ── Buffers ──────────────────────────────────────────────────

map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Buffer delete" })

-- ── Editing ──────────────────────────────────────────────────

-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down (normal and visual)
map("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("x", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Add blank lines without entering insert mode
map("n", "<leader>ij", "m`o<Esc>``", { desc = "Insert blank line below" })
map("n", "<leader>ik", "m`O<Esc>``", { desc = "Insert blank line above" })

-- Navigate wrapped lines naturally
map({ "n", "v" }, "j", "gj", { desc = "Down (wrapped)" })
map({ "n", "v" }, "k", "gk", { desc = "Up (wrapped)" })
