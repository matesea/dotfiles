" not compatible with vi
set nocompatible
" enable file type detection
filetype off

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'amiorin/ctrlp-z'
Plug 'chazy/cscope_maps'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mhinz/vim-grepper'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/LargeFile'
Plug 'mihais/vim-mark'
Plug 'vim-scripts/taglist.vim', { 'on': 'TlistToggle' }
Plug 'vivien/vim-linux-coding-style'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/neocomplete.vim'
endif

call plug#end()

filetype plugin indent on
set cindent     " c code indentation
set smartcase   " smart case detection while searching
set wildmenu    " command-line completion operates in a enhanced mode
set wildmode=list:longest
set showmode
set showcmd

set cursorline
syntax sync minlines=256
set diffopt+=filler
" less window redraw to speedup
" improve redraw speed
set ttyfast
"set ttyscroll=3
set lazyredraw
" Sets how many lines of history VIM has to remember
syntax on
set history=2000

" Enable filetype plugin
" load plugins according to different file type
filetype plugin on

" omni completion, smart autocompletion for programs
" when invoked, the text before the cursor is inspected to guess what might follow
" A popup menu offers word completion choices that may include struct and class members, system functions
set ofu=syntaxcomplete#Complete

" apply different indent format based on the detected file type
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

"set _viminfo path
if has("win32")
    set viminfo+=n$VIM/_viminfo
elseif has("unix")
    " Tell vim to remember certain things when we exit
    " '10   :marks will be remembered for up to 10 previously edited files
    " "100  : will save up to 100 lines for each register
    " :20   : up to 20 lines of comand-line history will be remembered
    " %     :save and restores the buffer list
    " n...  : where to save the viminfo files
    if has('nvim')
        set viminfo='10,\"100,:20,%,n~/.nviminfo
    else
        set viminfo='10,\"100,:20,%,n~/.viminfo
    endif

    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup ResCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup End
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set wildmenu "Turn on WiLd menu

set ruler "Always show current position

set cmdheight=1 "The commandbar height

set hid "Change buffer - without saving

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros 

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
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
set backupdir=$HOME/.vim_runtime/backup/
silent execute '!mkdir -p $HOME/.vim_runtime/backup/'

set nowb
set noswapfile

"Persistent undo
try
    if has("win32")
        set undodir=C:\Windows\Temp
    else
        set undodir=~/.vim_runtime/undo
    endif

    set undofile
    set undolevels=20
    set undoreload=1000
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

set undofile
set undolevels=20
set undoreload=1000

nnoremap gB :bp<cr>
nnoremap gb :bn<cr>
for i in range(0, 99)
    execute 'map <silent> '.i.'gb :b'.i.'<cr>'
endfor
inoremap jk <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set scrolloff=999

set linebreak       " line break
set textwidth=500

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines
set updatetime=250 "for vim-gitgutter

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
" vnoremap <silent> * :call VisualSearch('f')<cr>
" vnoremap <silent> # :call VisualSearch('b')<cr>
" 
" " When you press gv you vimgrep after the selected text
" vnoremap <silent> gv :call VisualSearch('gv')<cr>
" "map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
" 
" function! CmdLine(str)
"     exe "menu Foo.Bar :" . a:str
"     emenu Foo.Bar
"     unmenu Foo
" endfunction
" 
" " From an idea by Michael Naumann
" function! VisualSearch(direction) range
"     let l:saved_reg = @"
"     execute "normal! vgvy"
" 
"     let l:pattern = escape(@", '\\/.*$^~[]')
"     let l:pattern = substitute(l:pattern, "\n$", "", "")
" 
"     if a:direction == 'b'
"         execute "normal ?" . l:pattern . "^M"
"     elseif a:direction == 'gv'
"         call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
"     elseif a:direction == 'f'
"         execute "normal /" . l:pattern . "^M"
"     endif
" 
"     let @/ = l:pattern
"     let @" = l:saved_reg
" endfunction

" toggle highlight search
nmap <silent> <leader>h :setlocal hls!<cr>
nmap <silent> <leader>b :setlocal wrap!<cr>
nmap <silent> <leader>l :setlocal list!<cr>
nmap <silent> <leader>rn :setlocal relativenumber!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Close the current buffer
nnoremap bd :Bclose<cr>

" Close all the buffers
nnoremap <leader>ba :1,300 bd!<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Specify the behavior when switching between buffers 
try
    set switchbuf=usetab
    set showtabline=1
catch
endtry

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" traverse quickfix
nnoremap gc :cnext<cr>
nnoremap gC :cprev<cr>

nnoremap ts :tselect<cr>
nnoremap gt :tnext<cr>
nnoremap gT :tprev<cr>

