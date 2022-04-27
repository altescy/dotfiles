""" LINE NUMBER
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

set noswapfile

let mapleader = "\<Space>"

inoremap <C-c> <ESC>
inoremap <silent> jj <ESC>
inoremap <silent> kk <ESC>
inoremap <silent> <C-j> j
inoremap <silent> <C-k> k
noremap <C-c><C-c> :nohlsearch<Cr><Esc>
noremap <C-N><C-N> :set relativenumber!<CR>

" For terminal
tnoremap <Esc> <C-\><C-n>
command! -nargs=* T split | wincmd j | resize 10 | terminal <args>

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set expandtab
set incsearch
set ignorecase
set smartcase
set hlsearch
set cursorline
set cursorcolumn
set mouse=a
set spell
set spelllang=en,cjk

autocmd ColorScheme * hi clear SpellBad
    \| hi SpellBad cterm=underline

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif
" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" setup filetypes
autocmd BufNewFile,BufRead *.jsonnet setfiletype jsonnet
autocmd BufNewFile,BufRead *.libsonnet setfiletype libsonnet
autocmd BufNewFile,BufRead *.nim setfiletype nim
autocmd BufNewFile,BufRead *.nimble setfiletype nimble
autocmd BufNewFile,BufRead *.hsh setfiletype hush

""" dein
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein#install_process_timeout = 600

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand("~/.config/nvim/")
  if !filereadable(g:rc_dir . './dein.toml')
    execute '!touch ' . g:rc_dir . '/dein.toml'
  endif
  if !filereadable(g:rc_dir . './dein_lazy.toml')
    execute '!touch ' . g:rc_dir . '/dein_lazy.toml'
  endif
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()

  filetype plugin indent on
endif

if dein#check_install()
  call dein#install()
endif
