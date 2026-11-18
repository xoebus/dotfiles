-- Parsers to install and keep updated. `markdown_inline` powers injected
-- highlighting inside Markdown; `txtar` is registered locally further down.
local ensure_installed = {
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
}

-- Minimal incremental selection. The `incremental_selection` module was dropped
-- in the nvim-treesitter `main` rewrite, so we reimplement node grow/shrink on
-- top of the core treesitter API. `<c-s>` (scope) behaves the same as node grow.
local function setup_incremental_selection()
	local stack = {}
	local selection_buf, selection_tick

	local function selection_is_current()
		return selection_buf == vim.api.nvim_get_current_buf()
			and selection_tick == vim.api.nvim_buf_get_changedtick(0)
	end

	local function select(node)
		local srow, scol, erow, ecol = node:range()
		if ecol == 0 and erow > srow then
			erow = erow - 1
			ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1] or "")
		end
		vim.cmd("normal! \27")
		vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
		vim.cmd("normal! v")
		local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1] or ""
		local end_col = math.max(ecol - 1, 0)
		-- Tree-sitter's exclusive end is a byte offset. Move back to the
		-- first byte of the final UTF-8 character for an inclusive selection.
		while end_col > 0 do
			local byte = line:byte(end_col + 1)
			if not byte or byte < 0x80 or byte >= 0xC0 then
				break
			end
			end_col = end_col - 1
		end
		vim.api.nvim_win_set_cursor(0, { erow + 1, end_col })
	end

	local function same_range(a, b)
		local a1, a2, a3, a4 = a:range()
		local b1, b2, b3, b4 = b:range()
		return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
	end

	local function init()
		stack = {}
		selection_buf = vim.api.nvim_get_current_buf()
		selection_tick = vim.api.nvim_buf_get_changedtick(0)
		local node = vim.treesitter.get_node()
		if not node then
			return
		end
		stack = { node }
		select(node)
	end

	local function grow()
		if not selection_is_current() then
			return init()
		end
		local node = stack[#stack]
		if not node then
			return init()
		end
		local parent = node:parent()
		while parent and same_range(parent, node) do
			parent = parent:parent()
		end
		if not parent then
			return
		end
		stack[#stack + 1] = parent
		select(parent)
	end

	local function shrink()
		if not selection_is_current() then
			return init()
		end
		if #stack > 1 then
			stack[#stack] = nil
		end
		if stack[#stack] then
			select(stack[#stack])
		end
	end

	vim.keymap.set("n", "<c-space>", init, { desc = "Init treesitter selection" })
	vim.keymap.set("x", "<c-space>", grow, { desc = "Grow treesitter selection" })
	vim.keymap.set("x", "<c-s>", grow, { desc = "Grow treesitter selection" })
	vim.keymap.set("x", "<c-backspace>", shrink, { desc = "Shrink treesitter selection" })
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- The `main` branch is the supported line for Neovim 0.12+; `master` is
		-- frozen at Neovim 0.11 and crashes 0.12's injection parser.
		branch = "main",
		lazy = false, -- `main` does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			-- txtar is the archive format used by Go toolchain tests (cmd/go/testdata).
			-- The parser lives locally; TREE_SITTER_TXTAR can override the default path.
			local txtar_path = vim.env.TREE_SITTER_TXTAR or vim.fn.expand("~/src/claude/tree-sitter-txtar")

			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").txtar = {
						install_info = {
							path = txtar_path,
							queries = "queries/txtar",
						},
					}
				end,
			})

			vim.filetype.add({
				extension = {
					txtar = "txtar",
				},
			})

			local parsers = vim.list_extend(vim.deepcopy(ensure_installed), { "txtar" })
			require("nvim-treesitter").install(parsers)

			-- `main` enables nothing automatically: turn on highlighting and
			-- indentation per buffer once a parser is available.
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = args.match
					if ft == "" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if not pcall(vim.treesitter.start, args.buf, lang) then
						return
					end
					-- Treesitter indent breaks multi-line bullets in markdown.
					if ft ~= "markdown" then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			setup_incremental_selection()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true, -- jump forward to textobj, similar to targets.vim
				},
				move = {
					set_jumps = true, -- store motions in the jumplist
				},
			})

			-- Capture groups are defined in textobjects.scm. The submodules are
			-- `require`d lazily inside the mappings so they load on first use.
			local selects = {
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			}
			for lhs, query in pairs(selects) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
				end, { desc = "Select " .. query })
			end

			vim.keymap.set("n", "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap next parameter" })
			vim.keymap.set("n", "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "Swap previous parameter" })

			local moves = {
				goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
				goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
				goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
				goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
			}
			for fn, maps in pairs(moves) do
				for lhs, query in pairs(maps) do
					vim.keymap.set({ "n", "x", "o" }, lhs, function()
						require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
					end, { desc = fn .. " " .. query })
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
