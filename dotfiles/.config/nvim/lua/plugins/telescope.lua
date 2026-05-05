-- General purpose finder
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
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },

  keys = {
    {
      '<C-f>',
      ':Telescope find_files<CR>',
      desc="Find files (Telescope)",
      silent=true,
    },
    {
      '<S-C-f>',
      ':Telescope live_grep<CR>',
      desc="Live grep (Telescope)",
      silent=true,
    },
    {
      '<A-f>',
      ':Telescope<CR>',
      desc="Find anything (Telescope)",
      silent=true,
    }
  },

  opts = {
    defaults = {
      vimgrep_arguments = ripgrep(),
    },
    pickers = {
      find_files = {
        hidden = true,
        follow = true,
        find_command = ripgrep({ '--files' }),
      },
    }
  },
}
