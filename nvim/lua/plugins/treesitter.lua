return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = function()
			require("nvim-treesitter.install").update({
				with_sync = true,
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			{
				dir = vim.env.TREE_SITTER_TXTAR or vim.fn.expand("~/src/claude/tree-sitter-txtar"),
				name = "tree-sitter-txtar",
			},
		},
		config = function()
			-- txtar is the archive format used by Go toolchain tests (cmd/go/testdata).
			-- The parser lives locally; TREE_SITTER_TXTAR can override the default path.
			local txtar_path = vim.env.TREE_SITTER_TXTAR or vim.fn.expand("~/src/claude/tree-sitter-txtar")
			vim.opt.runtimepath:append(txtar_path)
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.txtar = {
				install_info = {
					url = txtar_path,
					files = { "src/parser.c" },
				},
				filetype = "txtar",
			}
			vim.filetype.add({
				extension = {
					txtar = "txtar",
				},
			})

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"go",
					"vimdoc",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"rust",
					"toml",
					"typescript",
					"vim",
					"yaml",
				},

				highlight = { enable = true },
				-- Treesitter indent breaks multi-line bullets in markdown
				indent = { enable = true, disable = { "markdown" } },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
