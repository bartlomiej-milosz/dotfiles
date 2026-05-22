-- luacheck config for the Neovim runtime + plugins used in this config.
-- Declares globals so editing lua/* files doesn't get flagged as "undefined variable".
std = "lua51+luajit"

globals = {
    "vim",
    -- mini.nvim modules that expose globals when configured
    "MiniIcons",
    "MiniPick",
    "MiniTrailspace",
    "MiniFiles",
    "MiniDeps",
    -- snacks.nvim — if you ever switch back to it
    "Snacks",
}

-- Don't complain about long lines in tables/configs; readability of dense table literals
-- is more important than a hard column limit in dotfiles.
max_line_length = 140

-- Ignore "unused argument" for callback signatures we don't control.
ignore = {
    "211/_.*",  -- unused local with leading underscore
    "212/_.*",  -- unused argument with leading underscore
    "212/self", -- unused self (method signatures)
}
