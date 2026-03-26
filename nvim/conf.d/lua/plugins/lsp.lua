-- Project configuration cache
local project_config_cache = {}

-- Cache for enabled LSP servers per buffer
local buffer_lsp_cache = {}

-- Get project-local LSP configuration from vim.g.lsp_config (.nvim.lua)
local function get_project_local_config()
  return vim.g.lsp_config or {}
end

-- Get project configuration with caching
local function get_project_config(root_dir)
  if project_config_cache[root_dir] then
    return project_config_cache[root_dir]
  end

  local config = {
    has_pyright = false,
    has_ruff = false,
    has_mypy = false,
    has_black = false,
    has_isort = false,
    has_pylint = false,
  }

  -- Check pyproject.toml
  local pyproject_path = root_dir .. "/pyproject.toml"
  local pyproject_file = io.open(pyproject_path, "r")
  if pyproject_file then
    local content = pyproject_file:read("*all")
    pyproject_file:close()

    -- More accurate matching: consider sections and keys
    config.has_pyright = content:match("%[tool%.pyright%]") ~= nil or content:match("pyright%s*=") ~= nil
    config.has_ruff = content:match("%[tool%.ruff%]") ~= nil or content:match("ruff%s*=") ~= nil
    config.has_mypy = content:match("%[tool%.mypy%]") ~= nil or content:match("mypy%s*=") ~= nil
    config.has_black = content:match("%[tool%.black%]") ~= nil or content:match("black%s*=") ~= nil
    config.has_isort = content:match("%[tool%.isort%]") ~= nil or content:match("isort%s*=") ~= nil
    config.has_pylint = content:match("%[tool%.pylint%]") ~= nil or content:match("pylint%s*=") ~= nil
  end

  -- Check Pipfile
  local pipfile_path = root_dir .. "/Pipfile"
  local pipfile = io.open(pipfile_path, "r")
  if pipfile then
    local content = pipfile:read("*all")
    pipfile:close()

    config.has_pyright = config.has_pyright or content:match("pyright") ~= nil
    config.has_ruff = config.has_ruff or content:match("ruff") ~= nil
    config.has_mypy = config.has_mypy or content:match("mypy") ~= nil
    config.has_black = config.has_black or content:match("black") ~= nil
    config.has_isort = config.has_isort or content:match("isort") ~= nil
    config.has_pylint = config.has_pylint or content:match("pylint") ~= nil
  end

  project_config_cache[root_dir] = config

  -- Debug logging
  if vim.g.lsp_debug then
    vim.notify(string.format("Project config for %s: %s", root_dir, vim.inspect(config)), vim.log.levels.INFO)
  end

  return config
end

-- Get Python project root directory
local function get_python_root(fname)
  local util = require("lspconfig.util")
  return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "Pipfile", "requirements.txt", ".git")(fname)
end

