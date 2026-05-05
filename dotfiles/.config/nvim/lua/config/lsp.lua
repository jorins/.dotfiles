local configure = function(opts)
  -- Set up autocompletion integration
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
  'basedpyright', -- Python type checker
  'csharp_ls',
  'dartls',
  'digestif', -- LaTeX server
  'eslint',
  'gdscript',
  'gleam',
  'gopls',
  'harper', -- Grammer checker
  'html',
  'jsonls',
  'ruff', -- Python formatter & linter
  'rust_analyzer',
  'svelte',
  'tinymist', -- Typst language server
  'ts_ls',
  'vimls',

  { 'bicep', {
    cmd = { 'dotnet', '/home/jorin/bicep-langserver/Bicep.LangServer.dll' },
  } },

  { 'elixirls', {
    cmd = { "elixir-ls" },
    -- on_attach = require("lsp-format").on_attach,
  } },

  { 'powershell_es', {
    bundle_path = '/opt/powershell-editor-services'
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

configure(opts)

-- return {
--   opts = opts,
--   configure = configure,
-- }

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--     require("lsp-format").on_attach(client, args.buf)
--   end,
-- })
