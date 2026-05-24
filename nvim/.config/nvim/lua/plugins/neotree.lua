-- neo-tree.nvim — persistent sidebar tree.
-- Complements mini.files (<leader>e), which stays the primary quick-nav tool.
-- neo-tree is the "read the whole directory structure at once" view, handy
-- when designing module layout the way a traditional IDE tree does.
-- Icons come from mini.icons (it mocks nvim-web-devicons), so no devicons dep.
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>E", "<cmd>Neotree toggle reveal<cr>", desc = "File tree (neo-tree)" },
	},
	opts = {
		close_if_last_window = true,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false, -- press H inside the tree to reveal hidden entries
				show_hidden_count = false, -- no "(N hidden items)" clutter
				hide_dotfiles = false, -- show .env, .venv, etc. (matches mini.files)
				hide_gitignored = false, -- match mini.files: no gitignore filtering
				-- Kept in sync with ignore_names/ignore_patterns in plugins/mini.lua.
				hide_by_name = {
					".git",
					"node_modules",
					"__pycache__",
					".ruff_cache",
					".mypy_cache",
					".pytest_cache",
					".ipynb_checkpoints",
					".DS_Store",
				},
				hide_by_pattern = {
					"*.pyc",
					"*.pyo",
					"*.egg-info",
				},
			},
		},
		window = { width = 32 },
	},
}
