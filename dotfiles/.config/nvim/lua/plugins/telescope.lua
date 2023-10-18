local function ripgrep(args)
  args = args or {}
  local out = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--trim',
    '--hidden',
    '--glob',
    '!**/.git/*',
  }
  for _, val in ipairs(args) do
    table.insert(out, val)
  end
  return out
end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  opts = {
    defaults = {
      vimgrep_arguments = ripgrep(),
    },
    pickers = {
      find_files = {
        hidden = true,
        follow = true,
        find_command = ripgrep({'--files'}),
      },
    }
  },
}
