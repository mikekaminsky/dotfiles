" Michael's Vim Profile

" Run pathogen
" execute pathogen#infect()


" Set font and size
set guifont=Menlo:h16

" Copy indent from current line when starting a new line 
set autoindent

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
set expandtab

" Set leader to the spacebar
let mapleader = "\<Space>"

" Map 'jk' to escape
imap jk <esc>

" Allow for pasting multiple lines
xnoremap p pgvy

" Set indent to 4 spaces
set sw=4

" Highlight the last searched pattern:
set hlsearch

" Set up autocommenting
autocmd FileType sh,ruby,python let b:comment_leader= '# '
autocmd FileType vim let b:comment_leader= '" '

" Ctrl - j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><D-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><D-j> :set paste<CR>m`O<Esc>``:set nopaste<CR>
