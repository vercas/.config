""""""""""""""""
"   Very basics.

set shell=bash

""""""""""""""""""
"   Mouse support.

if has("mouse")
    set mouse=a
endif

"""""""""""""""""""""""""""
"   Swap, backups and undo.

set backup
set writebackup

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

"""""""""""""""""""
"   Tab completion.

set wildmode=longest,list
set wildmenu

""""""""""""""""
"   Line numbas.

set number

""""""""""""""""""""""""""""""""""""""""""""
"   Case-insensitive and hilighted searches.

set ignorecase
set hlsearch

""""""""""""""""
"   Indentation.

set expandtab
set sw=4
set sts=4
" 4 spaces per tab.

autocmd FileType make set ts=4
" Makefiles should still get hard tabs, but displayed as 4 spaces.

set list
set listchars=tab:·\ ,eol:⏎,trail:·,extends:»,precedes:« " Unprintable chars mapping

"""""""""""""""""
"   Code folding.

set foldmethod=syntax
set foldcolumn=1
set foldlevelstart=20

let g:vim_markdown_folding_disabled=1 " Markdown
let javaScript_fold=1                 " JavaScript
let perl_fold=1                       " Perl
let php_folding=1                     " PHP
let r_syntax_folding=1                " R
let ruby_fold=1                       " Ruby
let sh_fold_enabled=1                 " sh
let vimsyn_folding='af'               " Vim script
let xml_syntax_folding=1              " XML

"""""""""""""""""""""""""""""""""
"   Unix line endings are coolio.

set ffs=unix

""""""""""""""""""""""""""
"   Airline configuration.

let g:airline_powerline_fonts = 1
set laststatus=2

"""""""""""""""
"   Vundle!   "
"""""""""""""""

set nocompatible
filetype off
" Required for Vundle

" Set the runtime path to include Vundle and initialize!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'                       " Bootstrap Vundle.

Plugin 'LucHermitte/lh-vim-lib'                     " Apparently, utilities.
Plugin 'LucHermitte/local_vimrc'                    " For local configurations.

Plugin 'mhinz/vim-startify'                         " Just a gimmick.

Plugin 'changyuheng/color-scheme-holokai-for-vim'   " Pretty theme.
Plugin 'dag/vim-fish'                               " I hate fish but I love Fish.
Plugin 'gabrielelana/vim-markdown'                  " Meh.
Plugin 'mutewinter/nginx.vim'                       " Lovely webserver.

Plugin 'ervandew/supertab'                          " Use of Tab to navigate completion menu.

Plugin 'tpope/vim-fugitive'                         " Git support (handy for Airline).
Plugin 'airblade/vim-gitgutter'                     " Shows changes in a gutter.

Plugin 'mbbill/undotree'                            " For those times when I fuck up colossally.

Plugin 'vim-airline/vim-airline'                    " Godlike addition!
Plugin 'bling/vim-bufferline'                       " Meh.

call vundle#end()
filetype plugin indent on

"   Here comes non-Vundle stuffs.

"""""""""""""""""""""""""""""""""""""""""
"   Syntax highlighting and color scheme.

syntax enable
silent! colorscheme holokai

