local function match_file_content(file_path, pattern)
  local file = io.open(file_path, "r")
  if not file then
    return false
  end
  for line in file:lines() do
    if line:match(pattern) then
      file:close()
      return true
    end
  end
  file:close()
  return false
end

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
        -- docker
        dockerls = {},
        docker_compose_language_service = {},
        -- go
        gopls = {},
        -- html
        html = {},
        -- lua
        lua_ls = {
          lsp = {
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
        },
        -- python
        pyright = {
          available = function(_, fname)
            local util = require("lspconfig.util")
            local root = util.root_pattern("pyproject.toml")(fname)
            if not root then
              return true -- default to true if no pyproject.toml is found
            end
            local pyproject_path = root .. "/pyproject.toml"
            if match_file_content(pyproject_path, "pyright") then
              return true
            else
              return false
            end
          end,
        },
        ruff = {
          available = function(_, fname)
            local util = require("lspconfig.util")
            local root = util.root_pattern("pyproject.toml")(fname)
            if not root then
              return true -- default to true if no pyproject.toml is found
            end
            local pyproject_path = root .. "/pyproject.toml"
            if match_file_content(pyproject_path, "ruff") then
              return true
            else
              return
            end
          end,
        },
        pylsp = {
          libs = {
            mypy = "pylsp-mypy",
            black = "python-lsp-black",
            isort = "python-lsp-isort",
          },
          available = function(config, fname)
            local function is_any_lib_used(file_path)
              for lib, _ in pairs(config.libs) do
                if match_file_content(file_path, lib) then
                  return true
                end
              end
              return false
            end

            local util = require("lspconfig.util")
            local root = util.root_pattern("pyproject.toml")(fname)
            if not root then
              return false
            end
            local pyproject_path = root .. "/pyproject.toml"
            local pipfile_path = root .. "/Pipfile"
            if
              not (match_file_content(pyproject_path, "pyright") or match_file_content(pipfile_path, "pyright"))
              and not (match_file_content(pyproject_path, "ruff") or match_file_content(pipfile_path, "ruff"))
              and (is_any_lib_used(pyproject_path) or is_any_lib_used(pipfile_path))
            then
              return true
            else
              return false
            end
          end,
          init = function(config, fname)
            local function mason_package_path(package)
              local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
              return path
            end

            local util = require("lspconfig.util")
            local root = util.root_pattern("pyproject.toml")(fname)
            if not root then
              return
            end
            local pyproject_path = root .. "/pyproject.toml"
            local pipfile_path = root .. "/Pipfile"

            local path = mason_package_path("python-lsp-server")
            local command = path .. "/venv/bin/pip"

            local args = { "install", "-U" }
            for lib, lsp in pairs(config.libs) do
              if match_file_content(pyproject_path, lib) or match_file_content(pipfile_path, lib) then
                table.insert(args, lsp)
              end
            end

            require("plenary.job")
              :new({
                command = command,
                args = args,
                cwd = path,
              })
              :start()
          end,
          lsp = {
            root_dir = function(fname)
              local util = require("lspconfig.util")
              return util.root_pattern(
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "Pipfile",
                "requirements.txt",
                ".venv"
              )(fname) or util.path.dirname(fname)
            end,
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = { enabled = true },
                  pylint = { enabled = true },
                  flake8 = { enabled = false },
                  mypy = { enabled = true },
                  black = { enabled = true },
                  isort = { enabled = true },
                },
              },
            },
          },
        },
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
        typos_lsp = {},
      },
    },
    init = function(settings)
      local fname = vim.api.nvim_buf_get_name(0)
      local opts = settings.opts

      require("mason").setup({})
      for _, config in pairs(opts.servers) do
        if (not config.available or config.available(config, fname)) and config.init then
          config.init(config, fname)
        end
      end
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            local fname = vim.api.nvim_buf_get_name(0)

            local ensure_installed = {}
            for server, config in pairs(opts.servers) do
              if not config.available or config.available(config, fname) then
                table.insert(ensure_installed, server)
              end
            end

            require("mason").setup()
            require("mason-lspconfig").setup({
              ensure_installed = ensure_installed,
              automatic_installation = true,
            })

            local cmp = require("blink.cmp")
            for server, config in pairs(opts.servers) do
              if not config.available or config.available(config, fname) then
                local lsp_config = config.lsp or {}
                lsp_config.capabilities = cmp.get_lsp_capabilities(lsp_config.capabilities)
                vim.lsp.config[server] = lsp_config
                vim.lsp.enable(server)
              end
            end

            vim.keymap.set("n", "gd", "<cmd>:lua vim.lsp.buf.definition()<CR>")
          end)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local config = opts.servers[client.name]
          if
            client
            and config
            and config.available
            and not config.available(config, vim.api.nvim_buf_get_name(ev.buf))
          then
            vim.schedule(function()
              vim.lsp.buf_detach_client(ev.buf, client.id)
              client.stop()
            end)
          end
        end,
      })
    end,
  },
}
