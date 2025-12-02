local utils = require('utils')
local set = utils.set
local map = utils.mapAll

-- Bootstrap lazy.nvim
-- Snippet from https://github.com/folke/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Have to set auto start flag before require
vim.g.coq_settings = {
  auto_start = 'shut-up'
}

--[[ Plugins ]]--
require('lazy').setup('plugins')

--[[ LSP ]]--
local lsp = require('lsp')
lsp.configure(lsp.opts)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    require("lsp-format").on_attach(client, args.buf)
  end,
})

--[[ Options ]]
--
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

vim.g.chadtree_settings = {
  keymap = {
    primary = { '<Enter>', 'l' },
    collapse = { '<S-Tab>', '`', 'h' }
  }
}

--[[ Commands ]]--
vim.g.coq_settings = {
  auto_start = 'shut-up'
}

-- Highlight on yank
vim.cmd [[ autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = true} ]]

--[[ Bindings ]]
--
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
  { 'v', '<S-Tab>', '<gv', silent },

  -- Save with Ctrl+S
  -- May require setup with terminal emulator
  { '', '<C-S>', ':update<CR>', silent },
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
  { '', '<C-f>', ':Telescope find_files<CR>', silent },
  { '', '<S-C-f>', ':Telescope live_grep<CR>', silent },
  { '', '<A-f>', ':Telescope<CR>', silent },

  -- Trouble
  { '', '<M-t>', ':TroubleToggle<CR>', silent },

  -- LSP bindings
  { 'n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent },
  { 'n', 'gN', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent },
  -- {'n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent},
  { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', silent },
  -- {'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent},
  { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', silent },
  { 'n', 'cr', '<cmd>lua vim.lsp.buf.rename()<CR>', silent },
  { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', silent },
  -- {'n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', silent},

  -- Toggle file explorer with alt + E
  { '', '<M-e>', ':CHADopen<CR>', silent }
}
