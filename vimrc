" not compatible with vi
" set nocompatible
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" let mapleader = ","
" let g:mapleader = ","

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

" import setting
lua require('setting')

" vim functions
source $VIMHOME/function.vim

" import key mapping
lua require('mapping')

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

lua << EOF
    -- enable lua modules
    require('impatient')

    -- statusline
    local statusline = require('statusline')
    statusline.tabline = false

    -- require("bufferline").setup{}
    -- require('lualine').setup()

    --[[
    local snap = require'snap'
    snap.maps {
      {"<Leader><Leader>", snap.config.file {producer = "ripgrep.file"}},
      {"<Leader>fb", snap.config.file {producer = "vim.buffer"}},
      {"<Leader>ff", snap.config.vimgrep {}},
      --- {"<Leader>fo", snap.config.file {producer = "vim.oldfile"}},
    }
    ]]--
EOF

" XX: startup speed: molokai > monokai > vim-monokai-tasty
" colorscheme vim-monokai-tasty
colorscheme molokai
" exclude quickfix from bnext/bprev
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
