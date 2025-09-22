return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			-- Lazily load the vscode-like snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				-- How should completion options be displayed to us?
				completion = {
					-- menu: display options in a menu
					-- menuone: automatically select the first option of the menu
					-- preview: automatically display the completion candidate as you navigate the menu
					-- noselect: prevent neovim from automatically selecting a completion option while navigating the menu
					completeopt = "menu,menuone,preview,noselect",
				},
				-- Setup snippet support based on the active lsp and the current text of the file
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- Expand snippets with LuaSnip
					end,
				},
				-- Setup how we interact with completion menus and options
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- Next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
					["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- Close completion window
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirm selection when explicitly chosen
				}),
				-- Where and how should cmp rank and find completions
				-- Order matters, cmp will provide LSP suggestions above all else
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP-based suggestions
					{ name = "luasnip" }, -- LuaSnip-based snippets
					{ name = "buffer" }, -- Buffer-based suggestions (current file)
					{ name = "path" }, -- File path completions
				}),
			})
		end,
	},
}
