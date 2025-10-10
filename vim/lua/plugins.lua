local M = {}

function M.setup()

     local function lazy_init()
         local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
         if not vim.loop.fs_stat(lazypath) then
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

    local ft_code = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua', 'java'}
    local has_git = vim.fn.executable('git') == 1

    local plugins = {
        { "fabius/molokai.nvim",
            dependencies = "rktjmp/lush.nvim",
            lazy = true,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'molokai'
            end
        },

        { 'tanvirtin/monokai.nvim',
            lazy = true,
            priority = 1000,
            config = function()
                require('monokai').setup {}
            end
        },

        { 'tamelion/neovim-molokai',
            lazy = true,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'molokai'
            end
        },

        { 'sainnhe/sonokai',
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.sonokai_style = 'default'
                vim.g.sonokai_better_performance = 1
                -- vim.g.sonokai_transparent_background = 1
                vim.g.sonokai_dim_inactive_windows = 1
                vim.cmd.colorscheme 'sonokai'
            end
        },

        { 'dasupradyumna/midnight.nvim',
            lazy = true,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'midnight'
            end
        },

        { 'rebelot/kanagawa.nvim',
           lazy = true,
            priority = 1000,
           config = function()
               require('kanagawa').setup({
                       dimInactive = true,
                       })
                vim.cmd.colorscheme 'kanagawa'
           end
        },

        { 'ribru17/bamboo.nvim',
           lazy = true,
           priority = 1000,
           config = function()
             require('bamboo').setup {
               -- optional configuration here
             }
             require('bamboo').load()
           end,
        },

        { 'tpope/vim-fugitive',
            lazy = true,
            cond = has_git,
            cmd = {'Git', 'GV', 'Gcd'},
        },

        { 'lewis6991/gitsigns.nvim',
            -- version = 'release',
            cond = has_git,
            keys = {
                {']c', function() package.loaded.gitsigns.next_hunk() end, desc = 'Next Hunk'},
                {'[c', function() package.loaded.gitsigns.prev_hunk() end, desc = 'Previous Hunk'},
                {'<leader>hr', function() package.loaded.gitsigns.reset_hunk() end, desc = 'Reset Hunk'},
                {'<leader>hb', function() package.loaded.gitsigns.blame_line{full = true} end, desc = 'Blame Line'},
            },
            config = function()
                require('config.gitsigns').setup()
            end
        },

        { 'junegunn/gv.vim',
            dependencies = {'tpope/vim-fugitive'},
            cmd = 'GV'
        },

        { 'nvim-mini/mini.icons',
            version = false,
            lazy = true,
            config = true,
        },

        { 'nvim-mini/mini.tabline',
           version = false,
           event = 'VeryLazy',
           dependencies = {'mini.icons'},
           config = true,
        },

        { 'nvim-mini/mini.statusline',
           version = false,
           event = 'VeryLazy',
           dependencies = {'mini.icons'},
           config = true,
        },

        { 'nvim-mini/mini.trailspace',
            version = false,
            lazy = true,
            ft = ft_code,
            config = {
                only_in_normal_buffers = true,
            },
        },

        { 'stevearc/quicker.nvim',
            ft = 'qf',
            event = 'QuickFixCmdPost',
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
                    { '>',
                        function()
                            require('quicker').expand({
                                    before = 2, after = 2,
                                    add_to_existing = true })
                        end, desc = 'Expand quickfix context'
                    },
                    { '<',
                        function()
                            require('quicker').collapse()
                        end, desc = 'Collapse quickfix context'
                    },
                },
                max_filename_width = function()
                    return math.floor(vim.o.columns / 2)
                end,
            },
        },

        { 'nvim-mini/mini.pairs',
            version = false,
            event = 'InsertEnter',
            opts = {}
        },

        { 'junegunn/fzf',
            lazy = true,
            -- fzf is loaded either by fzf to filter quickfix or caused by dependencies
            build ='./install --completion --key-bindings --xdg --no-update-rc',
        },

        { 'ibhagwan/fzf-lua',
            -- url = 'https://gitlab.com/ibhagwan/fzf-lua', -- XXX: github fzf-lua not found
            lazy = true,
            dependencies = {'fzf'},
            cmd = 'FzfLua',
            keys = {
                {'<leader>;', '<cmd>FzfLua builtin<cr>', desc = 'pick fzf-lua builtin'},

                {';a', '<cmd>FzfLua lines<cr>', desc = 'all buffer lines'},
                {';b', '<cmd>FzfLua buffers<cr>',desc = 'open buffers'},
                {';c', ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>',
                    desc = 'find files with cwd'},

                {';e', '<cmd>FzfLua combine pickers=buffers;oldfiles;files<cr>',
                    desc = 'find file with combined buffer/oldfiles/files pickers'},
                {';f', '<cmd>FzfLua global<cr>',
                    desc = 'global picker for file/buffer/tag'},

                -- grep related
                {';gc', ':FzfLua live_grep_native cwd=<C-R>=expand("%:h")<cr><cr>',
                    desc = 'grep files in the same folder of current open buffer'},
                {';gd', function()
                        local fzf = require('fzf-lua')
                        fzf.fzf_exec("fd -t d", {
                                prompt = "Folder:",
                                actions = {
                                ["default"] = function(selected)
                                    if selected and #selected > 0 then
                                        fzf.live_grep({ cwd = selected[1] })
                                    end
                                end,
                                },
                        })
                    end, desc = 'grep on selected folder'
                },
                {';gl', '<cmd>FzfLua live_grep_native<cr>', desc = 'live grep'},
                {';gw', '<cmd>FzfLua grep_cword<cr>', desc = 'search word under cursor'},

                {';j', '<cmd>FzfLua jumps<cr>', desc = 'pick from jumps'},
                {';q', '<cmd>FzfLua quickfix<cr>', desc = 'pick from quickfix'},
                {';r', '<cmd>FzfLua registers<cr>', desc = 'pick from registers'},
                {';s', '<cmd>FzfLua tagstack<cr>', desc = 'pick tagstack'},

                {';t', '<cmd>FzfLua btags<cr>', desc = 'search buffer tags'},

                {';zd', '<cmd>FzfLua zoxide<cr>', desc = 'jump directory with zoxide'},

                {';;', '<cmd>FzfLua command_history<cr>', desc = 'command history'},
                {';:', '<cmd>FzfLua commands<cr>', desc = 'commands'},
                {';/', '<cmd>FzfLua search_history<cr>', desc = 'search history'},
            },
            config = function()
                require('config.fzf-lua').setup()
            end
        },

        { "folke/flash.nvim",
            -- event = "VeryLazy",
            ---@type Flash.Config
            lazy = true,
            opts = {},
            keys = {
                { "ss", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                --[[
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
                --]]
            },
        },

        { "gennaro-tedesco/nvim-possession",
            dependencies = {
                "ibhagwan/fzf-lua",
            },
            lazy = true,
            config = true,
            keys = {
                {"<leader>sl", function() require('nvim-possession').list() end, desc = 'list existing sessions'},
                {"<leader>sn", function() require('nvim-possession').new() end, desc = 'create new session'},
                {"<leader>su", function() require('nvim-possession').update() end, desc = 'update current session'},
                {"<leader>sd", function() require('nvim-possession').delete() end, desc = 'delete current session'},
            },
        },

        { 'trmckay/based.nvim',
           lazy = true,
           cmd = "BasedConvert",
           config = function()
               require('based').setup({})
           end,
        },

        { 'chentoast/marks.nvim',
            lazy = true,
            config = function()
                require('marks').setup()
            end
        },

        { 'azabiong/vim-highlighter',
            config = function()
                vim.api.nvim_set_keymap('n', 'f<c-h>', ':Hi+<space>', {noremap = true})
                vim.cmd [[
                    nn [g <cmd>Hi {<cr>
                    nn ]g <cmd>Hi }<cr>
                    nn [f <cmd>Hi <<cr>
                    nn ]f <cmd>Hi ><cr>
                ]]
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

        { 'vladdoster/remember.nvim',
            config = true,
        },

        { "LunarVim/bigfile.nvim",
            init = function()
                require("bigfile").setup {
                    filesize = 3, -- size of the file in MiB, the plugin round file sizes to the closest MiB
                    pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
                    features = { -- features to disable
                      "indent_blankline",
                      "illuminate",
                      "lsp",
                      -- "treesitter",
                      "syntax",
                      "matchparen",
                      -- "vimopts",
                      "filetype",
                    },
                  }
            end
        },

        { 'fei6409/log-highlight.nvim',
            ft = 'log',
            opts = {
                extension = 'log',
                keyword = {
                    error = {
                        'bug', 'panic', 'Panic',
                        'Oops', 'oops'
                    },
                    warning = {
                        'retry', 'retrying',
                        'timeout', 'Timed out', 'timed out'
                    },
                    info = {
                        'INFORMATION', 'INFO', 'info'
                    },
                },
            },
        },

        { 'vivien/vim-linux-coding-style',
            lazy = true,
        },

        { 'Vimjas/vim-python-pep8-indent',
            lazy = true,
            ft = {'python'},
        },

        { 'octol/vim-cpp-enhanced-highlight',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp'},
        },

        { 'nvim-mini/mini.comment',
            version = false,
            ft = ft_code,
            dependencies = {'nvim-ts-context-commentstring'},
            opts = {
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring()
                            or vim.bo.commentstring
                    end,
                },
            },
        },

        { 'dstein64/vim-startuptime',
            lazy = true,
            cmd = 'StartupTime'
        },

        'romainl/vim-cool',

        { 'embear/vim-foldsearch',
            lazy = true,
            cmd = {
                'Fp',  -- Show the lines that contain the given regular expression
                'Fw',  -- Show lines which contain the word under the cursor
                'Fs'   -- Show lines which contain previous search pattern
                -- zE to clear all fold
                -- zo close fold, zC to close all fold
                -- zo open fold, zO to open all fold
                -- za toggle fold, zA toggle it recursively
           },
        },

        { 'ngemily/vim-vp4',
            lazy = true,
            cmd = { 'Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4'},
            config = function()
                if vim.fn.exists(':TSContextDisable') > 0 then
                    vim.cmd('TSContextDisable')
                end
            end
        },

        { 'JoosepAlviste/nvim-ts-context-commentstring',
            lazy = true,
            init = function()
                vim.g.skip_ts_context_commentstring_module = true
            end,
            config = function()
                require('ts_context_commentstring').setup {}
            end
        },

        { 'nvim-treesitter/nvim-treesitter',
            lazy = true,
            -- event = 'BufRead',
            dependencies = {
                {'nvim-treesitter-textobjects'},
                {'nvim-ts-context-commentstring'},
                {'nvim-treesitter-context'},
            },
            build = function()
               local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
               ts_update()
           end,
           config = function()
                require('config.treesitter')
           end
        },

        { 'nvim-treesitter/nvim-treesitter-textobjects',
            lazy = true,
        },

        { 'nvim-treesitter/nvim-treesitter-context',
            lazy = true,
            ft = ft_code,
            keys = {
                {'gd', mode = 'n', function() require("treesitter-context").go_to_context() end, desc = 'jump to definition'},
            },
            opts = {
                mode = 'cursor',
                max_lines = 3,
                line_numbers = true,
                trim_scope = 'outer',
            },
        },

        { 'hrsh7th/nvim-cmp',
            dependencies = {
                -- nvim-cmp source for buffer words
                'hrsh7th/cmp-buffer',
                -- nvim-cmp source for path
                'hrsh7th/cmp-path',
                -- Tmux completion source for nvim-cmp
                'andersevenrud/cmp-tmux',
                -- rip grep source
                "lukas-reineke/cmp-rg",
                -- nvim-cmp source for cmdline
                "hrsh7th/cmp-cmdline",
            },
            event = {'InsertEnter'},
            config = function()
                require('config.cmp').setup()
            end,
        },

        -- dim inactive window
        { 'levouh/tint.nvim',
            lazy = true,
            config = function()
                require('tint').setup()
            end
        },
        { 'b0o/incline.nvim',
            event = 'WinEnter',
            dependencies = {'mini.icons'},
            config = function()
                local helpers = require 'incline.helpers'
                local mini_icons = require 'mini.icons'
                require('incline').setup {
                    ignore = {
                        buftypes = 'special',
                        filetypes = {'gitcommit'},
                    },
                  window = {
                    padding = 0,
                    margin = { horizontal = 0 },
                  },
                  render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    if filename == '' then
                      filename = '[No Name]'
                    end
                    local ft_icon, ft_color = mini_icons.get("file", filename)
                    local modified = vim.bo[props.buf].modified
                    return {
                      ' ',
                      { filename, gui = modified and 'bold,italic' or 'bold' },
                      ' ',
                      ft_icon and { ft_icon, ' ', guibg = 'none', group = ft_color } or '',
                    }
                  end,
                }
            end,
        },

        { 'nvim-focus/focus.nvim',
            cmd = { "FocusSplitNicely", "FocusSplitCycle" , 'FocusToggle' },
            module = "focus",
            dependencies = {
                'levouh/tint.nvim',
            },
            keys = {
                {'<leader>fn', '<cmd>FocusSplitNicely<cr>', 'split focus nicely'}
            },
            config = function()
                require("focus").setup()
            end
        },

        { 'stevearc/aerial.nvim',
            lazy = true,
            dependencies = {
                {'nvim-treesitter'},
            },
            keys = {
                {']a', '<cmd>AerialNext<cr>', desc = '[Aerial]jump to next symbol'},
                {'[a', '<cmd>AerialPrev<cr>', desc = '[Aerial]jump to prevoius symbol'},
                {'<leader>a', '<cmd>AerialToggle<cr>', desc = 'toggle Aerial window'},
            },
            config = function()
                require("aerial").setup({
                    backends = {"treesitter"}
                })

                -- shortcut to find function in fzf mode
                -- faster than fzf.vim/fzf-lua BTags
                -- vim.keymap.set('n', ';z', '<cmd>call aerial#fzf()<cr>')
            end,
        },

        { 'matesea/trace32-practice.vim',
            lazy = true,
            ft = 'cmm',
        },

        { 'vim-scripts/scons.vim',
            lazy = true,
            ft = 'scons',
        },

        { 'nvim-mini/mini.surround',
            version = false,
            lazy = true,
            -- stylua: ignore
            keys = function(_, keys)
                -- Populate the keys based on the user's options
                local plugin = require('lazy.core.config').spec.plugins['mini.surround']
                local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
                local mappings = {
                    { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'x' } },
                    { opts.mappings.delete, desc = 'Delete surrounding' },
                    { opts.mappings.find, desc = 'Find right surrounding' },
                    { opts.mappings.find_left, desc = 'Find left surrounding' },
                    { opts.mappings.highlight, desc = 'Highlight surrounding' },
                    { opts.mappings.replace, desc = 'Replace surrounding' },
                    { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
                }
                mappings = vim.tbl_filter(function(m)
                    return m[1] and #m[1] > 0
                end, mappings)
                return vim.list_extend(mappings, keys)
            end,
            opts = {
                mappings = {
                    add = 'sa', -- Add surrounding in Normal and Visual modes
                    delete = 'ds', -- Delete surrounding
                    find = 'gzf', -- Find surrounding (to the right)
                    find_left = 'gzF', -- Find surrounding (to the left)
                    highlight = 'gzh', -- Highlight surrounding
                    replace = 'cs', -- Replace surrounding
                    update_n_lines = 'gzn', -- Update `n_lines`
                },
            },
        },

        { 'neovim/nvim-lspconfig',
            lazy = true,
            dependencies = {
                {'williamboman/mason.nvim', lazy = true},
                {'williamboman/mason-lspconfig.nvim', lazy = true},
                {'hrsh7th/cmp-nvim-lsp', lazy = true},
            },
            config = function()
                require('config.lspconfig').setup()
            end
        },

        { 'rickhowe/spotdiff.vim',
           lazy = true,
           cmd = 'Diffthis',
        },

        -- Perform diffs on blocks of code
        { 'AndrewRadev/linediff.vim',
            lazy = true,
            cmd = { 'Linediff', 'LinediffAdd' },
            keys = {
                { '<leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
                { '<leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
                { '<leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
                { '<leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
            },
        },

        { 's1n7ax/nvim-window-picker',
            keys = function(_, keys)
                local pick_window = function()
                    local picked_window_id = require('window-picker').pick_window()
                    if picked_window_id ~= nil then
                        vim.api.nvim_set_current_win(picked_window_id)
                    end
                end

                local swap_window = function()
                    local picked_window_id = require('window-picker').pick_window()
                    if picked_window_id ~= nil then
                        local current_winnr = vim.api.nvim_get_current_win()
                        local current_bufnr = vim.api.nvim_get_current_buf()
                        local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
                        vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
                        vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
                    end
                end

                local mappings = {
                    { 'sp', pick_window, desc = 'Pick window' },
                    { 'sw', swap_window, desc = 'Swap picked window' },
                }
                return vim.list_extend(mappings, keys)
            end,
            opts = {
                hint = 'floating-big-letter',
                show_prompt = false,
                filter_rules = {
                    include_current_win = true,
                    autoselect_one = true,
                    bo = {
                        filetype = { 'notify', 'noice', 'neo-tree-popup' },
                        buftype = { 'prompt', 'nofile', 'quickfix' },
                    },
                },
            },
        },

        { 'rainbowhxch/accelerated-jk.nvim',
            lazy = true,
            keys = {
                {'j', '<Plug>(accelerated_jk_gj)', desc = 'accelerated j'},
                {'k', '<Plug>(accelerated_jk_gk)', desc = 'accelerated k'},
            },
            opts = {},
        },


        { 'kevinhwang91/nvim-ufo',
           lazy = true,
           keys = {
                {'zM', function() require('ufo').closeAllFolds() end, desc = 'close all folds'},
                {'zR', function() require('ufo').openAllFolds() end, desc = 'open all folds'},
                {'zm', function() require('ufo').closeFoldsWith() end, desc = 'close fold with v:count'},
                -- {'zr', function() require('ufo').openFoldsExceptKinds end, desc = 'open all folds'},
            },
           dependencies ={
                {'kevinhwang91/promise-async', lazy = true},
                {'nvim-treesitter'},
                -- {'nvim-lspconfig'},
            },
           config = function()
                -- either 'treesitte' or 'lspconfig'
                require('config.nvim-ufo').setup('treesitter')
           end
        },

        { 'AndrewRadev/dsf.vim',
            -- stylua: ignore
            lazy = true,
            keys = {
                { 'dsf', '<Plug>DsfDelete', noremap = true, desc = 'Delete Surrounding Function' },
                { 'csf', '<Plug>DsfChange', noremap = true, desc = 'Change Surrounding Function' },
            },
            init = function()
                vim.g.dsf_no_mappings = 1
            end,
        },

        { 'westeri/asl-vim',
            lazy = true,
            ft = 'asl',
        },

        { "christoomey/vim-tmux-navigator",
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
              { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = {'n', 't'}, desc = 'go to left window' },
              { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = {'n', 't'}, desc = 'go to down window' },
              { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = {'n', 't'}, desc = 'go to upper window' },
              { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = {'n', 't'}, desc = 'go to right window' },
            },
        },

        -- jk to escape
        { "max397574/better-escape.nvim",
            config = function()
              require("better_escape").setup{}
            end,
        },

        -- gb to start, j{l/c/r} to align
        { 'echasnovski/mini.align',
            version = false,
            opts = {
                mappings = {
                    start = 'gb',
                    start_with_preview = 'gB',
                },
            },
            keys = {
                { 'gb', mode = { 'n', 'x' } },
                { 'gB', mode = { 'n', 'x' } },
            },
        },

        { 'pechorin/any-jump.vim',
            cmd = { 'AnyJump', 'AnyJumpVisual' },
            keys = {
                { '<leader>ii', '<cmd>AnyJump<CR>', desc = 'Any Jump' },
                { '<leader>ii', '<cmd>AnyJumpVisual<CR>', mode = 'x', desc = 'Any Jump' },
                { '<leader>ib', '<cmd>AnyJumpBack<CR>', desc = 'Any Jump Back' },
                { '<leader>il', '<cmd>AnyJumpLastResults<CR>', desc = 'Any Jump Resume' },
            },
            config = function()
                vim.g.any_jump_disable_default_keybindings = 1
            end,
        },

        { 'dhananjaylatkar/cscope_maps.nvim',
            lazy = true,
            keys = {
                {'<space>f', ':Cscope find<space>', desc = 'trigger Cscope'},
                {'<space>s', ':Cscope find s <C-R>=expand("<cword>")<cr><cr>', silent = true,
                    desc = 'find all references to a token under cursor'},
                {'<space>g', ':Cscope find g <C-R>=expand("<cword>")<cr><cr>', silent = true,
                    desc = 'find definition of the token under cursor'},
                {'<space>c', ':Cscope find c <C-R>=expand("<cword>")<cr><cr>', silent = true,
                    desc = 'find all calls to the function under cursor'},
            },
            cmd = {'Cscope'},
            config = function()
                require('config.cscope_maps').setup()
            end,
        },

        -- Git blame visualizer
        { 'FabijanZulj/blame.nvim',
            cond = has_git,
            cmd = 'BlameToggle',
            -- stylua: ignore
            keys = {
                { '<leader>gb', '<cmd>BlameToggle window<CR>', desc = 'Git blame (window)' },
            },
            opts = {
                date_format = '%Y-%m-%d %H:%M',
                merge_consecutive = false,
                max_summary_width = 30,
                mappings = {
                    commit_info = 'K',
                    stack_push = '>',
                    stack_pop = '<',
                    show_commit = '<CR>',
                    close = { '<Esc>', 'q' },
                },
            },
        },

        { 'ghillb/cybu.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
            keys = {
                { '[b', '<Plug>(CybuPrev)' },
                { ']b', '<Plug>(CybuNext)' },
                --[[
                { '<C-S-Tab>', '<Plug>(CybuLastusedPrev)' },
                { '<C-Tab>', '<Plug>(CybuLastusedNext)' },
                ]]
            },
            opts = {
                style = {
                    devicons = { enabled = false, },
                }
            },
        },

        { "folke/snacks.nvim",
          lazy = false,
          ---@type snacks.Config
          opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            toggle = {enabled = true},
            indent = {enabled = true},
            zen = {
                enabled = true,
                zoom = {
                    show = {tabline = false},
                    win = {backdrop = true},
                }
            },
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
                    width = 0,
                    height = 0,
                  },
                },
              },
            },
          },
          keys = {
              --[[

              {';a', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers'},
              {';b', function() Snacks.picker.buffers() end, desc = 'Buffers'},
              {';c', function() Snacks.picker.files({cwd = vim.fn.expand('%:h')}) end, desc = 'Find Files in cwd'},
              {';d', function() Snacks.picker.grep({cwd = vim.fn.expand('%:h')}) end, desc = 'Grep in cwd'},
              {';e', function() Snacks.picker.smart() end, desc = 'Smart Find Files'},
              {';g', function() Snacks.picker.grep() end, desc = 'Grep'},
              {';h', function() Snacks.picker.recent() end, desc = 'Recent'},
              {';j', function() Snacks.picker.jumps() end, desc = 'Jumps'},
              {';q', function() Snacks.picker.qflist() end, desc = 'Quickfix List'},
              {';w', function() Snacks.picker.grep_word() end, desc = 'Grep Word'},

              {';;', function() Snacks.picker.command_history() end, desc = 'Command History'},
              {';:', function() Snacks.picker.commands() end, desc = 'Commands'},
              {';/', function() Snacks.picker.search_history() end, desc = 'Search History'},

              ]]
              {';zf', function() Snacks.picker.zoxide() end, desc = 'Open File with Zoxide'},
          },
          init = function()
              vim.api.nvim_create_autocmd("User", {
                      pattern = "VeryLazy",
                      callback = function()
                        -- Setup some globals for debugging (lazy-loaded)
                        _G.dd = function(...)
                        end
                        _G.bt = function()
                            Snacks.debug.backtrace()
                        end
                        vim.print = _G.dd -- Override print to use snacks for `:=` commmand

                        Snacks.toggle.indent():map('si')
                        Snacks.toggle.zoom():map('sz')
                        Snacks.toggle.zen():map('sZ')
                      end
                  }

              )
          end,
        },
    }


    lazy_init()
    local lazy = require 'lazy'
    lazy.setup(plugins)
end

return M
