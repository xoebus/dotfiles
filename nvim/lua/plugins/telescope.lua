return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = vim.fn.executable("make") == 1,
			},
			"debugloop/telescope-undo.nvim",
		},
		cmd = { "Telescope" },
		keys = {
			{ "<leader>?", desc = "[?] Find recently opened files" },
			{ "<leader><space>", desc = "[ ] Find existing buffers" },
			{ "<leader>/", desc = "[/] Fuzzily search in current buffer" },
			{ "<leader>sf", desc = "[S]earch [F]iles" },
			{ "<leader>sh", desc = "[S]earch [H]elp" },
			{ "<leader>sw", desc = "[S]earch current [W]ord" },
			{ "<leader>sg", desc = "[S]earch by [G]rep" },
			{ "<leader>sd", desc = "[S]earch [D]iagnostics" },
			{ "<C-p>", desc = "Fuzzy find files in current directory" },
			{ "<leader>u", desc = "[U]ndo history tree" },
		},
		config = function()
			local trouble = require("trouble.sources.telescope")

			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false, -- don't clear the prompt on C-u
							["<C-d>"] = false, -- don't scroll docs on C-d
							["<C-t>"] = trouble.open,
							["<esc>"] = "close", -- close instead of switching to normal mode
						},
						n = {
							["<C-t>"] = trouble.open,
						},
					},
				},
			})

			-- Load extensions with error protection
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "undo")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set(
				"n",
				"<leader>/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "[/] Fuzzily search in current buffer" }
			)
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Fuzzy find files in current directory" })
			vim.keymap.set(
				"n",
				"<leader>u",
				require("telescope").extensions.undo.undo,
				{ desc = "[U]ndo history tree" }
			)
		end,
	},
}
