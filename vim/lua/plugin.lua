local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g     -- global variable
local opt = vim.opt -- global options

-- help function to map keys
local map = function(key)
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end

require('impatient')

local packer_install_dir = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

local plug_url_format = ''
-- if vim.g.is_linux > 0 then
  plug_url_format = 'https://hub.fastgit.org/%s'
-- else
--  plug_url_format = 'https://github.com/%s'
-- end

local packer_repo = string.format(plug_url_format, 'wbthomason/packer.nvim')
local install_cmd = string.format('10split |term git clone --depth=1 %s %s', packer_repo, packer_install_dir)

if fn.empty(fn.glob(packer_install_dir)) > 0 then
  vim.api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
  execute(install_cmd)
  execute 'packadd packer.nvim'
end

cmd [[packadd packer.nvim]]
-- workaround: nvim-yarp autoload vimscript not loaded
cmd [[packadd nvim-yarp]]

require('packer').startup{function()
        use {
            'lewis6991/impatient.nvim',
            -- config = function() require('impatient') end
        }

        use 'wbthomason/packer.nvim'

        use {'tamelion/neovim-molokai',
            config = function()
                vim.cmd('colorscheme molokai')
            end
        }
        --[[
        use {
            'tanvirtin/monokai.nvim',
            disable = true,
            config = function()
                require('monokai').setup {}
            end
        }

        use {'mhinz/vim-signify',
            config = function()
                vim.api.nvim_set_keymap('n', ']c', '<plug>(signify-next-hunk)', {silent = true, noremap = false})
                vim.api.nvim_set_keymap('n', '[c', '<plug>(signify-prev-hunk)', {silent = true, noremap = false})
            end
        }
        ]]--

        use {
            'lewis6991/gitsigns.nvim',
            requires = {
                'nvim-lua/plenary.nvim'
            },
            config = function()
                require('gitsigns').setup()
                vim.opt.updatetime = 300
            end
        }

        use {
            'tpope/vim-fugitive',
            opt = true,
            cmd = {'Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame'}
        }

        --[[
        use {'junegunn/gv.vim',
            opt = true,
            requires = {
                {
                    'tpope/vim-fugitive',
                    opt = true,
                    cmd = {'Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame', 'GV'}
                },
            },
            cmd = 'GV'
        }
        ]]--

        --[[
        use {
            'beauwilliams/statusline.lua',
            requires = {
                {'kyazdani42/nvim-web-devicons'},
                {'ryanoasis/vim-devicons'}
            },
        }
        local statusline = require('statusline')
        statusline.tabline = false
        statusline.lsp_diagnostics = false
        statusline.ale_diagnostics = false
        --]]

        use {'nvim-lualine/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true},
            config = function()
                require('lualine').setup{
                    options = {theme = 'ayu_dark'},
                }
            end
        }
        -- use 'lukelbd/vim-statusline'

        use {'ap/vim-buftabline',
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

        use 'bronson/vim-trailing-whitespace'
        g.extra_whitespace_ignored_filetypes = {
            'diff',
            'gitcommit',
            'unite',
            'qf',
            'help',
            'markdown',
            'log',
            'text'
        }

        use {'joereynolds/gtags-scope',
            opt = true,
            cmd = 'GtagsCscope',
            setup = function()
                vim.opt.csto = 0
                -- show msg when any other cscope db added
                vim.opt.cscopeverbose = true
                -- display result in quickfix
                vim.opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
                vim.opt.cscoperelative = true
            end,
            config = function()
                vim.api.nvim_set_keymap('n', '<leader>cf', ':cscope find<space>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<leader>ca', ':cscope add<space>', {noremap = true})
            end
        }

        use {'drmingdrmer/vim-toggle-quickfix',
            opt = true,
            cmd = {
                '<Plug>window:quickfix:toggle',
                '<Plug>window:location:toggle'
            },
            keys = {
                {'n', '<leader>q'},
                {'n', '<leader>l'},
            },
            config = function()
                vim.api.nvim_set_keymap('n', '<leader>q', '<Plug>window:quickfix:toggle', {noremap = false})
                vim.api.nvim_set_keymap('n', '<leader>l', '<Plug>window:location:toggle', {noremap = false})
            end
        }

        -- use 'jiangmiao/auto-pairs'
        use {'windwp/nvim-autopairs',
            config = function()
                require('nvim-autopairs').setup()
            end
        }

        use {'junegunn/fzf.vim',
            requires = {'junegunn/fzf',
                run = './install --completion --key-bindings --xdg --no-update-rc'
            }
        }
        -- plugin fzf.vim
        map {'n', ';e', ':FZF<cr>'}
        map {'n', ';c', ':FZF %:h<cr>'}
        map {'n', ';g', ':GFiles<cr>'}
        map {'n', ';b', ':Buffers<cr>'}
        map {'n', ';h', ':History'}
        map {'n', ';a', ':Lines<cr>'}
        map {'n', ';l', ':Blines<cr>'}
        map {'n', ';w', ':Blines <c-r><c-w><cr>'}
        map {'n', ';t', ':BTags<cr>'}
        map {'n', ';m', ':Marks<cr>'}
        map {'n', ';rg', ':Rg<space>'}
        map {'n', ';rw', ':Rg <c-r><c-w><cr>'}
        -- map {'n', ';rc', ':Rc<space>'}
        -- g.fzf_layout = {'down': '~40%'}

        -- alternative to fzf.vim
        -- use {'camspiers/snap'}

        -- alternative to fzf.vim
        use {
            'nvim-telescope/telescope.nvim',
            disable = true,
            requires = {
                {'nvim-lua/plenary.nvim',
                    disable = true,
                },
                {'nvim-telescope/telescope-fzf-native.nvim',
                    disable = true,
                    run = 'make',
                }
            },
            config = function()
                require('telescope').load_extension('fzf')
                vim.api.nvim_set_keymap('n', '<space>e', '<cmd>Telescope find_files<cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<space>g', '<cmd>Telescope live_grep<cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<space>b', '<cmd>Telescope buffers<cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<space>h', '<cmd>Telescope command_history<cr>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<space>a', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {noremap = true})
                vim.cmd[[
                    autocmd FileType TelescopePrompt call ncm2#disable_for_buffer()
                    ]]
            end
        }

        use { 'ibhagwan/fzf-lua',
            disable = true,
            requires = {
                {'vijaymarupudi/nvim-fzf',
                    opt = true,
                },
                {'kyazdani42/nvim-web-devicons',
                    opt = true,
                },
            },
            config = function()
                vim.api.nvim_set_keymap('n', '<space>e', "<cmd>lua require('fzf-lua').files({files = {cmd = '(global -Pol || rg --no-messages --files --no-ignore) 2>/dev/null'}})<cr>",
                    {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', '<space>c', "<cmd>lua require('fzf-lua').files({cwd = %:h, files = {cmd = '(global -Pol || rg --no-messages --files --no-ignore) 2>/dev/null'}})<cr>",
                    {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', '<space>rg', "<cmd>FzfLua live_grep<cr>",
                    {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', '<space>rw', "<cmd>FzfLua grep_cword<cr>",
                    {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', '<space>b', "<cmd>FzfLua buffers<cr>",
                    {noremap = true, silent = true})
                -- vim.api.nvim_set_keymap('n', '<space>hc', "<cmd>FzfLua command_history<cr>",
                --     {noremap = true, silent = true})
                -- vim.api.nvim_set_keymap('n', '<space>hf', "<cmd>FzfLua oldfiles<cr>",
                --     {noremap = true, silent = true})
                -- vim.api.nvim_set_keymap('n', '<space>hs', "<cmd>FzfLua search_history<cr>",
                --     {noremap = true, silent = true})
                vim.api.nvim_set_keymap('n', '<space>a', "<cmd>FzfLua lines<cr>",
                    {noremap = true, silent = true})
            end
        }

        use {'mileszs/ack.vim',
            config = function()
                vim.g.ackprg = 'rg -S --vimgrep --no-heading --no-column'
                vim.g.ackhighlight = 1
            end
        }

        use {'ncm2/ncm2',
            opt = true,
            requires = {
                {'SirVer/ultisnips', opt = true,
                    setup = function()
                        vim.g.UltiSnipsExpandTrigger = "<tab>"
                        vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
                        vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
                    end},
                {'honza/vim-snippets', opt = true},
                {'roxma/nvim-yarp', opt = true},
                {'ncm2/ncm2-bufword', opt = true},
                {'ncm2/ncm2-path', opt = true},
                {'fgrsnau/ncm2-otherbuf', opt = true},
                {'ncm2/ncm2-gtags', opt = true}
            },
            event = 'InsertEnter',
            setup = function()
                -- IMPORTANT: :help Ncm2PopupOpen for more information
                vim.opt.completeopt = {'noinsert', 'menuone', 'noselect'}
                -- suppress the annoying 'match x of y', 'The only match' and 'Pattern not
                -- found' messages
                vim.opt.shortmess:append({c = true})

                vim.cmd[[
                    inoremap <c-c> <ESC>
                    inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Tab>"
                    inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<S-Tab>"
                    ]]
            end,
            config = function()
                vim.fn['ncm2#enable_for_buffer']()
            end
        }

        --[[
        use {'moll/vim-bbye',
            opt = true,
            cmd = 'Bdelete',
            keys = {{'n', 'bd'}},
            config = function()
                vim.api.nvim_set_keymap('n', 'bd', ':Bdelete!<cr>', {silent = true})
            end
        }
        --]]

        use {'famiu/bufdelete.nvim',
            opt = true,
            cmd = 'Bdelete',
            keys = {{'n', 'bd'}},
            config = function()
                vim.api.nvim_set_keymap('n', 'bd', ':Bdelete<cr>', {silent = true, noremap = true})
            end
        }

        use 'ggandor/lightspeed.nvim'

        use {'jacquesbh/vim-showmarks',
            opt = true,
            cmd = 'DoShowMarks', -- DoShowMarks to enable
        }
        --[[
        use {'kshenoy/vim-signature',
            opt = true,
        }
        ]]--

        use {'inkarkat/vim-mark',
            opt = true,
            requires = {
                {'inkarkat/vim-ingo-library', opt = true}
            },
            cmd = {
                'Mark',
                'MarkLoad',
                'MarkSave',
                '<Plug>MarkSet',
                '<Plug>MarkRegex',
                '<Plug>MarkSearchOrCurNext',
                '<Plug>MarkSearchOrCurPrev'
            },
            keys = {
                {'n', '<leader>m'},
                {'n', '<leader>r'},
            },
            setup = function()
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
        }

        use 'farmergreg/vim-lastplace'

        use {'liuchengxu/vista.vim',
            opt = true,
            cmd = 'Vista'
        }
        g.vista_fzf_preview = {'right:50%'}

        use {'mhinz/vim-hugefile',
            opt = true,
            ft = {'log', 'text'}
        }
        g.hugefile_trigger_size = 150

        use {
            'matesea/vim-log-syntax',
            opt = true,
            ft = {'log', 'text'}
        }

        use {
            'vivien/vim-linux-coding-style',
            opt = true,
            ft = {'c', 'h', 'S'}
        }

        use {
            'mbbill/undotree',
            opt = true,
            cmd = 'UndotreeToggle'
        }
        g.undotree_WindowLayout = 2

        use {
            'octol/vim-cpp-enhanced-highlight',
            opt = true,
            ft = {'c', 'h', 'S', 'cpp'}
        }

        use {
            'tyru/caw.vim',
            opt = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua'}
        }

        use {'nathanaelkane/vim-indent-guides',
            opt = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'lua'}
        }
        g.indent_guides_enable_on_vim_startup = 1
        g.indent_guides_default_mapping = 0
        g.indent_guides_tab_guides = 0
        g.indent_guides_color_change_percent = 3
        g.indent_guides_guide_size = 1
        g.indent_guides_exclude_filetypes = {
            'help', 'defx', 'denite', 'denite-filter', 'startify',
            'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input',
            'any-jump', 'gina-status', 'gina-commit', 'gina-log'
        }

        use {'dstein64/vim-startuptime',
            opt = true,
            cmd = 'StartupTime'
        }

        use {'rhysd/accelerated-jk',
            config = function()
                vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {silent = true, noremap = false})
                vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {silent = true, noremap = false})
            end
        }

        use 'romainl/vim-cool'

        use {'embear/vim-foldsearch',
            opt = true,
            cmd = {'Fp', 'Fw', 'Fs'}
        }

        --[[
        use 'wellle/context.vim'
        cmd[[
            autocmd Filetype text call context#disable(1)
            autocmd Filetype log call context#disable(1)
        ]]
        --]]

        -- use 'machakann/vim-sandwich'

        use 'tpope/vim-sensible'

        use {'ngemily/vim-vp4',
            opt = true,
            cmd = {'Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4'}
        }

        use {'nanotee/zoxide.vim',
            opt = true,
            cmd = {'Z', 'Zi', 'Lz', 'Lzi'}
        }

        use {'justinmk/vim-gtfo',
            opt = true,
            keys = {
                {'n', 'got'}
            },
        }

        use 'kevinhwang91/nvim-bqf'

        use {
            'romgrk/nvim-treesitter-context',
            opt = true,
            cmd = {'TSContextEnable'},
            requires = {
                {'nvim-treesitter/nvim-treesitter',
                    opt = true,
                    run = ':TSUpdate'
                },
            },
            config = function()
                require('treesitter-context').setup{
                    enable = true,
                    throttle = true,
                }
            end
        }

        use {'rmagatti/auto-session',
            disable = true,
            config = function()
                vim.o.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"
                local opts = {
                      log_level = 'error',
                      auto_session_enable_last_session = false,
                      auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
                      auto_session_enabled = true,
                      auto_save_enabled = true,
                      auto_restore_enabled = true,
                      auto_session_suppress_dirs = {'/etc', '/tmp'}
                }
                require('auto-session').setup(opts)
            end
        }
        use {'rmagatti/session-lens',
            disable = true,
            requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
            config = function()
                require('session-lens').setup{
                      path_display = {'shorten'},
                      theme_conf = { border = false },
                      previewer = true
                }
            end
        }

        use {
            'neovim/nvim-lspconfig',
            disable = true,
            requires = {
                {'kabouzeid/nvim-lspinstall',
                    disable = true,
                    config = function()
                        local function setup_servers()
                          require'lspinstall'.setup()
                          local servers = require'lspinstall'.installed_servers()
                          for _, server in pairs(servers) do
                            require'lspconfig'[server].setup{}
                          end
                        end

                        setup_servers()

                        -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
                        require'lspinstall'.post_install_hook = function ()
                          setup_servers() -- reload installed servers
                          vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
                        end
                    end
                },
                {'gfanto/fzf-lsp.nvim', disable = true},
            }
        }

        --[[
        use({
            'tanvirtin/vgit.nvim',
            disable = true,
            event = 'BufWinEnter',
            requires = {
                'nvim-lua/plenary.nvim',
            },
            config = function()
                require('vgit').setup()
            end,
        })
        --]]
        use {'yamatsum/nvim-cursorline',
            disable = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua'},
        }
        use { 'beauwilliams/focus.nvim',
            cmd = { "FocusSplitNicely", "FocusSplitCycle" },
            module = "focus",
            config = function()
                require("focus").setup({hybridnumber = true})
            end
        }
    end,
    config = {
        -- Move to lua dir so impatient.nvim can cache it
        compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
    }
}

-- load packer_compiled with lua cache impatient
require('packer_compiled')

-- require('lspconfig')
