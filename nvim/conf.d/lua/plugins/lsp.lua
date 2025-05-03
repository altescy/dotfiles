return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        -- go
        gopls = {},
        -- html
        html = {},
        -- lua
        lua_ls = {
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
        },
        -- python
        pyright = {},
        ruff = {},
        -- rust
        rust_analyzer = {},
        -- sh
        bashls = {},
        -- text
        vale_ls = {},
        -- typescript
        ts_ls = {},
        -- yaml
        yamlls = {},
        -- others
        efm = {},
        typos_lsp = {
          cmd = { "typos-lsp" },
          root_markers = { "typos.toml", "_typos.toml", ".typos.toml", "pyproject.toml", "Cargo.toml", ".git" },
        },
      },
    },
    config = function(_, opts)
      local ensure_installed = {}
      for server, _ in pairs(opts.servers) do
        table.insert(ensure_installed, server)
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
        vim.lsp.enable(server)
      end
    end,
  },
}
