" text object
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'

" shows a git diff in the gutter and stages/undoes hunks
Plug 'airblade/vim-gitgutter'
    set updatetime=300
    nnoremap <silent> ]c :GitGutterNextHunk<cr>
    nnoremap <silent> [c :GitGutterPrevHunk<cr>

" git wrapper
Plug 'tpope/vim-fugitive', {'on': ['Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame']}

" git commit browser
Plug 'junegunn/gv.vim', {'on': ['GV']}

Plug 'junegunn/goyo.vim', {'on': 'Goyo'}

" buffer tabs
Plug 'ap/vim-buftabline'
    let g:buftabline_show = 1

" highlights trailing whitespace in red
Plug 'bronson/vim-trailing-whitespace'

" gtags-cscope
    " Plug 'joereynolds/gtags-scope'
    "   " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    "   set cscopetag
    "   " check cscope for definition of a symbol before checking ctags: set to 1
    "   " if you want the reverse search order.
    "   set csto=0
    "   " show msg when any other cscope db added
    "   set cscopeverbose
Plug 'jsfaint/gen_tags.vim', {'for': ['c', 'h', 'cpp', 'python']}
    if ! has("cscope") || ! executable('gtags')
        let g:loaded_gentags#gtags = 1
    endif
    if ! executable('ctags')
        let g:loaded_gentags#ctags = 1
    endif
    let g:gen_tags#gtags_default_map = 0
    nnoremap <leader>cf :cscope find<space>
    nnoremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>ca :cscope add<space>

" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
"     " enable gtags module
"     let g:gutentags_modules = ['ctags', 'gtags_cscope']

"     " config project root markers.
"     " let g:gutentags_project_root = ['.root']

"     " generate datebases in my cache directory, prevent gtags files polluting my project
"     " let g:gutentags_cache_dir = expand('~/.cache/tags')
"     " let g:gutentags_cache_dir = expand('~/.cache/tags_dir')

"     " change focus to quickfix window after search (optional).
"     let g:gutentags_plus_switch = 1

"     let g:gutentags_plus_nomap = 1
"     nnoremap <leader>cf :GscopeFind<space>
"     nnoremap <leader>cs :GscopeFind s <C-R>=expand("<cword>")<CR><CR>
"     nnoremap <leader>cg :GscopeFind g <C-R>=expand("<cword>")<CR><CR>
"     nnoremap <leader>cc :GscopeFind c <C-R>=expand("<cword>")<CR><CR>
"     nnoremap <leader>ca :GscopeFind a <C-R>=expand("<cword>")<CR><CR>
"     nnoremap <leader>cd :GscopeFind d <C-R>=expand("<cword>")<CR><CR>

" toggle quickfix window
Plug 'drmingdrmer/vim-toggle-quickfix', {'on': ['<Plug>window:quickfix:toggle', '<Plug>window:location:toggle']}
    nmap <leader>qt <Plug>window:quickfix:toggle
    nmap <leader>lt <Plug>window:location:toggle

" Pairs of handy bracket mappings
" Plug 'tpope/vim-unimpaired'

" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'
" "use default setting alt+p
" let g:AutoPairsShortcutToggle = '<leader>p'

" " a command-line fuzzy finder written in Go
Plug 'junegunn/fzf', {'do': './install --completion --key-bindings --xdg --no-update-rc' }
" manage imported github repositories
Plug 'atweiden/fzf-extras', {'on': []}
Plug 'skywind3000/z.lua', {'on': []}
" " things you can do with fzf and vim
Plug 'junegunn/fzf.vim'
    let g:fzf_layout = { 'down': '~25%' }
    nnoremap <leader>fe :FZF<cr>
    nnoremap <leader>fc :FZF %:h<cr>
    " git files
    " nnoremap <leader>fg :GFiles<cr>
    " open buffers
    nnoremap <leader>fg :Buffers<cr>
    " nnoremap <leader>fh :History<cr>
    " lines in loaded buffers
    nnoremap <leader>fa :Lines<cr>
    " lines in the current buffer
    nnoremap <leader>fl :BLines<cr>
    nnoremap <leader>fw :BLines <c-r><c-w><cr>
    " tags of the current buffer
    nnoremap <leader>ft :BTags<cr>
    " rg search
    " TODO: to populate rg results into quickfix,
    " by default fzf.vim use alt-a/alt-d to select and deselect all
    " but alt doesn't work on neovim, change to ctrl-s/ctrl-d in vim.vim
    nnoremap <leader>rg :Rg<space>
    nnoremap <leader>rw :Rg <c-r><c-w><cr>

if has('nvim')
    " disable python interpreter check in neovim startup
    let g:python3_host_skip_check = 1
    let g:python_host_skip_check = 1
    " TODO: set in ~/.local/vimrc
    " let g:python3_host_prog = '/opt/local/bin/python3'
    " let g:python_host_prog = '/opt/local/bin/python'
endif

if has("python3")
    " Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    "   " let g:Lf_CacheDirectory=$VIMDATA . '/LeaderF'
    "   " if !isdirectory(g:Lf_CacheDirectory)
    "   "     call mkdir(g:Lf_CacheDirectory, 'p')
    "   " endif
    "   " need git >= 2.11
    "   " let g:Lf_RecurseSubmodules = 1
    "   " by default leaderf will use commands like git ls-tree so some files will be missed
    "   " rg is even faster than fd
    "   if executable('rg')
    "       let g:Lf_DefaultExternalTool = 'rg'
    "       " let g:Lf_ExternalCommand = 'rg --no-messages --files %s'
    "   " elseif executable('fd')
    "   "     let g:Lf_ExternalCommand = 'fd --color=never -t f %s'
    "   endif
    "   let g:Lf_ShowDevIcons = 0
    "   let g:Lf_ShortcutF = '<leader>fe'
    "   let g:Lf_ShortcutB = '<leader>fb'
    "   let g:Lf_NoChdir = 1
    "   let g:Lf_ReverseOrder = 1
    "   let g:Lf_GtagsStoreInProject = 1
    "   if has('nvim-0.4.2')
    "       let g:Lf_WindowPosition = 'popup'
    "       let g:Lf_PreviewInPopup = 1
    "   endif
    "   " let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}

    "   " XX: LeaderfFile doesn't work when selecting multiple files
    "   " nnoremap <leader>fc       :<C-U><C-R>=printf("LeaderfFile %s ", expand("%:h"))<CR><CR>
    "   nnoremap <leader>fl       :LeaderfLine<cr>
    "   nnoremap <leader>fw       :LeaderfLineCword<cr>
    "   nnoremap <leader>ft       :LeaderfBufTag<cr>
    "   nnoremap <leader>ff       :LeaderfFunction<cr>

    "   " nnoremap <leader>fta      :LeaderfBufTagAll<cr>
    "   " nnoremap <leader>ffa      :LeaderfFunctionAll<cr>

    "   " option: --match-path to fuzzy the path
    "   nmap     <leader>rg       <Plug>LeaderfRgPrompt
    "   nnoremap <leader>rw       :<C-U><C-R>=printf("Leaderf rg -F -e %s ", expand("<cword>"))<CR><CR>
    "   nnoremap <leader>rc		:<C-U><C-R>=printf("Leaderf rg -F %s -e ", expand("%:h"))<CR><space>
    "   nnoremap <leader>rcw      :<C-U><C-R>=printf("Leaderf rg -F -e %s %s", expand("<cword>"), expand("%:h"))<CR><CR>

      " gtags
      " nnoremap <leader>gu       :Leaderf gtags --update<cr>
      " nnoremap <leader>gr       :Leaderf gtags --recall<cr>
      " cursor on definition => reference
      " on word has defined => definition
      " otherwise jump to symbol if any
      " nnoremap <leader>gb       :Leaderf gtags --by-context --auto-jump<cr>
      " -d: definition, -r: being called, -s: symbol, -g: grep
      " nnoremap <leader>gs       :Leaderf gtags --auto-jump -
      " go definition
      " nnoremap <leader>gg       :Leaderf gtags -d <c-r><c-w> --auto-jump<cr>
      " nmap <leader>gd           <Plug>LeaderfGtagsDefinition
      " go being called
      " nnoremap <leader>gc       :Leaderf gtags -r <c-r><c-w> --auto-jump<cr>
      " nmap <leader>gr           <Plug>LeaderfGtagsReference
      " nmap <leader>gs           <Plug>LeaderfGtagsSymbol
      " nmap <leader>gg           <Plug>LeaderfGtagsGrep

    " Track the engine.
    Plug 'SirVer/ultisnips', {'on': []}
        " Trigger configuration
        let g:UltiSnipsExpandTrigger = "<tab>"
        let g:UltiSnipsJumpForwardTrigger = "<c-b>"
        let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

        " Snippets are separated from the engine. Add this if you want them:
        Plug 'honza/vim-snippets', { 'on': [] }

    Plug 'ncm2/ncm2', {'on': []}
        Plug 'roxma/nvim-yarp', {'on': []}
        " NOTE: you need to install completion sources to get completions. Check
        " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
        Plug 'ncm2/ncm2-bufword', {'on': []}
        Plug 'ncm2/ncm2-path', {'on': []}
        Plug 'fgrsnau/ncm2-otherbuf', {'on': []}
        Plug 'ncm2/ncm2-gtags', {'on': []}

        function! s:load_insert(timer) abort
            call plug#load('ncm2')
            call plug#load('nvim-yarp')
            call plug#load('ncm2-bufword')
            call plug#load('ncm2-path')
            call plug#load('ncm2-otherbuf')
            call plug#load('ncm2-gtags')

            call plug#load('ultisnips')
            call plug#load('vim-snippets')

            " enable ncm2 for all buffers
            call ncm2#enable_for_buffer()

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
Plug 'mileszs/ack.vim',     { 'on': ['LAckAdd', 'LAck', 'Ack', 'AckAdd'] }
  if executable('rg')
      let g:ackprg = "rg -S --vimgrep --no-heading --no-column"
      " Rc: grep the folder of current editing file
      " command! -bang -nargs=* Rc  call fzf#vim#grep
      "     \('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
      "     \1, {'dir': expand('%:h:p')}, <bang>0)
      command! -complete=shellcmd -nargs=+ R
          \ call s:RunShellCommand("rg -S --vimgrep --no-heading --no-column ".<q-args>)
  elseif executable('ag')
      let g:ackprg = "ag --vimgrep"
      " Rc: grep the folder of current editing file
      " command! -bang -nargs=* Rc  call fzf#vim#grep
      "     \('ag --noheading --nogroup --color --smart-case '.shellescape(<q-args>),
      "     \1, {'dir': expand('%:h:p')}, <bang>0)
      command! -complete=shellcmd -nargs=+ R
          \ call s:RunShellCommand("ag --noheading --nogroup --nocolor --smart-case ".<q-args>)
  endif
  let g:ackhighlight = 1
  nnoremap <leader>aa     :LAckAdd!<space>
  nnoremap <leader>aw     :LAckAdd! <c-r><c-w><cr>
  nnoremap <leader>af     :LAckAdd!  %:p<left><left><left><left>
  nnoremap <leader>afw    :LAckAdd! <c-r><c-w> %:p<cr>
  nnoremap <leader>ad     :LAckAdd!  %:h<left><left><left><left>
  nnoremap <leader>adw    :LAckAdd! <c-r><c-w> %:h<cr>

