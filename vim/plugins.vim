" text object
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'

" shows a git diff in the gutter and stages/undoes hunks
" Plug 'airblade/vim-gitgutter', {'on': []}
"     set updatetime=300
"     let g:gitgutter_map_keys = 0
"     nnoremap <silent> ]c :GitGutterNextHunk<cr>
"     nnoremap <silent> [c :GitGutterPrevHunk<cr>

" XX: vim-signify faster than gitgutter in startup
Plug 'mhinz/vim-signify'
     set updatetime=300
    nmap ]c <plug>(signify-next-hunk)
    nmap [c <plug>(signify-prev-hunk)

" git wrapper
Plug 'tpope/vim-fugitive', {'on': ['Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame', 'GV']}

" git commit browser
Plug 'junegunn/gv.vim', {'on': 'GV'}

Plug 'junegunn/goyo.vim', {'on': 'Goyo'}

" buffer tabs
Plug 'ap/vim-buftabline'
    let g:buftabline_show = 1

" highlights trailing whitespace in red
Plug 'bronson/vim-trailing-whitespace', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim']}
    let g:extra_whitespace_ignored_filetypes = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'log', 'text']
" Plug 'ntpeters/vim-better-whitespace', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim']}

" gtags-cscope
Plug 'joereynolds/gtags-scope', {'on': 'GtagsCscope'}

" " == cscope mappings ==
" " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
" set cscopetag
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order.
set csto=0
" show msg when any other cscope db added
set cscopeverbose
  " display result in quickfix
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
set cscoperelative
nnoremap <leader>cf :cscope find<space>
nnoremap <leader>cs :cscope find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cg :cscope find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cc :cscope find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ca :cscope add<space>

" toggle quickfix window
Plug 'drmingdrmer/vim-toggle-quickfix', {'on': ['<Plug>window:quickfix:toggle', '<Plug>window:location:toggle']}
    nmap <leader>q <Plug>window:quickfix:toggle
    nmap <leader>l <Plug>window:location:toggle

" Pairs of handy bracket mappings
" Plug 'tpope/vim-unimpaired'

" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'
" "use default setting alt+p
" let g:AutoPairsShortcutToggle = '<leader>p'

" " a command-line fuzzy finder written in Go
Plug 'junegunn/fzf', {'do': './install --completion --key-bindings --xdg --no-update-rc'}
" manage imported github repositories
Plug 'atweiden/fzf-extras', {'on': []}
Plug 'skywind3000/z.lua', {'on': []}
" " things you can do with fzf and vim
Plug 'junegunn/fzf.vim'
    let g:fzf_layout = {'down': '~25%'}
    nnoremap ;e :FZF<cr>
    nnoremap ;c :FZF %:h<cr>
    " git files
    " nnoremap <leader>fg :GFiles<cr>
    " open buffers
    nnoremap ;b :Buffers<cr>
    nnoremap ;h :History
    " lines in loaded buffers
    nnoremap ;a :Lines<cr>
    " lines in the current buffer
    nnoremap ;l :BLines<cr>
    nnoremap ;w :BLines <c-r><c-w><cr>
    " tags of the current buffer
    nnoremap ;t :BTags<cr>
    " rg search
    " TODO: to populate rg results into quickfix,
    " by default fzf.vim use alt-a/alt-d to select and deselect all
    " but alt doesn't work on neovim, change to ctrl-s/ctrl-d in vim.vim
    nnoremap ;rg :Rg<space>
    nnoremap ;rw :Rg <c-r><c-w><cr>
    nnoremap ;rc :Rc<space>

if has('nvim')
    " disable python interpreter check in neovim startup
    let g:python3_host_skip_check = 1
    let g:python_host_skip_check = 1
    " TODO: set in ~/.local/vimrc
    " let g:python3_host_prog = '/opt/local/bin/python3'
    " let g:python_host_prog = '/opt/local/bin/python'
endif