set foldmethod=syntax
set foldlevel=100
" fast file traverse
noremap j gj
noremap k gk
nnoremap fvw :%v/\<<c-r><c-w>\>/d<cr>
nnoremap fv :%v//d<left><left>
nnoremap <leader>sv :vsp<space>
nnoremap <leader>sp :sp<space>
nnoremap <leader>e  :e<space>
" to reload current file
nnoremap rl :edit!<cr>
" toggle between relative line number & line number

""""""""""""""""""""""""""""""
" => CtrlP plugin
""""""""""""""""""""""""""""""
let g:ctrlp_map = 'sp'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_default_input = 1
let g:ctrlp_lazy_update = 1
noremap sr :CtrlPRoot<cr>
nnoremap sb :CtrlPBuffer<cr>

""""""""""""""""""""""""""""""
" CtrlP-Z 
""""""""""""""""""""""""""""""
let g:ctrlp_z_nerdtree = 1
" let g:ctrlp_extensions = ['Z', 'F']
nnoremap sz :CtrlPZ<cr>
nnoremap sf :CtrlPF<cr>

""""""""""""""""""""""""""""""
" tagbar plugin
""""""""""""""""""""""""""""""
nnoremap <leader>tt :TagbarToggle<cr>
""""""""""""""""""""""""""""""
" => cscope plugin
""""""""""""""""""""""""""""""
nnoremap cs :cscope<space>
nnoremap cf :cscope find<space>
nnoremap ca :cscope add<space>
nnoremap caa :cscope add files/all.out<cr>

""""""""""""""""""""""""""""""
" => the silver searcher plugin
""""""""""""""""""""""""""""""
if executable('ag')
    " use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor
    " use ag in CtrlP for listing file
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
    set grepformat=%f:%1:%c%m
else
    set grepprg=grep\ -nH
    let g:ctrlp_user_command = 'find %s -type f'
    let g:ctrlp_use_caching = 1
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp/'
endif

" => taglist plugin
nmap <silent> <leader>tl :TlistToggle<cr>

""""""""""""""""""""""""""""""
" => nerdtree
" view directory content
""""""""""""""""""""""""""""""
let g:NERDTreeChDirMode=0
let g:NERDTreeWinPos=0
nmap <leader>f :NERDTreeToggle<CR>

""""""""""""""""""""""""""""""
" => YankRing plugin
""""""""""""""""""""""""""""""
" if has("unix")
"     let g:yankring_history_dir = '~/.vim/'
"     let g:fuf_dataDir = '~/.vim-fuf-data'
" else
"     let g:yankring_history_dir = '$VIM'
"     let g:fuf_dataDir = '$VIM/.vim-fuf-data'
" endif
" let g:yankring_replace_n_pkey = '<c-l>'
" let g:yankring_replace_n_nkey = '<c-.>'
" let g:yankring_max_history = 200
" let g:yankring_clipboard_monitor=0
" nnoremap <leader>y     :YRShow<cr>

""""""""""""""""""""""""""""""
" => yankstack plugin
""""""""""""""""""""""""""""""
nnoremap <leader>y :Yanks<cr>
let g:yankstack_map_keys = 0
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste

""""""""""""""""""""""""""""""
" => airline plugin 
""""""""""""""""""""""""""""""
let g:airline_extensions = ['tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 0

if has('nvim')
    """"""""""""""""""""""""""""""
    " => deoplete plugin 
    """"""""""""""""""""""""""""""
    let g:acp_enableAtStartup = 0
    let g:deoplete#enable_at_startup = 1
else
    """"""""""""""""""""""""""""""
    " => neocomplete plugin 
    """"""""""""""""""""""""""""""
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#syntax#min_keyword_length = 3
endif
""""""""""""""""""""""""""""""
" => easymotion plugin
""""""""""""""""""""""""""""""
let g:EasyMotion_leader_key = ',,'
""""""""""""""""""""""""""""""
" => Minibuffer plugin
""""""""""""""""""""""""""""""
" let g:miniBufExplBuffersNeeded = 0
" let g:miniBufExplHideWhenDiff = 1
" let g:miniBufExplCycleArround = 1
" let g:bufExplorerSortBy = "name"
""""""""""""""""""""""""""""""
" => vim-gitgutter plugin
""""""""""""""""""""""""""""""
let g:gitgutter_eager = 0
""""""""""""""""""""""""""""""
" => vim-gitgutter plugin
""""""""""""""""""""""""""""""
nnoremap <leader>g :Grepper -tool ag -buffers<cr>

" import local config
if filereadable($HOME."/.vimrc.local")
    source $HOME/.vimrc.local
endif
