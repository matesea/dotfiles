" LoadLSP: manaully load lsp plugins
function! s:LoadLSP() abort
	silent! execute 'Lazy load mason.nvim mason-lspconfig cmp-nvim-lsp nvim-lspconfig'
endfunction
command! -range=% LoadLSP call <SID>LoadLSP()
