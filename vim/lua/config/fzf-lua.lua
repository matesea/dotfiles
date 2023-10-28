local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    local previewer = 'bat'
    if vim.fn.executable('bat') ~= 1 then
        previewer = 'builtin'
    end

    local actions = require "fzf-lua.actions"
    fzf_lua.setup({
        'max-perf',
        -- 'default',
        -- fzf_bin = 'sk',
        -- fzf_opts = { ["--no-separator"] = false},
        winopts = {
                preview = {default = previewer}
        },
        actions = {
            files = {
                ["default"] = actions.file_edit, -- align with fzf.vim
                ["ctrl-s"] = actions.file_split,
                ["ctrl-v"] = actions.file_vsplit,
            },
            buffers = {
                ["default"] = actions.buf_edit, -- align with fzf.vim
                ["ctrl-s"] = actions.buf_split,
                ["ctrl-v"] = actions.buf_vsplit,
            },
        },
        files = {previewer = false},
        global_color_icons  = false,
    })
end

return M
