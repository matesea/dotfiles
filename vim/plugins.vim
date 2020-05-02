" text object
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'

" shows a git diff in the gutter and stages/undoes hunks
Plug 'airblade/vim-gitgutter'
" {{{
  set updatetime=300
  nnoremap <silent> ]c :GitGutterNextHunk<cr>
  nnoremap <silent> [c :GitGutterPrevHunk<cr>
" }}}

" git wrapper
Plug 'tpope/vim-fugitive'

" git commit browser
Plug 'junegunn/gv.vim'

" buffer tabs
Plug 'ap/vim-buftabline'
" {{{
  let g:buftabline_show = 1
" }}}

" highlights trailing whitespace in red
Plug 'bronson/vim-trailing-whitespace'

" gtags-cscope
if has("cscope")
    Plug 'joereynolds/gtags-scope'
    " {{{
      " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
      set cscopetag
      " check cscope for definition of a symbol before checking ctags: set to 1
      " if you want the reverse search order.
      set csto=0
      " show msg when any other cscope db added
      set cscopeverbose
      nnoremap <leader>cf :cscope find<space>
      nnoremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
      nnoremap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
      nnoremap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
      nnoremap <leader>ca :cscope add<space>
    " }}}
endif

" better diff options for vim
" Plug 'chrisbra/vim-diff-enhanced'
" {{{
  " started In Diff-Mode set diffexpr (plugin not loaded yet)
"   if &diff
"       let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
"   endif
" }}}

" toggle quickfix window
Plug 'drmingdrmer/vim-toggle-quickfix'
" {{{
  nmap qt <Plug>window:quickfix:toggle
  nmap lt <Plug>window:location:toggle
  " clear quickfix
  nnoremap qc :cexpr []<cr>
  " clear location list
  nnoremap lc :lexpr []<cr>
" }}}

" Pairs of handy bracket mappings
" Plug 'tpope/vim-unimpaired'

" insert or delete brackets, parens, quotes in pair
" Plug 'jiangmiao/auto-pairs'
" {{{
" "use default setting alt+p
" let g:AutoPairsShortcutToggle = '<leader>p'
" }}}

" " a command-line fuzzy finder written in Go
Plug 'junegunn/fzf',    { 'on': ['FZF', 'Buffers'], 'do': './install --completion --key-bindings --xdg --no-update-rc' }
" manage imported github repositories
Plug 'atweiden/fzf-extras', {'on': []}
Plug 'skywind3000/z.lua', {'on': []}
" " things you can do with fzf and vim
 Plug 'junegunn/fzf.vim', { 'on': ['FZF', 'Buffers'] }
" " {{{
   nnoremap <leader>fr :FZF<cr>
   nnoremap <leader>fv :FZF %:h<cr>
"   " git files
"   " nnoremap <leader>fg :GFiles<cr>
"   " open buffers
   nnoremap <leader>fg :Buffers<cr>
"   " nnoremap <leader>fh :History<cr>
"   " lines in loaded buffers
"   nnoremap <leader>fa :Lines<cr>
"   " lines in the current buffer
"   nnoremap <leader>fl :BLines<cr>
"   " tags of the current buffer
"   nnoremap <leader>ft :BTags<cr>
"   " rg search
"   " TODO: to populate rg results into quickfix,
"   " by default fzf.vim use alt-a/alt-d to select and deselect all
"   " but alt doesn't work on neovim, change to ctrl-s/ctrl-d in vim.vim
"   nnoremap <leader>rg     :Rg<space>
"   nnoremap <leader>rgw    :Rg <c-r><c-w><cr>
"   nnoremap <leader>rc     :Rc<space>
"   nnoremap <leader>rcw    :Rc <c-r><c-w><cr>
" " }}}

if has('nvim')
    " disable python interpreter check in neovim startup
    let g:python3_host_skip_check = 1
    let g:python_host_skip_check = 1
    " TODO: set in ~/.local/vimrc
    " let g:python3_host_prog = '/opt/local/bin/python3'
    " let g:python_host_prog = '/opt/local/bin/python'
endif

if has("python3") || has("python")
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    " {{{
      " let g:Lf_CacheDirectory=$VIMDATA . '/LeaderF'
      " if !isdirectory(g:Lf_CacheDirectory)
      "     call mkdir(g:Lf_CacheDirectory, 'p')
      " endif
      " need git >= 2.11
      " let g:Lf_RecurseSubmodules = 1
      " by default leaderf will use commands like git ls-tree so some files will be missed
      " rg is even faster than fd
      if executable('rg')
          let g:Lf_DefaultExternalTool = 'rg'
          " let g:Lf_ExternalCommand = 'rg --no-messages --files %s'
      " elseif executable('fd')
      "     let g:Lf_ExternalCommand = 'fd --color=never -t f %s'
      endif
      let g:Lf_ShortcutF = '<leader>fe'
      let g:Lf_ShortcutB = '<leader>fb'
      let g:Lf_NoChdir = 1
      let g:Lf_ReverseOrder = 1
      let g:Lf_GtagsStoreInProject = 1
      if has('nvim-0.4.2')
          let g:Lf_WindowPosition = 'popup'
          let g:Lf_PreviewInPopup = 1
      endif
      " let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}

      nnoremap <leader>fc       :<C-U><C-R>=printf("LeaderfFile %s ", expand("%:h"))<CR><CR>
      nnoremap <leader>fl       :LeaderfLine<cr>
      nnoremap <leader>fw       :LeaderfLineCword<cr>
      nnoremap <leader>ft       :LeaderfBufTag<cr>
      nnoremap <leader>ff       :LeaderfFunction<cr>

      " nnoremap <leader>fta      :LeaderfBufTagAll<cr>
      " nnoremap <leader>ffa      :LeaderfFunctionAll<cr>

      " option: --match-path to fuzzy the path
      nmap     <leader>rg       <Plug>LeaderfRgPrompt
      nnoremap <leader>rw       :<C-U><C-R>=printf("Leaderf rg -F -e %s ", expand("<cword>"))<CR><CR>
      nnoremap <leader>rc		:<C-U><C-R>=printf("Leaderf rg -F %s -e ", expand("%:h"))<CR><space>
      nnoremap <leader>rcw      :<C-U><C-R>=printf("Leaderf rg -F -e %s %s", expand("<cword>"), expand("%:h"))<CR><CR>

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
      nmap <leader>gd           <Plug>LeaderfGtagsDefinition
      " go being called
      " nnoremap <leader>gc       :Leaderf gtags -r <c-r><c-w> --auto-jump<cr>
      nmap <leader>gr           <Plug>LeaderfGtagsReference
      nmap <leader>gs           <Plug>LeaderfGtagsSymbol
      nmap <leader>gg           <Plug>LeaderfGtagsGrep
    " }}}

    " Track the engine.
    " Plug 'SirVer/ultisnips', { 'on': [] }
    " " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    " let g:UltiSnipsExpandTrigger = "<tab>"
    " let g:UltiSnipsJumpForwardTrigger = "<c-b>"
    " let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

    " {{{
    " Snippets are separated from the engine. Add this if you want them:
      Plug 'honza/vim-snippets', { 'on': [] }
      autocmd InsertEnter * call plug#load('vim-snippets')
    " }}}
endif

" Vim plugin for the Perl module / CLI script 'ack'
Plug 'mileszs/ack.vim',     { 'on': ['LAckAdd', 'LAck', 'Ack', 'AckAdd'] }
" {{{
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
" }}}

" delete buffers and close files in vim without closing windows or messing up layout
Plug 'moll/vim-bbye'
" {{{
  nnoremap bd :Bdelete!<cr>
  nnoremap bw :Bwipeout!<cr>
" }}}

" vim motions on speed
" Plug 'easymotion/vim-easymotion'
" " {{{
"   " let g:EasyMotion_leader_key = ',,'
"   let g:EasyMotion_do_mapping = 0
"   " Jump to anywhere you want with minimal keystrokes, with just one key binding.
"   " `s{char}{label}`
"   nmap s <Plug>(easymotion-overwin-f)
"   " `s{char}{char}{label}`
"   " Need one more keystroke, but on average, it may be more comfortable.
"   nmap ss <Plug>(easymotion-overwin-f2)
"   " Turn on case-insensitive feature
"   let g:EasyMotion_smartcase = 1
"   " JK motions: Line motions
"   map gj <Plug>(easymotion-j)
"   map gk <Plug>(easymotion-k)
" " }}}

" the missing motion for vim
Plug 'justinmk/vim-sneak'

" Extended f, F, t and T key mappings for Vim
Plug 'rhysd/clever-f.vim'
" {{{
  let g:clever_f_across_no_line = 1
  let g:clever_f_smart_case = 1
" }}}

" mark: highlight several words in different colors simultaneously
Plug 'mihais/vim-mark'
" {{{
  nmap <leader>M <Plug>MarkToggle
  nmap <leader>N <Plug>MarkAllClear
" }}}

" reopen files at the last edit position
Plug 'farmergreg/vim-lastplace'

" A light and configurable statusline/tabline plugin for vim
Plug 'itchyny/lightline.vim'
" {{{
"  let g:lightline = {
"        \ 'colorscheme': 'molokai',
"        \ }
" }}}

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
" {{{
  " let g:vista_fzf_preview = ['right:50%']
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
" }}}

" speed up loading of large files
Plug 'mhinz/vim-hugefile'
" {{{
  let g:hugefile_trigger_size = 15
" }}}

" tree explorer plugin
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" molokai theme
Plug 'tomasr/molokai'

" syntax file to highlight various log files
Plug 'dzeban/vim-log-syntax', { 'for': ['log', 'txt'] }

" solarized colorscheme
" Plug 'altercation/vim-colors-solarized'

" defaults settings for eveyone
Plug 'tpope/vim-sensible'

" follow linux kernel coding style
Plug 'vivien/vim-linux-coding-style', { 'for': ['c', 'h', 'S'] }

" vim tmux seamless navigator
" Plug 'christoomey/vim-tmux-navigator'

" undo history visualizer
Plug 'mbbill/undotree',     { 'on': 'UndotreeToggle' }
" {{{
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<cr>
" }}}

" show search index
Plug 'google/vim-searchindex'

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

Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }}
" {{{
" don't give |ins-completion-menu| messages.c
  set shortmess+=c
  " always show signcolumns
  set signcolumn=yes

  " https://zhuanlan.zhihu.com/p/76033635
  " CocInstall: coc-ultisnips, coc-yank, coc-tabnine, coc-ccls
  "     "coc.source.around.enable": false,
  "     "coc.source.buffer.enable": false,

  " start coc 500ms after start vim
  let g:coc_start_at_startup = 0
  function! CocTimerStart(timer)
      exec "CocStart"
  endfunction
  autocmd InsertEnter * call timer_start(50, 'CocTimerStart', { 'repeat': 1 })

  " load coc in insert mode
  " augroup load_coc
  "     autocmd!
  "     autocmd InsertEnter * call plug#load('coc.nvim')
  "       \| autocmd! load_coc
  " augroup END

  " for coc-snippets, use tab to trigger
  " inoremap <silent><expr> <TAB>
  "   \ pumvisible() ? coc#_select_confirm() :
  "   \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  "   \ <SID>check_back_space() ? "\<TAB>" :
  "   \ coc#refresh()

  " function! s:check_back_space() abort
  "   let col = col('.') - 1
  "   return !col || getline('.')[col - 1]  =~# '\s'
  " endfunction
  " let g:coc_snippet_next = '<tab>'

  " Use <C-l> for trigger snippet expand.
  imap <C-l> <Plug>(coc-snippets-expand)
  " Use <C-j> for both expand and jump (make expand higher priority.)
  imap <C-j> <Plug>(coc-snippets-expand-jump)

  " forbit coc for file > 0.5MB
  let g:trigger_size = 0.5 * 1048576
  augroup hugefile
    autocmd!
    autocmd BufReadPre *
          \ let size = getfsize(expand('<afile>')) |
          \ if (size > g:trigger_size) || (size == -2) |
          \   echohl WarningMsg | echomsg 'WARNING: altering options for this huge file!' | echohl None |
          \   exec 'CocDisable' |
          \ else |
          \   exec 'CocEnable' |
          \ endif |
          \ unlet size
  augroup END
