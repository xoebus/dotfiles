return {
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "Trouble" },
		keys = {
			{
				"[d",
				function()
					vim.diagnostic.jump({ count = -1, float = true })
				end,
				desc = "Go to previous [d]iagnostic",
			},
			{
				"]d",
				function()
					vim.diagnostic.jump({ count = 1, float = true })
				end,
				desc = "Go to next [d]iagnostic",
			},
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
			{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document diagnostics" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
			{ "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references" },
		},
		opts = {},
	},
}
