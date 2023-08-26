" Vundle requires this
set nocompatible

set hidden

" enable syntax highlighting
syntax enable

" don't wrap lines
set nowrap

" keep the cursor in the middle of the screen
set scrolloff=15

" expand tabs to spaces
set expandtab

" autoindenting
" set autoindent
set copyindent
set shiftround

set showmatch

" ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase

" show line numbers
set relativenumber
set nonumber

" highlight current line
set cursorline

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" highlight search terms, but clear on esc
set hlsearch

" show search matches during typing
set incsearch

set history=1000
set undolevels=1000

" ignore files during autocompletion
set wildignore=*.pyc

" change leader key
let mapleader = " "

" change terminal title
set title

" don't fully autocomplete filenames
set wildmode=list:longest,full

" don't use terminal bell
set visualbell
set noerrorbells
set t_vb=

" who needs it?!
set nobackup
set noswapfile

" tab = 4 spaces by default
set tabstop=4
set softtabstop=4
set shiftwidth=4

" powerful backspacing
set backspace=indent,eol,start

" disable # going to beginning of line
set formatoptions-=r
set formatoptions-=o

" quickly change tab width
nnoremap <leader>h :call TabWidthToggle()<CR>
function! TabWidthToggle()
    if &tabstop == 2
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        echo "Tab width set to 4"
    else
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        echo "Tab width set to 2"
    endif
endfunction

" handy shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" color 81th column
let &colorcolumn=0
nnoremap <leader>f :call ColorColumnToggle()<CR>
function! ColorColumnToggle()
    if &colorcolumn
        set colorcolumn=0
    else
        set colorcolumn=81
    endif
endfunction

" shortcut for paste mode
nnoremap <leader>p :set paste!<CR>

" show that there are more characters in a long line
set nolist
set listchars=extends:#,precedes:#,tab:▸\ ,eol:¬
nmap <leader>l :set list!<CR>

set ttimeoutlen=10

" shift+;+w = ;+w
"nnoremap ; :

" enable mouse scrolling
set mouse=a

" w!! saves the file with sudo
cmap w!! w !sudo tee % >/dev/null

" Remove trailing whitespace on file save
autocmd BufWritePre * :%s/\s\+$//e

" Don't mess up html files
let html_no_rendering=1

" Open new panes on the right and below
set splitbelow
set splitright

" %% expands into path to current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" open file in current file's directory
map <leader>ew :e %%
map <leader>et :tabe %%

set encoding=utf-8

" disable highlighting after search
map <leader>s :noh<CR>

" compile LaTeX after saving
au BufWritePost *.tex silent exec ":!$(make >/dev/null 2>&1 &)"

" :Wrap enables line wrapping
command! -nargs=* Wrap set wrap linebreak nolist

" Set up Vundle
filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdcommenter'
Plug 'wikitopian/hardmode'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/vim-flake8'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', {'dir': '~/.vim/bundle/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/Valloric/YouCompleteMe'
call plug#end()

filetype plugin indent on


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='luna'

" show airline when there is only one tab
set laststatus=2

" ==============================================================================
" NERDTree settings
" ==============================================================================
"
map <C-n> :NERDTreeToggle<CR>

" ==============================================================================
" Markdown settings
" ==============================================================================
let g:vim_markdown_folding_disabled=1

" Relative numbers
" Relative line numbering only in sone cases
function! NumberToggle()
  if &relativenumber
    set number
    set norelativenumber
  else
    set relativenumber
    set nonumber
  endif
endfunc

nnoremap <C-x> :call NumberToggle()<cr>

" Switch to absolute numbers when vim loses focus
:au FocusLost * :set number
:au FocusGained * :set relativenumber

" Switch to absolute numbers when going into insert mode
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" ==============================================================================
" Commenter shortcuts
" ==============================================================================
" Ctrl+k toggles comments
nmap <C-k> <leader>c<leader>

" ==============================================================================
" EasyMotion config
" ==============================================================================
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

nmap t <Plug>(easymotion-s2)

" ==============================================================================
" GitGutter config
" ==============================================================================
set updatetime=100

" ==============================================================================
" The silver searcher
" ==============================================================================
let g:ackprg = 'ag --nogroup --nocolor --column'

" ==============================================================================
" FZF
" ==============================================================================
map <leader>f :call fzf#run({'sink': 'tabedit'})<cr>
map <leader>t :Tags<cr>
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Use Ctrl-w + j/k to navigate between normal window and quickfix window