if has("nvim-0.5")
    " Track the engine.
    Plug 'SirVer/ultisnips', {'on': []}
        " Trigger configuration
        let g:UltiSnipsExpandTrigger = "<tab>"
        let g:UltiSnipsJumpForwardTrigger = "<c-b>"
        let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

        " Snippets are separated from the engine. Add this if you want them:
        Plug 'honza/vim-snippets', {'on': []}

    Plug 'hrsh7th/nvim-compe', {'on': []}
        let g:compe = {}
        let g:compe.enabled = v:true
        let g:compe.autocomplete = v:true
        let g:compe.debug = v:false
        let g:compe.min_length = 1
        let g:compe.preselect = 'enable'
        let g:compe.throttle_time = 80
        let g:compe.source_timeout = 200
        let g:compe.incomplete_delay = 400
        let g:compe.max_abbr_width = 100
        let g:compe.max_kind_width = 100
        let g:compe.max_menu_width = 100
        let g:compe.documentation = v:true
        let g:compe.source = {}
        let g:compe.source.path = v:true
        let g:compe.source.buffer = v:true
        let g:compe.source.tags = v:true
        " let g:compe.source.calc = v:true
        let g:compe.source.nvim_lsp = v:true
        let g:compe.source.nvim_lua = v:true
        let g:compe.source.vsnip = v:true

    Plug 'andersevenrud/compe-tmux', {'on': []}
        let g:compe.source.tmux = {}
        let g:compe.source.tmux.all_panes = v:true

    " Plug 'ncm2/ncm2', {'on': []}
    "     Plug 'roxma/nvim-yarp', {'on': []}
    "     " NOTE: you need to install completion sources to get completions. Check
    "     " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
    "     Plug 'ncm2/ncm2-bufword', {'on': []}
    "     Plug 'ncm2/ncm2-path', {'on': []}
    "     Plug 'fgrsnau/ncm2-otherbuf', {'on': []}
    "     Plug 'ncm2/ncm2-gtags', {'on': []}

        function! s:load_insert(timer) abort
            if (&filetype ==# 'log' || &filetype ==# 'text')
                " echom 'not for log'
                return
            endif
            " call plug#load('ncm2')
            " call plug#load('nvim-yarp')
            " call plug#load('ncm2-bufword')
            " call plug#load('ncm2-path')
            " call plug#load('ncm2-otherbuf')
            " call plug#load('ncm2-gtags')

            call plug#load('ultisnips')
            call plug#load('vim-snippets')
            call plug#load('nvim-compe')
            " call plug#load('compe-tmux')

            " enable ncm2 for all buffers
            " call ncm2#enable_for_buffer()

            " When the <Enter> key is pressed while the popup menu is visible, it only
            " hides the menu. Use this mapping to close the menu and also start a new
            " line.
            " inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
        endfunction

        " IMPORTANT: :help Ncm2PopupOpen for more information
        set completeopt=noinsert,menuone,noselect
        " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
        " found' messages
        set shortmess+=c
        " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
        inoremap <c-c> <ESC>
        " Use <TAB> to select the popup menu:
        inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " When the <Enter> key is pressed while the popup menu is visible, it only
        " hides the menu. Use this mapping to close the menu and also start a new
        " line.
        " inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

        autocmd InsertEnter * call timer_start(50, function('s:load_insert'))
endif

" Vim plugin for the Perl module / CLI script 'ack'
Plug 'mileszs/ack.vim',     {'on': ['LAckAdd', 'LAck', 'Ack', 'AckAdd']}
  if executable('rg')
      let g:ackprg = "rg -S --vimgrep --no-heading --no-column"
      " Rc: grep the folder of current editing file
      command! -bang -nargs=* Rc  call fzf#vim#grep
          \('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
          \1, fzf#vim#with_preview({'dir': expand('%:h:p')}), <bang>0)
      command! -complete=shellcmd -nargs=+ R
          \ call s:RunShellCommand("rg -S --vimgrep --no-heading --no-column ".<q-args>)
  elseif executable('ag')
      let g:ackprg = "ag --vimgrep"
      " Rc: grep the folder of current editing file
      command! -bang -nargs=* Rc  call fzf#vim#grep
          \('ag --noheading --nogroup --color --smart-case '.shellescape(<q-args>),
          \1, fzf#vim#with_preview({'dir': expand('%:h:p')}), <bang>0)
      command! -complete=shellcmd -nargs=+ R
          \ call s:RunShellCommand("ag --noheading --nogroup --nocolor --smart-case ".<q-args>)
  endif
  let g:ackhighlight = 1

" delete buffers and close files in vim without closing windows or messing up layout
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
  nnoremap <silent> bd :Bdelete!<cr>

" the missing motion for vim
Plug 'justinmk/vim-sneak', {'on': ['<Plug>Sneak_s', '<Plug>Sneak_S']}
    let g:sneak#label = 1
    " 2-character Sneak (default)
    nmap s <Plug>Sneak_s
    nmap S <Plug>Sneak_S
    " visual-mode
    xmap s <Plug>Sneak_s
    xmap S <Plug>Sneak_S
    " operator-pending-mode
    omap s <Plug>Sneak_s
    omap S <Plug>Sneak_S
    " repeat motion
    map ; <Plug>Sneak_;
    map , <Plug>Sneak_,

" Extended f, F, t and T key mappings for Vim
" Plug 'rhysd/clever-f.vim'
"   let g:clever_f_across_no_line = 1
"   let g:clever_f_smart_case = 1

" Highlight characters to move directly with f/t/F/T
Plug 'deris/vim-shot-f', {'on': [
            \'<Plug>(shot-f-f)', '<Plug>(shot-f-F)',
            \'<Plug>(shot-f-t)', '<Plug>(shot-f-T)']}
    let g:shot_f_no_default_key_mappings = 1
    nmap f  <Plug>(shot-f-f)
    nmap F  <Plug>(shot-f-F)
    nmap t  <Plug>(shot-f-t)
    nmap T  <Plug>(shot-f-T)
    xmap f  <Plug>(shot-f-f)
    xmap F  <Plug>(shot-f-F)
    xmap t  <Plug>(shot-f-t)
    xmap T  <Plug>(shot-f-T)
    omap f  <Plug>(shot-f-f)
    omap F  <Plug>(shot-f-F)
    omap t  <Plug>(shot-f-t)
    omap T  <Plug>(shot-f-T)

" Display and toggle marks
" Plug 'kshenoy/vim-signature', {'on': []}
" 	let g:SignatureIncludeMarks = 'abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
"     let g:SignatureForceRemoveGlobal = 0
"     let g:SignatureUnconditionallyRecycleMarks = 1
"     let g:SignatureErrorIfNoAvailableMarks = 0
"     let g:SignaturePurgeConfirmation = 0
"     let g:SignatureMarkTextHLDynamic = 1
"     let g:SignatureMarkerTextHLDynamic = 1
"     let g:SignatureIncludeMarkers = repeat('⚐', 10)
" 	let g:SignatureMap = {
"		\ 'Leader':            'm',
"		\ 'ListBufferMarks':   'm/',
"		\ 'ListBufferMarkers': 'm?',
"		\ 'PlaceNextMark':     'm,',
"		\ 'ToggleMarkAtLine':  'mm',
"		\ 'PurgeMarksAtLine':  'm-',
"		\ 'DeleteMark':        'dm',
"		\ 'PurgeMarks':        'm<Space>',
"		\ 'PurgeMarkers':      'm<BS>',
"		\ 'GotoNextLineAlpha': "']",
"		\ 'GotoPrevLineAlpha': "'[",
"		\ 'GotoNextSpotAlpha': '`]',
"		\ 'GotoPrevSpotAlpha': '`[',
"		\ 'GotoNextLineByPos': "]'",
"		\ 'GotoPrevLineByPos': "['",
"		\ 'GotoNextSpotByPos': 'mn',
"		\ 'GotoPrevSpotByPos': 'mp',
"		\ 'GotoNextMarker':    ']-',
"		\ 'GotoPrevMarker':    '[-',
"		\ 'GotoNextMarkerAny': ']=',
"		\ 'GotoPrevMarkerAny': '[=',
"		\}

Plug 'jacquesbh/vim-showmarks'
" needed by vim-mark
Plug 'inkarkat/vim-ingo-library', {'on': ['MarkLoad', 'Mark', 'MarkSave', '<Plug>MarkSet', '<Plug>MarkRegex']}
" mark: highlight several words in different colors simultaneously
Plug 'inkarkat/vim-mark', {'on': ['MarkLoad', 'Mark', 'MarkSave', '<Plug>MarkSet', '<Plug>MarkRegex']}
    let g:mwDefaultHighlightingPalette = 'maximum'
    let g:mwHistAdd = '/@'
    let g:mw_no_mappings = 1
    let g:mwAutoLoadMarks = 1
    let g:mwAutoLoadMarks = 1
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
    nmap * <Plug>MarkSearchOrCurNext
    nmap # <Plug>MarkSearchOrCurPrev
 	nmap <unique> <Leader>m <Plug>MarkSet
 	xmap <unique> <Leader>m <Plug>MarkSet
 	nmap <unique> <Leader>r <Plug>MarkRegex
 	xmap <unique> <Leader>r <Plug>MarkRegex
 	nmap <unique> <Leader>n <Plug>MarkClear
" reopen files at the last edit position
Plug 'farmergreg/vim-lastplace'

" if has("nvim-0.5")
"     Plug 'beauwilliams/statusline.lua'
" else
Plug 'lukelbd/vim-statusline'
    " Plug 'itchyny/lightline.vim'
" endif

" A light and configurable statusline/tabline plugin for vim
     " Plug 'mengelbrecht/lightline-bufferline'
     " set showtabline=2
     " let g:lightline#bufferline#show_number  = 0
     " let g:lightline#bufferline#shorten_path = 0
     " let g:lightline#bufferline#unnamed      = '[No Name]'
     " let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
     " let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
     " let g:lightline.component_type   = {'buffers': 'tabsel'}

     " autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim', {'On': 'Vista'}
  let g:vista_fzf_preview = ['right:50%']
  " function! NearestMethodOrFunction() abort
  "   return get(b:, 'vista_nearest_method_or_function', '')
  " endfunction
  "
  " set statusline+=%{NearestMethodOrFunction()}
  " let g:vista#renderer#enable_icon = 0
  "
  " " show the nearest function in your statusline automatically,
  " autocmd VimEnter *.c call vista#RunForNearestMethodOrFunction()
  " autocmd VimEnter *.h call vista#RunForNearestMethodOrFunction()
  " autocmd VimEnter *.py call vista#RunForNearestMethodOrFunction()
  "
  " let g:lightline                  = {}
  " let g:lightline.colorscheme = 'ayu_dark'
  " let g:lightline.active = {'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified', 'method' ] ]}
  " let g:lightline.component_function = {
  "         \   'method': 'NearestMethodOrFunction'
  "         \ }

" speed up loading of large files
Plug 'mhinz/vim-hugefile', {'for': ['log', 'txt']}
  let g:hugefile_trigger_size = 150

" tree explorer plugin
" Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" molokai theme
if has('nvim')
    Plug 'tamelion/neovim-molokai'
else
    Plug 'tomasr/molokai'
endif
" Plug 'crusoexia/vim-monokai'
" Plug 'sickill/vim-monokai'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'erichdongubler/vim-sublime-monokai'

" Plug 'morhetz/gruvbox'
"
" Plug 'cocopon/iceberg.vim'
" Plug 'joshdick/onedark.vim'
" Plug 'arcticicestudio/nord-vim'

" syntax file to highlight various log files
Plug 'matesea/vim-log-syntax', {'for': ['log', 'txt']}

" Plug 'MTDL9/vim-log-highlighting', {'for': ['log', 'txt']}
"     au Syntax log syn keyword logLevelError fatal
    " au rc Syntax log syn keyword logLevelError \(FATAL\|ERROR\|ERRORS\|FAIL\|FAILED\|FAILURE\|assert\)
    " au rc Syntax log syn keyword logLevelWarning \(warn\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\)

" solarized colorscheme
Plug 'altercation/vim-colors-solarized', {'on': []}

" follow linux kernel coding style
Plug 'vivien/vim-linux-coding-style', {'for': ['c', 'h', 'S']}

" vim tmux seamless navigator
Plug 'christoomey/vim-tmux-navigator'

" undo history visualizer
Plug 'mbbill/undotree',     {'on': 'UndotreeToggle'}
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<cr>

" asynchronous completion framework
" if has('nvim')
"     Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
" else
"     Plug 'Shougo/deoplete.nvim'
"     Plug 'roxma/nvim-yarp'
"     Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:acp_enableAtStartup = 0
" let g:deoplete#enable_at_startup = 0
" " load deoplete when entering insert mode, reduce ~200ms in startup
" autocmd InsertEnter * call deoplete#enable()

" Plug 'lifepillar/vim-mucomplete'
"     let g:mucomplete#no_mappings = 1
"     set completeopt+=menuone,noinsert
"     set shortmess+=c
"     let g:mucomplete#enable_auto_at_startup = 1
" 	imap <c-j> <plug>(MUcompleteFwd)
" 	imap <c-k> <plug>(MUcompleteBwd)

" Plug 'maralla/completor.vim'
"     let g:completor_complete_options = 'menuone,noselect,preview'

" c/cpp enhanced highlight
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'h', 'S', 'cpp']}

" unobtrusive scratch window
" Plug 'mtth/scratch.vim', {'on': ['<plug>(scratch-insert-reuse)',
"    \'<plug>(scratch-insert-clear)',
"    \'<plug>(scratch-selection-reuse)',
"    \'<plug>(scratch-selection-clear)']}
"   let g:scratch_no_mappings = 1
"   nmap gs <plug>(scratch-insert-reuse)
"   nmap gS <plug>(scratch-insert-clear)
"   xmap gs <plug>(scratch-selection-reuse)
"   xmap gS <plug>(scratch-selection-clear)

" go to terminal or file manager
Plug 'justinmk/vim-gtfo'

" lightweight implementation of emacs's kill-ring for vim
" Plug 'maxbrunsfeld/vim-yankstack'
"   " TODO: try nvim-miniyank & vim-yoink
"   let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
"   let g:yankstack_map_keys = 0
"   nmap <c-p> <Plug>yankstack_substitute_older_paste
"   nmap <c-n> <Plug>yankstack_substitute_newer_paste

" comment stuff out
" Plug 'tpope/vim-commentary', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim']}

Plug 'tyru/caw.vim', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim', 'sh']}

Plug 'nathanaelkane/vim-indent-guides', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim']}
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_default_mapping = 0
    let g:indent_guides_tab_guides = 0
    let g:indent_guides_color_change_percent = 3
    let g:indent_guides_guide_size = 1
    let g:indent_guides_exclude_filetypes = [
      \ 'help', 'defx', 'denite', 'denite-filter', 'startify',
      \ 'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input',
      \ 'any-jump', 'gina-status', 'gina-commit', 'gina-log'
      \ ]

" t32 cmm script syntax
" Plug 'm42e/trace32-practice.vim'

" profile startuptime
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}
Plug 'dstein64/vim-startuptime', {'on': []}

