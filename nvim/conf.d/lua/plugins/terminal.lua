return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 10,
      hide_numbers = true,
      start_in_insert = true,
      close_on_exit = true,
      direction = "horizontal",
      shade_terminals = false,
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
  },
}
