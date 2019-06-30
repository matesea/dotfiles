" not compatible with vi
set nocompatible
" enable file type detection
filetype off

let s:nvim = has('nvim')
" let s:cygwin = has("unix") && has("win32unix")
let s:xdg_config = exists("$XDG_CONFIG_HOME")
let s:xdg_data = exists("$XDG_DATA_HOME")

" === vim-plug ===
if s:xdg_config && isdirectory($XDG_CONFIG_HOME.'/nvim/plugged')
    " import plugin from ${XDG_CONFIG_HOME}/nvim/plugged if available
    call plug#begin($XDG_CONFIG_HOME.'/nvim/plugged')
elseif s:xdg_config && isdirectory($XDG_CONFIG_HOME.'/vim/plugged')
    " import plugin from ${XDG_CONFIG_HOME}/vim/plugged if available
    call plug#begin($XDG_CONFIG_HOME.'/vim/plugged')
else
    " rollback to search $HOME/.vim/plugged
    call plug#begin($HOME.'/.vim/plugged')
endif

" shows a git diff in the gutter and stages/undoes hunks
Plug 'airblade/vim-gitgutter'
" buffer tabs
Plug 'ap/vim-buftabline'
" highlights trailing whitespace in red
Plug 'bronson/vim-trailing-whitespace'
" Plug 'tranngocthachs/gtags-cscope-vim-plugin'
Plug 'joereynolds/gtags-scope'
" better diff options for vim
Plug 'chrisbra/vim-diff-enhanced'
" toggle quickfix window
Plug 'drmingdrmer/vim-toggle-quickfix'
" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'
" a command-line fuzzy finder written in Go
Plug 'junegunn/fzf',    { 'do': './install --all' }
" things you can do with fzf and vim
Plug 'junegunn/fzf.vim'
" Plug 'junegunn/vim-easy-align'
" syntax file to highlight various log files
Plug 'dzeban/vim-log-syntax'
" vim motion on speed
Plug 'easymotion/vim-easymotion'
" reopen files at the last edit position
Plug 'farmergreg/vim-lastplace'
" A light and configurable statusline/tabline plugin for vim
Plug 'itchyny/lightline.vim'
" jump to any location specified by two characters
" Plug 'justinmk/vim-sneak'
" class outline viewer for vim
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" a lightweight implementation of emacs's kill-ring for vim
Plug 'maxbrunsfeld/vim-yankstack'
" speed up loading of large files
Plug 'mhinz/vim-hugefile'
" help you win at grep
Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
" mark: highlight several words in different colors simultaneously
Plug 'mihais/vim-mark'
" delete buffers and close files in vim without closing windows or messing up layout
Plug 'moll/vim-bbye'
" tree explorer plugin
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" integrate with fzy or picker into vim
" Plug 'srstevenson/vim-picker'
" molokai theme
Plug 'tomasr/molokai'
" defaults everyone can agree on
Plug 'tpope/vim-sensible'
" solarized colorscheme
Plug 'altercation/vim-colors-solarized'
" edit large file quickly
" Plug 'vim-scripts/LargeFile'
" source code browser
" Plug 'vim-scripts/taglist.vim', { 'on': 'TlistToggle' }
" follow linux kernel coding style
Plug 'vivien/vim-linux-coding-style', { 'for': 'c' }

" vim tmux seamless navigator
Plug 'christoomey/vim-tmux-navigator'
" git wrapper
Plug 'tpope/vim-fugitive'
" git commit browser
Plug 'junegunn/gv.vim'
" undo
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
" show search index
Plug 'google/vim-searchindex'
" completion system
if s:nvim
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/neocomplete.vim'
endif
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

filetype plugin indent on
set cindent     " c code indentation
set smartindent " smart indent
set smartcase   " smart case detection while searching
" set wildmode=longest:full,full
set wildmode=list:longest,full
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

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

