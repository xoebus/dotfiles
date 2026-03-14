return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofumpt" },
		},
		default_format_opts = {
			-- Use LSP formatting only when no conform formatter is configured for the filetype
			lsp_format = "fallback",
		},
		format_on_save = { timeout_ms = 500 },
	},
}
