return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "python",
        "vim",
        "vimdoc",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local themes = {
        dark = {
          blue = "#839bd3",
          cyan = "#739389",
          black = "#080616",
          white = "#dbd7bc",
          red = "#b44947",
          violet = "#917fb4",
          grey = "#717169",
        },
        light = {
          blue = "#839bd3",
          cyan = "#597b75",
          black = "#1f1f28",
          white = "#f2ecbc",
          red = "#c84053",
          violet = "#b35b79",
          grey = "#8a8980",
        },
      }

      local colors = themes.dark

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
          lualine_x = { "diagnostics" },
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
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        number = "ordinal",
        separator_style = { "", "" },
        indicator = {
          style = "none",
          icon = "",
        },
      },
      highlights = {
        background = { bg = "none" },
        fill = { bg = "none" },
        buffer_selected = { bg = "none", fg = "#DCA561" },
        buffer_visible = { bg = "none", fg = "#839bd3" },
        close_button = { bg = "none" },
        close_button_selected = { bg = "none" },
        close_button_visible = { bg = "none" },
        duplicate = { bg = "none" },
        duplicate_selected = { bg = "none" },
        duplicate_visible = { bg = "none" },
        error = { bg = "none" },
        error_selected = { bg = "none" },
        error_visible = { bg = "none" },
        hint = { bg = "none" },
        hint_selected = { bg = "none" },
        hint_visible = { bg = "none" },
        indicator_selected = { bg = "none" },
        indicator_visible = { bg = "none" },
        info = { bg = "none" },
        info_selected = { bg = "none" },
        info_visible = { bg = "none" },
        modified = { bg = "none" },
        modified_selected = { bg = "none" },
        modified_visible = { bg = "none" },
        numbers = { bg = "none" },
        numbers_selected = { bg = "none" },
        numbers_visible = { bg = "none" },
        offset_separator = { bg = "none" },
        pick = { bg = "none" },
        pick_selected = { bg = "none" },
        pick_visible = { bg = "none" },
        separator = { bg = "none" },
        separator_selected = { bg = "none" },
        separator_visible = { bg = "none" },
        tab = { bg = "none" },
        tab_close = { bg = "none" },
        tab_selected = { bg = "none" },
        tab_separator = { bg = "none" },
        tab_separator_selected = { bg = "none" },
        trunc_marker = { bg = "none" },
        warning = { bg = "none" },
        warning_selected = { bg = "none" },
        warning_visible = { bg = "none" },
      },
    },
    keys = {
      { "<Tab>", ":BufferLineCycleNext<CR>", noremap = true, desc = "Next buffer" },
      { "<S-Tab>", ":BufferLineCyclePrev<CR>", noremap = true, desc = "Previous buffer" },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
    config = function(_, opts)
      vim.cmd("colorscheme kanagawa")
      require("kanagawa").setup(opts)
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {},
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
  {
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
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "Type .qa",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss all notifications" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
