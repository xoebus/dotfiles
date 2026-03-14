return {
	"tpope/vim-sleuth",
	{ "tpope/vim-fugitive", cmd = { "Git", "G" } },
	{ "tpope/vim-vinegar", keys = { { "-", desc = "Open parent directory" } } },

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Document" },
				{ "<leader>r", group = "Rename" },
				{ "<leader>s", group = "Search" },
				{ "<leader>w", group = "Workspace" },
				{ "<leader>x", group = "Diagnostics" },
			},
		},
	},
}
