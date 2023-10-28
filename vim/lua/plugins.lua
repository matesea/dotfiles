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
    local ver = vim.version()
    local is_neovim8 = function()
        return ver.major == 0 and ver.minor < 9
    end

    local plugins = {
        { "fabius/molokai.nvim",
            dependencies = "rktjmp/lush.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'molokai'
            end
        },

        {'tanvirtin/monokai.nvim',
            enabled = false,
            lazy = false,
            config = function()
                require('monokai').setup {}
            end
        },

        { 'tamelion/neovim-molokai',
            enabled = false,
            lazy = false,
            config = function()
                vim.cmd.colorscheme 'molokai'
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
           config = function()
                vim.cmd("colorscheme kanagawa")
           end
        },

        { 'tpope/vim-fugitive',
            lazy = true,
            cmd = {'Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame', 'GV', 'Gcd'},
        },

        { 'FabijanZulj/blame.nvim',
            lazy = true,
            cmd = 'ToggleBlame',
        },

        {'rhysd/git-messenger.vim',
            enabled = false,
		    cmd = 'GitMessenger',
		    keys = {
		    	{ '<Leader>gm', '<Plug>(git-messenger)', desc = 'Git messenger'}
		    },
		    init = function()
		    	vim.g.git_messenger_include_diff = 'current'
		    	vim.g.git_messenger_no_default_mappings = false
		    	vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
		    end,
        },

        { 'lewis6991/gitsigns.nvim',
            -- version = 'release',
            event = 'VeryLazy',
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            config = function()
                require('config.gitsigns').setup()
            end
        },

        { 'junegunn/gv.vim',
            dependencies = {'tpope/vim-fugitive'},
            lazy = true,
            cmd = 'GV'
        },

        { 'echasnovski/mini.tabline',
           config = function()
               require('mini.tabline').setup({
                   show_icons = false
               })
           end
        },

	    { 'nmac427/guess-indent.nvim', lazy = false, priority = 50, config = true },

        --[[
        { 'ap/vim-buftabline',
            enabled = false,
            config = function()
                vim.g.buftabline_show = 1
                vim.g.buftabline_numbers = 2
                vim.api.nvim_set_keymap('n', '<leader>1', '<Plug>BufTabLine.Go(1)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>2', '<Plug>BufTabLine.Go(2)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>3', '<Plug>BufTabLine.Go(3)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>4', '<Plug>BufTabLine.Go(4)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>5', '<Plug>BufTabLine.Go(5)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>6', '<Plug>BufTabLine.Go(6)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>7', '<Plug>BufTabLine.Go(7)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>8', '<Plug>BufTabLine.Go(8)', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>9', '<Plug>BufTabLine.Go(9)', {noremap = false})
            end
        }
        ]]

        { 'bronson/vim-trailing-whitespace',
            lazy = true,
            ft = ft_code,
            cmd = 'FixWhitespace',
            init = function()
                vim.g.extra_whitespace_ignored_filetypes = {
                    'diff',
                    'gitcommit',
                    'unite',
                    'qf',
                    'help',
                    'markdown',
                    'log',
                    'text',
                    'fzf',
                    'terminal',
                }
            end
        },
        --[[
        use({
            'emileferreira/nvim-strict',
            lazy = true,
            ft = ft_code,
            config = function()
                require('strict').setup({
                   excluded_filetypes = { 'text', 'markdown', 'html' },
                   deep_nesting = {
                       depth_limit = 5,
                       ignored_trailing_characters = ',',
                       ignored_leading_characters = '.'
                   },
                   overlong_lines = {
                       length_limit = 120
                   },
                   tab_indentation = {
                       highlight = false,
                       highlight_group = 'SpellBad',
                       convert_on_save = false,
                   },
               })
            end
        })
        ]]

        { 'joereynolds/gtags-scope',
            lazy = true,
            --[[
            cmd = {'GtagsCscope',},
            keys = {
                {'<leader>gc', '<cmd>GtagsCscope<cr>', mode = {'n'}, noremap = true, silent = false, desc = 'start gtags-cscope'},
            },
            ]]
            config = function()
                require('config.gtags').setup()
            end
        },

        { 'drmingdrmer/vim-toggle-quickfix',
            lazy = true,
            keys = {
                {'<leader>q', '<Plug>window:quickfix:toggle', desc = 'toggle quickfix'},
                {'<leader>f', '<Plug>window:location:toggle', desc = 'toggle location list'},
            },
        },

        { 'windwp/nvim-autopairs',
            -- dependencies = 'nvim-treesitter',
            -- module = {'nvim-autopairs.completion.cmp', 'nvim-autopairs'},
            event = 'InsertEnter',
            config = function()
                require('nvim-autopairs').setup()
            end
        },

        { 'junegunn/fzf',
            lazy = true,
            -- fzf is loaded either by fzf to filter quickfix or caused by dependencies
            cmd = "FzfQF",
            build ='./install --completion --key-bindings --xdg --no-update-rc',
            config = function()
                vim.cmd("source $VIMHOME/quick-fzf.vim")
            end
        },

        { 'junegunn/fzf.vim',
            enabled = false,
            dependencies = {'fzf'},
            lazy = true,
            keys = function()
                ---@type LazyKeys[]
	            local ret = {}
                local prefix = '<space>'
	            for _, key in ipairs({ 'e', 'c', 'g', 'b', 'h', 'a', 'l', 'w', 't', 'm', 'r', 'x' }) do
                    ret[#ret + 1] = { prefix .. key, desc = key }
	            end
	            return ret
            end,
            config = function()
                local prefix = '<space>'
                vim.api.nvim_set_keymap('n', prefix ..'e', ':FZF<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix ..'c', ':FZF %:h<cr>', {noremap = true, silent = true})
                -- vim.api.nvim_set_keymap('n', prefix .. 'g', ':GFiles<cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', prefix .. 'b', ':Buffers<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'h', ':History', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'a', ':Lines<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'l', ':Blines<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'w', ':Lines <c-r><c-w><cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 't', ':BTags<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'm', ':Marks<cr>', {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', prefix .. 'r', ':Rg<space>', {noremap = true})
                vim.api.nvim_set_keymap('n', prefix .. 'x', ':Rg <c-r><c-w><cr>', {noremap = true, silent = true})
            end
        },

        --[[
        { 'nvim-telescope/telescope.nvim',
            dependencies = {
                {'nvim-lua/plenary.nvim',},
                {'nvim-telescope/telescope-fzf-native.nvim',
                    build ='make',
                }
            },
            config = function()
                require('config.telescope').setup()
            end
        },
        ]]

        { 'ibhagwan/fzf-lua',
            lazy = true,
            dependencies = {'fzf'},
            cmd = 'FzfLua',
            keys = {
                {';a', '<cmd>FzfLua lines<cr>', desc = 'open buffer lines'},
                {';b', '<cmd>FzfLua buffers<cr>',desc = 'open buffers'},
                {';s', ':FzfLua<space>', desc = 'FzfLua prompt'},
                {';f', '<cmd>FzfLua builtin<cr>', desc = 'FzfLua prompt'},
                {';e', '<cmd>FzfLua files<cr>', desc = 'find files'},
                {';t', '<cmd>FzfLua btags<cr>', desc = 'search buffer tags'},
                {';w', '<cmd>FzfLua grep_cword<cr>', desc = 'search word under cursor'},
                {';c', ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>', desc = 'find files with cwd'},
                {';d', ':FzfLua grep cwd=<C-R>=expand("%:h")<cr><cr>', desc = 'grep files with cwd'},
            },
            config = function()
                require('config.fzf-lua').setup()
            end
        },

        { 'trmckay/based.nvim',
           lazy = true,
           cmd = "BasedConvert",
           config = function()
               require('based').setup({})
           end,
        },

        --[[
        { 'kazhala/close-buffers.nvim',
            lazy = true,
            cmd = {"BDelete", "BWipeout"},
            keys = {'bd', 'bo'},
            config = function()
                require('close_buffers').setup()
                vim.api.nvim_set_keymap('n', 'bd', ':BDelete this<cr>', {silent = true, noremap = true})
                vim.api.nvim_set_keymap('n', 'bo', ':BDelete other<cr>', {silent = true, noremap = true})
            end
        },

        { 'jacquesbh/vim-showmarks',
            enabled = false,
            cmd = 'DoShowMarks', -- DoShowMarks to enable
        },
        ]]
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
                   nn - <Cmd>Hi/next<CR>
                   nn _ <Cmd>Hi/previous<CR>
                   nn f<left> <Cmd>Hi/older<cr>
                   nn f<right> <Cmd>Hi/newer<cr>
                ]]
            end,
            -- nn [<cr> <cmd>Hi {<cr>
            -- nn ]<cr> <cmd>Hi }<cr>

            -- f + <cr>: HiSet, hightlight current word
            -- f + <backspace>: HiErase
            -- f + <C-L>: HiClear
            -- f + tab: HiFind
            -- :Hi + <pattern>: highlight one pattern
            -- :Hi save <name>: save current highlight to file
        },

        { 'inkarkat/vim-mark',
            lazy = true,
            dependencies = {
                {'inkarkat/vim-ingo-library', lazy = true}
            },
            cmd = {
                'Mark',
                'MarkLoad',
                'MarkSave',
                --[[ '<Plug>MarkSet',
                '<Plug>MarkRegex',
                '<Plug>MarkSearchOrCurNext',
                '<Plug>MarkSearchOrCurPrev' ]]
            },
            keys = {
                {'<leader>m'},
                {'<leader>r'},
            },
            init = function()
                vim.g.mwDefaultHighlightingPalette = 'maximum'
                vim.g.mwHistAdd = '/@'
                vim.g.mw_no_mappings = 1
                vim.g.mwAutoLoadMarks = 0
            end,
            config = function()
                -- map {'n', '<Plug>IgnoreMarkSearchNext', '<Plug>MarkSearchNext', noremap = false}
                -- map {'n', '<Plug>IgnoreMarkSearchPrev', '<Plug>MarkSearchPrev', noremap = false}
                vim.api.nvim_set_keymap('n', '<leader>m', '<Plug>MarkSet', {noremap = false})
                vim.api.nvim_set_keymap('x', '<leader>m', '<Plug>MarkSet', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>MarkRegex', {noremap = false})
                vim.api.nvim_set_keymap('x', '<leader>r', '<Plug>MarkRegex', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>n', '<Plug>MarkClear', {noremap = false})
            end
        },

        { 'ethanholz/nvim-lastplace',
            config = function()
                require('nvim-lastplace').setup{
                    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
                    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
                    lastplace_open_folds = true
                }
            end
        },

        { "LunarVim/bigfile.nvim",
            init = function()
                require("bigfile").setup {
                    filesize = 20, -- size of the file in MiB, the plugin round file sizes to the closest MiB
                    pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
                    features = { -- features to disable
                      "indent_blankline",
                      "illuminate",
                      "lsp",
                      "treesitter",
                      "syntax",
                      "matchparen",
                      -- "vimopts",
                      "filetype",
                    },
                  }
            end
        },

        { 'mhinz/vim-hugefile',
            enabled = false,
           init = function()
               vim.g.hugefile_trigger_size = 150
           end
        },

        { 'matesea/vim-log-syntax',
            lazy = true,
            ft = {'log', 'text'}
        },

        { 'vivien/vim-linux-coding-style',
            lazy = true,
            ft = {'c', 'h', 'S'}
        },

        { 'Vimjas/vim-python-pep8-indent',
            lazy = true,
            ft = {'python'},
        },

        --[[
        { 'mbbill/undotree',
            enabled = false,
            cmd = 'UndotreeToggle',
            confing = function()
                vim.g.undotree_WindowLayout = 2
            end
        },]]

        { 'octol/vim-cpp-enhanced-highlight',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp'},
        },

        { 'echasnovski/mini.comment',
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

        { 'nathanaelkane/vim-indent-guides',
            lazy = true,
            ft = ft_code,
            init = function()
                vim.g.indent_guides_enable_on_vim_startup = 1
                vim.g.indent_guides_default_mapping = 0
                vim.g.indent_guides_tab_guides = 0
                vim.g.indent_guides_color_change_percent = 3
                vim.g.indent_guides_guide_size = 1
                vim.g.indent_guides_exclude_filetypes = {
                    'help', 'defx', 'denite', 'denite-filter', 'startify',
                    'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input',
                    'any-jump', 'gina-status', 'gina-commit', 'gina-log', 'terminal',
                    'fzf'
                }
            end
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
                -- za toggle fold, toggle it recursively
           },
        },

        -- 'tpope/vim-sensible',

        { 'ngemily/vim-vp4',
            lazy = true,
            cmd = { 'Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4'}
        },

        { 'nanotee/zoxide.vim',
            lazy = true,
            cmd = { 'Z', 'Zi', 'Lz', 'Lzi'},
            keys = {
                {'<leader>zz', ':Z<space>', desc = 'cd with zoxide'},
                {'<leader>zi', ':Zi<space>', desc = 'cd with zoxide+fzf'},
            },
        },

        { 'justinmk/vim-gtfo',
            lazy = true,
            keys = 'got',
        },

        { 'kevinhwang91/nvim-bqf',
           lazy = true,
           ft = 'qf',
           dependencies = {
               {'nvim-treesitter'},
           },
           config = function()
               require('bqf').setup({
                    func_map = {
                        -- remap c-k/c-j to pscrollup/pscrolldown to free c-b/c-f
                        pscrollup = '<C-k>',
                        pscrolldown = '<C-j>',
                    },
                    -- disable auto preview
                    --[[ preview = {
                        auto_preview = false
                    } ]]
                })
           end
        },

        { 'nathom/filetype.nvim',
            cond = is_neovim8(),
            config = function()
                require("filetype").setup({
                    overrides = {
                        extensions = {
                            log = "log",
                            txt = "log",
                        }
                    }
                })
               vim.cmd[[
                   syntax on
                   filetype plugin indent on
               ]]
            end
        },

        { 'JoosepAlviste/nvim-ts-context-commentstring',
            lazy = true,
            config = function()
                require('ts_context_commentstring').setup {}
            end
        },

        { 'nvim-treesitter/nvim-treesitter',
            lazy = true,
            -- event = 'BufRead',
            dependencies = {
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

        { 'nvim-treesitter/nvim-treesitter-context',
            lazy = true,
            ft = ft_code,
            config = function()
                require('treesitter-context').setup{
                      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                      line_numbers = true,
                      multiline_threshold = 20, -- Maximum number of lines to show for a single context
                      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                      mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
                      -- Separator between context and content. Should be a single character string, like '-'.
                      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                      separator = nil,
                      zindex = 20, -- The Z-index of the context window
                      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
                }
            end
        },

        { 'm-demare/hlargs.nvim',
             lazy = true,
             ft = ft_code,
             dependencies = {
                 {'nvim-treesitter'},
             },
             config = function()
                 require('hlargs').setup()
             end
        },

        { 'hrsh7th/nvim-cmp',
            lazy = true,
            dependencies = {
                {'hrsh7th/cmp-buffer', lazy = true},
                {'hrsh7th/cmp-path', lazy = true},
                {'hrsh7th/cmp-cmdline', lazy = true},
                {'andersevenrud/cmp-tmux', lazy = true},
                {'hrsh7th/cmp-vsnip', lazy = true},
                -- {'hrsh7th/vim-vsnip', lazy = true},
                -- {'saadparwaiz1/cmp_luasnip', dependencies = 'L3MON4D3/LuaSnip'},
                -- { 'quangnguyen30192/cmp-nvim-tags', lazy = true, ft = { 'c', 'h', 'python', 'cpp'}}
            },
            event = 'InsertEnter',
            config = function()
                require('config.cmp').setup()
            end
        },

        --[[
        { 'tanvirtin/vgit.nvim',
            enabled = false,
            event = 'BufWinEnter',
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            config = function()
                require('vgit').setup()
            end,
        },

        { 'gelguy/wilder.nvim',
            enabled = false,
            config = function()
                local wilder = require('wilder')
                wilder.setup({modes = { ':', '/', '?'}})
            end,
        },
        ]]

        { 'beauwilliams/focus.nvim',
            lazy = true,
            cmd = { "FocusSplitNicely", "FocusSplitCycle" , 'FocusEnable' },
            module = "focus",
            config = function()
                require("focus").setup({hybridnumber = false})
            end
        },

        { 'stevearc/aerial.nvim',
            lazy = true,
            dependencies = {
                {'nvim-treesitter'},
                {'fzf'},
            },
            cmd = { 'AerialToggle'},
            config = function()
                require("aerial").setup({
                    backends = {"treesitter"}
                })

                -- shortcut to find function in fzf mode
                -- faster than fzf.vim/fzf-lua BTags
                vim.keymap.set('n', ';z', '<cmd>call aerial#fzf()<cr>')
            end,
        },

        { 'matesea/trace32-practice.vim',
            lazy = true,
            ft = 'cmm',
        },

        { 'mtth/scratch.vim',
            lazy = true,
            cmd = { 'Scratch' },
        },

        { 'vim-scripts/scons.vim',
            lazy = true,
            ft = 'scons',
        },

        { "tpope/vim-surround" },

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

        { 'rainbowhxch/accelerated-jk.nvim',
            lazy = true,
            keys = {'j', 'k'},
            config = function()
                vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)')
                vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)')
            end
        },

        { 'rickhowe/spotdiff.vim',
           lazy = true,
           cmd = 'Diffthis',
        },

        { "olimorris/persisted.nvim",
            lazy = true,
            config = function()
                require("persisted").setup()
            end,
        },

        { 'echasnovski/mini.cursorword',
            version = false,
            ft = ft_code,
            config = function()
                require('mini.cursorword').setup()
            end
        },

        { 's1n7ax/nvim-window-picker',
            version = 'v1.*',
            keys = {'sp'},
            config = function()
                require'window-picker'.setup()
                vim.keymap.set("n", 'sp', function()
                    local picker = require('window-picker')
                    local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
                    vim.api.nvim_set_current_win(picked_window_id)
                end, { desc = "Pick a window" })
            end,
        },

        -- cscope/gtags for nvim 0.9+
        {
            'dhananjaylatkar/cscope_maps.nvim',
            lazy = true,
            keys = {
                {'<leader>cf', ':Cscope find<space>',
                    desc = 'trigger Cscope'},
                {'<leader>cs', ':Cscope find s <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all references to a token under cursor'},
                {'<leader>cg', ':Cscope find g <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find definition of the token under cursor'},
                {'<leader>cc', ':Cscope find c <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all calls to the function under cursor'},
                {'<leader>ct', ':Cscope find t <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all instances of the text under cursor'},
                {'<leader>ca', ':Cscope find a <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find functions that function under cursor calls'},
            },
            cmd = {'Cscope'},
            config = function()
                require('config.cscope_maps').setup()
            end,
        },

        { 'ggandor/leap.nvim',
            lazy = true,
            keys = {
                {'ss', '<Plug>(leap-forward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to'},
                {'sS', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to'},
                {'SS', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from window'},
            },
            config = true,
        },

	    { 'ggandor/flit.nvim',
            enabled = false,
            lazy = true,
	        keys = function()
                ---@type LazyKeys[]
	            local ret = {}
	            for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
                    ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
	            end
	            return ret
	        end,
	        opts = { labeled_modes = 'nx' },
	    },

        {
            "folke/flash.nvim",
            enabled = false,
            event = "VeryLazy",
            ---@type Flash.Config
            lazy = true,
            opts = {},
            keys = {
                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            },
        },
        --[[

        { 'skywind3000/vim-preview',
            lazy = true,
            cmd = { 'PreviewQuickfix', 'PreviewSignature'},
        },

        { 'folke/which-key.nvim',
            event = "VeryLazy",
            init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
            end,
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        },
        ]]
    }

    lazy_init()
    local lazy = require 'lazy'
    lazy.setup(plugins)
end

return M
