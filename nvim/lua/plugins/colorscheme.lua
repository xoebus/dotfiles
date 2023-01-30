return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termuicolors = true
      vim.o.background = "dark"
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  },
}

