-- Project configuration cache
local project_config_cache = {}

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
            local root = get_python_root(fname)
            if not root then
              return false
            end

            local proj_config = get_project_config(root)

            -- Don't use pylsp if pyright or ruff is used
            if proj_config.has_pyright or proj_config.has_ruff then
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
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })

      -- Cache for enabled LSP servers per buffer
      local buffer_lsp_cache = {}

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

        local cmp = require("blink.cmp")

        for server, config in pairs(opts.servers) do
          if not config.available or config.available(config, fname) then
            local lsp_config = config.lsp or {}
            lsp_config.capabilities = cmp.get_lsp_capabilities(lsp_config.capabilities)

            -- Set up LSP config if not already set
            if not vim.lsp.config[server] then
              vim.lsp.config[server] = lsp_config
            end

            -- Enable LSP for this buffer
            vim.lsp.enable(server)
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

      -- LspAttach autocmd for dynamic control
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
