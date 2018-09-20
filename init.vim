call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'w0rp/ale'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-surround'
Plug 'qpkorr/vim-bufkill'
Plug 'shougo/deoplete.nvim'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-sleuth'

" COLORS
Plug 'liuchengxu/space-vim-dark'
Plug 'tlhr/anderson.vim'

" RUBY
Plug 'tpope/vim-endwise'

call plug#end()

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

set termguicolors
colorscheme anderson

hi Comment cterm=italic
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi NonText    ctermbg=NONE guibg=NONE

function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf('%dW %dE', all_non_errors, all_errors)
endfunction

set statusline=%f\ %y\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)\ %{LinterStatus()}

augroup commands
  autocmd!
  autocmd BufNewFile,BufRead *.glsl setfiletype glsl
  autocmd BufNewFile,BufRead *.hamlc setfiletype haml
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritePre * %s/\($\n\s*\)\+\%$//e
  autocmd FileType qf set nobuflisted
augroup END

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
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
map <C-m> :NERDTreeToggle<CR>
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

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_linters = {'go': ['go build', 'gometalinter']}
let g:NERDTreeChDirMode = 2
let g:NERDTreeShowHidden = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1
