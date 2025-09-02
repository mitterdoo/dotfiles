" source $VIMRUNTIME/defaults.vim
set tabstop=4
set shiftwidth=4
set softtabstop=0

set smartindent

" fix vim requiring saving when switching buffers (even though they remain
" open. thanks vim 
set hidden

syntax on
" colorscheme unokai

set noexpandtab

" six rows, use cur window width
set termwinsize=6x0

" ignore case in search
set ignorecase

set relativenumber
set number
set scrolloff=4
set signcolumn=auto

set hlsearch " highlight all search matches

set noshowmode

" colorscheme unokai
highlight Keyword term=bold cterm=bold gui=bold
highlight Statement term=bold cterm=bold gui=bold
highlight Type term=bold cterm=bold gui=bold
highlight Identifier term=bold cterm=bold gui=bold
highlight Comment term=italic cterm=italic gui=italic
highlight Search ctermbg=DarkMagenta ctermfg=Black


set mouse=a " legacy needs

set tags+=./.tags

nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
nnoremap <C-`> :botright term<cr>
inoremap <C-[> {<cr>}<ESC>O
