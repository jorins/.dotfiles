local cmd = vim.cmd
local fn = vim.fn
local o = vim.opt
local g = vim.g

local utils = require 'utils'
local set = utils.set
local map = utils.mapAll

-------------
-- Plugins --
-------------
require('packer').startup(function (use)
  -- Core
  use {
    -- Package manager
    {
      'wbthomason/packer.nvim'
    },

    -- LSP configs
    {
      'neovim/nvim-lspconfig',
      requires = { 'ms-jpq/coq_nvim' },
      config = function()
        local lspconfig = require 'lspconfig'
        local coqify = require('coq').lsp_ensure_capabilities

        local on_attach = function(client, bufno)
          -- Format on save
          cmd([[ autocmd BufWritePre <buffer=> lua vim.lsp.buf.formatting_sync() ]])
        end

        local servers = {
          -- Install most servers with
          -- $ npm install --global vscode-langservers-extracted stylelint-lsp typescript typescript-language-server yaml-language-server vim-language-server

          -- General purpose languages
          'elixirls',
          'gopls',
          { 'sumneko_lua', {
            settings = {
              Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true), },
          } } } },
          'powershell_es',
          'pylsp',
          'typeprof',
          'rust_analyzer',

          -- Web
          'eslint',
          'html',
          'stylelint_lsp',
          'svelte',
          'tsserver',

          -- DSLs
          'gdscript',
          'vimls',

          -- Data
          'bicep',
          'jsonls',
          'yamlls',
        }

        for _, server in pairs(servers) do
          -- Assume plain string by default and build default config
          local name = server
          local config = { on_attach = on_attach }

          if type(server) == 'table' then
            -- If table, override
            name = server[1]
            for key, val in pairs(server[2]) do
              config[key] = val
            end
          end

          lspconfig[name].setup(coqify(config))
        end
      end
    },

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = 'maintained',
          highlight = {
            enable = true,
          },

          indent = {
            enable = true,
          },

          textobjects = {
            lsp_interop = {
              enable = true,
            },
          },
        }
      end
    },
  }

  -- Extension
  use {
    -- Completion
    { 'ms-jpq/coq_nvim' },

    -- Snippets
    { 'ms-jpq/coq.artifacts' },

    -- Fuzzy finding
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      },
      config = function()
        local telescope = require('telescope')
        telescope.setup {}
        telescope.load_extension('fzf')
      end
    },
  }

  -- GUI
  use {
    -- Theme
    {
      'junegunn/seoul256.vim'
    },

    -- File explorer
    {
      'ms-jpq/chadtree',
      branch = 'chad',
      run = 'python3 -m chadtree deps',
    },

    -- Git gutter
    {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup()
      end
    },
  }

  -- Utilities
  use {
    -- Register peeking
    {
      'tversteeg/registers.nvim'
    },

    -- Comments
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    },

    -- Indentation indicators
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require('indent_blankline').setup {
          -- Config seems broken, so it's also set with g: variables
          space_char_blankline = ' ',
          context_char = '¦',
          show_current_context = true,
          show_current_context_start = false,
          use_treesitter = true,
          char_list = {' '},
        }
      end
    },

    --[[
    -- Surrounding
    -- Looking for a solution here.
    --{  }
    --]]

    -- Alignment, not neovim based
    {
        'junegunn/vim-easy-align'
    },

    -- Colour rendering
    {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    },
  }
end)

-------------
-- Options --
-------------

-- Theme
g.seoul256_background = 234
cmd 'colorscheme seoul256'

-- Basic settings
set {
  -- Basics
  termguicolors = true,
  number = true,
  relativenumber = true,

  -- Folding
  foldmethod = 'expr',
  foldexpr = 'nvim_treesitter#foldexpr()',
  foldlevelstart = 20,

  -- Tabs
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,

  -- Etc.
  grepprg = 'rg --vimgrep',
  updatetime = 100,
  scrolloff = 8,
  sidescrolloff = 10,
  -- colorcolumn = '81',
}

--[[ indentBlankline {
  -- Config seems broken, so it's also set with g: variables
  space_char_blankline = ' ',
  context_char = '¦',
  show_current_context = true,
  show_current_context_start = false,
  use_treesitter = true,
  char_list = {' '},
} ]]

g.chadtree_settings = { keymap = {
  primary = { '<Enter>', 'l' },
  collapse = { '<S-Tab>', '`', 'h' }
}}

g.coq_settings = {
  auto_start = 'shut-up'
}

--------------
-- Commands --
--------------

-- Highlight on yank
cmd [[ autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = true} ]]

--------------
-- Bindings --
--------------
local silent = {
  silent = true,
  noremap = true,
}

local loud = {
  silent = false,
  noremap = true,
}