" accelerate j/k movement
Plug 'rhysd/accelerated-jk'
    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)

" " Highlight cursor word
" Plug 'itchyny/vim-cursorword'
"     augroup user_plugin_cursorword
"         autocmd!
"         autocmd FileType defx,denite,fern,qf let b:cursorword = 0
"         autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif
"         autocmd InsertEnter * let b:cursorword = 0
"         autocmd InsertLeave * let b:cursorword = 1
"     augroup END

" disable hlsearch automatically when we done searching
Plug 'romainl/vim-cool'

Plug 'haya14busa/vim-asterisk'
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  let g:asterisk#keeppos = 1

Plug 'embear/vim-foldsearch', {'on': ['Fp', 'Fw', 'Fs']}
    let g:foldsearch_disable_mappings = 1
    " zE to remove all folding
    " zd to remove single folding

" Plug 'wellle/context.vim', {'for': ['c', 'h', 'S', 'cpp', 'python']}

Plug 'machakann/vim-sandwich'

" Plug 'pechorin/any-jump.vim', {'on': ['AnyJump', 'AnyJumpVisual']}
"     let g:any_jump_disable_default_keybindings = 1
" 	" Normal mode: Jump to definition under cursor
" 	nnoremap <silent> <leader>ii :AnyJump<CR>
" 	" Visual mode: jump to selected text in visual mode
" 	xnoremap <silent> <leader>ii :AnyJumpVisual<CR>
" 	" Normal mode: open previous opened file (after jump)
" 	nnoremap <silent> <leader>ib :AnyJumpBack<CR>
" 	" Normal mode: open last closed search window again
" 	nnoremap <silent> <leader>il :AnyJumpLastResults<CR>

Plug 'haya14busa/vim-edgemotion', {'on': ['<Plug>(edgemotion-j)', '<Plug>(edgemotion-k)']}
	map gj <Plug>(edgemotion-j)
	map gk <Plug>(edgemotion-k)
	xmap gj <Plug>(edgemotion-j)
	xmap gk <Plug>(edgemotion-k)

" defaults settings for eveyone
Plug 'tpope/vim-sensible'
    let g:loaded_matchit = 0    " skip loading matchit.vim

" filter buffer content in-place without modification
" Plug 'lambdalisue/fin.vim', {'on': 'Fin'}

Plug 'ngemily/vim-vp4', {'on': ['Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4']}

" make quickfix window better
" slow in startup & nvim-nightly required
" Plug 'kevinhwang91/nvim-bqf'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nanotee/zoxide.vim', {'on': ['Z', 'Zi', 'Lz', 'Lzi']}
