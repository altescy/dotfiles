return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    tag = "v1.0.2",
    config = function()
      require("gitsigns").setup({})
    end,
  },
}
