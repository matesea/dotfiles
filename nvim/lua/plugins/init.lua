local function lazy_init()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

-- workaround: nvim-yarp autoload vimscript not loaded
-- cmd [[packadd nvim-yarp]]

local ft_code = { "c", "h", "S", "cpp", "python", "vim", "sh", "lua", "java" }
local has_git = vim.fn.executable("git") == 1

local bigfile = function(bufnr)
    local max_filesize = 3 * 1024 * 1024 -- 3MB
    local check_stats = vim.loop.fs_stat
    local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
        return true
    else
        return false
    end
end

local bigfile_current_buf = function()
    -- return true if current buffer is bigfile
    return bigfile(vim.api.nvim_get_current_buf())
end

-- Terminal Mappings
local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
            vim.cmd.wincmd(dir)
        end)
    end
end

local disabled_plugins = {
    -- jk to escape
    {
        "max397574/better-escape.nvim",
        enabled = false,
        opts = {
            default_mappings = false,
            mappings = {
                i = { j = { k = "<esc>" } },
                v = { j = { k = "<esc>" } },
            },
        },
    },

    {
        "coder/claudecode.nvim",
        enabled = false,
        cond = vim.fn.executable("claude") == 1,
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal = {
                snacks_win_opts = {
                    position = "bottom",
                    height = 0.4,
                    width = 1.0,
                    border = "single",

                    -- position = "float",
                    -- height = 0.85,
                    -- width = 0.85,
                },
            },
        },
        -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
        -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
        -- spec defers loading until a <leader>a* mapping is pressed and the commands
        -- would not exist yet.
        cmd = {
            "ClaudeCode",
            "ClaudeCodeFocus",
            "ClaudeCodeSelectModel",
            "ClaudeCodeAdd",
            "ClaudeCodeSend",
            "ClaudeCodeTreeAdd",
            "ClaudeCodeStatus",
            "ClaudeCodeStart",
            "ClaudeCodeStop",
            "ClaudeCodeOpen",
            "ClaudeCodeClose",
            "ClaudeCodeDiffAccept",
            "ClaudeCodeDiffDeny",
            "ClaudeCodeCloseAllDiffs",
        },
        keys = {
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
            --[[
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
			},
            ]]
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny diff" },
        },
    },

    {
        "AxelGard/oneokai.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("oneokai").load()
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- frappe/macchiato/mocha
                term_colors = true,
                dim_inactive = {
                    enabled = false,   -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "moon",
                cache = true,
                dim_inactive = true,
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        config = function()
            local kanagawa = require("kanagawa")
            kanagawa.setup({
                compile = true,     -- enable compiling the colorscheme
                dimInactive = true, -- dim inactive window `:h hl-NormalNC`
            })
            kanagawa.load("dragon")
        end,
    },
}

