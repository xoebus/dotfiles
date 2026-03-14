local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Must be set before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins")

-- Enable true color support
vim.opt.termguicolors = true

-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
-- Ensure directories exist
local data_dir = vim.fn.stdpath("data")
local undo_dir = data_dir .. "/undo"
local backup_dir = data_dir .. "/backup"
local swap_dir = data_dir .. "/swp"

vim.fn.mkdir(undo_dir, "p")
vim.fn.mkdir(backup_dir, "p")
vim.fn.mkdir(swap_dir, "p")

vim.opt.undofile = true
vim.opt.undodir = undo_dir
vim.opt.backupdir = backup_dir
vim.opt.directory = swap_dir

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250
-- Always show the sign column so the editor doesn't shift when diagnostics appear
vim.opt.signcolumn = "yes"

-- menuone: show the menu even when there's only one match
-- noselect: don't auto-select the first item
vim.opt.completeopt = "menuone,noselect"

-- Preview :s substitutions incrementally in the buffer
vim.opt.inccommand = "nosplit"
-- Single global statusline instead of one per window
vim.opt.laststatus = 3

vim.opt.mouse = "a"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Prevent Space from moving the cursor since it's the leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
vim.keymap.set("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

-- Briefly highlight yanked text
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Restore the cursor position upon re-opening the file (unless it's a Git commit message).
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("RestoreCursor", {
		clear = true,
	}),
	callback = function()
		-- Check if there's a mark from a previous opening of the file.
		local prev = vim.fn.line("'\"")
		if prev == 0 then
			return
		end

		-- Check if the file has been truncated since it was last opened.
		local eof = vim.fn.line("$")
		if prev > eof then
			return
		end

		-- Don't restore the cursor position in git commit messages as they're
		-- normally new each time.
		if vim.bo.filetype == "gitcommit" then
			return
		end

		vim.cmd('normal! `"')
	end,
})
