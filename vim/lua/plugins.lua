local M = {}

function M.setup()

    --[[ local conf = {
       profile = {
         enabled = true,
         threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
       },

       display = {
         open_fn = function()
           return require("packer.util").float { border = "rounded" }
         end,
       },
        -- Move to lua dir so impatient.nvim can cache it
        compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
    }

     -- Check if packer.nvim is installed
     -- Run PackerCompile if there are changes in this file
     local function packer_init()
       local fn = vim.fn
       local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
       if fn.empty(fn.glob(install_path)) > 0 then
         packer_bootstrap = fn.system {
           "git",
           "clone",
           "--depth",
           "1",
           "https://github.com/wbthomason/packer.nvim",
           install_path,
         }
         vim.cmd {packadd packer.nvim}
       end
       vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
     end ]]

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

    local plugins = {
        -- 'lewis6991/impatient.nvim',

        -- 'wbthomason/packer.nvim',

        {'tamelion/neovim-molokai',
            config = function()
                vim.cmd('colorscheme molokai')
            end
        },
        --[[ {'rebelot/kanagawa.nvim',,
           lazy = true,
           config = function()
                vim.cmd("colorscheme kanagawa")
           end
        }]]

        'tpope/vim-fugitive',

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

        {'junegunn/gv.vim',
            lazy = true,
            cmd = 'GV'
        },

        {'echasnovski/mini.tabline',
           config = function()
               require('mini.tabline').setup({
                   show_icons = false
               })
           end
        },
        --[[
        use {'ap/vim-buftabline',
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

        {'bronson/vim-trailing-whitespace',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua', 'java'},
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
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua', 'java'},
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

        {'joereynolds/gtags-scope',
            lazy = true,
            cmd = {'GtagsCscope',},
            config = function()
                require('config.gtags').setup()
            end
        },

        {'drmingdrmer/vim-toggle-quickfix',
            lazy = true,
            --[[ cmd = {
                '<Plug>window:quickfix:toggle',
                '<Plug>window:location:toggle'
            }, ]]
            keys = {
                '<leader>q',
                '<leader>f',
            },
            config = function()
                vim.api.nvim_set_keymap('n', '<leader>q', '<Plug>window:quickfix:toggle', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>window:location:toggle', {noremap = false})
            end
        },

        {'windwp/nvim-autopairs',
            -- dependencies = 'nvim-treesitter',
            -- module = {'nvim-autopairs.completion.cmp', 'nvim-autopairs'},
            event = 'InsertEnter',
            config = function()
                require('nvim-autopairs').setup()
            end
        },

        {'junegunn/fzf.vim',
            dependencies = {'junegunn/fzf',
                build ='./install --completion --key-bindings --xdg --no-update-rc'
            },
            event = 'BufEnter',
            -- config = function()
            --     vim.cmd[[let g:fzf_layout = {'down': '~40%'}]]
            -- end
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
            dependencies = {'junegunn/fzf',
                build ='./install --completion --key-bindings --xdg --no-update-rc'
            },
            cmd = {'FzfLua'},
            config = function()
                require('config.fzf-lua').setup()
            end
        },

        --[[
        { 'mileszs/ack.vim',
            enabled = false,
            config = function()
                vim.g.ackprg = 'rg -S --vimgrep --no-heading --no-column'
                vim.g.ackhighlight = 1
            end
        },

        { 'jesseleite/vim-agriculture',
           enabled = false,
           cmd = 'RgRaw',
        },]]

        {'trmckay/based.nvim',
           lazy = true,
           cmd = "BasedConvert",
           config = function()
               require('based').setup({})
           end,
        },

        {'kazhala/close-buffers.nvim',
            lazy = true,
            cmd = {"BDelete", "BWipeout"},
            keys = {'bd', 'bo'},
            config = function()
                require('close_buffers').setup()
                vim.api.nvim_set_keymap('n', 'bd', ':BDelete this<cr>', {silent = true, noremap = true})
                vim.api.nvim_set_keymap('n', 'bo', ':BDelete other<cr>', {silent = true, noremap = true})
            end
        },

        { 'ggandor/leap.nvim',
            lazy = true,
            keys = {'s', 'S', 'f', 'F', 't', 'T'},
            config = function()
                leap = require('leap')
                leap.setup {
                    case_insensitive = true,
                }
                leap.set_default_keymaps()
            end
        },
        --[[
        {'ggandor/lightspeed.nvim',
           enabled = false,
           keys = {'s', 'S', 'f', 'F', 't', 'T'},
           config = function()
               require('lightspeed').setup {}
           end
       },

        {'jacquesbh/vim-showmarks',
            enabled = false,
            cmd = 'DoShowMarks', -- DoShowMarks to enable
        },
        {'chentoast/marks.nvim', enabled = false},
        ]]

        { 'azabiong/vim-highlighter',
            -- lazy = true,
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

        {'inkarkat/vim-mark',
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

        -- use 'farmergreg/vim-lastplace'
        {'ethanholz/nvim-lastplace',
            config = function()
                require('nvim-lastplace').setup{
                    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
                    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
                    lastplace_open_folds = true
                }
            end
        },

        --[[
        {'liuchengxu/vista.vim',
            enabled = false,
            cmd = 'Vista',
            config = function()
                g.vista_fzf_preview = {'right:50%'}
            end
        },]]

        {'mhinz/vim-hugefile',
           -- doesn't trigger if setting lazy = true
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
            ft = {'c', 'h', 'S', 'cpp'}
        },

        { 'b3nj5m1n/kommentary',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua', 'java'}
        },

        {'nathanaelkane/vim-indent-guides',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'lua'},
            init = function()
                vim.g.indent_guides_enable_on_vim_startup = 1
                vim.g.indent_guides_default_mapping = 0
                vim.g.indent_guides_tab_guides = 0
                vim.g.indent_guides_color_change_percent = 3
                vim.g.indent_guides_guide_size = 1
                vim.g.indent_guides_exclude_filetypes = {
                    'help', 'defx', 'denite', 'denite-filter', 'startify',
                    'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input',
                    'any-jump', 'gina-status', 'gina-commit', 'gina-log'
                }
            end
        },

        {'dstein64/vim-startuptime',
            lazy = true,
            cmd = 'StartupTime'
        },

        --[[
        use {'rhysd/accelerated-jk',
           enabled = false,
            config = function()
                vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {silent = true, noremap = false})
                vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {silent = true, noremap = false})
            end
        }
        ]]

        'romainl/vim-cool',

        {'embear/vim-foldsearch',
            lazy = true,
            cmd = {
                'Fp',  -- Show the lines that contain the given regular expression
                'Fw',  -- Show lines which contain the word under the cursor
                'Fs'   -- Show lines which contain previous search pattern
                -- zE to clear all fold
           },
        },

        -- use 'machakann/vim-sandwich'

        'tpope/vim-sensible',

        {'ngemily/vim-vp4',
            lazy = true,
            cmd = {'Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4'}
        },

        {'nanotee/zoxide.vim',
            lazy = true,
            cmd = {'Z', 'Zi', 'Lz', 'Lzi'}
        },

        {'justinmk/vim-gtfo',
            lazy = true,
            keys = 'got',
        },

        {'kevinhwang91/nvim-bqf',
           lazy = true,
           ft = 'qf',
           dependencies = {
               {'nvim-treesitter/nvim-treesitter', lazy = true},
           },
           config = function()
               require('bqf').setup()
           end
        },
        {'nathom/filetype.nvim',
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
        {'nvim-treesitter/nvim-treesitter',
            lazy = true,
            -- event = 'BufRead',
            build =function()
               local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
               ts_update()
           end,
           config = function()
               require('config.treesitter')
           end
        },

        { 'lewis6991/nvim-treesitter-context',
            lazy = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'lua', 'java'},
            dependencies = {
                {'nvim-treesitter/nvim-treesitter', lazy = true},
            },
            config = function()
                require('treesitter-context').setup{
                    enabled = true,
                    throttle = true,
                }
            end
        },
        { 'm-demare/hlargs.nvim',
             lazy = true,
             ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua', 'java'},
             dependencies = {
                 {'nvim-treesitter/nvim-treesitter', lazy = true},
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
                {'hrsh7th/cmp-vsnip', lazy = true},
                {'hrsh7th/vim-vsnip', lazy = true},
                {'andersevenrud/cmp-tmux', lazy = true},
                -- {'quangnguyen30192/cmp-nvim-tags', lazy = true, ft = {'c', 'h', 'python', 'cpp'}}
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
        { 'beauwilliams/focus.nvim',
            enabled = false,
            cmd = { "FocusSplitNicely", "FocusSplitCycle" },
            module = "focus",
            config = function()
                require("focus").setup({hybridnumber = true})
            end
        },

        {'gelguy/wilder.nvim',
            enabled = false,
            config = function()
                local wilder = require('wilder')
                wilder.setup({modes = {':', '/', '?'}})
            end,
        },
        ]]
        {'stevearc/aerial.nvim',
            lazy = true,
             dependencies = {
                 {'nvim-treesitter/nvim-treesitter', lazy = true},
             },
            cmd = {'AerialToggle'},
            config = function()
                require("aerial").setup({
                    backends = {"treesitter"}
                })
            end,
        },
        { 'matesea/trace32-practice.vim',
            lazy = true,
            ft = {'cmm'}
        },
        { 'vim-scripts/Quich-Filter',
            enabled = false,
            config = function()
                vim.cmd[[
                   nnoremap ,f :call FilteringNew().addToParameter('alt', @/).run()<CR>
                   nnoremap ,F :call FilteringNew().parseQuery(input('>'), '|').run()<CR>
                   nnoremap ,g :call FilteringGetForSource().return()<CR>
                ]]
            end
        },

        -- use {'mtth/scratch.vim'}
        {'vim-scripts/scons.vim', lazy = true, ft = {'scons'}},
        {"tpope/vim-surround"},

        {'neovim/nvim-lspconfig',
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
        {'rainbowhxch/accelerated-jk.nvim',
            config = function()
                vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)')
                vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)')
            end
        },
        {'rickhowe/spotdiff.vim',
           lazy = true,
           cmd = 'Diffthis',
        },
        { "nvim-tree/nvim-web-devicons", lazy = true },
    }

    lazy_init()
    local lazy = require 'lazy'

    -- pcall(require, 'impatient')

    -- lazy.init(conf)
    lazy.setup(plugins)

    -- load packer_compiled with lua cache impatient
    -- pcall(require, 'packer_compiled')
end

return M
