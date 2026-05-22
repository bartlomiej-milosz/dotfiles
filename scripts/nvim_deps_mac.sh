#!/usr/bin/env bash
# External tools the Neovim config depends on that mason cannot install:
#   - tree-sitter: CLI used by nvim-treesitter (`main` branch) to compile parsers
#   - luacheck   : lua linter (built from Lua sources; we install via brew instead
#                  of mason to avoid pulling in luarocks just to build it)
brew install tree-sitter luacheck
