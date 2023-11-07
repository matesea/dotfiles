local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    local previewer = 'builtin'
    --[[
    if vim.fn.executable('bat') == 1 then
        previewer = 'builtin'
    end
    ]]

    local actions = require "fzf-lua.actions"

    local fzf_lua_table = {
        'max-perf',
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
    }

    local fzf_tmux_opts = vim.env.FZF_TMUX_OPTS
    if fzf_tmux_opts ~= nil then
        -- FZF_TMUX_OPTS set, choose with fzf-tmux popup window
        fzf_lua_table.fzf_bin = 'fzf-tmux'
        fzf_lua_table.fzf_opts = {['--border'] = 'rounded'}
        fzf_lua_table.fzf_tmux_opts = {['-p'] = '80%,90%'}
        fzf_lua_table.winopts = {preview = {default = previewer, layout = 'horizontal'}}
    else -- max-perf profile
        fzf_lua_table['winopts'] = {preview = {default = previewer}}
    end
    fzf_lua.setup(fzf_lua_table)
end

return M