"set _viminfo path
" if has("win32")
"     set viminfo+=n$VIM/_viminfo
if has("unix")
    " Tell vim to remember certain things when we exit
    " '10   :marks will be remembered for up to 10 previously edited files
    " "100  : will save up to 100 lines for each register
    " :20   : up to 20 lines of comand-line history will be remembered
    " %     :save and restores the buffer list
    " n...  : where to save the viminfo files
    if s:nvim
        if s:xdg_data
            set viminfo='50,\"100,:20,%,n$XDG_DATA_HOME/.nviminfo
        else
            set viminfo='50,\"100,:20,%,n$HOME/.nviminfo
        endif
    else
        if s:xdg_data
            set viminfo='50,\"100,:20,%,n$XDG_DATA_HOME/.viminfo
        else
            set viminfo='50,\"100,:20,%,n$HOME/.viminfo
        endif
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
set ignorecase "Ignore case when searching
set hlsearch "Highlight search things
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
if s:xdg_data
    set backupdir=$XDG_DATA_HOME/.vim/backup/
    silent execute '!mkdir -p $XDG_DATA_HOME/.vim/backup/'
else
    set backupdir=$HOME/.local/vim/backup/
    silent execute '!mkdir -p $HOME/.local/vim/backup/'
endif

set nowb
set noswapfile

"Persistent undo
if has("persistent_undo")
    set undofile
    try
        " if has("win32")
        "     set undodir=C:\Windows\Temp
        if s:xdg_data
            set undodir=$XDG_DATA_HOME/.vim/undo
        else
            set undodir=$HOME/.local/vim/undo
        endif
    catch
    endtry
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl
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
nmap <silent> <leader>hl :setlocal hls!<cr>
nmap <silent> <leader>wr :setlocal wrap!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
nnoremap <leader>vw :%v/\<<c-r><c-w>\>/d<cr>
nnoremap <leader>v :%v//d<left><left>
" nnoremap <leader>e  :e<space>
" to reload current file
nnoremap <leader>R :edit!<cr>

""""""""""""""""""""""""""""""
" => directory traverse
""""""""""""""""""""""""""""""
nnoremap <leader>cd :cd<space>
nnoremap <leader>u :cd ..<cr>:pwd<cr>
nnoremap <leader>u2 :cd ../..<cr>:pwd<cr>
nnoremap <leader>u3 :cd ../../..<cr>:pwd<cr>
nnoremap <leader>u4 :cd ../../../..<cr>:pwd<cr>
nnoremap <leader>u5 :cd ../../../../..<cr>:pwd<cr>

""""""""""""""""""""""""""""""
" tagbar plugin
""""""""""""""""""""""""""""""
nnoremap tt :TagbarToggle<cr>
""""""""""""""""""""""""""""""
" => cscope plugin
""""""""""""""""""""""""""""""
if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
    " show msg when any other cscope db added
    set cscopeverbose
    nnoremap cf :cscope find<space>
    nnoremap cs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap cg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap cc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap ca :cscope add<space>
endif
""""""""""""""""""""""""""""""
" => gtags-cscope-vim plugin
""""""""""""""""""""""""""""""
nnoremap <leader>gc :GtagsCscope<cr>

""""""""""""""""""""""""""""""
" => vimgrep
""""""""""""""""""""""""""""""
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
    " use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor
    " use ag in CtrlP for listing file
    " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " ag is fast enough that CtrlP doesn't need to cache
    " let g:ctrlp_use_caching = 0
    set grepformat=%f:%1:%c%m
else
    set grepprg=grep\ -nH
    " let g:ctrlp_user_command = 'find %s -type f'
    " let g:ctrlp_use_caching = 1
    " if exists("$XDG_DATA_HOME")
    "     let g:ctrlp_cache_dir = $XDG_DATA_HOME.'/.vim/ctrlp/'
    " else
    "     let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp/'
    " endif
