return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		-- Load before all other plugins to avoid flash of unstyled content
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			-- Automatically configure highlight groups for detected plugins
			auto_integrations = true,
			transparent_background = true,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
