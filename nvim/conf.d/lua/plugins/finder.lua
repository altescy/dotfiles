return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = true,
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<C-k>", builtin.live_grep, { desc = "Telescope live grep" })
      vim.cmd([[highlight TelescopeBorder guibg=none]])
      vim.cmd([[highlight TelescopeTitle guibg=none]])
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {},
    config = function()
      vim.api.nvim_set_keymap("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true })
    end,
  },
}
