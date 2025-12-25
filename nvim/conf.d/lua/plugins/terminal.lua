return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 10,
      hide_numbers = true,
      start_in_insert = true,
      close_on_exit = true,
      direction = "float",
      shade_terminals = false,
      float_opts = {
        border = "curved",
      },
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
  },
}
