" not compatible with vi
set nocompatible
" enable file type detection
filetype off
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

let s:nvim = has('nvim')
" let s:cygwin = has("unix") && has("win32unix")
let s:xdg_config = exists("$XDG_CONFIG_HOME")
let s:xdg_data = exists("$XDG_DATA_HOME")
if s:xdg_config && isdirectory($XDG_CONFIG_HOME . '/nvim')
    let $VIMHOME=$XDG_CONFIG_HOME . '/nvim'
elseif s:xdg_config && isdirectory($XDG_CONFIG_HOME . '/vim')
    let $VIMHOME=$XDG_CONFIG_HOME . '/vim'
elseif isdirectory($HOME . '/dotfiles/vim')
    let $VIMHOME=$HOME . '/dotfiles/vim'
else
    let $VIMHOME=$HOME . '/.vim'
endif

if s:xdg_data
    let $VIMDATA=$XDG_DATA_HOME . '/.vim'
else
    let $VIMDATA=$HOME . '/.local/vim'
endif

" Plugin Manager Installation {{{
let g:plugins=$VIMHOME.'/plugged'
let s:plugin_manager=$VIMHOME . '/autoload/plug.vim'
let s:plugin_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

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

" show vimrc
map <f9>    :sp $MYVIMRC<cr>
" show plugins.vim
map <f10>   :execute 'sp $VIMHOME/plugins.vim'<cr>

filetype plugin indent on
set cindent     " c code indentation
set smartindent " smart indent
" set wildmode=longest:full,full
" set wildmode=list:longest,full
set wildmode=longest,full
set showmode
set showcmd

set cursorline
set diffopt+=filler
" less window redraw to speedup
" improve redraw speed
set ttyfast
"set ttyscroll=3
set lazyredraw
" Sets how many lines of history VIM has to remember
set history=2000

syntax on
syntax sync minlines=256

" Enable filetype plugin
" load plugins according to different file type
filetype plugin on

" omni completion, smart autocompletion for programs
" when invoked, the text before the cursor is inspected to guess what might follow
" A popup menu offers word completion choices that may include struct and class members, system functions
set ofu=syntaxcomplete#Complete

" apply different indent format based on the detected file type
filetype indent on

"set _viminfo path
" if has("win32")
"     set viminfo+=n$VIM/_viminfo
if has("unix")
    let &viminfo="'100,<50,s10,h,n"
    if s:xdg_data
        let s:viminfodir=$XDG_DATA_HOME
    else
        let s:viminfodir=$HOME
    endif
    if !isdirectory(s:viminfodir)
        call mkdir(s:viminfodir, 'p')
    endif
    if s:nvim
        let &viminfo.=s:viminfodir . '/.viminfo.shada'
    else
        let &viminfo.=s:viminfodir . '/.viminfo'
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7
set cmdheight=1 "The commandbar height
set hid "Change buffer - without saving
" Set backspace config
set whichwrap+=<,>,h,l
set incsearch ignorecase smartcase hlsearch
set nolazyredraw "Don't redraw while executing macros
set magic "Set magic on, for regular expressions
set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells novisualbell t_vb=
set tm=500

if has("gui_running")
    set guioptions-=e
else
    set t_Co=256
    set background=dark
    colorscheme molokai
endif
set nu

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
set backup
let &backupdir=$VIMDATA . '/backup/'
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
set nowb noswapfile

"Persistent undo
if has("persistent_undo")
    set undofile
    let &undodir = $VIMDATA . '/undo'
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

syntax enable
" set undolevels=20
" set undoreload=10000

nnoremap gB :bp<cr>
nnoremap gb :bn<cr>
for i in range(0, 20)
    execute 'map <silent> '.i.'gb :b'.i.'<cr>'
endfor

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set scrolloff=999

set linebreak       " line break
set textwidth=500

set wrap "Wrap lines
set updatetime=250 "for vim-gitgutter

" toggle highlight search
" nmap <silent> <leader>hl :setlocal hls!<cr>
" nmap <silent> <leader>wr :setlocal wrap!<cr>

" make regex a little easier
set magic

" Set default dictionary to english
set spelllang=en_us
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
nnoremap gc :cnext<cr>
nnoremap gC :cprev<cr>
" traverse location list
nnoremap gl :lnext<cr>
nnoremap gL :lprev<cr>

nnoremap ts :tselect<cr>
nnoremap gt :tnext<cr>
nnoremap gT :tprev<cr>

set foldmethod=syntax
set foldlevel=100
" fast file traverse
noremap j gj
noremap k gk
" new buffer without name
" nnoremap <leader>e  :enew<cr>
" to reload current file
nnoremap <leader>R  :edit!<cr>
nnoremap <leader>vd :%v//d<left><left>
nnoremap <leader>vw :%v/\<<c-r><c-w>\>/d<cr>
nnoremap <leader>ss :%s/<c-r><c-w>//g<left><left>
nnoremap <leader>sw :%s/\<<c-r><c-w>\>//g<left><left>

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

function! s:RunShellCommand(cmdline)
  enew
  setlocal buftype=nofile bufhidden=hide noswapfile
  call setline(1, 'cmd:  ' . a:cmdline)
  " call setline(2, 'Expanded to:  ' . a:cmdline)
  " call append(line('$'), substitute(getline(0), '.', '=', 'g'))
  silent execute '$read !'. a:cmdline
endfunction

" command! -nargs=* -complete=shellcmd R  enew |
"             \setlocal buftype=nofile bufhidden=hide noswapfile |
"             \r !<args>
" command! -nargs=* -complete=shellcmd Rv vnew | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
" command! -nargs=* -complete=shellcmd Rh new  | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
""""""""""""""""""""""""""""""
" import local config
if s:xdg_config && filereadable($XDG_CONFIG_HOME .'/.local/vimrc')
    source $XDG_CONFIG_HOME/.local/vimrc
elseif filereadable($HOME."/.local/vimrc")
    source $HOME/.local/vimrc
endif
