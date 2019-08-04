" text object
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'

" shows a git diff in the gutter and stages/undoes hunks
Plug 'airblade/vim-gitgutter'
" {{{
  let g:gitgutter_eager = 0
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
Plug 'joereynolds/gtags-scope'
" {{{
  if has("cscope")
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
      """"""""""""""""""""""""""""""
      " => gtags-cscope-vim plugin
      """"""""""""""""""""""""""""""
      nnoremap <leader>cl :GtagsCscope<cr>
  endif
" }}}

" better diff options for vim
Plug 'chrisbra/vim-diff-enhanced'

" toggle quickfix window
Plug 'drmingdrmer/vim-toggle-quickfix'
" {{{
  nmap qt <Plug>window:quickfix:toggle
  nmap lt <Plug>window:location:toggle
  " clear quickfix
  nmap qc :cexpr []<cr>
  " clear location list
  nmap lc :lexpr []<cr>
" }}}

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" a command-line fuzzy finder written in Go
Plug 'junegunn/fzf',    { 'do': './install --all' }
" things you can do with fzf and vim
Plug 'junegunn/fzf.vim'
" {{{
  nnoremap <leader>fe :FZF<cr>
  nnoremap <leader>fc :FZF %:h<cr>
  " git files
  " nnoremap <leader>fg :GFiles<cr>
  " open buffers
  nnoremap <leader>fb :Buffers<cr>
  " nnoremap <leader>fh :History<cr>
  " lines in loaded buffers
  nnoremap <leader>fa :Lines<cr>
  " lines in the current buffer
  nnoremap <leader>fl :BLines<cr>
  " tags of the current buffer
  nnoremap <leader>ft :BTags<cr>
  " rg search
  " TODO: to populate rg results into quickfix,
  " by default fzf.vim use alt-a/alt-d to select and deselect all
  " but alt doesn't work on neovim, change to ctrl-s/ctrl-d in vim.vim
  nnoremap <leader>rg     :Rg<space>
  nnoremap <leader>rgw    :Rg <c-r><c-w><cr>
  nnoremap <leader>rc     :Rc<space>
  nnoremap <leader>rcw    :Rc <c-r><c-w><cr>
" }}}

" Vim plugin for the Perl module / CLI script 'ack'
Plug 'mileszs/ack.vim',     { 'on': ['LAckAdd', 'LAck', 'Ack', 'AckAdd'] }
" {{{
  if executable('rg')
      let g:ackprg = "rg -S --vimgrep --no-heading --no-column"
      " Rc: grep the folder of current editing file
      command! -bang -nargs=* Rc  call fzf#vim#grep
          \('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
          \1, {'dir': expand('%:h:p')}, <bang>0)
      command! -complete=shellcmd -nargs=+ R
          \ call s:RunShellCommand("rg -S --vimgrep --no-heading --no-column ".<q-args>)
  elseif executable('ag')
      let g:ackprg = "ag --vimgrep"
      " Rc: grep the folder of current editing file
      command! -bang -nargs=* Rc  call fzf#vim#grep
          \('ag --noheading --nogroup --color --smart-case '.shellescape(<q-args>),
          \1, {'dir': expand('%:h:p')}, <bang>0)
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

" syntax file to highlight various log files
Plug 'dzeban/vim-log-syntax'

" vim motions on speed
Plug 'easymotion/vim-easymotion'
" {{{
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
  map gj <Plug>(easymotion-j)
  map gk <Plug>(easymotion-k)
" }}}

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

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
" {{{
  " let g:vista_fzf_preview = ['right:50%']
  nnoremap <leader>v  :Vista!!<cr>
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

" tree explorer plugin
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" {{{
  nmap <leader>nt :NERDTreeToggle<cr>
" }}}

" molokai theme
Plug 'tomasr/molokai'

" solarized colorscheme
" Plug 'altercation/vim-colors-solarized'

" defaults settings for eveyone
Plug 'tpope/vim-sensible'

" follow linux kernel coding style
Plug 'vivien/vim-linux-coding-style', { 'for': 'c' }

" vim tmux seamless navigator
Plug 'christoomey/vim-tmux-navigator'

" undo history visualizer
Plug 'mbbill/undotree',     { 'on': 'UndotreeToggle' }
" {{{
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<cr>
" }}}

" show search index
Plug 'google/vim-searchindex'

" asynchronous completion framework
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
elsei
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:acp_enableAtStartup = 0
let g:deoplete#enable_at_startup = 0
" load deoplete when entering insert mode, reduce ~200ms in startup
autocmd InsertEnter * call deoplete#enable()

" c/cpp enhanced highlight
Plug 'octol/vim-cpp-enhanced-highlight'

" unobtrusive scratch window
Plug 'mtth/scratch.vim'

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
