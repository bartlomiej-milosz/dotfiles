-- mini.nvim — full suite, configured as the backbone of the config.
-- All modules live in this file so the surface area is easy to scan and extend.
return {
	{
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			local has = function(mod)
				return pcall(require, mod)
			end

			-- ── Icons (required by mini.files / mini.pick / mini.statusline) ─
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()

			-- ── Editing primitives ───────────────────────────────────────────
			require("mini.ai").setup({ n_lines = 500 }) -- better text objects (a/i pairs)
			require("mini.surround").setup() -- sa/sd/sr — add/delete/replace surroundings
			require("mini.pairs").setup() -- auto-pairs
			require("mini.comment").setup() -- gc / gcc — comment toggle (treesitter-aware via ts integration)
			require("mini.move").setup() -- Alt-hjkl move lines/selections (we override with our own in keymaps.lua)
			require("mini.splitjoin").setup() -- gS to split/join args
			require("mini.bracketed").setup() -- ]b/[b, ]q/[q, ]d/[d navigation
			require("mini.trailspace").setup() -- highlight + :lua MiniTrailspace.trim()
			require("mini.operators").setup() -- gx exchange, gm multiply, gr replace, etc.
			require("mini.jump").setup() -- smart f/F/t/T
			require("mini.jump2d").setup({ mappings = { start_jumping = "<CR>" } })

			-- ── UI / Visual ──────────────────────────────────────────────────
			require("mini.statusline").setup({ use_icons = true })
			require("mini.tabline").setup()
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
			})
			require("mini.cursorword").setup({ delay = 250 })
			require("mini.hipatterns").setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					hex = require("mini.hipatterns").gen_highlighter.hex_color(),
				},
			})
			require("mini.notify").setup({
				lsp_progress = { enable = true, duration_last = 1500 },
			})
			vim.notify = require("mini.notify").make_notify()

			-- ── Files ────────────────────────────────────────────────────────
			local ignore_names = {
				[".DS_Store"] = true,
				["Thumbs.db"] = true,
				[".localized"] = true,
			}
			local ignore_patterns = { "%.pyc$", "%.swp$", "%.swo$" }
			local function is_ignored(name)
				if ignore_names[name] then
					return true
				end
				for _, p in ipairs(ignore_patterns) do
					if name:match(p) then
						return true
					end
				end
				return false
			end

			require("mini.files").setup({
				content = {
					filter = function(fs_entry)
						return not is_ignored(fs_entry.name)
					end,
				},
				windows = { preview = true, width_preview = 80 },
				mappings = {
					close = "q",
					go_in = "L",
					go_in_plus = "<CR>",
					go_out = "H",
					go_out_plus = "h",
					reset = "<BS>",
					show_help = "g?",
					synchronize = "=",
					trim_left = "<",
					trim_right = ">",
				},
			})

			-- ── Pickers ──────────────────────────────────────────────────────
			require("mini.pick").setup({
				mappings = { choose_in_split = "<C-s>", choose_in_vsplit = "<C-v>" },
				options = { use_cache = true },
			})
			vim.ui.select = MiniPick.ui_select
			require("mini.extra").setup() -- adds oldfiles, git_*, lsp_*, diagnostic, etc.

			-- ── Sessions / Visits / Starter ──────────────────────────────────
			require("mini.sessions").setup({ autoread = false, autowrite = true })
			require("mini.visits").setup() -- automatic file-visit tracking, integrates with pick

			local starter = require("mini.starter")
			starter.setup({
				evaluate_single = true,
				header = table.concat({
					"  ╭──────────────────────────╮",
					"  │      Welcome back        │",
					"  ╰──────────────────────────╯",
				}, "\n"),
				items = {
					starter.sections.recent_files(8, true),
					starter.sections.builtin_actions(),
				},
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.aligning("center", "center"),
				},
			})

			-- ── Git ──────────────────────────────────────────────────────────
			require("mini.git").setup() -- :Git wrapper, status, blame
			require("mini.diff").setup({ -- gutter signs + per-hunk operations
				view = {
					style = "sign",
					signs = { add = "▎", change = "▎", delete = "" },
					priority = 199,
				},
			})

			-- ── Which-key (mini.clue) ────────────────────────────────────────
			local miniclue = require("mini.clue")
			miniclue.setup({
				window = { delay = 300, config = { width = "auto" } },
				triggers = {
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" },
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
					{ mode = "n", keys = "]" },
					{ mode = "n", keys = "[" },
				},
				clues = {
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),

					-- Leader groups (these are what makes <leader> discoverable)
					{ mode = "n", keys = "<Leader>b", desc = "+Buffer" },
					{ mode = "n", keys = "<Leader>c", desc = "+Code" },
					{ mode = "n", keys = "<Leader>d", desc = "+Debug" },
					{ mode = "n", keys = "<Leader>f", desc = "+Find" },
					{ mode = "n", keys = "<Leader>g", desc = "+Git" },
					{ mode = "n", keys = "<Leader>i", desc = "+Insert" },
					{ mode = "n", keys = "<Leader>s", desc = "+Search" },
					{ mode = "n", keys = "<Leader>u", desc = "+UI/Toggle" },
					{ mode = "n", keys = "<Leader>w", desc = "+Window" },
					{ mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
				},
			})
		end,
		keys = {
			-- ── Files / explorer ─────────────────────────────────────────────
			{
				"<leader>e",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
				end,
				desc = "File explorer (here)",
			},
			{
				"<leader>E",
				function()
					require("mini.files").open(vim.uv.cwd(), false)
				end,
				desc = "File explorer (cwd)",
			},

			-- ── Pick (mini.pick + mini.extra) ────────────────────────────────
			{ "<leader><leader>", "<cmd>Pick files<cr>", desc = "Find files" },
			{ "<leader>ff", "<cmd>Pick files<cr>", desc = "Find files" },
			{ "<leader>fr", "<cmd>Pick oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Pick help<cr>", desc = "Help tags" },
			{ "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fc", "<cmd>Pick commands<cr>", desc = "Commands" },
			{ "<leader>fp", "<cmd>Pick visit_paths<cr>", desc = "Visited paths" },
			{ "<leader>fg", "<cmd>Pick git_files<cr>", desc = "Git files" },
			{ "<leader>sg", "<cmd>Pick grep_live<cr>", desc = "Grep (live)" },
			{ "<leader>sw", "<cmd>Pick grep pattern='<cword>'<cr>", desc = "Grep word under cursor" },
			{ "<leader>sb", "<cmd>Pick buf_lines scope='current'<cr>", desc = "Buffer lines" },
			{ "<leader>sd", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
			{ "<leader>sr", "<cmd>Pick resume<cr>", desc = "Resume last picker" },

			-- ── Git ─────────────────────────────────────────────────────────
			{ "<leader>gs", "<cmd>Git status<cr>", desc = "Status" },
			{ "<leader>gl", "<cmd>Git log --oneline -n 20<cr>", desc = "Log" },
			{ "<leader>gb", "<cmd>Git blame -- %<cr>", desc = "Blame current file" },
			{
				"<leader>gd",
				function()
					vim.cmd("vert Git diff -- " .. vim.fn.expand("%"))
				end,
				desc = "Diff current file",
			},
			{
				"<leader>gh",
				function()
					require("mini.diff").toggle_overlay()
				end,
				desc = "Hunk overlay toggle",
			},

			-- ── Sessions ────────────────────────────────────────────────────
			{
				"<leader>us",
				function()
					require("mini.sessions").select()
				end,
				desc = "Select session",
			},

			-- ── Buffer cleanup ──────────────────────────────────────────────
			{
				"<leader>uW",
				function()
					MiniTrailspace.trim()
				end,
				desc = "Trim trailing whitespace",
			},
		},
	},
}
