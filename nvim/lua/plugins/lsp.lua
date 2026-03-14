return {
	-- Completion engine and sources
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
		},
		config = function()
			local lspkind = require("lspkind")
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({
						-- Replace the word under cursor rather than inserting alongside it
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				-- Show only icons (not text labels) for completion item kinds
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
		},
		config = function()
			require("fidget").setup()

			-- Set capabilities globally for all servers (Neovim 0.11+)
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			-- Use LspAttach autocmd instead of on_attach (Neovim 0.11+ recommended pattern)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local nmap = function(keys, func, desc)
						vim.keymap.set(
							"n",
							keys,
							func,
							{ noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. desc }
						)
					end

					nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
					nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
					nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					nmap(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- K (hover) and <C-k> (signature help) are Neovim 0.11 defaults,
					-- but we override <C-k> in normal mode since the default is insert-mode only
					nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

					-- Create a command `:Format` local to the LSP buffer
					-- Note: conform.nvim is the primary formatter (lsp_format = "fallback")
					vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
						vim.lsp.buf.format()
					end, { desc = "Format current buffer with LSP" })

					-- Enable inlay hints if the server supports them
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})

			-- Enable LSP servers (Neovim 0.11+)
			vim.lsp.enable({ "gopls", "lua_ls", "rust_analyzer", "zls" })
		end,
	},
}
