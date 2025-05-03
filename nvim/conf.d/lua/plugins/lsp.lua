return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- lua
          "lua_ls",
          -- python
          "pyright",
          "ruff",
          -- sh
          "bashls",
          -- text,
          "vale_ls",
          -- yaml
          "yamlls",
        },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")

      -- lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim", "require" },
            },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      })
      vim.lsp.enable("lua_ls")
      -- python
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruff")
      -- sh
      vim.lsp.enable("bashls")
      -- text
      vim.lsp.enable("vale_ls")
      -- yaml
      vim.lsp.enable("yamlls")
    end,
  },
}
