" This is my nvim config file

" Plugins {
call plug#begin('~/.vim/plugged')
    Plug 'sheerun/vim-polyglot'
    Plug 'scrooloose/nerdtree'
    Plug 'junegunn/goyo.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'itchyny/lightline.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'dylanaraps/wal.vim'

    Plug 'joshdick/onedark.vim'
    Plug 'drewtempelmeyer/palenight.vim'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}

    Plug 'tpope/vim-surround'
    Plug 'justinmk/vim-sneak'

    Plug 'Shougo/neosnippet.vim'
    Plug 'hlissner/vim-neosnippets'
call plug#end()
" }

let g:neosnippet#snippets_directory = ['~/.vim/bundle/vim-neosnippets']
let g:neosnippet#disable_runtime_snippets = { '_' : 1  }

imap <expr><TAB>
            \ pumvisible() ? "\<C-n>" :
            \ neosnippet#expandable_or_jumpable() ?
            \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


" Tabs and spacing
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=4                " One tab == four spaces.
set tabstop=4                   " One tab == four spaces.

map <C-f> :NERDTreeToggle<CR>

nnoremap <M-j>  <C-W>J
nnoremap <M-k>  <C-W>K
nnoremap <M-l>  <C-W>L
nnoremap <M-h>  <C-W>H

" Line numbering.
set number relativenumber

:imap jk <Esc>

set signcolumn=no

set showmatch                           " Highlight matching parentheses.
set list                                " Highlight trailing whitespaces.:
set listchars=tab:›·,trail:·,extends:›,precedes:‹

set splitbelow splitright

set wildmenu                            " Show autocompletion list.
set scrolloff=8                         " Minimum number of lines to keep above and below cursor.
set autoread

syntax on
set t_Co=256

set background=dark
colorscheme onedark

highlight Normal ctermfg=7 ctermbg=none

let g:airline_powerline_fonts=1
let g:airline_theme='bubblegum'

















