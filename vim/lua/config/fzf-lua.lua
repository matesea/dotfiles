local M = {}

function M.setup(prefix)
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    -- plugin fzf.lua
    vim.api.nvim_set_keymap('n', prefix .. '/', "<cmd>FzfLua search_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. ':', "<cmd>FzfLua command_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'a', "<cmd>FzfLua lines<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'b', "<cmd>FzfLua buffers<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'f', ":FzfLua<space>", {noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'e', '<cmd>FzfLua files<cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'g', "<cmd>FzfLua live_grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'j', "<cmd>FzfLua jumps<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'r', "<cmd>FzfLua grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 't', "<cmd>FzfLua btags<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'w', "<cmd>FzfLua grep_cword<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', prefix .. 'x', "<cmd>FzfLua oldfiles<cr>", {silent = true, noremap = true})
    vim.cmd('nnoremap ' .. prefix .. 'c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>')
    vim.cmd('nnoremap ' .. prefix .. 'd :FzfLua grep cwd=<C-R>=expand("%:h")<cr><cr>')

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
