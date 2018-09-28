call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'qpkorr/vim-bufkill'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-endwise'
Plug 'dracula/vim'
call plug#end()

set termguicolors

let g:dracula_italic = 0
colorscheme dracula

set shortmess=I
let mapleader = ","
set backupcopy=yes
set hidden
set confirm
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set ignorecase
set number
set colorcolumn=80
set nowrap
set encoding=utf8
set noruler
set laststatus=2
set list
set listchars=tab:>-
set tw=80
set tags=./tags;
set completeopt-=preview
set cursorline
set background=dark
set incsearch
set hlsearch
syntax enable

augroup commands
  autocmd!
  autocmd BufNewFile,BufRead *.glsl setfiletype glsl
  autocmd BufNewFile,BufRead *.hamlc setfiletype haml
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritePre * %s/\($\n\s*\)\+\%$//e
  autocmd FileType qf set nobuflisted
augroup END

nnoremap <silent> <C-f> :GGrep<cr>
nnoremap <silent> <C-p> :GFiles<cr>
nnoremap <silent> <C-n> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
vnoremap > >gv
vnoremap < <gv
nnoremap <silent> <C-c> :BD<cr>
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap Q <nop>
nnoremap q <nop>
map <C-t> :NERDTreeToggle<CR>
nnoremap <Tab> :bnext<CR>

augroup nerdtreebindings
  autocmd!
  autocmd FileType nerdtree map <buffer> <C-c> <NOP>
  autocmd FileType nerdtree map <buffer> <C-f> <NOP>
  autocmd FileType nerdtree map <buffer> <C-p> <NOP>
  autocmd FileType nerdtree map <buffer> <leader>x <NOP>
  autocmd FileType nerdtree nnoremap <buffer> <Tab> <NOP>
augroup END

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

let g:NERDTreeChDirMode = 2
let g:NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = '+'
