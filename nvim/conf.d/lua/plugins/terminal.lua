return {
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        size = 10,
        hide_numbers = true,
        start_in_insert = true,
        close_on_exit = true,
        direction = 'horizontal',
        shade_terminals = false,
      })
      vim.api.nvim_create_user_command('T', function(args)
        vim.cmd('ToggleTerm' .. args.args)
      end, { nargs = '*' })
    end,
  }
}
