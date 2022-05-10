
local M = {}

function M.setup()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
        return
    end
    telescope.load_extension('fzf')
    vim.api.nvim_set_keymap('n', '<space>e', '<cmd>Telescope find_files<cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>g', '<cmd>Telescope live_grep<cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>b', '<cmd>Telescope buffers<cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>h', '<cmd>Telescope command_history<cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>a', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {noremap = true})
    vim.cmd[[
        autocmd FileType TelescopePrompt call ncm2#disable_for_buffer()
        ]]
end

return M
