local utils = {}

function utils.set(val)
  if (type(val) == "table") then
    while val[1] do
      utils.set(table.remove(val, 1))
    end
    for k, v in pairs(val) do
      vim.opt[k]=v
    end
  elseif (type(val) == "string") then
    local n = val:match('^no(%a+)$')
    if n then
      vim.opt[n] = false
    else
      vim.opt[val] = true
    end
  end
end

function utils.set_tabs(opts)
  if (type(opts) == "number") then
    opts = {length=opts, tabs=false}
  end
  for _, tabopt in ipairs({'shiftwidth', 'tabstop'}) do
    print(tabopt)
    utils.set{[tabopt]=opts.length}
  end
  utils.set{et=not(opts.tabs)}
end

function utils.map(mode, combo, mapping, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

function utils.mapAll(mapTable)
  for index, mapping in ipairs(mapTable) do
    utils.map(mapping[1], mapping[2], mapping[3], mapping[4])
  end
end

function utils.prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

function utils.has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function utils.configurator(scope, prefix, separator)
  separator = separator or '_'
  return function(opts)
    for index, value in pairs(opts) do
      scope[prefix .. separator .. index] = value
    end
  end
end

---@alias server_spec detailed_server_spec | string
--
---@param opts lsp_opts
--
---@class lsp_opts
---@field config table
---@field servers server_spec[]
--
---@class detailed_server_spec
---@field name string
---@field config table
--
---@return fun() -> nil
function utils.configure_lsp(opts)
  return function()
    local lspconfig = require('lspconfig')
    local coq = require('coq')
    local coqify = coq.lsp_ensure_capabilities

    for index, server in pairs(opts.servers) do
      print('Processing ' .. name)
      local name
      local config = {}

      -- Copy our defaults to the new table
      for key, val in pairs(opts.config) do
        config[key] = val
      end

      if type(server) == 'string' then
        -- If it's a string, that's all we need
        name = server

      elseif type(server) == 'table' then
        -- It's a table, extract name and override defaults
        name = server.name
        for key, val in pairs(server.config) do
          config[key] = val
        end

      else
        -- It's neither, that's not right
        error(string.format(
          'Unhandled type of server specification #%s, expected server or string but got %s',
          index, type(server)
        ))
      end

      print(index .. '. ' .. name .. ' -> ' .. vim.inspect(config))

      -- Finally run the configuration with generated settings
      lspconfig[name].setup(coqify(config))
    end
  end
end

return utils
