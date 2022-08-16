local utils = require('utils')
local set = utils.set
local map = utils.mapAll

--[[ Plugins ]]--
require('packer').startup(function (use)
  use { -- Core
    'wbthomason/packer.nvim', -- Package manager

    { -- LSP configs
      -- Install most servers with
      -- $ npm install --global vscode-langservers-extracted stylelint-lsp typescript typescript-language-server yaml-language-server vim-language-server
      'neovim/nvim-lspconfig',
      requires = { 'ms-jpq/coq_nvim' },
      config = function() require('utils').configure_lsp({
        config =  {
          on_attach = function(client, bufno)
          end,
        },

        servers = {
          'bicep',
          'elixirls',
          'eslint',
          'gdscript',
          'gopls',
          'html',
          'jsonls',
          'powershell_es',
          'pylsp',
          'rust_analyzer',
          'svelte',
          'tsserver',
          'typeprof',
          'vimls',
          {
            name = 'yamlls',
            config = {
              settings = { yaml = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            } } }
          },
          {
            name = 'stylelint_lsp',
            config = {
              filetypes = { 'css', 'less', 'scss', 'sugarss', 'wxss' },
            },
          },
          {
            name = 'sumneko_lua',
            config = { settings = { Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file('', true), },
          } } } },
        },
      }) end
    },

    { -- Treesitter
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
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
        }
      end
    },

    'mfussenegger/nvim-dap', -- Debugger
  }

  use { -- Extension
    'ms-jpq/coq_nvim', -- Completion
    'ms-jpq/coq.artifacts', -- Snippets

    { -- Fuzzy finding
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
      },
      config = function()
        local telescope = require('telescope')
        telescope.setup {}
        telescope.load_extension('fzf')
      end
    },
  }

  use { -- GUI
    'junegunn/seoul256.vim', -- Theme

    'folke/lsp-colors.nvim', -- Automatic theme fixing for LSP

    { -- File explorer
      'ms-jpq/chadtree',
      branch = 'chad',
      run = 'python3 -m chadtree deps',
    },

    { -- Git gutter
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup()
      end
    },

    { -- Issue panel
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require('trouble').setup {} end
    },

    { -- Debugger UI
      'rcarriga/nvim-dap-ui',
      requires = { 'mfussenegger/nvim-dap' }
    },
  }

  use { -- Utilities
    'tversteeg/registers.nvim', -- Register peeking

    'lukas-reineke/lsp-format.nvim', -- Format on save

    { -- Comments
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    },

    { -- Indentation indicators
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('indent_blankline').setup {
          space_char_blankline = ' ',
          context_char = '¦',
          show_current_context = true,
          show_current_context_start = false,
          use_treesitter = true,
          char_list = {' '},
        }
      end
    },

    { -- Automatic pairs
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup({
          check_ts = true,
        })
      end
    },

    'junegunn/vim-easy-align', -- Alignment, not neovim based

    { -- Colour rendering
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    },
  }
end)

--[[ Options ]]--
-- Theme
vim.g.seoul256_background = 234
vim.cmd 'colorscheme seoul256'

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
}

vim.g.chadtree_settings = { keymap = {
  primary = { '<Enter>', 'l' },
  collapse = { '<S-Tab>', '`', 'h' }
}}

vim.g.coq_settings = {
  auto_start = 'shut-up'
}

--[[ Commands ]]--

-- Highlight on yank
vim.cmd [[ autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = true} ]]

--[[ Bindings ]]--
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
  { 'v', '<A-j>', [[:m '>+1<CR>gv=gv]], silent },
  { 'v', '<A-k>', [[:m '<-2<CR>gv=gv]], silent },

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

  -- Tab controls
  { 'n', '<C-w>t', ':tabnew<CR>', silent},
  { 'n', '<C-tab>', ':tabnext<CR>', silent},
  { 'n', '<C-S-tab>', ':tabprevious<CR>', silent},

  -- Double-tap escape to leave terminal mode
  { 't', '<Esc><Esc>', '<C-\\><C-N>', silent },

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
  { 'n', '+', ':resize +1<CR>', silent },
  { 'n', '-', ':resize -1<CR>', silent },
  { 'n', '<M-+>', ':vertical resize +1<CR>', silent },
  { 'n', '<M-->', ':vertical resize -1<CR>', silent },

  { 'v', '+', ':resize +1<CR>', silent },
  { 'v', '-', ':resize -1<CR>', silent },
  { 'v', '<M-+>', ':vertical resize +1<CR>', silent },
  { 'v', '<M-->', ':vertical resize -1<CR>', silent },

  { 't', '<M-+>', '<C-\\><C-N>:vertical resize +1<CR>i', silent },
  { 't', '<M-->', '<C-\\><C-N>:vertical resize -1<CR>i', silent },
  { 't', '<M-?>', '<C-\\><C-N>:resize +1<CR>i', silent },
  { 't', '<M-_>', '<C-\\><C-N>:resize -1<CR>i', silent },

  -- Telescope finding
  { '', '<C-f>', ':Telescope find_files<CR>', silent},
  { '', '<S-C-f>', ':Telescope live_grep<CR>', silent},
  { '', '<A-f>', ':Telescope<CR>', silent},

  -- Trouble
  { '', '<M-t>', ':TroubleToggle<CR>', silent},

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
