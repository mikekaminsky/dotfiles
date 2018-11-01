" Michael's Vim Profile

set nocp

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Appearance
Plug 'altercation/vim-colors-solarized'

" File navivation
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'

" Vim commands and controls
Plug 'vim-scripts/camelcasemotion'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'

" SQL
Plug 'shmup/vim-sql-syntax'

" Python
Plug 'ambv/black'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'


call plug#end()


"filetype off
filetype on
syntax on
filetype plugin indent on

" Try to make vim go faster in TMUX
set lazyredraw
set ttyfast

"###################################
"System
"###################################

" Switch to visual bells from stupid beeps
set vb 

" Have vim read changes from file as they happen
set autoread

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
nnoremap Q <nop>

"Write every time window loses focus
au FocusLost * silent! wa

"Set spell check for text files
autocmd FileType gitcommit,mail,mkd,text set spell

" Set headers
au BufRead,BufNewFile *.lookml set filetype=lookml
autocmd FileType lookml set syntax=yaml

" Make vim recognize . as keyword in R files
augroup rperiod
  autocmd!
  autocmd FileType r set iskeyword-=.
augroup END

"prevent vim from backing up crontabs
set backupskip=/tmp/*,/private/tmp/*

"When you move away from a buffer it will go into the background
"it doesn't close the buffer when you close the window --needed for :Cdo
set hidden

"Prevent existing swap file warnings
set shortmess+=A

"Add splits below and to the right
set splitbelow
set splitright

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

" Get the nice tab through menu
set wildmenu

" Display line numbers
set number

"ctrl+h toggles relative line numbers on and off
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <C-h> :call NumberToggle()<cr>

"<leader>+l toggles drop line at cursor
function! VertToggle()
  if(&colorcolumn)
    set colorcolumn=
  else
    let thiscol = col('.')
    echo thiscol
    let &colorcolumn=thiscol
  endif
endfunc

nnoremap <leader>l :call VertToggle()<cr>


"Set colorscheme
"Recommended: import solarized as your default colorscheme for terminal (see
"more at https://github.com/altercation/solarized/tree/master/osx-terminal.app-colors-solarized
set t_Co=256
if !has('gui_running')
  let g:solarized_termcolors=&t_Co
  "let g:solarized_termtrans=1 " Use the default terminal background color
endif
set background=dark
colorscheme solarized
" Set font and size
set guifont=Menlo:h14

" Highlight search terms
set hlsearch

" Color search words
hi Search guibg=WhiteSmoke
hi Search guifg=CornflowerBlue

" find as you type search
set incsearch

" Show matching brackets and parentheses
set showmatch

" Ignore case in search
set ignorecase

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
nnoremap <leader>rw :%s/\s\+$//

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
autocmd BufWritePre *.py,*.js,*.sql :call <SID>StripTrailingWhitespaces()


"Don't double-indent single line comments in c and c++
au FileType c,cpp setlocal comments-=:// comments+=f://


"Panic Button
"Space f takes you to the last place you edited
nnoremap <Leader>f `.

" <space>ev splits and edits vimrc
" <space>sv sources vimrc
noremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Status line
set laststatus=2 " Always show status line
set statusline=%f " Path to the file
set statusline+=%= " Switch to the right side
set statusline+=%l " Current line
set statusline+=/ " Separator
set statusline+=%L " Total lines


"###################################
"Editing
"###################################
" Copy indent from current line when starting a new line
set autoindent
" DON'T wrap long lines
set nowrap
" Break lines on words
set linebreak
" Make j,k,0,and $ behave the same way with wrapped lines
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
"noremap  <buffer> <silent> 0 g0
"noremap  <buffer> <silent> $ g$

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
" & Set indent to 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Except not for python
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4

autocmd Filetype markdown setlocal wrap

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

"Use your tenkey numpad
inoremap <Esc>Oq 1
inoremap <Esc>Or 2
inoremap <Esc>Os 3
inoremap <Esc>Ot 4
inoremap <Esc>Ou 5
inoremap <Esc>Ov 6
inoremap <Esc>Ow 7
inoremap <Esc>Ox 8
inoremap <Esc>Oy 9
inoremap <Esc>Op 0
inoremap <Esc>On .
inoremap <Esc>OQ /
inoremap <Esc>OR *
inoremap <Esc>Ol +
inoremap <Esc>OS -
inoremap <Esc>OM <Enter>

"Paste with space before
"nnoremap <C-p> a <esc>p

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Map cu to change to underscore
nnoremap cu ct_
nnoremap cU dT_s

" Indent/unindent visual mode selection with tab/shift+tab
" COMMENTED OUT DUE TO INCOMPATABILITY WITH SNIPMATE
"vnoremap <tab> >gv
"vnoremap <s-tab> <gv

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
vnoremap <Leader>0 ^
nnoremap H ^
nnoremap L $

"use space j to provide the opposite of shift j
noremap <Leader>j i<CR><Esc>

"In insert mode '\fn' inserts the file name and
" '\fp' inserts the file path
inoremap \fn <C-R>=expand("%:t")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>

" Copy path of file to clipboard for pasting into terminal.
noremap <leader>k :let @* = expand("%:p")<CR>

"###################################
"Abbreviations
"###################################

" Typos
iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev wiht with
iabbrev reponse response

" My names
iabbrev @@  kaminsky.michael@gmail.com
iabbrev myname  Michael Kaminsky

" SQL keywords
augroup sqlcaps
  autocmd!
  autocmd FileType sql,sqlanywhere iabbrev <buffer> select SELECT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> from FROM
  autocmd FileType sql,sqlanywhere iabbrev <buffer> case CASE
  autocmd FileType sql,sqlanywhere iabbrev <buffer> when WHEN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> where WHERE
  autocmd FileType sql,sqlanywhere iabbrev <buffer> join JOIN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> on ON
  autocmd FileType sql,sqlanywhere iabbrev <buffer> distinct DISTINCT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> left LEFT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> right RIGHT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> outer OUTER
  autocmd FileType sql,sqlanywhere iabbrev <buffer> set SET
  autocmd FileType sql,sqlanywhere iabbrev <buffer> group GROUP
  autocmd FileType sql,sqlanywhere iabbrev <buffer> with WITH
  autocmd FileType sql,sqlanywhere iabbrev <buffer> and AND
  autocmd FileType sql,sqlanywhere iabbrev <buffer> or OR
  autocmd FileType sql,sqlanywhere iabbrev <buffer> order ORDER
  autocmd FileType sql,sqlanywhere iabbrev <buffer> between BETWEEN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> max MAX
  autocmd FileType sql,sqlanywhere iabbrev <buffer> min MIN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> interval INTERVAL
  autocmd FileType sql,sqlanywhere iabbrev <buffer> coalesce COALESCE
  autocmd FileType sql,sqlanywhere iabbrev <buffer> greatest GREATEST
  autocmd FileType sql,sqlanywhere iabbrev <buffer> as AS
  autocmd FileType sql,sqlanywhere iabbrev <buffer> end END
  autocmd FileType sql,sqlanywhere iabbrev <buffer> count COUNT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> then THEN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> is IS
  autocmd FileType sql,sqlanywhere iabbrev <buffer> not NOT
  autocmd FileType sql,sqlanywhere iabbrev <buffer> null NULL
  autocmd FileType sql,sqlanywhere iabbrev <buffer> else ELSE
  autocmd FileType sql,sqlanywhere iabbrev <buffer> by BY
  autocmd FileType sql,sqlanywhere iabbrev <buffer> sum SUM
  autocmd FileType sql,sqlanywhere iabbrev <buffer> drop DROP
  autocmd FileType sql,sqlanywhere iabbrev <buffer> table TABLE
  autocmd FileType sql,sqlanywhere iabbrev <buffer> begin BEGIN
  autocmd FileType sql,sqlanywhere iabbrev <buffer> commit COMMIT 
  autocmd FileType sql,sqlanywhere iabbrev <buffer> having HAVING
  autocmd FileType sql,sqlanywhere iabbrev <buffer> to TO
  autocmd FileType sql,sqlanywhere iabbrev <buffer> over OVER
  autocmd FileType sql,sqlanywhere iabbrev <buffer> partition PARTITION
augroup END

"####################################################################
"Plugin Configuration
"####################################################################

"###################################
" Jedi
"###################################
let g:jedi#completions_command = "<C-b>"

"###################################
" NerdTree
"###################################
noremap \ :NERDTreeToggle<CR>
noremap \| :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$','\.swp$']

"###################################
" NerdCommender
"###################################
"Double tap space to comment
map <leader><leader> <plug>NERDCommenterToggle

let NERDTreeIgnore = ['\.pyc$']

"###################################
" delimitMate
"###################################
let delimitMate_matchpairs = "(:),[:],{:}"

"###################################
" flake8
"###################################
command! Flake8 call Flake8()
nnoremap <Leader>c :Flake8<CR>

"###################################
" Fzf
"###################################

" TODO:
" Make hitting these again close the quickfix window
" Semicolon to fuzzy search buffers
nmap ; :Buffers<CR>
" Fuzzy Search files
nmap <Leader>t :Files<CR>

"###################################
" The Silver Searcher
"###################################
 
" Let Ack use Ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

nnoremap <Leader>a :Ag <Space>

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--path-to-ignore .gitignore --ignore-dir .git/ --hidden', <bang>0)

"###################################
" Goyo
"###################################

" TODO: Have this undo-itself when called a second time
" TODO: Figure out how to get this to set wrapping as well
function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
  if !has('gui_running')
    let g:solarized_termcolors=256
  endif
  colors solarized
endfunction

command! ProseMode call ProseMode()
nmap <Leader>w :ProseMode<CR> 

"###################################
"Source local .vimrc
"###################################
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

let python_highlight_all = 1
