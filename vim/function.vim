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
