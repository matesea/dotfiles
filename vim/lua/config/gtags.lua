local M = {}

function M.setup()
    vim.api.nvim_set_keymap('n', '<leader>cf', ':cscope find<space>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
end

return M
