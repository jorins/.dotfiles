return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'css',
      'comment',
      'elixir',
      'go',
      'html',
      'javascript',
      'jsdoc',
      'json',
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
  },
}
