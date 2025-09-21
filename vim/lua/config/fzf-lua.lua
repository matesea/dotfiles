local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    local previewer = 'builtin'

    local actions = require "fzf-lua.actions"

    local fzf_lua_table = {
        'max-perf',
        defaults = {
            color_icons = false,
        },
        actions = {
            files = {
                true,
                ["default"] = actions.file_edit, -- align with fzf.vim
                ["ctrl-s"] = actions.file_split,
                ["ctrl-v"] = actions.file_vsplit,
                ["ctrl-i"] = actions.toggle_ignore,
                ["ctrl-h"] = actions.toggle_hidden,
                ["ctrl-f"] = actions.toggle_follow,
            },
            buffers = {
                ["default"] = actions.buf_edit, -- align with fzf.vim
                ["ctrl-s"] = actions.buf_split,
                ["ctrl-v"] = actions.buf_vsplit,
            },
        },
        files = {
            previewer = false,
        },
        oldfiles = {
            include_current_session = true,
        },
        previewers = {
          builtin = {
            -- fzf-lua is very fast, but it really struggled to preview a couple files
            -- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
            -- It turns out it was Treesitter having trouble parsing the files.
            -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
            -- (Yes, I know you shouldn't have 100KB minified files in source control.)
            syntax_limit_b = 1024 * 100, -- 100KB
          },
        },
        grep = {
          -- One thing I missed from Telescope was the ability to live_grep and the
          -- run a filter on the filenames.
          -- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
          -- With this change, I can sort of get the same behaviour in live_grep.
          -- ex: > enable --*/plugins/*
          -- I still find this a bit cumbersome. There's probably a better way of doing this.
          rg_glob = true, -- enable glob parsing
          glob_flag = "--iglob", -- case insensitive globs
          glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        },
        winopts = {
            preview = {
                default = previewer,
                layout = 'vertical',
                vertical = 'down:45%'
            }
        }
    }

    local fzf_tmux_opts = vim.env.FZF_TMUX_OPTS
    if fzf_tmux_opts ~= nil then
        -- FZF_TMUX_OPTS set, choose with fzf-tmux popup window
        if vim.fn.executable('bat') == 1 then
            previewer = 'bat'
        end
        fzf_lua_table.fzf_bin = 'fzf-tmux'
        fzf_lua_table.fzf_opts = {['--border'] = 'rounded'}
        fzf_lua_table.fzf_tmux_opts = {['-p'] = '80%,90%'}
        fzf_lua_table.winopts = {
            preview = {
                default = previewer,
                layout = 'vertical',
                vertical = 'down:45%'
            }
        }
    end
    fzf_lua.setup(fzf_lua_table)
end

return M
