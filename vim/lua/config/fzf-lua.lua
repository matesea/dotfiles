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
            file_icons = false,
            git_icons = false,
        },
        actions = {
            -- Below are the default actions, setting any value in these tables will override
          -- the defaults, to inherit from the defaults change [1] from `false` to `true`
          files = {
            true,        -- uncomment to inherit all the below in your custom config
            -- Pickers inheriting these actions:
            --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
            --   tags, btags, args, buffers, tabs, lines, blines
            -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
            -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
            -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
            ["enter"]       = FzfLua.actions.file_edit,
            ["ctrl-s"]      = FzfLua.actions.file_split,
            ["ctrl-v"]      = FzfLua.actions.file_vsplit,
            ["ctrl-t"]      = FzfLua.actions.file_tabedit,
            ["alt-q"]       = FzfLua.actions.file_sel_to_qf,
            ["alt-Q"]       = FzfLua.actions.file_sel_to_ll,
            ["alt-i"]       = FzfLua.actions.toggle_ignore,
            ["alt-h"]       = FzfLua.actions.toggle_hidden,
            ["alt-f"]       = FzfLua.actions.toggle_follow,
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
            width = 0.95,
            height = 0.95,
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