" delete buffers and close files in vim without closing windows or messing up layout
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
  nnoremap <silent> bd :Bdelete!<cr>

" the missing motion for vim
" Plug 'justinmk/vim-sneak', {'on': ['<Plug>Sneak_s', '<Plug>Sneak_S']}
"     " 2-character Sneak (default)
"     nmap <leader>s <Plug>Sneak_s
"     nmap <leader>S <Plug>Sneak_S
"     " visual-mode
"     xmap <leader>s <Plug>Sneak_s
"     xmap <leader>S <Plug>Sneak_S
"     " operator-pending-mode
"     omap <leader>s <Plug>Sneak_s
"     omap <leader>S <Plug>Sneak_S
"     " repeat motion
"     map ; <Plug>Sneak_;
"     map , <Plug>Sneak_,

" Extended f, F, t and T key mappings for Vim
" Plug 'rhysd/clever-f.vim'
"   let g:clever_f_across_no_line = 1
"   let g:clever_f_smart_case = 1

Plug 'deris/vim-shot-f'

" mark: highlight several words in different colors simultaneously
Plug 'mihais/vim-mark', {'on': ['MarkLoad', 'Mark', 'MarkSave', '<Plug>MarkSet', '<Plug>MarkRegex']}
    let g:mwDefaultHighlightingPalette = 'maximum'
    let g:mwHistAdd = '/@'
    let g:mw_no_mappings = 1
    let g:mwAutoLoadMarks = 0
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

