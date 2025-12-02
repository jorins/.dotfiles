return {
  'folke/lsp-colors.nvim', -- Automatic theme fixing for LSP
  'junegunn/seoul256.vim', -- Theme
  'junegunn/vim-easy-align', -- Alignment, not neovim based
  'lukas-reineke/lsp-format.nvim', -- Format on save
  'mfussenegger/nvim-dap', -- Debugger
  'ms-jpq/coq.artifacts', -- Snippets
  'ms-jpq/coq_nvim', -- Completion
  'norcalli/nvim-colorizer.lua', -- Display colours of hex codes
  'numToStr/Comment.nvim', -- Comments
  'tversteeg/registers.nvim', -- Register peeking
  -- 'gleam-lang/gleam.vim', -- Gleam support

  { -- LSP base configs
    'neovim/nvim-lspconfig',
    dependencies = { 'ms-jpq/coq_nvim' },
  },

  { -- Surrounding
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
  },

  { -- File explorer
    'ms-jpq/chadtree',
    branch = 'chad',
    build = 'python3 -m chadtree deps',
  },

  { -- Git gutter
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  { -- Git GUI
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim'
    },
    config = true,
  },

  { -- Issue panel
    'folke/trouble.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
  },

  { -- Debugger UI
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' }
  },

  { -- Indentation indicators
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
          char = '▏'
      }
    }
  },

  { -- Automatic pairs
    'windwp/nvim-autopairs',
    opts = {
      check_ts = true,
    }
  },
}
