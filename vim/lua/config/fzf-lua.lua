local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    -- plugin fzf.lua
    vim.api.nvim_set_keymap('n', '<space>/', "<cmd>FzfLua search_history<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>;', "<cmd>FzfLua command_history<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>a', "<cmd>FzfLua lines<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>b', "<cmd>FzfLua buffers<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>e', '<cmd>FzfLua files<cr>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>g', "<cmd>FzfLua live_grep<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>j', "<cmd>FzfLua jumps<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>w', "<cmd>FzfLua grep_cword<cr>", {noremap = true})
    vim.api.nvim_set_keymap('n', '<space>x', "<cmd>FzfLua oldfiles<cr>", {noremap = true})
    vim.cmd[[nnoremap <space>c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>]]

    fzf_lua.setup{
        files = {
            cmd = 'ff',
            git_icons = false,
            file_icons = false,
            color_icons = false,
            previewer = false,
        },
        git = {
            files = {
                git_icons = false,
                file_icons = false,
                color_icons = false,
                previewer = false,
            },
            status = {
                git_icons = false,
                file_icons = false,
                color_icons = false,
            },
        },
        grep = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        buffers = {
            file_icons = false,
            color_icons = false,
        },
        tabs = {
            file_icons = false,
            color_icons = false,
        },
        tags = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        btags = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        quickfix = {
            git_icons = false,
            file_icons = false,
        },
    }
end

return M
