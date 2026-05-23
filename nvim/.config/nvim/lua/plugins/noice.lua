-- noice.nvim: replaces the bottom cmdline with a centered popup
-- (command-palette style) and routes LSP/messages through a nicer UI.
return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		---@module 'noice'
		---@type NoiceConfig
		opts = {
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
			},

			lsp = {
				-- Let noice render LSP hover/signature with markdown highlighting.
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				-- LSP progress (replaces mini.notify's lsp_progress).
				progress = { enabled = true },
			},

			-- Route all messages + vim.notify through noice's built-in "mini"
			-- view (corner, no extra deps). This fully replaces mini.notify.
			messages = {
				enabled = true,
				view = "mini",
				view_error = "mini",
				view_warn = "mini",
				view_history = "messages",
				view_search = "virtualtext",
			},
			notify = {
				enabled = true,
				view = "mini",
			},

			presets = {
				bottom_search = false, -- keep `/` and `?` in the popup too
				command_palette = true, -- cmdline + completion stacked near the top
				long_message_to_split = true, -- long messages go to a split, not a popup
				inc_rename = false,
				lsp_doc_border = true,
			},
		},
	},
}