endif
""""""""""""""""""""""""""""""
" => nerdtree
" view directory content
""""""""""""""""""""""""""""""
nmap <leader>nt :NERDTreeToggle<cr>
""""""""""""""""""""""""""""""
" => yankstack plugin
""""""""""""""""""""""""""""""
" call yankstack#setup()
nnoremap <leader>y :Yanks<cr>
let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
let g:yankstack_map_keys = 0
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste
""""""""""""""""""""""""""""""

if s:nvim
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
" let g:EasyMotion_leader_key = ',,'
let g:EasyMotion_do_mapping = 0
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap ss <Plug>(easymotion-overwin-f2)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
""""""""""""""""""""""""""""""
" => vim-gitgutter plugin
""""""""""""""""""""""""""""""
let g:gitgutter_eager = 0
" nnoremap <leader>gg :G
" nnoremap <leader>g  :Git<space>
nnoremap <leader>gs :Gstatus<CR>
" nnoremap <leader>gd :Gdiff
" nnoremap <leader>gb :Gblame<CR>
" nnoremap <leader>gw :Gbrowse<CR>
" nnoremap <leader>gc :Gcommit %
" nnoremap <leader>gl :Glog<CR>
" nnoremap <leader>gp :Gpush
""""""""""""""""""""""""""""""
" => vim-grepper plugin
""""""""""""""""""""""""""""""
nnoremap <leader>g :Grepper -tool rg<cr>
nnoremap <leader>G :Grepper -tool git<cr>
nnoremap <leader>gb :Grepper -tool rg -buffers<cr>
nnoremap <leader>gw :Grepper -tool rg -buffers -cword -noprompt<cr>
""""""""""""""""""""""""""""""
" => vim-mark plugin
""""""""""""""""""""""""""""""
nmap mt <Plug>MarkToggle
nmap mc <Plug>MarkAllClear

""""""""""""""""""""""""""""""
" => vim-sneak plugin
""""""""""""""""""""""""""""""
" let g:sneak#label = 1
" nmap s <Plug>Sneak_s
" nmap t <Plug>Sneak_S
" xmap s <Plug>Sneak_s
" xmap t <Plug>Sneak_S

""""""""""""""""""""""""""""""
" => vim-log-syntax plugin
""""""""""""""""""""""""""""""
" change filetype to log
nnoremap <leader>l :setlocal filetype=log<cr>

""""""""""""""""""""""""""""""
" => vim-buftabline
""""""""""""""""""""""""""""""
let g:buftabline_show = 1
" let g:buftabline_numbers = 1

""""""""""""""""""""""""""""""
" => fzf plugin
""""""""""""""""""""""""""""""
nnoremap fe :FZF<cr>
nnoremap fc :FZF %:h<cr>
" git files
" nnoremap <leader>fg :GFiles<cr>
" open buffers
nnoremap fb :Buffers<cr>
" nnoremap <leader>fh :History<cr>
" lines in loaded buffer
nnoremap fl :Lines<cr>
" lines in the current buffer
nnoremap bl :BLines<cr>
" rg search
nnoremap <silent> rw :Rg <C-R><C-W><CR>
nnoremap <silent> rg :Rg<space>
" imap <c-x><c-l> <plug>(fzf-complete-line)

""""""""""""""""""""""""""""""
" => vim-toggle-quickfix plugin
""""""""""""""""""""""""""""""
nmap qt <Plug>window:quickfix:toggle

""""""""""""""""""""""""""""""
" => vim-bbye plugin
""""""""""""""""""""""""""""""
nnoremap bd :Bdelete<cr>

""""""""""""""""""""""""""""""
" => undotree
""""""""""""""""""""""""""""""
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<cr>
""""""""""""""""""""""""""""""
" => easy-align
""""""""""""""""""""""""""""""
" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" import local config
if s:xdg_config && filereadable($XDG_CONFIG_HOME."/.vimrc.local")
    source $XDG_CONFIG_HOME/.vimrc.local
elseif filereadable($HOME."/.vimrc.local")
    source $HOME/.vimrc.local
endif
