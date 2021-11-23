" Michael's Vim Profile

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Appearance
Plug 'Rigellute/rigel'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim'

" Tmux / REPL
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'

" File navivation
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'

" Vim commands and controls
Plug 'vim-scripts/camelcasemotion'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'

" Linting
Plug 'dense-analysis/ale'

" SQL
Plug 'shmup/vim-sql-syntax'
Plug 'alcesleo/vim-uppercase-sql'

" Python
Plug 'psf/black', { 'branch': 'stable' }
"Plug 'psf/black'
Plug 'nvie/vim-flake8'

" R / Stan
Plug 'maverickg/stan.vim'

" Git
Plug 'tpope/vim-fugitive'

call plug#end()

"filetype off
filetype on
syntax on
filetype plugin indent on

" Block remote code execution security hole.
set nomodeline

" Set leader to the spacebar
" NOTE: This needs to come before we map anything to leader
let mapleader = "\<Space>"

"###################################
"System
"###################################
"
" Try to make vim go faster in TMUX
set lazyredraw
set ttyfast

" Switch to visual bells from stupid beeps
set visualbell

" Have vim read changes from file as they happen
set autoread

"Save lots of history
set history=1000

" Let's save undo info!
if !isdirectory($HOME.'/.vim')
    call mkdir($HOME.'/.vim', '', 0770)
