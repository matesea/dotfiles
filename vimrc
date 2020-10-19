" not compatible with vi
" set nocompatible
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

let s:nvim = has('nvim')
" let s:cygwin = has("unix") && has("win32unix")
let s:xdg_config = exists("$XDG_CONFIG_HOME")   " default $HOME/.config
let s:xdg_data = exists("$XDG_DATA_HOME")       " default: $HOME/.local/share
" $XDG_CACHE_HOME default: $HOME/.cache
if s:xdg_config && isdirectory($XDG_CONFIG_HOME . '/nvim')
    let $VIMHOME = $XDG_CONFIG_HOME . '/nvim'
elseif s:xdg_config && isdirectory($XDG_CONFIG_HOME . '/vim')
    let $VIMHOME = $XDG_CONFIG_HOME . '/vim'
elseif isdirectory($HOME . '/dotfiles/vim')
    let $VIMHOME = $HOME . '/dotfiles/vim'
else
    let $VIMHOME = $HOME . '/.vim'
endif

if s:xdg_data
    let $VIMDATA = $XDG_DATA_HOME . '/vim'
    let $VIMINFO = $XDG_DATA_HOME
else
    let $VIMDATA = $HOME . '/.local/vim'
    let $VIMINFO = $HOME
endif

set cindent     " c code indentation
" set wildmode=longest:full,full
" set wildmode=list:longest,full
set wildmode=longest,full
set showmode
set showcmd
set number

" remove cursorline because it harms scolling speed
" set cursorline
if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
else
    set diffopt+=filler
endif
" less window redraw to speedup
" improve redraw speed
set ttyfast
"set ttyscroll=3
set lazyredraw
" Sets how many lines of history VIM has to remember
set history=2000

" Enable filetype plugin
" load plugins according to different file type
filetype plugin indent off
syntax sync minlines=250

" omni completion, smart autocompletion for programs
" when invoked, the text before the cursor is inspected to guess what might follow
" A popup menu offers word completion choices that may include struct and class members, system functions
set ofu=syntaxcomplete#Complete

"set _viminfo path
" if has("win32")
"     set viminfo+=n$VIM/_viminfo
"
" !,'300,<50,@100,s10,h
if s:nvim && ! has('win32') && ! has('win64')
    set shada=!,'300,<50,@100,s10,h,n$VIMINFO/.viminfo.shada
else
    set viminfo=!,'300,<50,@100,s10,h,n$VIMINFO/.viminfo
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7
set cmdheight=2 "The commandbar height
set hidden "Change buffer - without saving
" Set backspace config
set whichwrap+=<,>,h,l
set ignorecase smartcase hlsearch
set magic "Set magic on, for regular expressions
set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells novisualbell t_vb=
set tm=500

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup nowritebackup noswapfile
let &backupdir = $VIMDATA . '/backup/'
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif

"Persistent undo
if has("persistent_undo")
    set undofile
    let &undodir = $VIMDATA . '/undo'
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" set undolevels=20
" set undoreload=10000

nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> [b :bprev<cr>
nnoremap <silent> ]q :cnext<cr>
nnoremap <silent> [q :cprev<cr>
nnoremap <silent> ]l :lnext<cr>
nnoremap <silent> [l :lprev<cr>
nnoremap <silent> ]t :tabn<cr>
nnoremap <silent> [t :tabp<cr>

cnoremap <C-h> <Home>
cnoremap <C-l> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" Switch (window) to the directory of the current opened buffer
map <Leader>cd :lcd %:p:h<CR>:pwd<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set scrolloff=999

set linebreak       " line break
set textwidth=500

set nowrap " no wrap lines

" Set default dictionary to english
" set spelllang=en_us
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify the behavior when switching between buffers
try
    set switchbuf=usetab
    set showtabline=1
catch
endtry

" traverse quickfix
" nnoremap <silent> gC :cprev<cr>
" nnoremap <silent> gc :cnext<cr>
" traverse location list
" nnoremap <silent> gL :lprev<cr>
" nnoremap <silent> gl :lnext<cr>

set foldmethod=syntax
set foldlevel=100
" new buffer without name
" nnoremap <leader>e  :enew<cr>
" to reload current file and discard modification
nnoremap <leader>R  :edit!<cr>
nnoremap <leader>vd :%v##d<left><left>
nnoremap <leader>vw :%v#<c-r><c-w>#d<cr>

" execute command and put the results into new buffer
" # alternative file name which is the last edit file, % for current file name
" they are readonly registers
" check https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
" or https://www.brianstorti.com/vim-registers/
" ex: find pattern in current file :R rg <pattern> #

""""""""""""""""""""""""""""""
" => vimgrep
""""""""""""""""""""""""""""""
if executable('rg')
    set grepprg=rg\ -S\ --vimgrep\ --no-heading\ --no-column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat=%f:%1:%c%m
else
    set grepprg=grep\ -nH
endif

function! s:RunShellCommand(cmdline) abort
  enew
  setlocal buftype=nofile bufhidden=hide noswapfile
  call setline(1, 'cmd:  ' . a:cmdline)
  " call setline(2, 'Expanded to:  ' . a:cmdline)
  " call append(line('$'), substitute(getline(0), '.', '=', 'g'))
  silent execute '$read !'. a:cmdline
endfunction

function! RemoveEmptyLines() abort
    silent! execute ':%g/^[\ \t]*$/d'
endfunction
command! -range=% RemoveEmptyLines call RemoveEmptyLines()

" Plugin Manager Installation {{{
let g:plugins = $VIMHOME.'/plugged'
let s:plugin_manager = $VIMHOME . '/autoload/plug.vim'
let s:plugin_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" import local config
if s:xdg_config && filereadable($XDG_DATA_HOME .'/vimrc')
    source $XDG_DATA_HOME/vimrc
elseif filereadable($HOME."/.local/vimrc")
    source $HOME/.local/vimrc
endif

if empty(glob(s:plugin_manager))
  echom 'vim-plug not found. Installing...'
  if executable('curl')
    silent exec '!curl -fLo ' . s:plugin_manager . ' --create-dirs ' .
        \ s:plugin_url
  elseif executable('wget')
    call mkdir(fnamemodify(s:plugin_manager, ':h'), 'p')
    silent exec '!wget --force-directories --no-check-certificate -O ' .
        \ expand(s:plugin_manager) . ' ' . s:plugin_url
  else
    echom 'Could not download plugin manager. No plugins were installed.'
    finish
  endif
  augroup vimplug
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif
" }}}

call plug#begin(g:plugins)
source $VIMHOME/plugins.vim
call plug#end()

if has("gui_running")
    set guioptions-=e
else
    set t_Co=256
    set termguicolors
endif
set background=dark
colorscheme molokai

inoremap <esc> <nop>
inoremap jk <esc>

" Fast saving from all modes
nnoremap <Leader>w :write<CR>
xnoremap <Leader>w <Esc>:write<CR>
nnoremap <C-s> :<C-u>write<CR>
xnoremap <C-s> :<C-u>write<CR>
cnoremap <C-s> <C-u>write<CR>

" toggle wrap
nnoremap <silent> <leader>tw :setlocal wrap!<cr>
" toggle relativenumber
nnoremap <silent> <leader>tr :setlocal relativenumber!<cr>

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Start an external command with a singlewr bang
nnoremap ! :!

" " Returns visually selected text
" function! s:get_selection(cmdtype) "{{{
" 	let temp = @s
" 	normal! gv"sy
" 	let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
" 	let @s = temp
" endfunction "}}}
" 
" " Window-control prefix
" nnoremap  [Window]   <Nop>
" nmap      <C-W> [Window]
" 
" nnoremap <silent> [Window]v  :<C-u>split<CR>
" nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
" nnoremap <silent> [Window]t  :tabnew<CR>
" nnoremap <silent> [Window]o  :<C-u>only<CR>
" nnoremap <silent> [Window]b  :b#<CR>
" nnoremap <silent> [Window]c  :close<CR>
" nnoremap <silent> [Window]x  :<C-u>call <SID>window_empty_buffer()<CR>
" nnoremap <silent> [Window]z  :<C-u>call <SID>zoom()<CR>
" 
" " Split current buffer, go to previous window and previous buffer
" nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
" nnoremap <silent> [Window]sg :vsplit<CR>:wincmd p<CR>:e#<CR>
" 
" " Simple zoom toggle
" function! s:zoom()
" 	if exists('t:zoomed')
" 		unlet t:zoomed
" 		wincmd =
" 	else
" 		let t:zoomed = { 'nr': bufnr('%') }
" 		vertical resize
" 		resize
" 		normal! ze
" 	endif
" endfunction
