" Michael's Vim Profile
source ~/.vim/bundle/pathogen/autoload/pathogen.vim

" Run pathogen
execute pathogen#infect()

"###################################
"System
"###################################
"Save lots of history
set history=1000

" Set leader to the spacebar
let mapleader = "\<Space>"

" Making it so ; works like : for commands. Saves typing and
" eliminates :W style typos due to lazy holding shift.
nnoremap ; :

"Stupid lazy-shift holding errors
cmap W w                        
cmap WQ wq
cmap wQ wq
cmap Q q

"###################################
"Environment
"###################################

"Show the mode
set showmode
"Highlight the cursor line 
set cursorline
"Show column and line number at bottom right
set ruler
"Relative line numbers
set rnu 
"ctrl+n toggles relative line numbers on and off
nnoremap <C-n> <leader>:set rnu! rnu?<CR>

"Set colorscheme
set background=dark
colorscheme solarized
" Set font and size
set guifont=Menlo:h16
" Highlight the last searched pattern:
set hlsearch
" Show matching brackets and parentheses
set showmatch 
" Highlight search terms
set hlsearch
" Ignore case in search
set ignorecase
" find as you type search
set incsearch
"clearing highlighted search using "<space> /"
nmap <silent> <leader>/ :nohlsearch<CR>

"###################################
"Editing
"###################################
" Copy indent from current line when starting a new line 
set autoindent
" wrap long lines
set nowrap                      

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
" & Set indent to 4 spaces
set expandtab
set tabstop=4
set sw=4
set expandtab

" Map 'jk' to escape
imap jk <esc>

" Allow for pasting multiple lines
xnoremap p pgvy

" Ctrl - j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><D-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><D-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

"Copy and paste to system clipboard with space y and space d
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

"double tap spce to start selecting stuff
nmap <Leader><Leader> V

" Indent/unindent visual mode selection with tab/shift+tab
vmap <tab> >gv
vmap <s-tab> <gv

"Enable omni completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"Remap <C-P> to <C-p>
"Use ctrl+p to autocomplete from insert mode
imap <C-p> <C-P>

"###################################
"Plugins
"###################################
"Nerd tree
map \ :NERDTreeToggle<CR>

"###################################
"Source local .vimrc
"###################################
if filereadable($HOME . "/.vimrc_local")
  source ~/.vimrc_local
endif