endif
if !isdirectory($HOME.'/.vim/undo-dir')
    call mkdir($HOME.'/.vim/undo-dir', '', 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

"Write every time window loses focus
au FocusLost * silent! wa

"prevent vim from backing up crontabs
set backupskip=/tmp/*,/private/tmp/*

"When you move away from a buffer it will go into the background
"it doesn't close the buffer when you close the window --needed for :Cdo
set hidden

"Prevent existing swap file warnings
set shortmess+=A

" Get the nice tab through menu
set wildmenu

"Enable omni completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

"###################################
"Search
"###################################

" Highlight search terms
set hlsearch

" find as you type search
set incsearch

" With both on, searches with no capitals are case insensitive, while searches with a capital characters are case sensitive.
set ignorecase
set smartcase

" Show matching brackets and parentheses
set showmatch

" Color search words
hi Search guibg=WhiteSmoke
hi Search guifg=CornflowerBlue

"clearing highlighted search using "<space> /"
nnoremap <silent> <leader>/ :nohlsearch<CR>

"Make search always go the same direction
noremap <silent> n /<CR>
noremap <silent> N ?<CR>

" Don't jump to the next (previous) occurrence of the highlighted word on
" search
nnoremap <silent> * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap <silent> # :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

"###################################
"Navigation
"###################################

"Add splits below and to the right
set splitbelow
set splitright

" Simplify navigating between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Make it easier to navigate to first non-blank character in a line
nnoremap <Leader>0 ^
vnoremap <Leader>0 ^
nnoremap H ^
nnoremap L $

"###################################
"Appearance
"###################################
 
"Set colorscheme

set termguicolors
set term=xterm-256color
syntax enable
syntax on
colorscheme rigel

" Status line
set laststatus=2 " Always show status line
set statusline=%f " Path to the file
set statusline+=%= " Switch to the right side
set statusline+=%l " Current line
set statusline+=/ " Separator
set statusline+=%L " Total lines

"Show the mode
set showmode

"Highlight the cursor line
set cursorline

"Show column and line number at bottom right
set ruler

"Relative line numbers
set relativenumber

" Display line numbers
set number

"###################################
"File types an syntax
"###################################
"
"Set spell check for text files
autocmd FileType gitcommit,mail,mkd,text set spell

" Set lookml filteype
au BufRead,BufNewFile *.lookml set filetype=lookml

" Make vim recognize . as keyword in R files
augroup rperiod
  autocmd!
  autocmd FileType r set iskeyword-=.
augroup END

"Don't double-indent single line comments in c and c++
au FileType c,cpp setlocal comments-=:// comments+=f://

" Specify appropriate indenting for python
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4

" Wrap lines in markdown
autocmd Filetype markdown setlocal wrap

"###################################
"Basic usability maps
"###################################

" Map 'jk' to escape
inoremap jk <esc>

" Making it so ; works like : for commands. Saves typing and
" eliminates :W style typos due to lazy holding shift.
nnoremap ; :

"Stupid lazy-shift holding errors
cnoremap W w
cnoremap WQ wq
cnoremap wQ wq
cnoremap Q q
nnoremap Q <nop>

" Instead of stumbling into ex mode, repeat the last macro used.
nnoremap Q @@

autocmd FileType lookml set syntax=yaml

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

" Allow for pasting multiple lines
xnoremap p pgvy

"Copy and paste to system clipboard with space y and space p
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

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Map cu to change to underscore
nnoremap cu ct_
nnoremap cU dT_s

"Remap <C-P> to <C-p>
"Use ctrl+p to autocomplete from insert mode
inoremap <C-p> <C-P>
inoremap <C-n> <C-N>

"use space j to provide the opposite of shift j
noremap <Leader>j i<CR><Esc>

"In insert mode '\fn' inserts the file name and
" '\fp' inserts the file path
inoremap \fn <C-R>=expand("%:t")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>

" Copy path of file to clipboard for pasting into terminal.
noremap <leader>k :let @* = expand("%:p")<CR>

" ;1 will set the 'a mark at the point you are typing.
inoremap ;1 <c-o>ma

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

"###################################
" Helpful custom functions
"###################################

"ctrl+h toggles relative line numbers on and off
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

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

"Panic Button
"Space f takes you to the last place you edited
nnoremap <Leader>f `.

" <space>ev splits and edits vimrc
" <space>sv sources vimrc
noremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Command for refreshing all buffers
function! RefreshBuffers()
  let curBuf=bufnr('%')
  set noconfirm
  bufdo e!
  set confirm
  execute 'buffer ' . curBuf
endfunction

command! RefreshBuffers call RefreshBuffers()
nmap <Leader>ra :RefreshBuffers<CR>


"####################################################################
"Plugin Configuration
"####################################################################

"###################################
" Airline
"###################################

let g:rigel_airline = 1
let g:airline_theme = 'rigel'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:airline_section_z = '%2l/%L☰%2v'
let g:airline#extensions#default#section_truncate_width = {
    \ 'warning': 80,
    \ 'error': 80,
    \ 'x': 80,
    \ 'y': 80}

" buffer "tab" navigation
nnoremap <leader><tab> :bnext<CR>
nnoremap <leader><S-tab> :bprevious<CR>
 
"###################################
" Jedi
"###################################
let g:jedi#completions_command = "<C-b>"

"###################################
" NerdTree
"###################################
noremap \ :NERDTreeToggle<CR>
noremap \| :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$','\.sw*$']

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
" Slime
"###################################
" Get slime working with radian see:
" https://github.com/randy3k/radian/issues/114
" https://github.com/jpalardy/vim-slime/issues/211
"
function! _EscapeText_r(text)
  call system("cat > ~/.slime_r", a:text)
  return ["source('~/.slime_r', echo = TRUE, max.deparse.length = 4095)\r"]
endfunction

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{top-right}"}
" Don't prompt for configuration
let g:slime_dont_ask_default = 1


"###################################
" Goyo
"###################################

let goyo_on = 0
function! ProseMode()
  if g:goyo_on == 0
    let g:goyo_on = 1
    let g:goyo_pre_settings =
    \ { 'spell':    &spell,
    \   'ci':       &ci,
    \   'si':       &si,
    \   'ai':       &ai,
    \   'list':     &list,
    \   'showmode': &showmode,
    \   'showcmd':  &showcmd,
    \   'wrap':     &wrap,
    \   'complete': &complete
    \}
    call goyo#execute(0, [])
    set spell noci nosi noai nolist noshowmode noshowcmd wrap
    set complete+=s
    set bg=light
    colors solarized
  elseif g:goyo_on == 1
    let g:goyo_on = 0
    call goyo#execute(0, [])
    for [k, v] in items(g:goyo_pre_settings)
      execute printf('let &%s = %s', k, string(v))
    endfor
    set bg=dark
    colors solarized
  endif
endfunction
command! ProseMode call ProseMode()
nmap <Leader>w :ProseMode<CR>

"###################################
" Black
"###################################

let g:black_virtualenv="~/.virtualenvs/black"

"###################################
" Ale
"###################################

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'r': ['styler'],
\   'python': ['black'],
\}

" Fix a file on <leader>b
nmap <Leader>b :ALEFix<CR>

" Lintr
let g:ale_r_lintr_lint_package = 0
let g:ale_r_lintr_options = 'with_defaults(line_length_linter(100))'


"###################################
"Source local .vimrc
"###################################
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

let python_highlight_all = 1
