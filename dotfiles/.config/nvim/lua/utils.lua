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

return utils