-- Mason package path helper
local function mason_package_path(package)
  local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
  return path
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
        -- css
        cssls = {},
        tailwindcss = {},
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
            root_dir = function(bufnr)
              local fname = type(bufnr) == "number" and vim.api.nvim_buf_get_name(bufnr) or bufnr
              local util = require("lspconfig.util")
              return util.root_pattern(".git", "stylua.toml", ".stylua.toml")(fname) or vim.fs.dirname(fname)
            end,
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                  disable = { "missing-fields" },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("config"),
                  },
                  checkThirdParty = false,
                },
                telemetry = {
                  enable = false,
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          },
        },
        -- python
        pyright = {
          available = function(_, fname)
            local root = get_python_root(fname)
            if not root then
              return false
            end
            local config = get_project_config(root)
            return config.has_pyright
          end,
        },
        ruff = {
          available = function(_, fname)
            local root = get_python_root(fname)
            if not root then
              return false
            end
            local config = get_project_config(root)
            return config.has_ruff
          end,
        },
        pylsp = {
          libs = {
            mypy = "pylsp-mypy",
            black = "python-lsp-black",
            isort = "python-lsp-isort",
          },
          available = function(config, fname)
            local bufnr = vim.fn.bufnr(fname)
            if bufnr ~= -1 and vim.bo[bufnr].filetype ~= "python" then
              return false
            end

            local root = get_python_root(fname)
            if not root then
              return false
            end

            local proj_config = get_project_config(root)

            -- Don't use pylsp if pyright is used
            if proj_config.has_pyright then
              return false
            end

            -- Enable only if mypy, black, or isort is used
            return proj_config.has_mypy or proj_config.has_black or proj_config.has_isort
          end,
          init = function(config, fname)
            local root = get_python_root(fname)
            if not root then
              return
            end

            local proj_config = get_project_config(root)
            local path = mason_package_path("python-lsp-server")
            local command = path .. "/venv/bin/pip"

            local args = { "install", "-U" }
            if proj_config.has_mypy then
              table.insert(args, config.libs.mypy)
            end
            if proj_config.has_black then
              table.insert(args, config.libs.black)
            end
            if proj_config.has_isort then
              table.insert(args, config.libs.isort)
            end

            -- Only install if there are plugins to install
            if #args > 2 then
              require("plenary.job")
                :new({
                  command = command,
                  args = args,
                  cwd = path,
                })
                :start()
            end
          end,
          get_lsp_config = function(config, fname)
            local root = get_python_root(fname)
            if not root then
              return {}
            end

            local proj_config = get_project_config(root)
            local util = require("lspconfig.util")

            local pylsp_cmd = nil
            local venv_dir = root .. "/.venv"
            if vim.fn.isdirectory(venv_dir) == 1 then
              local direct = venv_dir .. "/bin/pylsp"
              if vim.fn.executable(direct) == 1 then
                pylsp_cmd = { direct }
              else
                local venv_entries = vim.fn.glob(venv_dir .. "/*/bin/pylsp", false, true)
                if #venv_entries > 0 then
                  pylsp_cmd = { venv_entries[1] }
                end
              end
            end

            local pylsp_mypy_cfg = { enabled = proj_config.has_mypy, live_mode = false }
            local venv_mypy = root .. "/.venv/bin/mypy"
            local venv_python = root .. "/.venv/bin/python"
            if vim.fn.executable(venv_mypy) == 1 then
              pylsp_mypy_cfg.overrides = { "--python-executable", venv_python, true }
              pylsp_mypy_cfg.mypy_command = { venv_mypy }
            end

            local pylsp_settings = {
              pylsp = {
                plugins = {
                  pycodestyle = { enabled = true },
                  pylint = { enabled = proj_config.has_pylint },
                  flake8 = { enabled = false },
                  pylsp_mypy = pylsp_mypy_cfg,
                  black = { enabled = proj_config.has_black },
                  isort = { enabled = proj_config.has_isort },
                },
              },
            }

            local lsp_config = {
              filetypes = { "python" },
              root_dir = util.root_pattern(
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "Pipfile",
                "requirements.txt",
                ".venv"
              )(fname) or vim.fs.dirname(fname),
              settings = pylsp_settings,
              on_init = function(client)
                client.notify("workspace/didChangeConfiguration", { settings = pylsp_settings })
              end,
            }
            lsp_config.cmd = pylsp_cmd or { "pylsp" }
            if vim.fn.executable(venv_mypy) == 1 then
              lsp_config.cmd_env = { PYLSP_MYPY_ALLOW_DANGEROUS_CODE_EXECUTION = "1" }
            end
            return lsp_config
          end,
        },
        -- rust
        rust_analyzer = {},
        -- sh
        bashls = {},
        -- text
        vale_ls = {},
        -- typescript
        biome = {},
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
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        automatic_enable = { exclude = { "pylsp" } },
      })

      -- Setup static LSP configurations once (excluding dynamic ones like pylsp)
      local cmp = require("blink.cmp")
      local local_cfg = get_project_local_config()
      local overrides = local_cfg.override or {}
      for server, config in pairs(opts.servers) do
        if not config.get_lsp_config then
          local lsp_config = vim.tbl_deep_extend("force", config.lsp or {}, overrides[server] or {})
          lsp_config.capabilities = cmp.get_lsp_capabilities(lsp_config.capabilities)
          vim.lsp.config[server] = lsp_config
        end
      end

      -- Setup LSP for each buffer
      local function setup_lsp_for_buffer(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == "" then
          return
        end

        -- Avoid duplicate setup
        if buffer_lsp_cache[bufnr] then
          return
        end
        buffer_lsp_cache[bufnr] = true

        local local_cfg = get_project_local_config()
        local disabled = local_cfg.disable or {}
        local overrides = local_cfg.override or {}

        for server, config in pairs(opts.servers) do
          local force_enabled = overrides[server] and overrides[server].force_enable
          if vim.tbl_contains(disabled, server) then
            -- skip: disabled by project-local config
          elseif force_enabled or not config.available or config.available(config, fname) then
            if config.get_lsp_config then
              local lsp_config = config.get_lsp_config(config, fname)
              local server_overrides = vim.deepcopy(overrides[server] or {})
              server_overrides.force_enable = nil
              lsp_config = vim.tbl_deep_extend("force", lsp_config, server_overrides)
              if lsp_config.settings then
                lsp_config.on_init = function(client)
                  client.notify("workspace/didChangeConfiguration", { settings = lsp_config.settings })
                end
              end
              lsp_config.capabilities = cmp.get_lsp_capabilities(lsp_config.capabilities)
              lsp_config.name = server
              vim.lsp.start(lsp_config, { bufnr = bufnr })
            else
              if overrides[server] then
                local server_overrides = vim.deepcopy(overrides[server])
                server_overrides.force_enable = nil
                local lsp_config = vim.tbl_deep_extend("force", vim.lsp.config[server] or {}, server_overrides)
                lsp_config.capabilities = cmp.get_lsp_capabilities(lsp_config.capabilities)
                vim.lsp.config[server] = lsp_config
              end
              vim.lsp.enable(server)
            end
          end
        end
      end

      -- Setup LSP on FileType event
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          setup_lsp_for_buffer(ev.buf)
        end,
      })

      -- Setup LSP for existing buffers
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(bufnr) then
                setup_lsp_for_buffer(bufnr)
              end
            end

            -- Setup keybindings
            vim.keymap.set("n", "gd", "<cmd>:lua vim.lsp.buf.definition()<CR>")
          end)
        end,
      })

      -- Clear cache when configuration files are modified
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "pyproject.toml", "Pipfile" },
        callback = function()
          local fname = vim.fn.expand("<afile>:p")
          local root = vim.fn.fnamemodify(fname, ":h")
          project_config_cache[root] = nil

          if vim.g.lsp_debug then
            vim.notify(string.format("Cleared cache for %s", root), vim.log.levels.INFO)
          end
        end,
      })

      -- Clear all caches when .nvim.lua is modified (project-local LSP config may have changed)
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { ".nvim.lua" },
        callback = function()
          project_config_cache = {}
          buffer_lsp_cache = {}

          if vim.g.lsp_debug then
            vim.notify("Cleared all LSP caches (.nvim.lua modified)", vim.log.levels.INFO)
          end

          vim.schedule(function()
            for _, client in ipairs(vim.lsp.get_clients()) do
              local buffers = vim.lsp.get_buffers_by_client_id(client.id)
              client.stop()
              for _, bufnr in ipairs(buffers) do
                setup_lsp_for_buffer(bufnr)
              end
            end
          end)
        end,
      })

      -- LspAttach autocmd for dynamic control
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local config = opts.servers[client.name]
          local local_cfg = get_project_local_config()
          local overrides = local_cfg.override or {}
          local force_enabled = overrides[client.name] and overrides[client.name].force_enable
          if
            client
            and config
            and not force_enabled
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
