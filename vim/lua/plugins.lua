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

    --[[
    local disabled = {
        'tpope/vim-sensible',

        { 'windwp/nvim-autopairs',
            -- dependencies = 'nvim-treesitter',
            -- module = {'nvim-autopairs.completion.cmp', 'nvim-autopairs'},
            event = 'InsertEnter',
            config = function()
                require('nvim-autopairs').setup()
            end
        },

        { 'tanvirtin/vgit.nvim',
            event = 'BufWinEnter',
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            config = function()
                require('vgit').setup()
            end,
        },

        { 'gelguy/wilder.nvim',
            config = function()
                local wilder = require('wilder')
                wilder.setup({modes = { ':', '/', '?'}})
            end,
        },

        { 'mbbill/undotree',
            cmd = 'UndotreeToggle',
            confing = function()
                vim.g.undotree_WindowLayout = 2
            end
        },

        {'rhysd/git-messenger.vim',
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

        { 'ap/vim-buftabline',
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
        },

        { 'junegunn/fzf.vim',
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
            cmd = 'DoShowMarks', -- DoShowMarks to enable
        },

        { 'mhinz/vim-hugefile',
           init = function()
               vim.g.hugefile_trigger_size = 150
           end
        },

        { "tpope/vim-surround" },

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
                    preview = {
                        auto_preview = false
                    }
                })
           end
        },

        { "ashfinal/qfview.nvim",
            lazy = true,
            ft = 'qf',
            config = true,
        },

        { 'drmingdrmer/vim-toggle-quickfix',
            lazy = true,
            keys = {
                {'<leader>q', '<Plug>window:quickfix:toggle', desc = 'toggle quickfix'},
                {'<leader>f', '<Plug>window:location:toggle', desc = 'toggle location list'},
            },
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
                -- '<Plug>MarkSet',
                -- '<Plug>MarkRegex',
                -- '<Plug>MarkSearchOrCurNext',
                -- '<Plug>MarkSearchOrCurPrev'
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

    }
    ]]

    local plugins = {
        { "fabius/molokai.nvim",
            dependencies = "rktjmp/lush.nvim",
            lazy = true,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme 'molokai'
            end
        },

        {'tanvirtin/monokai.nvim',
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
                vim.cmd("colorscheme kanagawa")
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
            cmd = {'Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame', 'GV', 'Gcd'},
        },

        { 'FabijanZulj/blame.nvim',
            lazy = true,
            cmd = 'ToggleBlame',
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

        { 'stevearc/qf_helper.nvim',
            ft = 'qf',
            keys = {
                {'<leader>q', '<cmd>QFToggle!<cr>', desc = 'toggle quickfix'},
                {'<leader>f', '<cmd>LLToggle!<cr>', desc = 'toggle location list'},
                {']q', '<cmd>QNext<cr>', desc = 'next quickfix/location list item'},
                {'[q', '<cmd>QPrev<cr>', desc = 'previous quickfix/location list item'},
            },
            config = true,
        },

        { "yorickpeterse/nvim-pqf",
            event = 'UIEnter',
            config = true,
        },

        { 'echasnovski/mini.pairs',
            event = 'InsertEnter',
            opts = {}
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

        { 'ibhagwan/fzf-lua',
            lazy = true,
            dependencies = {'fzf'},
            cmd = 'FzfLua',
            keys = {
                {';a', '<cmd>FzfLua lines<cr>', desc = 'all buffer lines'},
                {';b', '<cmd>FzfLua buffers<cr>',desc = 'open buffers'},
                {';c', ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>', desc = 'find files with cwd'},
                {';d', ':FzfLua live_grep_native cwd=<C-R>=expand("%:h")<cr><cr>', desc = 'grep files with cwd'},
                {';e', '<cmd>FzfLua files<cr>', desc = 'find files'},
                {';f', '<cmd>FzfLua builtin<cr>', desc = 'pick fzf-lua builtin'},
                {';g', '<cmd>FzfLua live_grep_native<cr>', desc = 'live grep'},
                {';h', '<cmd>FzfLua oldfiles<cr>', desc = 'choose file from history'},
                {';j', '<cmd>FzfLua jumps<cr>', desc = 'pick from jumps'},
                {';l', '<cmd>FzfLua blines<cr>', desc = 'current buffer lines'},
                {';q', '<cmd>FzfLua quickfix<cr>', desc = 'pick from quickfix'},
                {';s', '<cmd>FzfLua tagstack<cr>', desc = 'pick tagstack'},
                {';t', '<cmd>FzfLua btags<cr>', desc = 'search buffer tags'},
                {';w', '<cmd>FzfLua grep_cword<cr>', desc = 'search word under cursor'},
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
            keys = {
                {']a', '<cmd>AerialNext<cr>', desc = '[Aerial]jump to next symbol'},
                {'[a', '<cmd>AerialPrev<cr>', desc = '[Aerial]jump to prevoius symbol'},
                {'<leader>a', '<cmd>AerialToggle<cr>', desc = 'toggle Aerial window'},
                {';z', '<cmd> call aerial#fzf()<cr>', desc = 'choose symbol with fzf'}
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

        { 'mtth/scratch.vim',
            lazy = true,
            cmd = { 'Scratch' },
        },

        { 'vim-scripts/scons.vim',
            lazy = true,
            ft = 'scons',
        },

        { 'echasnovski/mini.surround',
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

        { 'rainbowhxch/accelerated-jk.nvim',
            lazy = true,
            keys = {
                {'j', '<Plug>(accelerated_jk_gj)', desc = 'accelerated j'},
                {'k', '<Plug>(accelerated_jk_gk)', desc = 'accelerated k'},
            },
            opts = {},
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

        { "folke/flash.nvim",
            -- event = "VeryLazy",
            ---@type Flash.Config
            lazy = true,
            opts = {},
            keys = {
                { "ss", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            },
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
    }

    if ver.major >= 1 or ver.minor >= 9 then
        -- cscope/gtags for nvim 0.9+
        table.insert(plugins,
            { 'dhananjaylatkar/cscope_maps.nvim',
            lazy = true,
            keys = {
                {'<leader>cf', ':Cscope find<space>', desc = 'trigger Cscope'},
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
        })
    else
        table.insert(plugins,
            { 'joereynolds/gtags-scope',
            lazy = true,
            cmd = {'GtagsCscope'},
            keys = {
                {'<leader>cf', ':cscope find<space>', desc = 'trigger Cscope'},
                {'<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all references to a token under cursor'},
                {'<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find definition of the token under cursor'},
                {'<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all calls to the function under cursor'},
                {'<leader>ct', ':cscope find t <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find all instances of the text under cursor'},
                {'<leader>ca', ':cscope find a <C-R>=expand("<cword>")<cr><cr>',
                    desc = 'find functions that function under cursor calls'},
            },
            config = function()
                require('config.gtags').setup()
            end
        })
        table.insert(plugins,
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
            })
    end

    lazy_init()
    local lazy = require 'lazy'
    lazy.setup(plugins)
end

return M
