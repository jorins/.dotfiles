" ==== Basic settings ====
"
syntax enable
set termguicolors
set nocompatible
set foldmethod=syntax
set inccommand=nosplit
set updatetime=250
set scrolloff=4
set sidescrolloff=4

set number
set relativenumber

set autoindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set backupcopy=yes
set grepprg=rg\ --vimgrep

" ==== Plugins ====
call plug#begin('~/.vim/plugged')
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language server framework

  " ==== June Gunn's plugins (author of vim-plug) ====
  Plug 'junegunn/seoul256.vim' " Theme
  Plug 'junegunn/vim-peekaboo' " Register peek
  Plug 'junegunn/vim-easy-align' " Alignment
  Plug 'junegunn/goyo.vim' " Focus writing
  Plug 'junegunn/limelight.vim' " Focus writing
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
  Plug 'junegunn/fzf.vim' " Vim integrations for fzf
  " Plug 'junegunn/gv.vim' " Git commit visualiser, requires tpope/vim-fugitive

  " ==== Shougo's plugins (author of Deoplete) ====
  " Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } " File browser
  " Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' } " Interface fuzzy finder
  " Plug 'Shougo/deol.nvim', { 'do': ':UpdateRemotePlugins' } " Shells
  " Plug 'Shougo/deoppet.nvim' " Snippets (check this out once it's more ready)
  " Plug 'Shougo/deoplete.nvim' " Autocompletion, doesn't play nicely with coc

  " ==== tpope's plugins ====
  " Plug 'tpope/vim-fugitive' " Git commands, requirement for gv.vim
  " Plug 'tpope/vim-surround' " Surround stuff

  " ==== Misc. ====
  Plug 'preservim/nerdcommenter' " Comment functions
  " Plug 'preservim/nerdtree' " File browser
  Plug 'leafOfTree/vim-svelte-plugin' " Svelte
  Plug 'HerringtonDarkholme/yats.vim' " Typescript
  Plug 'digitaltoad/vim-pug' " Pug
  " Plug 'erichdongubler/vim-sublime-monokai'
call plug#end()

" ==== Coc extensions ====
let g:coc_global_extensions = [
  \ 'coc-yank',
  \ 'coc-snippets',
  \ 'coc-explorer',
  \ 'coc-pairs',
  \ 'coc-highlight',
  \ 'coc-git',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-tsserver',
  \ 'coc-pyright',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-svelte',
  \ ]

" ==== Plugin configuration ====
function! s:goyo_enter()
  Limelight
  CocCommand git.toggleGutters
endfunction
function! s:goyo_leave()
  Limelight!
  CocCommand git.toggleGutters
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

let g:vim_svelte_plugin_use_typescript=1
let g:vim_svelte_plugin_use_sass=1
let g:vim_svelte_plugin_use_foldexpr=1

command! -bang -nargs=* Find call fzf#vim#grep("rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob '!{.git,node_modules}' --color 'always' ".shellescape(<q-args>), 1, <bang>0)
nnoremap <silent> <C-F><C-F> :Find<CR>
nnoremap <silent> <C-F>f :Files<CR>

nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gN <Plug>(coc-diagnostic-prev)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" ==== Theme ====
let g:seoul256_background = 234
colo seoul256

" ==== Functions ====
" Allow saving of files as sudo when I forgot to start vim using sudo.
" from https://stackoverflow.com/a/7078429
cmap w!! w !sudo tee > /dev/null %

" Move lines with alt-j/k
" from http://vim.wikia.com/wiki/Moving_lines_up_or_down
" Tweaked to use arrow keys in insert mode
nnoremap <silent> <A-k> :m .-2<CR>==
nnoremap <silent> <A-j> :m .+1<CR>==
inoremap <silent> <A-down> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-up> <Esc>:m .-2<CR>==gi
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv

" Indentation control with tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <silent> <Tab> >gv
vnoremap <silent> <S-Tab> <gv

" Save with Ctrl+S
" May require setup with your temrinal emulator
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

noremap <silent> <C-n> :CocNext<CR>
noremap <silent> <C-p> :CocPrev<CR>

" Fold with space
" from http://vim.wikia.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Move with ctrl+hjkl
nnoremap <silent> <C-h> <C-\><C-N><C-w>h
nnoremap <silent> <C-j> <C-\><C-N><C-w>j
nnoremap <silent> <C-k> <C-\><C-N><C-w>k
nnoremap <silent> <C-l> <C-\><C-N><C-w>l
vnoremap <silent> <C-h> <C-\><C-N><C-w>h
vnoremap <silent> <C-j> <C-\><C-N><C-w>j
vnoremap <silent> <C-k> <C-\><C-N><C-w>k
vnoremap <silent> <C-l> <C-\><C-N><C-w>l
tnoremap <silent> <C-h> <C-\><C-N><C-w>h
tnoremap <silent> <C-j> <C-\><C-N><C-w>j
tnoremap <silent> <C-k> <C-\><C-N><C-w>k
tnoremap <silent> <C-l> <C-\><C-N><C-w>l

" Double-tap escape to leave terminal mode
tnoremap <Esc><Esc> <C-\><C-N>

" Start terminal
cnoremap zsh edit term://zsh

" Enter inserts newline
nnoremap <silent> <CR> o<Esc>
nnoremap <silent> <S-CR> O<Esc>

" Backspace deletes backwards
nnoremap <BS> dh
vnoremap <BS> d

" Making use of Swedish keys
nnoremap ö :
nnoremap Ö ;

nnoremap ä /
nnoremap Ä ^

nnoremap å }
nnoremap Å {

nnoremap ¤ $
vnoremap ¤ $
cnoremap ¤ $

" Easier copy/paste
nnoremap Y "+y
nnoremap P "+p

" Coc Explorer toggle
nnoremap <silent> <C-e> :CocCommand explorer<CR>
vnoremap <silent> <C-e> :CocCommand explorer<CR>
tnoremap <silent> <C-e> :CocCommand explorer<CR>i

" Window resizing
nnoremap <silent> + :resize +1<CR>
nnoremap <silent> - :resize -1<CR>
nnoremap <silent> <M-+> :vertical resize +1<CR>
nnoremap <silent> <M--> :vertical resize -1<CR>

vnoremap <silent> + :resize +1<CR>
vnoremap <silent> - :resize -1<CR>
vnoremap <silent> <M-+> :vertical resize +1<CR>
vnoremap <silent> <M--> :vertical resize -1<CR>

tnoremap <silent> <M-+> <C-\><C-N>:vertical resize +1<CR>i
tnoremap <silent> <M--> <C-\><C-N>:vertical resize -1<CR>i
tnoremap <silent> <M-?> <C-\><C-N>:resize +1<CR>i
tnoremap <silent> <M-_> <C-\><C-N>:resize -1<CR>i

" Startup commands
" from https://stackoverflow.com/a/5800087/4659324
function! StartUp()
    if 0 == argc()
        CocCommand explorer
    end
endfunction

autocmd VimEnter * call StartUp()

" Unfold all on opening
" from https://stackoverflow.com/a/8316817/4659324
au BufRead * normal zR
