" source $VIMRUNTIME/defaults.vim
set background=light
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

" custom syntax
" filetype plugin indent on
" au BufRead,BufNewFile *.ks set filetype=kos
" au BufRead,BufNewFile *.ks set filetype=basic

" ignore case in search
set ignorecase

set relativenumber
set number
set scrolloff=4
set signcolumn=auto

set hlsearch " highlight all search matches

set noshowmode

" disable hard-wrapping inserting newlines
setlocal textwidth=0

" colorscheme unokai
highlight Keyword term=bold cterm=bold gui=bold ctermfg=Red
highlight Constant term=underline ctermfg=Magenta guifg=Magenta
highlight Statement term=bold cterm=bold gui=bold
highlight Type term=bold cterm=bold gui=bold
highlight Identifier term=bold cterm=bold gui=bold
highlight Comment term=italic cterm=italic gui=italic
highlight Search ctermbg=DarkMagenta ctermfg=Black
highlight Normal ctermbg=black guibg=Black
highlight NonText ctermbg=black guibg=Black


set mouse=a " legacy needs

set tags+=./.tags,.tags

" inoremap <C-backspace> <ESC>dbxi
inoremap <C-backspace> <C-W>
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
nnoremap <C-`> :botright term<cr>
inoremap <C-[> {<cr>}<ESC>O
inoremap <C-9> (<cr>)<ESC>O
