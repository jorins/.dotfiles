return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'astro',
        'bash',
        'css',
        'comment',
        'elixir',
        'gleam',
        'go',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'latex',
        'lua',
        'pug',
        'query',
        'rst',
        'scss',
        'typescript',
        'vim',
        'yaml',
      },
      highlight = { enable = true, },
      indent = { enable = true, },
      textobjects = {
        lsp_interop = {
          enable = true,
        },
      },
    })
  end
}