" A light and configurable statusline/tabline plugin for vim
Plug 'itchyny/lightline.vim'
    " Plug 'mengelbrecht/lightline-bufferline'
    " let g:lightline = {
    "            \ 'tabline': {
    "            \   'left': [['buffers']],
    "            \   'right': [['close']]
    "            \},
    "            \ 'component_expand': {
    "            \   'buffers': 'lightline#bufferline#buffers'
    "            \ },
    "            \ 'component_type': {
    "            \   'buffers': 'tabsel'
    "            \ }
    "\}
    " autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
"   let g:vista_fzf_preview = ['right:50%']
  " nnoremap <leader>v  :Vista!!<cr>
  " function! NearestMethodOrFunction() abort
  "   return get(b:, 'vista_nearest_method_or_function', '')
  " endfunction

  " set statusline+=%{NearestMethodOrFunction()}

  " " show the nearest function in your statusline automatically,
  " autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
  " let g:lightline = {
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'readonly', 'filename', 'modified', 'method' ] ]
  "       \ },
  "       \ 'component_function': {
  "       \   'method': 'NearestMethodOrFunction'
  "       \ },
  "       \ }

" speed up loading of large files
Plug 'mhinz/vim-hugefile', { 'for': ['log', 'txt'] }
  let g:hugefile_trigger_size = 150

