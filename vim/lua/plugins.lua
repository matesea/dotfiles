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
                {'SS', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to'},
                {'gs', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from window'},
            },
            config = true,
        },

        { 'ggandor/flit.nvim',
            lazy = true,
            dependencies = 'ggandor/leap.nvim',
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


        { 'justinmk/vim-gtfo',
            lazy = true,
            keys = 'got',
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

        {  "lukas-reineke/indent-blankline.nvim",
            lazy = true,
            ft = ft_code,
            main = "ibl",
            ---@module "ibl"
                ---@type ibl.config
            opts = {},
        },

        { 'bronson/vim-trailing-whitespace',
            lazy = true,
            enabled = false,
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

        { 'nvim-mini/mini.bufremove',
            version = false,
            lazy = true,
            keys = {
                {'bd', mode = 'n', function() require("mini.bufremove").wipeout() end,
                    desc = 'wipeout buffer'
                },
            },
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

        { 'stevearc/qf_helper.nvim',
            ft = 'qf',
            keys = {
                {'<leader>q', '<cmd>QFToggle!<cr>', desc = 'toggle quickfix'},
                {']q', '<cmd>QNext<cr>', desc = 'next quickfix/location list item'},
                {'[q', '<cmd>QPrev<cr>', desc = 'previous quickfix/location list item'},
            },
            config = true,
        },

        { "yorickpeterse/nvim-pqf",
            event = 'UIEnter',
            config = true,
        },

        { 'nvim-mini/mini.pairs',
            version = false,
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
            -- url = 'https://gitlab.com/ibhagwan/fzf-lua', -- XXX: github fzf-lua not found
            lazy = true,
            dependencies = {'fzf'},
            cmd = 'FzfLua',
            keys = {
                {';a', '<cmd>FzfLua lines<cr>', desc = 'all buffer lines'},
                {';b', '<cmd>FzfLua buffers<cr>',desc = 'open buffers'},
                {';c', ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>', desc = 'find files with cwd'},
                {';d', function()
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

                {';e', '<cmd>FzfLua files<cr>', desc = 'find files'},

                {';f', '<cmd>FzfLua builtin<cr>', desc = 'pick fzf-lua builtin'},
                {';g', '<cmd>FzfLua live_grep_native<cr>', desc = 'live grep'},
                {';h', '<cmd>FzfLua oldfiles<cr>', desc = 'choose file from history'},
                {';j', '<cmd>FzfLua jumps<cr>', desc = 'pick from jumps'},
                {';q', '<cmd>FzfLua quickfix<cr>', desc = 'pick from quickfix'},
                {';r', '<cmd>FzfLua registers<cr>', desc = 'pick from registers'},
                {';s', '<cmd>FzfLua tagstack<cr>', desc = 'pick tagstack'},

                {';t', '<cmd>FzfLua btags<cr>', desc = 'search buffer tags'},
                {';T', '<cmd>FzfLua tags_live_grep<cr>', desc = 'search all tags'},

                {';w', '<cmd>FzfLua grep_cword<cr>', desc = 'search word under cursor'},
                {';z', '<cmd>FzfLua zoxide<cr>', desc = 'jump directory with zoxide'},
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

        {
            "gennaro-tedesco/nvim-possession",
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

        { 'nvim-mini/mini.indentscope',
            version = false,
            ft = ft_code,
            keys = {
                {'<leader>iu', mode = 'n', function() require("mini.indentscope").undraw() end, desc = 'undraw indentscope'},
            },
            config = function()
                require('mini.indentscope').setup{}
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
            lazy = true,
            dependencies = {
                -- nvim-cmp source for buffer words
                'hrsh7th/cmp-buffer',
                -- nvim-cmp source for path
                'hrsh7th/cmp-path',
                -- Tmux completion source for nvim-cmp
                'andersevenrud/cmp-tmux',
                -- rip grep source
                "lukas-reineke/cmp-rg",
            },
            event = 'InsertEnter',
            opts = function()
                vim.api.nvim_set_hl(
                    0,
                    'CmpGhostText',
                    { link = 'Comment', default = true }
                )
                local cmp = require('cmp')
                local defaults = require('cmp.config.default')()
                local completion_labels = {
                    buffer   = "[Buf]",
                    path     = "[Path]",
                    tmux     = "[Tmux]",
                    rg       = "[Rg]",
                }

                local function has_words_before()
                    if vim.bo.buftype == 'prompt' then
                        return false
                    end
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    -- stylua: ignore
                    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
                end

                local all_sources = {
                    { name = 'path', priority = 40 },
                    { name = 'buffer', priority = 50, keyword_length = 3, option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
                    { name = 'rg', priority = 10, label = 'rg' },
                    {
                        name = 'tmux',
                        priority = 10,
                        option = { all_panes = true, label = 'tmux' },
                    },
                }

                local tooBig = function(bufnr)
                    local max_filesize = 512 * 1024 -- 512KB
                    local check_stats = vim.loop.fs_stat
                    local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    else
                        return false
                    end
                end

                local choose_sources = function(bufnr)
                    if tooBig(bufnr) then
                        return {}
                    end
                    return all_sources
                end

                vim.api.nvim_create_autocmd("BufReadPre", {
                    callback = function(ev)
                        local sources = choose_sources(ev.buf)
                        if not tooBig(ev.buf) then
                            -- insert additional completion sources if file is not too big
                            cmp.setup.cmdline(':', {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = cmp.config.sources({
                                    { name = 'buffer', priority = 50, keyword_length = 3, option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
                                    { name = 'path', priority = 40 },
                                    {
                                        name = 'tmux',
                                        priority = 10,
                                        option = { all_panes = true, label = 'tmux' },
                                    },
                                })
                            })
                            cmp.setup.cmdline({'/', '?'}, {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = cmp.config.sources({
                                    { name = 'buffer', priority = 50, keyword_length = 3, option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
                                    {
                                        name = 'tmux',
                                        priority = 10,
                                        option = { all_panes = true, label = 'tmux' },
                                    },
                                })
                            })
                        end
                        cmp.setup.buffer({
                            sources = cmp.config.sources(sources),
                        })
                    end,
                })

                return {
                    sorting = defaults.sorting,
                    experimental = {
                        ghost_text = {
                            hl_group = 'Comment',
                        },
                    },
                    completion = {
                        completeopt = 'menu,menuone,noinsert'
                            .. (auto_select and '' or ',noselect'),
                    },
                    preselect = auto_select and cmp.PreselectMode.Item
                        or cmp.PreselectMode.None,
                    view = {
                        entries = {follow_cursor = true},
                    },
                    sources = cmp.config.sources(choose_sources(vim.api.nvim_get_current_buf())),
                    performance = {
                        max_view_entries = 20,
                    },
                    mapping = cmp.mapping.preset.insert({
                        -- <CR> accepts currently selected item.
                        -- Set `select` to `false` to only confirm explicitly selected items.
                        ['<CR>'] = cmp.mapping.confirm({ select = false }),
                        ['<S-CR>'] = cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        }),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-n>'] = cmp.mapping.select_next_item({
                            behavior = cmp.SelectBehavior.Insert,
                        }),
                        ['<C-p>'] = cmp.mapping.select_prev_item({
                            behavior = cmp.SelectBehavior.Insert,
                        }),
                        --[[ disable c-k/c-j select to not conflict with vim-tmux-navigator
                        ['<C-j>'] = cmp.mapping.select_next_item({
                            behavior = cmp.SelectBehavior.Insert,
                        }),
                        ['<C-k>'] = cmp.mapping.select_prev_item({
                            behavior = cmp.SelectBehavior.Insert,
                        }),
                        ]]
                        ['<C-d>'] = cmp.mapping.select_next_item({ count = 5 }),
                        ['<C-u>'] = cmp.mapping.select_prev_item({ count = 5 }),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-c>'] = function(fallback)
                            cmp.close()
                            fallback()
                        end,
                        ['<Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            elseif has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                    }),
                    formatting = {
                        format = function(entry, vim_item)
                            -- Set menu source name
                            vim_item.kind = vim_item.kind
                            if completion_labels[entry.source.name] then
                                vim_item.menu = completion_labels[entry.source.name]
                            end

                            vim_item.dup = ({
                                nvim_lua = 0,
                                buffer = 0,
                            })[entry.source.name] or 1

                            return vim_item
                        end,
                    },
                }
            end,
            ---@param opts cmp.ConfigSchema
            config = function(_, opts)
                for _, source in ipairs(opts.sources) do
                    source.group_index = source.group_index or 1
                end
                require('cmp').setup(opts)
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
            lazy = true,
            event = 'VeryLazy',
            dependencies = {'mini.icons'},
            config = function()
                local helpers = require 'incline.helpers'
                local mini_icons = require 'mini.icons'
                require('incline').setup {
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

        { 'beauwilliams/focus.nvim',
            lazy = true,
            cmd = { "FocusSplitNicely", "FocusSplitCycle" , 'FocusToggle' },
            module = "focus",
            dependencies = {
                'levouh/tint.nvim',
            },
            keys = {
                {'<leader>fn', '<cmd>FocusSplitNicely<cr>', 'split focus nicely'}
            },
            config = function()
                require("focus").setup({hybridnumber = false})
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
        {
            'AndrewRadev/linediff.vim',
            lazy = true,
            cmd = { 'Linediff', 'LinediffAdd' },
            keys = {
                { '<leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
                { '<leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
                { '<leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
                { '<leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
            },
        },

        { 'echasnovski/mini.cursorword',
            version = false,
            ft = ft_code,
            config = function()
                require('mini.cursorword').setup()
            end
        },

        { 's1n7ax/nvim-window-picker',
            version = '2.*',
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

        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {},
            -- stylua: ignore
            keys = {
                { '<Leader>ua', 'ga', desc = 'Show character under cursor' },
                { 'ga', function() require('harpoon'):list():add() end, desc = 'Add location' },
                { '<C-e>', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
                { '<C-n>', function() require('harpoon'):list():next() end, desc = 'Next location' },
                { '<C-p>', function() require('harpoon'):list():prev() end, desc = 'Previous location' },
                { '<Leader>mr', function() require('harpoon'):list():remove() end, desc = 'Remove location' },
                { '<Leader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon select 1' },
                { '<Leader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon select 2' },
                { '<Leader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon select 3' },
                { '<Leader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon select 4' },
            },
        },

        { 'westeri/asl-vim',
            lazy = true,
            ft = 'asl',
        },

        {
            "christoomey/vim-tmux-navigator",
            cmd = {
              "TmuxNavigateLeft",
              "TmuxNavigateDown",
              "TmuxNavigateUp",
              "TmuxNavigateRight",
              "TmuxNavigatePrevious",
            },
            keys = {
              { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
              { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
              { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
              { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
              { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
            },
        },

        -- jk to escape
        { "max397574/better-escape.nvim",
            config = function()
              require("better_escape").setup{}
            end,
        },

        -- gb to start, j{l/c/r} to align
        {
            'echasnovski/mini.align',
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

        {
            'pechorin/any-jump.vim',
            cmd = { 'AnyJump', 'AnyJumpVisual' },
            keys = {
                { '<leader>ii', '<cmd>AnyJump<CR>', desc = 'Any Jump' },
                { '<leader>ii', '<cmd>AnyJumpVisual<CR>', mode = 'x', desc = 'Any Jump' },
                { '<leader>ib', '<cmd>AnyJumpBack<CR>', desc = 'Any Jump Back' },
                { '<leader>il', '<cmd>AnyJumpLastResults<CR>', desc = 'Any Jump Resume' },
            },
            config = function()
                vim.g.any_jump_disable_default_keybindings = 1
                vim.api.nvim_create_autocmd('FileType', {
                    group = vim.api.nvim_create_augroup('rafi.any-jump', {}),
                    pattern = 'any-jump',
                    callback = function()
                        vim.opt.cursorline = true
                    end,
                })
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
    }


    lazy_init()
    local lazy = require 'lazy'
    lazy.setup(plugins)
end

return M
