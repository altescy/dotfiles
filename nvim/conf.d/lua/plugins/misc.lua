return {
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
  },
  {
    "stevearc/overseer.nvim",
    lazy = true,
    keys = {
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    },
  },
}
