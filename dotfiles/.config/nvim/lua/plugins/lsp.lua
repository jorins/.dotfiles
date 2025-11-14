return {
  'neovim/nvim-lspconfig',
  dependencies = { 'ms-jpq/coq_nvim' },
  opts = {
    'astro',
    {
      name = 'bicep',
      config = {
        cmd = {'dotnet', '/home/jorin/bicep-langserver/Bicep.LangServer.dll'},
      }
    },
    'csharp_ls',
    {
      name = 'elixirls',
      config = {
        cmd = { "elixir-ls" },
        on_attach = require("lsp-format").on_attach,
      }
    },
    'digestif', -- LaTeX server
    'eslint',
    'gdscript',
    'gleam',
    'gopls',
    'html',
    'jsonls',
    {
      name = 'powershell_es',
      config = {
        bundle_path = '/opt/powershell-editor-services'
      }
    },
    'pylsp',
    'rust_analyzer',
    'svelte',
    'ts_ls',
    'typeprof',
    'vimls',
    {
      name = 'yamlls',
      config = {
        settings = { yaml = {
          ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
          ['https://json.schemastore.org/github-action.json'] = '/.github/actions/*',
          ['https://taskfile.dev/schema.json'] = 'Taskfile.yml'
        } } }
    },
    {
      name = 'stylelint_lsp',
      config = {
        filetypes = { 'css', 'less', 'scss', 'sugarss', 'wxss' },
      },
    },
    {
      name = 'lua_ls',
      config = { settings = { Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true), },
        telemetry = { enable = false },
      } } } },
  },

  config = function(plugin, opts)
    local lspconfig = require('lspconfig')
    local coq = require('coq')
    local coqify = coq.lsp_ensure_capabilities

    for _, server in ipairs(opts) do
      local name
      local config

      if type(server) == 'string' then
        name = server
        config = {}

        -- If it's a table, extract name and override defaults
      elseif type(server) == 'table' then
        name = server.name or server[1]
        config = server.config

      else
        -- It's neither, that's not right
        error('Unhandled type of server specification:' .. type(server))
      end

      vim.lsp.config(name, coqify(config))
    end
  end
}
