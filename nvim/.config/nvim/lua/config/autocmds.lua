local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Briefly highlight yanked text
autocmd("TextYankPost", {
    group    = augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Shell / Bash: 2-space indent (convention)
autocmd("FileType", {
    group    = augroup("ShellIndent", { clear = true }),
    pattern  = { "sh", "bash", "zsh" },
    callback = function()
        vim.opt_local.shiftwidth  = 2
        vim.opt_local.tabstop     = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Lua: 2-space indent
autocmd("FileType", {
    group    = augroup("LuaIndent", { clear = true }),
    pattern  = { "lua" },
    callback = function()
        vim.opt_local.shiftwidth  = 2
        vim.opt_local.tabstop     = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Go: tabs (gofmt convention)
autocmd("FileType", {
    group    = augroup("GoIndent", { clear = true }),
    pattern  = { "go" },
    callback = function()
        vim.opt_local.expandtab   = false
        vim.opt_local.shiftwidth  = 4
        vim.opt_local.tabstop     = 4
        vim.opt_local.softtabstop = 4
    end,
})

-- Close auxiliary windows with q
autocmd("FileType", {
    group    = augroup("QuickClose", { clear = true }),
    pattern  = { "help", "man", "qf", "lspinfo", "checkhealth", "dap-float", "dap-repl" },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
    end,
})

-- Restore cursor to last known position when opening a file
autocmd("BufReadPost", {
    group    = augroup("RestoreCursor", { clear = true }),
    callback = function()
        local mark   = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Disable mini.indentscope in special buffers
autocmd("FileType", {
    group    = augroup("MiniIndentscopeDisable", { clear = true }),
    pattern  = { "help", "man", "lazy", "mason", "lspinfo", "checkhealth", "starter", "minifiles", "dap-repl", "dap-float" },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})
