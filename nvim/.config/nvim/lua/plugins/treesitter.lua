return {
	"nvim-treesitter/nvim-treesitter",
	-- When the plugin builds run the TSUpdate command to ensure all our servers are installed and updated
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"python",
				"lua",
				"html",
				"json",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
			},
			highlight = {
				enable = true,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
