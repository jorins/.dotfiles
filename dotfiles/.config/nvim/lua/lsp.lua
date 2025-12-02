local configure = function(opts)
  local coq = require('coq')
  local coqify = coq.lsp_ensure_capabilities

  for _, server in ipairs(opts) do
    local name
    local config

    if type(server) == 'string' then
      -- Name-only specification; use blank config
      name = server
      config = {}
    elseif type(server) == 'table' then
      -- If it's a table, extract name and override defaults
      name = server.name or server[1]
      config = server.config or server[2]
    else
      -- It's neither, that's not right
      error('Unhandled type of server specification:' .. type(server))
    end

    vim.lsp.config(name, coqify(config))
    vim.lsp.enable(name)
  end
end

local opts = {
  -- Default configs
  'astro',
  'csharp_ls',
  'digestif', -- LaTeX server
  'eslint',
  'gdscript',
  'gleam',
  'gopls',
  'html',
  'jsonls',
  'ruff', -- Python formatter & linter
  'rust_analyzer',
  'svelte',
  'ts_ls',
  -- 'ty',
  'vimls',

  { 'bicep', {
    cmd = { 'dotnet', '/home/jorin/bicep-langserver/Bicep.LangServer.dll' },
  } },

  { 'elixirls', {
    cmd = { "elixir-ls" },
    on_attach = require("lsp-format").on_attach,
  } },

  { 'powershell_es', {
    bundle_path = '/opt/powershell-editor-services'
  } },

  { 'pylsp', {
    settings = {
      pylsp = {
        plugins = {
          -- Force disable all the stuff I don't use.
          -- 1st party
          autopep8 = { enabled = false },
          flake8 = { enabled = false },
          mccabe = { enabled = false },
          preload = { enabled = false },
          pycodestyle = { enabled = false },
          pydocstyle = { enabled = false },
          pyflakes = { enabled = false },
          pylint = { enabled = false },
          yapf = { enabled = false },

          -- 3rd party
          isort = { enabled = false },
          black = { enabled = false },
          pylsp_rope = { enabled = false },
          ruff = { enabled = false },

          -- Formatting and linting handled by separate ruff server, so I only
          -- want mypy from here.
          pylsp_mypy = { enabled = true },
        }
      }
    },
  } },

  { 'yamlls', {
    settings = {
      yaml = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://json.schemastore.org/github-action.json'] = '/.github/actions/*',
        ['https://taskfile.dev/schema.json'] = 'Taskfile.yml'
      }
    }
  } },

  { 'stylelint_lsp', {
    filetypes = { 'css', 'less', 'scss', 'sugarss', 'wxss' },
  } },

  { 'lua_ls', {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true), },
        telemetry = { enable = false },
      }
    }
  } },
}

return {
  opts = opts,
  configure = configure,
}
