function! s:RunShellCommand(cmdline) abort
  enew
  setlocal buftype=nofile bufhidden=hide noswapfile
  call setline(1, 'cmd:  ' . a:cmdline)
  " call setline(2, 'Expanded to:  ' . a:cmdline)
  " call append(line('$'), substitute(getline(0), '.', '=', 'g'))
  silent execute '$read !'. a:cmdline
endfunction

function! s:RemoveEmptyLines() abort
    silent! execute ':%g/^[\ \t]*$/d'
endfunction
command! -range=% RemoveEmptyLines call <SID>RemoveEmptyLines()

" Returns visually selected text
function! s:get_selection(cmdtype) "{{{
	let temp = @s
	normal! gv"sy
	let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
	let @s = temp
endfunction "}}}

" Simple zoom toggle
function! s:zoom()
	if exists('t:zoomed')
		unlet t:zoomed
		wincmd =
	else
		let t:zoomed = { 'nr': bufnr('%') }
		vertical resize
		resize
		normal! ze
	endif
endfunction

function! s:window_empty_buffer()
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete '.l:current
	endif
endfunction

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>
" Delete buffer, leave blank window
nnoremap <silent> <c-w>x  :<C-u>call <SID>window_empty_buffer()<CR>
" toggle window zoom
nnoremap <silent> <c-w>z  :<C-u>call <SID>zoom()<CR>

" Rgd: grep inside folder of current editing file
command! -bang -nargs=* Rgd call fzf#vim#grep
    \('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
    \1, fzf#vim#with_preview({'dir': expand('%:h:p')}), <bang>0)

" Rgb: Rg and put the result into new buffer
command! -complete=shellcmd -nargs=+ Rgb
    \ call s:RunShellCommand("rg -S --vimgrep --no-heading --no-column ".<q-args>)

" WA to overwrite options overwritten by sensible.vim
" autocmd VimEnter * :set scrolloff=999
" autocmd VimEnter * :set history=2000

" LoadLSP: manaully load lsp plugins
function! s:LoadLSP() abort
	silent! execute 'Lazy load mason.nvim mason-lspconfig cmp-nvim-lsp nvim-lspconfig'
endfunction
command! -range=% LoadLSP call <SID>LoadLSP()


" inspired by gtfo.vim
" open virtual/horizontal tmux window and cd to the folder of current file
" only support tmux 1.6+
func! s:tmux_split(dir, opt) abort
	let l:dir = substitute(expand(a:dir, 1), '\\\\\+', '\', 'g')
	silent call system("tmux split-window " . a:opt . " -c '" . l:dir . "'")
endf

nnoremap <silent><leader>ts :<c-u>call <sid>tmux_split("%:p:h", "")<cr>
nnoremap <silent><leader>tv :<c-u>call <sid>tmux_split("%:p:h", "-h")<cr>
