-- Treesitter on nvim 0.11+: nvim-treesitter `main` branch + builtin vim.treesitter.
-- The legacy `master` branch is broken on nvim 0.12 (calls removed APIs).
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ensure_installed = {
				"bash",
				"c",
				"diff",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"git_config",
				"gitcommit",
				"gitignore",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			}

			local ts = require("nvim-treesitter")
			ts.install(ensure_installed)

			-- Map filetype → parser for cases where they differ
			local ft_to_parser = {
				sh = "bash",
				gitcommit = "gitcommit",
				gitconfig = "git_config",
				gitignore = "gitignore",
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = ft_to_parser[ft] or ft
					if not pcall(vim.treesitter.start, args.buf, lang) then
						return
					end
					-- Treesitter-based indent (opt-in per buffer)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	-- Context: sticky function/class header at the top of the window
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			enable = true,
			max_lines = 3,
			mode = "cursor",
			separator = nil,
		},
	},

	-- Textobjects on the `main` branch (uses the new nvim-treesitter API).
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = { set_jumps = true },
			})

			local move = require("nvim-treesitter-textobjects.move")
			local function jump(fn, query)
				return function()
					fn(query, "textobjects")
				end
			end
			local map = vim.keymap.set
			map(
				{ "n", "x", "o" },
				"]f",
				jump(move.goto_next_start, "@function.outer"),
				{ desc = "Next function start" }
			)
			map({ "n", "x", "o" }, "]c", jump(move.goto_next_start, "@class.outer"), { desc = "Next class start" })
			map({ "n", "x", "o" }, "]F", jump(move.goto_next_end, "@function.outer"), { desc = "Next function end" })
			map({ "n", "x", "o" }, "]C", jump(move.goto_next_end, "@class.outer"), { desc = "Next class end" })
			map(
				{ "n", "x", "o" },
				"[f",
				jump(move.goto_previous_start, "@function.outer"),
				{ desc = "Prev function start" }
			)
			map({ "n", "x", "o" }, "[c", jump(move.goto_previous_start, "@class.outer"), { desc = "Prev class start" })
			map(
				{ "n", "x", "o" },
				"[F",
				jump(move.goto_previous_end, "@function.outer"),
				{ desc = "Prev function end" }
			)
			map({ "n", "x", "o" }, "[C", jump(move.goto_previous_end, "@class.outer"), { desc = "Prev class end" })
		end,
	},
}