local plugins = {
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.sonokai_style = "default"
            vim.g.sonokai_better_performance = 1
            -- vim.g.sonokai_transparent_background = 1
            vim.g.sonokai_dim_inactive_windows = 1
            vim.cmd.colorscheme("sonokai")
        end,
    },

    {
        "tpope/vim-fugitive",
        lazy = true,
        cond = has_git,
        cmd = { "Git", "GV", "Gcd" },
    },

    { "junegunn/gv.vim", dependencies = { "tpope/vim-fugitive" }, cmd = "GV" },

    {
        "lewis6991/gitsigns.nvim",
        -- version = 'release',
        cond = has_git,
        keys = {
            { "]c", remap = true, desc = "Next Hunk" },
            { "[c", remap = true, desc = "Previous Hunk" },
            {
                "<leader>hr",
                function()
                    package.loaded.gitsigns.reset_hunk()
                end,
                desc = "Reset Hunk",
            },
            {
                "<leader>hb",
                function()
                    package.loaded.gitsigns.blame_line({ full = true })
                end,
                desc = "Blame Line",
            },
        },
        config = function()
            require("gitsigns").setup({
                max_file_length = 20000,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    -- Actions
                    -- map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
                    -- map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
                    -- map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
                    -- map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
                    -- map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
                    -- map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
                    -- map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
                    -- map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
                    -- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
                    -- map('n', '<leader>tb', gs.toggle_current_line_blame)
                    map("n", "<leader>hd", gs.diffthis)
                    -- map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
                    map("n", "<leader>td", gs.toggle_deleted)
                    -- -- Text object
                    -- map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                    -- map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end,
            })
            vim.opt.updatetime = 300
        end,
    },

    -- disable search highlighting when search is done
    { "romainl/vim-cool" },

    {
        'sphamba/smear-cursor.nvim',
        event = 'VeryLazy',
        opts = {
            hide_target_hack = true,
            cursor_color = 'none'
        }
    },

    {
        "nvim-mini/mini.nvim",
        lazy = false,
        config = function()
            local miniclue = require("mini.clue")
            require("mini.tabline").setup({ show_icons = false })
            require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
            -- require('mini.animate').setup()
            require("mini.clue").setup({
                clues = {
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },
                    { mode = "n", keys = "<LocalLeader>" },
                    { mode = "x", keys = "<LocalLeader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },

                    -- `s` key
                    { mode = "n", keys = "s" },
                },
            })

            -- enable these modules only if filetype matches
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("code_edit", { clear = true }),
                pattern = ft_code,
                once = true,
                callback = function(event)
                    require("mini.trailspace").setup({ only_in_normal_buffers = true })

                    -- Better Around/Inside textobjects
                    --
                    -- Examples:
                    --  - va)  - [V]isually select [A]round [)]paren
                    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
                    --  - ci'  - [C]hange [I]nside [']quote
                    require("mini.ai").setup({ n_lines = 500 })

                    -- Add/delete/replace surroundings (brackets, quotes, etc.)
                    --
                    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
                    -- - sd'   - [S]urround [D]elete [']quotes
                    -- - sr)'  - [S]urround [R]eplace [)] [']
                    require("mini.surround").setup({
                        mappings = {
                            add = "sa",             -- Add surrounding in Normal and Visual modes
                            delete = "ds",          -- Delete surrounding
                            find = "gzf",           -- Find surrounding (to the right)
                            find_left = "gzF",      -- Find surrounding (to the left)
                            highlight = "gzh",      -- Highlight surrounding
                            replace = "cs",         -- Replace surrounding
                            update_n_lines = "gzn", -- Update `n_lines`
                        },
                    })

                    require("mini.pairs").setup()
                    require("mini.align").setup({
                        mappings = {
                            start = "gb",
                            start_with_preview = "gB",
                        },
                    })

                    -- manually load nvim-ts-context-commentstring
                    require("lazy").load({ plugins = { "nvim-ts-context-commentstring" } })
                    require("mini.comment").setup({
                        options = {
                            custom_commentstring = function()
                                return require("ts_context_commentstring.internal").calculate_commentstring()
                                    or vim.bo.commentstring
                            end,
                        },
                    })
                end,
            })
        end,
    },

    {
        "stevearc/quicker.nvim",
        ft = "qf",
        event = "QuickFixCmdPost",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {
            edit = {
                enabled = true,
                autosave = false,
            },
            highlight = {
                lsp = false,
                load_buffers = false,
            },
            -- stylua: ignore
            keys = {
                {
                    '>',
                    function()
                        require('quicker').expand({
                            before = 2,
                            after = 2,
                            add_to_existing = true
                        })
                    end,
                    desc = 'Expand Quickfix Context'
                },
                {
                    '<',
                    function()
                        require('quicker').collapse()
                    end,
                    desc = 'Collapse Quickfix Context'
                },
            },
            max_filename_width = function()
                return math.floor(vim.o.columns / 2)
            end,
        },
    },

    {
        "junegunn/fzf",
        lazy = true,
        -- fzf is loaded either by fzf to filter quickfix or caused by dependencies
        build = "./install --completion --key-bindings --xdg --no-update-rc",
    },

    {
        "ibhagwan/fzf-lua",
        -- url = 'https://gitlab.com/ibhagwan/fzf-lua', -- XXX: github fzf-lua not found
        lazy = true,
        dependencies = { "fzf" },
        cmd = "FzfLua",
        keys = {
            { "<leader><localleader>", "<cmd>FzfLua builtin<cr>",         desc = "Pick Fzf-Lua Builtin" },

            { "<leader>sb",            "<cmd>FzfLua lines<cr>",           desc = "Buffer Lines" },
            { "<leader>fb",            "<cmd>FzfLua buffers<cr>",         desc = "Buffers" },

            -- { "<leader>c", ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>', desc = "find files with cwd" },
            -- { "<leader>e", "<cmd>FzfLua files<cr>", desc = "pick file" },

            -- grep related
            --[[
            {
                "<leader>gd",
                function()
                    local fzf = require("fzf-lua")
                    fzf.fzf_exec("fd -t d", {
                        prompt = "Folder:",
                        actions = {
                            ["default"] = function(selected)
                                if selected and #selected > 0 then
                                    fzf.live_grep_native({ cwd = selected[1] })
                                end
                            end,
                        },
                    })
                end,
                desc = "Select Folder and Grep",
            },
			{
				"<leader>gc",
				':FzfLua live_grep_native cwd=<C-R>=expand("%:h")<cr><cr>',
				desc = "grep files in the same folder of current open buffer",
			},
			{ "<leader>gl", "<cmd>FzfLua live_grep_native<cr>", desc = "live grep" },
			{
				"<leader>gw",
				function()
					require("fzf-lua").live_grep_native({ search = vim.fn.expand("<cword>") })
				end,
				desc = "search word under cursor",
			},
            ]]

            { "<leader>fr",            "<cmd>FzfLua oldfiles<cr>",        desc = "Recent File" },
            { "<leader>s/",            "<cmd>FzfLua search_history<cr>",  desc = "Search History" },
            { "<leader>sC",            "<cmd>FzfLua commands<cr>",        desc = "Commands" },
            { "<leader>sc",            "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>sj",            "<cmd>FzfLua jumps<cr>",           desc = "pick Jumps" },
            { "<leader>sm",            "<cmd>FzfLua marks<cr>",           desc = "Marks" },
            { "<leader>sq",            "<cmd>FzfLua quickfix<cr>",        desc = "Pick Quickfix" },
            { "<leader>st",            "<cmd>FzfLua btags<cr>",           desc = "Search Buffer Tags" },
            { "<leader>sz",            "<cmd>FzfLua zoxide<cr>",          desc = "Jump Directory with Zoxide" },
            { '<leader>s"',            "<cmd>FzfLua registers<cr>",       desc = "Pick Register" },

            -- Git
            { '<leader>gc',            '<cmd>FzfLua git_bcommits<CR>',    desc = 'Buffer Commit' },
            { '<leader>gb',            '<cmd>FzfLua git_blame<CR>',       desc = 'Blame' },
        },
        config = function()
            local status_ok, fzf_lua = pcall(require, "fzf-lua")

            if not status_ok then
                return
            end

            local previewer = "builtin"

            local actions = require("fzf-lua.actions")

            local fzf_lua_table = {
                "max-perf",
                defaults = {
                    color_icons = false,
                    file_icons = false,
                    git_icons = false,
                },
                actions = {
                    -- Below are the default actions, setting any value in these tables will override
                    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
                    files = {
                        true, -- uncomment to inherit all the below in your custom config
                        -- Pickers inheriting these actions:
                        --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                        --   tags, btags, args, buffers, tabs, lines, blines
                        -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
                        -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
                        -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
                        ["enter"] = FzfLua.actions.file_edit,
                        ["ctrl-s"] = FzfLua.actions.file_split,
                        ["ctrl-v"] = FzfLua.actions.file_vsplit,
                        ["ctrl-t"] = FzfLua.actions.file_tabedit,
                        ["alt-q"] = FzfLua.actions.file_sel_to_qf,
                        ["alt-Q"] = FzfLua.actions.file_sel_to_ll,
                        ["alt-i"] = FzfLua.actions.toggle_ignore,
                        ["alt-h"] = FzfLua.actions.toggle_hidden,
                        ["alt-f"] = FzfLua.actions.toggle_follow,
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
                    rg_glob = true,            -- enable glob parsing
                    glob_flag = "--iglob",     -- case insensitive globs
                    glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
                },
                winopts = {
                    width = 0.9,
                    height = 0.9,
                    preview = {
                        default = previewer,
                        layout = "vertical",
                        vertical = "down:45%",
                    },
                },
            }

            --[[
			local fzf_tmux_opts = vim.env.FZF_TMUX_OPTS
			if fzf_tmux_opts ~= nil then
				-- FZF_TMUX_OPTS set, choose with fzf-tmux popup window
				if vim.fn.executable("bat") == 1 then
					previewer = "bat"
				end
				fzf_lua_table.fzf_bin = "fzf-tmux"
				fzf_lua_table.fzf_opts = { ["--border"] = "rounded" }
				fzf_lua_table.fzf_tmux_opts = { ["-p"] = "80%,90%" }
				fzf_lua_table.winopts = {
					preview = {
						default = previewer,
						layout = "vertical",
						vertical = "down:45%",
					},
				}
			end
            ]]
            fzf_lua.setup(fzf_lua_table)
        end,
    },

    {
        "dmtrKovalenko/fff",
        build = function()
            -- downloads a prebuilt binary or falls back to cargo build
            require("fff.download").download_or_build_binary()
        end,
        opts = {
            layout = {
                width = 0.9,
                prompt_position = "top",
            },
        },
        keys = {
            {
                "<leader>fc",
                function()
                    require("fff").find_files_in_dir(vim.fn.expand("%:h"))
                end,
                desc = "Find Files in Current Directory",
            },
            {
                "<leader>ff",
                function()
                    require("fff").find_files()
                end,
                desc = "Find files",
            },
            {
                "<leader>sG",
                function()
                    require("fff").live_grep({ cwd = vim.fn.expand("%:h") })
                end,
                desc = "Live Grep in Curent Directory",
            },
            {
                "<leader>sg",
                function()
                    require("fff").live_grep()
                end,
                desc = "Live Grep",
            },
            {
                "<leader>sf",
                function()
                    require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
                end,
                desc = "Live Fuzy Grep",
            },
            {
                "<leader>sw",
                function()
                    require("fff").live_grep({ query = vim.fn.expand("<cword>") })
                end,
                desc = "Live Grep cword",
            },
        },
    },

    {
        "folke/flash.nvim",
        -- event = "VeryLazy",
        ---@type Flash.Config
        lazy = true,
        opts = {},
        keys = {
            {
                "ss",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            --[[
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            --]]
        },
    },

    {
        "trmckay/based.nvim",
        lazy = true,
        cmd = "BasedConvert",
        opts = {},
    },

    {
        "azabiong/vim-highlighter",
        config = function()
            vim.api.nvim_set_keymap("n", "f<c-h>", ":Hi+<space>", { noremap = true })
            vim.cmd([[
                nn [g <cmd>Hi {<cr>
                nn ]g <cmd>Hi }<cr>
                nn [f <cmd>Hi <<cr>
                nn ]f <cmd>Hi ><cr>
            ]])
        end,
        -- [g: jump to any highlight backward
        -- ]g: jump to any highlight forward
        -- [f: jump to highlight under cursor backward
        -- ]f: jump to highlight under cursor forward

        -- f + <cr>: HiSet, hightlight current word
        -- f + <backspace>: HiErase
        -- f + <C-L>: HiClear
        -- f + tab: HiFind
        -- :Hi + <pattern>: highlight one pattern
        -- :Hi save <name>: save current highlight to file
    },

    { "vladdoster/remember.nvim",         config = true },

    {
        "fei6409/log-highlight.nvim",
        lazy = true,
        config = function()
            require("log-highlight").setup({
                extension = "log",
                keyword = {
                    error = {
                        "bug",
                        "panic",
                        "Panic",
                        "Oops",
                        "oops",
                    },
                    warning = {
                        "retry",
                        "retrying",
                        "timeout",
                        "Timed out",
                        "timed out",
                    },
                    info = {
                        "INFORMATION",
                        "INFO",
                        "info",
                    },
                },
            })
            vim.opt_local.filetype = "log"
            vim.opt_local.syntax = "ON"
        end,
    },

    { "vivien/vim-linux-coding-style",    lazy = true },

    { "Vimjas/vim-python-pep8-indent",    lazy = true,  ft = { "python" } },

    { "octol/vim-cpp-enhanced-highlight", lazy = true,  ft = { "c", "h", "S", "cpp" } },

    {
        "embear/vim-foldsearch",
        lazy = true,
        cmd = {
            "Fp", -- Show the lines that contain the given regular expression
            "Fw", -- Show lines which contain the word under the cursor
            "Fs", -- Show lines which contain previous search pattern
            -- zE to clear all fold
            -- zo close fold, zC to close all fold
            -- zo open fold, zO to open all fold
            -- za toggle fold, zA toggle it recursively
        },
    },

    {
        "ngemily/vim-vp4",
        lazy = true,
        cmd = { "Vp4FileLog", "Vp4Annotate", "Vp4Describe", "Vp4" },
        config = function()
            if vim.fn.exists(":TSContextDisable") > 0 then
                vim.cmd("TSContextDisable")
            end
        end,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
        version = false,
        lazy = true,
        -- event = 'BufRead',
        dependencies = {
            { "nvim-treesitter-textobjects" },
            -- {'nvim-ts-context-commentstring'},
            { "nvim-treesitter-context" },
        },
        build = ":TSUpdate",
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "comment",
                "cpp",
                "diff",
                "gitattributes",
                "gitignore",
                "go",
                "html",
                "http",
                "java",
                "javascript",
                "jsdoc",
                "json",
                "julia",
                "kotlin",
                "llvm",
                "lua",
                "luadoc",
                "luap",
                "make",
                "markdown",
                "markdown_inline",
                "ninja",
                "nix",
                "perl",
                "printf",
                "python",
                "query",
                "regex",
                "ruby",
                "toml",
                "rust",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },

            highlight = {
                enable = false,
                additional_vim_regex_highlighting = false,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = false,
                    node_incremental = "v",
                    scope_incremental = false,
                    node_decremental = "V",
                },
            },

            indent = {
                enable = true,
            },

            refactor = {
                highlight_definitions = { enable = true },
                highlight_current_scope = { enable = true },
            },

            -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["],"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[,"] = "@parameter.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        [">,"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<,"] = "@parameter.inner",
                    },
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = true,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        ft = ft_code,
        keys = {
            {
                "gd",
                mode = "n",
                function()
                    require("treesitter-context").go_to_context()
                end,
                desc = "Jump to Definition",
            },
        },
        opts = {
            mode = "cursor",
            max_lines = 3,
            line_numbers = true,
            trim_scope = "outer",
        },
    },

    {
        "saghen/blink.cmp",
        lazy = true,
        cond = not bigfile_current_buf(),
        event = "InsertEnter",
        dependencies = {
            "mgalliou/blink-cmp-tmux",
            "saghen/blink.lib",
            {
                "mikavilpas/blink-ripgrep.nvim",
                version = "*", -- use the latest stable version
            },
        },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source
        -- build = 'cargo build --release',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = "default",
                -- 👇🏻👇🏻 (optional) add a keymap to invoke the search manually
                ["<c-g>"] = {
                    function()
                        require("blink-cmp").show({ providers = { "ripgrep" } })
                    end,
                },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {
                    -- "snippets",
                    "buffer",
                    "path",
                    "tmux",
                    -- "ripgrep",
                },
                providers = {
                    tmux = {
                        module = "blink-cmp-tmux",
                        name = "tmux",
                        -- default options
                        opts = {
                            -- `panes` option supports these values:
                            -- * `window`  - completions from current tmux window panes only
                            -- * `session` - completions from current tmux session panes only
                            -- * `all`     - completions from all tmux panes
                            panes = "all",
                            -- min_keyword_length = 5,
                            capture_history = false,
                            -- only suggest completions from `tmux` if the `trigger_chars` are
                            -- used
                            triggered_only = false,
                        },
                        min_keyword_length = 4,
                        async = true,
                        max_items = 15,
                    },
                    buffer = {
                        name = "buffer",
                        module = "blink.cmp.sources.buffer",
                        opts = {
                            -- (recommended) filter to only "normal" buffers
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                            -- Maximum total number of characters (in an individual buffer) for which buffer completion runs synchronously. Above this, asynchronous processing is used.
                            max_sync_buffer_size = 20000,
                            -- Maximum total number of characters (in an individual buffer) for which buffer completion runs asynchronously. Above this, the buffer will be skipped.
                            max_async_buffer_size = 400000,
                            -- Maximum text size across all buffers (default: 500KB)
                            max_total_buffer_size = 1500000,
                        },
                        min_keyword_length = 3,
                    },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        -- see the full configuration below for all available options
                        ---@module "blink-ripgrep"
                        ---@type blink-ripgrep.Options
                        opts = {
                            backend = {
                                use = "ripgrep",
                            },
                            max_filesize = "200K",
                            prefix_min_len = 4,
                        },
                        async = true,
                        max_items = 15,
                    },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {
                sorts = {
                    "exact",
                    -- defaults
                    "score",
                    "sort_text",
                },
                implementation = "prefer_rust_with_warning",
            },
        },
        opts_extend = { "sources.default" },
    },

    {
        "nvim-focus/focus.nvim",
        cmd = {
            "FocusSplitNicely",
            "FocusSplitCycle",
            "FocusToggle",
        },
        module = "focus",
        opts = {},
    },

    {
        "stevearc/aerial.nvim",
        lazy = true,
        dependencies = {
            { "nvim-treesitter" },
        },
        keys = {
            { "]a",         "<cmd>AerialNext<cr>",   desc = "[Aerial]jump to next symbol" },
            { "[a",         "<cmd>AerialPrev<cr>",   desc = "[Aerial]jump to prevoius symbol" },
            { "<leader>aw", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial Window" },
        },
        opts = {},
    },

    { "matesea/trace32-practice.vim", lazy = true, ft = "cmm" },

    { "vim-scripts/scons.vim",        lazy = true, ft = "scons" },

    {
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        lazy = true,
        ft = { "lua" },
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            {
                "mason-org/mason.nvim",
                ---@module 'mason.settings'
                ---@type MasonSettings
                ---@diagnostic disable-next-line: missing-fields
                opts = {},
            },
            -- Maps LSP server names between nvim-lspconfig and Mason package names.
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            -- Brief aside: **What is LSP?**
            --
            -- LSP is an initialism you've probably heard, but might not understand what it is.
            --
            -- LSP stands for Language Server Protocol. It's a protocol that helps editors
            -- and language tooling communicate in a standardized fashion.
            --
            -- In general, you have a "server" which is some tool built to understand a particular
            -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
            -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
            -- processes that communicate with some "client" - in this case, Neovim!
            --
            -- LSP provides Neovim with features like:
            --  - Go to definition
            --  - Find references
            --  - Autocompletion
            --  - Symbol Search
            --  - and more!
            --
            -- Thus, Language Servers are external tools that must be installed separately from
            -- Neovim. This is where `mason` and related plugins come into play.
            --
            -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
            -- and elegantly composed help section, `:help lsp-vs-treesitter`

            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client:supports_method("textDocument/inlayHint", event.buf) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --  See `:help lsp-config` for information about keys and how to configure
            ---@type table<string, vim.lsp.Config>
            local servers = {
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`ts_ls`) will work just fine
                -- ts_ls = {},

                stylua = {}, -- Used to format Lua code

                -- Special Lua Config, as recommended by neovim help docs
                lua_ls = {
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if
                                path ~= vim.fn.stdpath("config")
                                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                            then
                                return
                            end
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                            runtime = {
                                version = "LuaJIT",
                                path = { "lua/?.lua", "lua/?/init.lua" },
                            },
                            workspace = {
                                checkThirdParty = false,
                                -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                                --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                                library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
                                    "${3rd}/luv/library",
                                    "${3rd}/busted/library",
                                }),
                            },
                        })
                    end,
                    settings = {
                        Lua = {},
                    },
                },
            }

            -- Ensure the servers and tools above are installed
            --
            -- To check the current status of installed tools and/or manually install
            -- other tools, you can run
            --    :Mason
            --
            -- You can press `g?` for help in this menu.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                -- You can add other tools here that you want Mason to install
            })

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            for name, server in pairs(servers) do
                vim.lsp.config(name, server)
                vim.lsp.enable(name)
            end
        end,
    },

    { -- Autoformat
        "stevearc/conform.nvim",
        cmd = { "ConformInfo", "FormatBuffer" },
        ---@module 'conform'
        ---@type conform.setupOpts
        config = function()
            require("conform").setup()
            vim.api.nvim_create_user_command("FormatBuffer", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "Format buffer" })
        end,
    },

    -- Perform diffs on blocks of code
    {
        "AndrewRadev/linediff.vim",
        lazy = true,
        cmd = { "Linediff", "LinediffAdd" },
        keys = {
            { "<leader>mdf", ":Linediff<CR>",          mode = "x",              desc = "Line diff" },
            { "<leader>mda", ":LinediffAdd<CR>",       mode = "x",              desc = "Line diff add" },
            { "<leader>mds", "<cmd>LinediffShow<CR>",  desc = "Line diff show" },
            { "<leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
        },
    },

    {
        "s1n7ax/nvim-window-picker",
        keys = function(_, keys)
            local pick_window = function()
                local picked_window_id = require("window-picker").pick_window()
                if picked_window_id ~= nil then
                    vim.api.nvim_set_current_win(picked_window_id)
                end
            end

            local swap_window = function()
                local picked_window_id = require("window-picker").pick_window()
                if picked_window_id ~= nil then
                    local current_winnr = vim.api.nvim_get_current_win()
                    local current_bufnr = vim.api.nvim_get_current_buf()
                    local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
                    vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
                    vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
                end
            end

            local mappings = {
                { "sp", pick_window, desc = "Pick window" },
                { "sw", swap_window, desc = "Swap picked window" },
            }
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            hint = "floating-big-letter",
            show_prompt = false,
            filter_rules = {
                include_current_win = true,
                autoselect_one = true,
                bo = {
                    filetype = { "notify", "noice", "neo-tree-popup" },
                    buftype = { "prompt", "nofile", "quickfix" },
                },
            },
        },
    },

    {
        "rainbowhxch/accelerated-jk.nvim",
        lazy = true,
        keys = {
            { "j", "<Plug>(accelerated_jk_gj)", desc = "Accelerated j" },
            { "k", "<Plug>(accelerated_jk_gk)", desc = "Accelerated k" },
        },
        opts = {},
    },

    {
        "kevinhwang91/nvim-ufo",
        lazy = true,
        keys = {
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close All Folds",
            },
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open All Folds",
            },
            {
                "zm",
                function()
                    require("ufo").closeFoldsWith()
                end,
                desc = "Close Fold with v:count",
            },
            -- {'zr', function() require('ufo').openFoldsExceptKinds end, desc = 'open all folds'},
        },
        dependencies = {
            { "kevinhwang91/promise-async", lazy = true },
            { "nvim-treesitter" },
            -- {'nvim-lspconfig'},
        },
        config = function()
            local status_ok, ufo = pcall(require, "ufo")
            if not status_ok then
                return
            end
            local backend = "treesitter"

            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.keymap.set("n", "K", function()
                local winid = ufo.peekFoldedLinesUnderCursor()
                if not winid then
                    -- choose one of coc.nvim and nvim lsp
                    vim.lsp.buf.hover()
                end
            end)

            if backend == "lspconfig" then
                -- Option 2: nvim lsp as LSP client
                -- Tell the server the capability of foldingRange,
                -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
                for _, ls in ipairs(language_servers) do
                    require("lspconfig")[ls].setup({
                        capabilities = capabilities,
                        -- you can add other fields for setting up lsp server in this table
                    })
                end
                ufo.setup()
            elseif backend == "treesitter" then
                -- Option 3: treesitter as a main provider instead
                -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
                -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
                ufo.setup({
                    provider_selector = function(bufnr, filetype, buftype)
                        return { "treesitter", "indent" }
                    end,
                })
            end
        end,
    },

    {
        "AndrewRadev/dsf.vim",
        -- stylua: ignore
        lazy = true,
        keys = {
            { "dsf", "<Plug>DsfDelete", noremap = true, desc = "Delete Surrounding Function" },
            { "csf", "<Plug>DsfChange", noremap = true, desc = "Change Surrounding Function" },
        },
        init = function()
            vim.g.dsf_no_mappings = 1
        end,
    },

    { "westeri/asl-vim", lazy = true, ft = "asl" },

    {
        "christoomey/vim-tmux-navigator",
        cond = vim.env.TMUX,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        init = function()
            vim.g.tmux_navigator_no_mappings = true
        end,
        keys = {
            { "<c-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = { "n", "t" }, desc = "Go to Left Window" },
            { "<c-j>", "<cmd>TmuxNavigateDown<cr>",  mode = { "n", "t" }, desc = "Go to Down Window" },
            { "<c-k>", "<cmd>TmuxNavigateUp<cr>",    mode = { "n", "t" }, desc = "Go to Upper Window" },
            { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "Go to Right Window" },
        },
    },

    {
        "dhananjaylatkar/cscope_maps.nvim",
        lazy = true,
        keys = {
            { "<leader>cf", ":Cscope find<space>", desc = "Trigger Cscope" },
            {
                "<leader>cs",
                ':Cscope find s <C-R>=expand("<cword>")<cr><cr>',
                silent = true,
                desc = "Cscope: Find All References",
            },
            {
                "<leader>cg",
                ':Cscope find g <C-R>=expand("<cword>")<cr><cr>',
                silent = true,
                desc = "Cscope: Find Definition",
            },
            {
                "<leader>cc",
                ':Cscope find c <C-R>=expand("<cword>")<cr><cr>',
                silent = true,
                desc = "Cscope: Find All Calls",
            },
        },
        cmd = { "Cscope" },
        opts = {
            disable_maps = true,       -- true disables keymaps, only :Cscope will be loaded
            skip_input_prompt = true,  -- "true" doesn't ask for input
            cscope = {
                db_file = "GTAGS",     -- location of cscope db file
                exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
                picker = "quickfix",   -- "telescope", "fzf-lua" or "quickfix"
                picker_opts = {
                    -- size of quickfix window
                    window_size = 10,                 -- any positive integer
                    -- position of quickfix window
                    window_pos = "bottom",            -- "bottom", "right", "left" or "top"
                },
                skip_picker_for_single_result = true, -- jump directly to position for single result
                -- these args are directly passed to "cscope -f <db_file> <args>"
                -- db_build_cmd_args = { "-bqkv" },
                -- statusline indicator, default is cscope executable
                statusline_indicator = nil,
            },
        },
    },

    -- Git blame visualizer
    {
        "FabijanZulj/blame.nvim",
        cond = has_git,
        cmd = "BlameToggle",
        -- stylua: ignore
        opts = {
            date_format = "%Y-%m-%d %H:%M",
            merge_consecutive = false,
            max_summary_width = 30,
            mappings = {
                commit_info = "K",
                stack_push = ">",
                stack_pop = "<",
                show_commit = "<CR>",
                close = { "<Esc>", "q" },
            },
        },
    },

    {
        "ghillb/cybu.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "[b", "<Plug>(CybuPrev)" },
            { "]b", "<Plug>(CybuNext)" },
            --[[
            { '<C-S-Tab>', '<Plug>(CybuLastusedPrev)' },
            { '<C-Tab>', '<Plug>(CybuLastusedNext)' },
            ]]
        },
        opts = {
            style = {
                devicons = { enabled = false },
            },
        },
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            toggle = {
                map = function(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.silent = opts.silent ~= false
                    Snacks.keymap.set(mode, lhs, rhs, opts)
                end,
            },
            dim = { enabled = true },
            indent = { enabled = true },
            quickfile = { enabled = true },
            bigfile = {
                notify = true,          -- show notification when big file detected
                size = 3 * 1024 * 1024, -- 3MB
                line_length = 1000,     -- average line length (useful for minified files)
                -- Enable or disable features when big file detected
                ---@param ctx {buf: number, ft:string}
                setup = function(ctx)
                    if vim.fn.exists(":NoMatchParen") ~= 0 then
                        vim.cmd([[NoMatchParen]])
                    end
                    Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                    vim.b.completion = false
                    vim.b.minianimate_disable = true
                    vim.b.minihipatterns_disable = true
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(ctx.buf) then
                            vim.bo[ctx.buf].syntax = ctx.ft
                        end
                    end)
                    -- vimopts
                    vim.b.swapfile = false
                    vim.b.foldmethod = "manual"
                    vim.b.list = false
                    vim.b.undolevels = -1
                    vim.b.undoreload = 0
                    vim.b.syntax = "OFF"
                    vim.b.filetype = ""
                    vim.b.completion = false
                end,
            },
            --[[
            picker = {
                win = {
                    -- Make file truncation consider window width.
                    -- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
                    list = {
                        on_buf = function(self)
                            self:execute("calculate_file_truncate_width")
                        end,
                    },
                    preview = {
                        on_buf = function(self)
                            self:execute("calculate_file_truncate_width")
                        end,
                        on_close = function(self)
                            self:execute("calculate_file_truncate_width")
                        end,
                    },
                },
                actions = {
                    -- Make file truncation consider window width.
                    -- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
                    calculate_file_truncate_width = function(self)
                        local width = self.list.win:size().width
                        self.opts.formatters.file.truncate = width - 6
                    end,
                },
                layouts = {
                    default = {
                        layout = {
                            -- Make the default popup window use 100% of screen not 80%.
                            width = 0.9,
                            height = 0.9,
                        },
                    },
                },
            },
            ]]
            terminal = {
                win = {
                    style = 'terminal',
                    wo = { winbar = '' },
                    -- stylua: ignore
                    keys = {
                        nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
                        nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
                        nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
                        nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
                        hide_slash = { '<C-/>', 'hide', desc = 'Hide Terminal', mode = 't' },
                        hide_underscore = { '<c-_>', 'hide', desc = 'which_key_ignore', mode = 't' },
                    },
                },
            },
        },
        keys = {
            --[[

          {'<leader>sb', function() Snacks.picker.lines() end, desc = 'Lines'},
          {'<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers'},
          -- {'<leader>ff', function() Snacks.picker.smart() end, desc = 'Smart Find Files'},
          {'<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent'},
          {'<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers'},
          {'<leader>s/', function() Snacks.picker.search_history() end, desc = 'History'},
          {'<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands'},
          {'<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History'},
          {'<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps'},
          {'<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks'},
          {'<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List'},

            {
                "<leader>sz",
                function()
                    Snacks.picker.zoxide()
                end,
                desc = "Open File after Zoxide",
            },
          ]]
            {
                "<leader>ft",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Terminal",
            },
            {
                "<c-/>",
                function()
                    Snacks.terminal.focus(nil)
                end,
                mode = { 'n', 't' },
                desc = "Terminal Focus"
            },
            {
                "<c-_>",
                function()
                    Snacks.terminal.focus(nil)
                end,
                mode = { 'n', 't' },
                desc = "Terminal Focus"
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...) end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` commmand

                    Snacks.toggle.zoom():map("<leader>uz")
                    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
                    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
                    Snacks.toggle.line_number():map('<leader>ul')
                    Snacks.toggle.option('showtabline',
                        { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map(
                    '<leader>ua')
                    Snacks.toggle.dim():map('<leader>ud')
                    Snacks.toggle.indent():map('<leader>ui')
                end,
            })
        end,
    },

    -- floating status line
    {
        "b0o/incline.nvim",
        event = "VeryLazy", -- only for multi-window
        opts = {
            ignore = {
                buftypes = "special",
                filetypes = { "gitcommit" },
            },
            window = {
                padding = 0,
                margin = { horizontal = 0 },
            },
        },
    },

    {
        "folke/sidekick.nvim",
        cmd = "Sidekick",
        opts = {
            cli = {
                win = {
                    layout = "bottom",
                },
            },
        },
        -- stylua: ignore
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function() require("sidekick.cli").focus() end,
                desc = "Sidekick Focus",
                mode = { "n", "t", "i", "x" },
            },
            {
                "<leader>aa",
                function() require("sidekick.cli").toggle() end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function() require("sidekick.cli").select() end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function() require("sidekick.cli").close() end,
                desc = "Detach a CLI Session",
            },
            {
                "<leader>at",
                function() require("sidekick.cli").send({ msg = "{this}" }) end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function() require("sidekick.cli").send({ msg = "{file}" }) end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function() require("sidekick.cli").send({ msg = "{selection}" }) end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>ap",
                function() require("sidekick.cli").prompt() end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
        },
    },

    -- changes the working directory to the project root when you open a file.
    {
        'wsdjeg/rooter.nvim',
        cmd = 'Rooter',
        opts = {},
    }
}

lazy_init()
require("lazy").setup(plugins)
