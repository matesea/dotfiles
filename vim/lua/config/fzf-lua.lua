local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    -- plugin fzf.lua
    vim.api.nvim_set_keymap('n', '<space>/', "<cmd>FzfLua search_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>;', "<cmd>FzfLua command_history<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>a', "<cmd>FzfLua lines<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>b', "<cmd>FzfLua buffers<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>f', ":FzfLua<space>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>e', '<cmd>FzfLua files<cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>g', "<cmd>FzfLua live_grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>j', "<cmd>FzfLua jumps<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>r', "<cmd>FzfLua grep<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>t', "<cmd>FzfLua btags<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>w', "<cmd>FzfLua grep_cword<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<space>x', "<cmd>FzfLua oldfiles<cr>", {silent = true, noremap = true})
    vim.cmd[[nnoremap <space>c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>]]
    vim.cmd[[nnoremap <space>d :FzfLua grep cwd=<C-R>=expand("%:h")<cr><cr>]]

    local previewer = 'bat'
    if vim.fn.executable('bat') ~= 1 then
        previewer = 'builtin'
    end

    fzf_lua.setup({'max-perf',
        -- fzf_bin = 'sk',
        -- fzf_opts = { ["--no-separator"] = false},
        winopts = {
                preview = {default = previewer}
        },
        files = {previewer = false},
        global_color_icons  = false,
    })
end

return M
