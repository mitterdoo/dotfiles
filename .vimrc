" source $VIMRUNTIME/defaults.vim
set tabstop=4
set shiftwidth=4
set softtabstop=0

" fix vim requiring saving when switching buffers (even though they remain
" open. thanks vim 
set hidden

syntax on
colorscheme unokai

set noexpandtab

set relativenumber
set number
set scrolloff=4
set signcolumn=auto
set noshowmode

set mouse=a " legacy needs

set tags+=./.tags

nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
