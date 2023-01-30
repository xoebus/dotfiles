return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable "make" == 1,
      },
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      local trouble = require("trouble.providers.telescope")

      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-t>"] = trouble.open_with_trouble,
              ["<esc>"] = "close",
            },
            n = {
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
        },
      }

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("undo")

      -- See `:help telescope.builtin`
      vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles,
        { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers,
        { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find,
        { desc = "[/] Fuzzily search in current buffer]" })

      vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files,
        { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags,
        { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string,
        { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep,
        { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics,
        { desc = "[S]earch [D]iagnostics" })

      vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files,
        { desc = "Fuzzy find files in current directory" })

      vim.keymap.set("n", "<leader>u", require("telescope").extensions.undo.undo,
        { desc = "[U]ndo history tree" })
    end
  },
}