map {
  -- Move lines with alt-j/k
  -- from http://vim.wikia.com/wiki/Moving_lines_up_or_down
  -- Tweaked to use arrow keys in insert mode
  { 'n', '<A-j>', ':m .+1<CR>==', silent },
  { 'n', '<A-k>', ':m .-2<CR>==', silent },
  { 'i', '<A-down>', '<Esc>:m .+1<CR>==gi', silent },
  { 'i', '<A-up>', '<Esc>:m .-2<CR>==gi', silent },
  { 'v', '<A-j>', ":m '>+1<CR>gv=gv", silent },
  { 'v', '<A-k>', ":m '<-2<CR>gv=gv", silent },

  -- Indentation control with tab
  { 'n', '<Tab>', '>>', silent },
  { 'n', '<S-Tab>', '<<', silent },
  { 'v', '<Tab>', '>gv', silent },
  { 'v', '<S-Tab>',  '<gv', silent },

  -- Save with Ctrl+S
  -- May require setup with terminal emulator
  { '',  '<C-S>', ':update<CR>', silent },
  { 'v', '<C-S>', '<C-C>:update<CR>', silent },
  { 'i', '<C-S>', '<C-O>:update<CR>', silent },

  -- Fold with space
  -- from http://vim.wikia.com/wiki/Folding
  { 'n', '<Space>', [[@=(foldlevel('.')?'za':"\\<Space>")<CR>]], silent },
  { 'v', '<Space>', 'zf', silent },

  -- Move with ctrl+hjkl
  { 'n', '<C-h>', '<C-\\><C-N><C-w>h', silent },
  { 'n', '<C-j>', '<C-\\><C-N><C-w>j', silent },
  { 'n', '<C-k>', '<C-\\><C-N><C-w>k', silent },
  { 'n', '<C-l>', '<C-\\><C-N><C-w>l', silent },
  { 'v', '<C-h>', '<C-\\><C-N><C-w>h', silent },
  { 'v', '<C-j>', '<C-\\><C-N><C-w>j', silent },
  { 'v', '<C-k>', '<C-\\><C-N><C-w>k', silent },
  { 'v', '<C-l>', '<C-\\><C-N><C-w>l', silent },
  { 't', '<C-h>', '<C-\\><C-N><C-w>h', silent },
  { 't', '<C-j>', '<C-\\><C-N><C-w>j', silent },
  { 't', '<C-k>', '<C-\\><C-N><C-w>k', silent },
  { 't', '<C-l>', '<C-\\><C-N><C-w>l', silent },

  -- Double-tap escape to leave terminal mode
  { 't', '<Esc><Esc>', '<C-\\><C-N>', silent },

  -- Start terminal
  { 'c', 'zsh', 'edit term://zsh', silent },

  -- Enter inserts newline
  { 'n', '<CR>', 'o<Esc>', silent },
  { 'n', '<S-CR>', 'O<Esc>', silent },

  -- Backspace deletes backwards
  { 'n', '<BS>', 'dh', silent },
  { 'v', '<BS>', 'd', silent },

  -- Making use of Swedish keys
  { '', 'ö', ':', loud },
  { '', 'Ö', ';', loud },
  { '', 'ä', '/', loud },
  { '', 'Ä', '^', loud },
  { '', 'å', '}', loud },
  { '', 'Å', '{', loud },
  { '', '¤', '$', loud },

  -- Easier copy/paste
  { '', 'Y', '"+y', loud },
  { 'n', 'P', '"+p', loud },

  -- Window resizing
  { 'n', '+', ':resize +1<CR>', loud },
  { 'n', '-', ':resize -1<CR>', loud },
  { 'n', '<M-+>', ':vertical resize +1<CR>', loud },
  { 'n', '<M-->', ':vertical resize -1<CR>', loud },

  { 'v', '+', ':resize +1<CR>', loud },
  { 'v', '-', ':resize -1<CR>', loud },
  { 'v', '<M-+>', ':vertical resize +1<CR>', loud },
  { 'v', '<M-->', ':vertical resize -1<CR>', loud },

  { 't', '<M-+>', '<C-\\><C-N>:vertical resize +1<CR>i', loud },
  { 't', '<M-->', '<C-\\><C-N>:vertical resize -1<CR>i', loud },
  { 't', '<M-?>', '<C-\\><C-N>:resize +1<CR>i', loud },
  { 't', '<M-_>', '<C-\\><C-N>:resize -1<CR>i', loud },

  -- Telescope finding
  { '', '<C-f>', ':Telescope find_files<CR>', loud},
  { '', '<S-C-f>', ':Telescope live_grep<CR>', loud},
  { '', '<A-f>', ':Telescope<CR>', loud},

  -- LSP bindings
  {'n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent},
  {'n', 'gN', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent},
  -- {'n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent},
  {'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', silent},
  -- {'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent},
  {'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', silent},
  {'n', 'cr', '<cmd>lua vim.lsp.buf.rename()<CR>', silent},
  {'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', silent},
  -- {'n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', silent},

  -- Toggle file explorer with alt + E
  {'', '<M-e>', ':CHADopen<CR>', silent}
}
