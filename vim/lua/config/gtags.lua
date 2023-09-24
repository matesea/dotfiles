local M = {}

function M.setup()

    vim.opt.csto = 0
    -- show msg when any other cscope db added
    vim.opt.cscopeverbose = true
    -- display result in quickfix
    vim.opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
    vim.opt.cscoperelative = true

    vim.api.nvim_set_keymap('n', '<leader>cf', ':cscope find<space>', {silent = false, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
end

return M
