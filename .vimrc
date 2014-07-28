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
cnoremap W w
cnoremap WQ wq
cnoremap wQ wq
cnoremap Q q

"Set spell check for text files
autocmd FileType gitcommit,mail,mkd,text set spell

"prevent vim from backing up crontabs
set backupskip=/tmp/*,/private/tmp/*

"When you move away from a buffer it will go into the background 
"it doesn't close the buffer when you close the window --needed for :Cdo
set hidden

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

"ctrl+h toggles relative line numbers on and off
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set nonumber
    set relativenumber
  endif
endfunc

nnoremap <C-h> :call NumberToggle()<cr>

"Set colorscheme
set background=dark
colorscheme solarized
" Set font and size
set guifont=Menlo:h14
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
nnoremap <silent> <leader>/ :nohlsearch<CR>
"Make search always go the same direction
noremap <silent> n /<CR>
noremap <silent> N ?<CR>

"Show whitespace that includes trailing whitespace.
highlight ExtraWhitespace ctermbg=darkgreen guibg=DarkCyan
nnoremap <Leader>wn :match ExtraWhitespace /\s\+\%#\@<!$/<CR>
nnoremap <Leader>wf :match<CR>
autocmd BufWinEnter * call clearmatches()

"Panic Button
"Space f takes you to the last place you edited
nnoremap <Leader>f `.

nnoremap <leader>ev :vsplit $MYVIMRC<cr>

nnoremap <leader>sv :source $MYVIMRC<cr>



"###################################
"Editing
"###################################
" Copy indent from current line when starting a new line 
set autoindent
" wrap long lines
set wrap
" Break lines on words
set linebreak
" Make j,k,0,and $ behave the same way with wrapped lines
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
" & Set indent to 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Map 'jk' to escape
inoremap jk <esc>

" Allow for pasting multiple lines
xnoremap p pgvy

" Ctrl - j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><D-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><D-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

"Copy and paste to system clipboard with space y and space d
vnoremap <Leader>y "+y
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P


"Paste with space before
nnoremap <C-p> a <esc>p

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Map cu to change to underscore
nnoremap cu ct_
nnoremap cU dT_s

" Indent/unindent visual mode selection with tab/shift+tab
vnoremap <tab> >gv
vnoremap <s-tab> <gv

"Enable omni completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

"Remap <C-P> to <C-p>
"Use ctrl+p to autocomplete from insert mode
inoremap <C-p> <C-P>
inoremap <C-n> <C-N>

"Make it easier to navigate to first non-blank character in a line
nnoremap <Leader>0 ^
nnoremap H ^
nnoremap L $

"use space j to provide the opposite of shift j
noremap <Leader>j i<CR><Esc>

"In insert mode '\fn' inserts the file name and
" '\fp' inserts the file path
inoremap \fn <C-R>=expand("%:t")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>


"###################################
"Plugins
"###################################
"Nerd tree
noremap \ :NERDTreeToggle<CR>

"Double tap space to comment
noremap <leader><leader> <plug>NERDCommenterToggle

"Delimitmate
let delimitMate_matchpairs = "(:),[:],{:}"

"###################################
"Source local .vimrc
"###################################
if filereadable($HOME . "/.vimrc_local")
  source ~/.vimrc.local
endif


