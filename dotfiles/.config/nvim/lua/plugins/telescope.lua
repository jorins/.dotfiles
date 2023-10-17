local function ripgrep(args)
  args = args or {}
  local out = {
    "rg",
    "--no-config",
    "--no-ignore",
    "--hidden",
    "--glob",
    "!**/.git/*",
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
  config = function(plugin, opts)
    local telescope = require('telescope')
    local telescopeConfig = require('telescope.config')
    telescope.setup({
      opts = {
        defaults = {
          vimgrep_arguments = {
            unpack(telescopeConfig.values.vimgrep_arguments),
            '--hidden',
            '--glob',
            '!/**/.git/*'
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = ripgrep({'--files'}),
          },
          live_grep = {
            hidden = true,
            find_command = ripgrep()
          },
        }
      },
    })
    telescope.load_extension('fzf')
  end
}