" }}}

" c/cpp enhanced highlight
Plug 'octol/vim-cpp-enhanced-highlight'

" unobtrusive scratch window
Plug 'mtth/scratch.vim', { 'on': ['<plug>(scratch-insert-reuse)',
    \'<plug>(scratch-insert-clear)',
    \'<plug>(scratch-selection-reuse)',
    \'<plug>(scratch-selection-clear)']}
" {{{
  let g:scratch_no_mappings = 1
  nmap gs <plug>(scratch-insert-reuse)
  nmap gS <plug>(scratch-insert-clear)
  xmap gs <plug>(scratch-selection-reuse)
  xmap gS <plug>(scratch-selection-clear)
" }}}

" go to terminal or file manager
Plug 'justinmk/vim-gtfo'

" lightweight implementation of emacs's kill-ring for vim
Plug 'maxbrunsfeld/vim-yankstack'
" {{{
  " TODO: try nvim-miniyank & vim-yoink
  let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
  let g:yankstack_map_keys = 0
  nmap <c-p> <Plug>yankstack_substitute_older_paste
  nmap <c-n> <Plug>yankstack_substitute_newer_paste
" }}}

" comment stuff out
Plug 'tpope/vim-commentary'

" Start a * or # search from a visual block
Plug 'nelstrom/vim-visual-star-search'

" t32 cmm script syntax
" Plug 'm42e/trace32-practice.vim'

" profile startuptime
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
