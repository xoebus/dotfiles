return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local theta = require("alpha.themes.theta")
			local dashboard = require("alpha.themes.dashboard")

			theta.buttons.val = {
				{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
				{ type = "padding", val = 1 },
				dashboard.button("e", "  New file", "<cmd>ene<CR>"),
				dashboard.button("p", "  Find file", "<cmd>Telescope find_files<CR>"),
				dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
				dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
				dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
			}

			require("alpha").setup(theta.config)
		end,
	},
}