" tree explorer plugin
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" molokai theme
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'

" syntax file to highlight various log files
Plug 'dzeban/vim-log-syntax', { 'for': ['log', 'txt'] }

" solarized colorscheme
Plug 'altercation/vim-colors-solarized', {'on': []}

" defaults settings for eveyone
Plug 'tpope/vim-sensible'

" follow linux kernel coding style
Plug 'vivien/vim-linux-coding-style', { 'for': ['c', 'h', 'S'] }

" vim tmux seamless navigator
Plug 'christoomey/vim-tmux-navigator'

" undo history visualizer
Plug 'mbbill/undotree',     { 'on': 'UndotreeToggle' }
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<cr>

" asynchronous completion framework
" if has('nvim')
"     Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
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
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'h', 'S', 'cpp'] }

" unobtrusive scratch window
Plug 'mtth/scratch.vim', { 'on': ['<plug>(scratch-insert-reuse)',
    \'<plug>(scratch-insert-clear)',
    \'<plug>(scratch-selection-reuse)',
    \'<plug>(scratch-selection-clear)']}
  let g:scratch_no_mappings = 1
  nmap gs <plug>(scratch-insert-reuse)
  nmap gS <plug>(scratch-insert-clear)
  xmap gs <plug>(scratch-selection-reuse)
  xmap gS <plug>(scratch-selection-clear)

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

Plug 'tyru/caw.vim', {'for': ['c', 'h', 'S', 'cpp', 'python', 'vim']}

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
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'dstein64/vim-startuptime', { 'on': [] }

" accelerate j/k movement
Plug 'rhysd/accelerated-jk'
    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)

" Highlight cursor word
Plug 'itchyny/vim-cursorword'
    augroup user_plugin_cursorword
        autocmd!
        autocmd FileType defx,denite,fern,qf let b:cursorword = 0
        autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif
        autocmd InsertEnter * let b:cursorword = 0
        autocmd InsertLeave * let b:cursorword = 1
    augroup END

" disable hlsearch automatically when we done searching
Plug 'romainl/vim-cool'

Plug 'haya14busa/vim-asterisk', {'on': ['<Plug>(asterisk-*)', '<Plug>(asterisk-#)',
            \'<Plug>(asterisk-g*)', '<Plug>(asterisk-g#)', '<Plug>(asterisk-z*)',
            \'<Plug>(asterisk-gz*)', '<Plug>(asterisk-z#)']}
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)

Plug 'embear/vim-foldsearch', {'on': ['Fp', 'Fw', 'Fs'] }
    let g:foldsearch_disable_mappings = 1
    " zE to remove all folding
    " zd to remove single folding

Plug 'wellle/context.vim', {'for': ['c', 'h', 'S', 'cpp', 'python']}

Plug 'machakann/vim-sandwich'

Plug 'pechorin/any-jump.vim', {'on': ['AnyJump', 'AnyJumpVisual']}
    let g:any_jump_disable_default_keybindings = 1
	" Normal mode: Jump to definition under cursor
	nnoremap <silent> <leader>ii :AnyJump<CR>
	" Visual mode: jump to selected text in visual mode
	xnoremap <silent> <leader>ii :AnyJumpVisual<CR>
	" Normal mode: open previous opened file (after jump)
	nnoremap <silent> <leader>ib :AnyJumpBack<CR>
	" Normal mode: open last closed search window again
	nnoremap <silent> <leader>il :AnyJumpLastResults<CR>

Plug 'haya14busa/vim-edgemotion', {'on': ['<Plug>(edgemotion-j)', '<Plug>(edgemotion-k)']}
	map gj <Plug>(edgemotion-j)
	map gk <Plug>(edgemotion-k)
	xmap gj <Plug>(edgemotion-j)
	xmap gk <Plug>(edgemotion-k)
