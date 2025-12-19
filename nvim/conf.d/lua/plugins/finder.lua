return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = true,
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
      { "<C-k>", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
    },
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
    keys = {
      { "<C-n>", ":Neotree toggle<CR>", noremap = true, desc = "Toggle NeoTree" },
    },
  },
}
