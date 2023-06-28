local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    -- plugin fzf.lua
    vim.api.nvim_set_keymap('n', ';/', "<cmd>FzfLua search_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';:', "<cmd>FzfLua command_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';a', "<cmd>FzfLua lines<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';b', "<cmd>FzfLua buffers<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';f', ":FzfLua<space>", {noremap = true})
    vim.api.nvim_set_keymap('n', ';e', '<cmd>FzfLua files<cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';g', "<cmd>FzfLua live_grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';j', "<cmd>FzfLua jumps<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';r', "<cmd>FzfLua grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';t', "<cmd>FzfLua btags<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';w', "<cmd>FzfLua grep_cword<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', ';x', "<cmd>FzfLua oldfiles<cr>", {silent = true, noremap = true})
    vim.cmd[[nnoremap ;c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>]]
    vim.cmd[[nnoremap ;d :FzfLua grep cwd=<C-R>=expand("%:h")<cr><cr>]]

    local previewer = 'bat'
    if vim.fn.executable('bat') ~= 1 then
        previewer = 'builtin'
    end

    local actions = require "fzf-lua.actions"
    fzf_lua.setup({'max-perf',
        -- fzf_bin = 'sk',
        -- fzf_opts = { ["--no-separator"] = false},
        winopts = {
                preview = {default = previewer}
        },
        actions = {
            files = {
                ["default"] = actions.file_edit, -- align with fzf.vim
            },
        },
        files = {previewer = false},
        global_color_icons  = false,
    })
end

return M
