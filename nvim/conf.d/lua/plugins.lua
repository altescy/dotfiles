local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({ "editorconfig/editorconfig-vim" })

  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  use({
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      local keyset = vim.keymap.set
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      local colors_dark = {
        blue = "#839bd3",
        cyan = "#739389",
        black = "#080616",
        white = "#dbd7bc",
        red = "#b44947",
        violet = "#917fb4",
        grey = "#717169",
      }
      local colors_light = {
        blue = "#839bd3",
        cyan = "#597b75",
        black = "#1f1f28",
        white = "#f2ecbc",
        red = "#c84053",
        violet = "#b35b79",
        grey = "#8a8980",
      }

      local colors = colors_dark

      local kanagawa_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.violet },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
        },

        insert = { a = { fg = colors.black, bg = colors.blue } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },

        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white },
        },
      }

      require("lualine").setup({
        options = {
          theme = kanagawa_theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { "filename", "branch" },
          lualine_c = {
            "%=", --[[ add your center compoentnts here in place of this comment ]]
          },
          lualine_x = {},
          lualine_y = { "filetype", "progress" },
          lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {},
        extensions = {},
      })
    end,
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
  })

  use({
    "akinsho/bufferline.nvim",
    tag = "*",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "ordinal",
          diagnostics = "coc",
          separator_style = "slant",
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or ""
            return " " .. icon
          end,
        },
      })
      vim.api.nvim_set_keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true })
    end,
  })

  use({
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
      require("kanagawa").setup({
        backgronnd = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("telescope").setup({})
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<C-k>", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    end,
  })

  use({
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          crystal = { "crystal" },
          go = { "goimports", "gofmt" },
          lua = { "stylua" },
          nim = { "nimpretty" },
          python = { "isort", "black" },
          rust = { "rustfmt", lsp_format = "fallback" },
          terraform = { "terraform_fmt" },
          ["*"] = { "trim_whitespace", "trim_newlines" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
        format_after_save = {
          lsp_format = "fallback",
        },
      })
    end,
  })

  use({
    "NeogitOrg/neogit",
    requires = "sindrets/diffview.nvim",
    config = function()
      require("neogit").setup({})
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  })

  use({
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup({})
    end,
  })

  use({
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("scrollbar.handlers.search").setup({})
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "lua",
        "css",
        "html",
        "javascript",
        "typescript",
      })
    end,
  })

  use({ "github/copilot.vim" })

  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.api.nvim_set_keymap("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true })
    end,
  })

  use({ "vimpostor/vim-lumen" })

  use({
    "google/vim-jsonnet",
    opt = true,
    ft = { "jsonnet" },
  })

  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup({
        size = 10,
        hide_numbers = true,
        start_in_insert = true,
        close_on_exit = true,
        direction = "horizontal",
        shade_terminals = false,
      })
      vim.api.nvim_create_user_command("T", function(args)
        vim.cmd("ToggleTerm" .. args.args)
      end, { nargs = "*" })
    end,
  })

  use({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmarkdown" },
    run = "cd app && npx --yes yarn install",
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
