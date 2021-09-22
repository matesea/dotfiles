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

return require('packer').startup(function()
        use 'wbthomason/packer.nvim'

        use 'tamelion/neovim-molokai'
        cmd('colorscheme molokai')

        use {
            'lewis6991/impatient.nvim',
            config = function() require('impatient') end
        }

        use {'mhinz/vim-signify'}
        opt.updatetime = 300
        -- plugin vim-signify
        map {'n', ']c', '<plug>(signify-next-hunk)', silent = true}
        map {'n', '[c', '<plug>(signify-prev-hunk)', silent = true}

        -- use {
        --     'tpope/vim-fugitive',
        --     opt = true,
        --     cmd = {'Gread', 'Gwrite', 'Git', 'Ggrep', 'Gblame', 'GV'}
        -- }

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

        use {
            'beauwilliams/statusline.lua',
            requires = {
                {'kyazdani42/nvim-web-devicons'},
                {'ryanoasis/vim-devicons'}
            },
        }
        local statusline = require('statusline')
        statusline.tabline = false

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
            }
        }

        use 'jiangmiao/auto-pairs'

        use {'junegunn/fzf.vim',
            requires = {'junegunn/fzf',
                run = './install --completion --key-bindings --xdg --no-update-rc'
            }
        }
        -- plugin fzf.vim
        map {'n', ';e', ':FZF<cr>'}
        map {'n', ';c', ':FZF %:h<cr>'}
        map {'n', ';b', ':Buffers<cr>'}
        map {'n', ';h', ':History'}
        map {'n', ';a', ':Lines<cr>'}
        map {'n', ';l', ':Blines<cr>'}
        map {'n', ';w', ':Blines <c-r><c-w><cr>'}
        map {'n', ';t', ':BTags<cr>'}
        map {'n', ';rg', ':Rg<space>'}
        map {'n', ';rw', ':Rg <c-r><c-w><cr>'}
        -- map {'n', ';rc', ':Rc<space>'}
        -- g.fzf_layout = {'down': '~40%'}

        -- use 'mileszs/ack.vim'
        use {
            'moll/vim-bbye',
            opt = true,
            cmd = 'Bdelete',
            keys = {{'n', 'bd'}},
            config = function()
                vim.api.nvim_set_keymap('n', 'bd', ':Bdelete!<cr>', {silent = true})
            end
        }

        use 'ggandor/lightspeed.nvim'

        use 'jacquesbh/vim-showmarks'

        use {'inkarkat/vim-mark',
            opt = true,
            requires = {
                {'inkarkat/vim-ingo-library', opt = true}
            },
            cmd = {
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

        use 'wellle/context.vim'
        cmd[[
            autocmd Filetype text call context#disable(1)
            autocmd Filetype log call context#disable(1)
        ]]

        use 'machakann/vim-sandwich'

        use 'tpope/vim-sensible'

        use {'ngemily/vim-vp4',
            opt = true,
            cmd = {'Vp4FileLog', 'Vp4Annotate', 'Vp4Describe', 'Vp4'}
        }

        use {'nanotee/zoxide.vim',
            opt = true,
            cmd = {'Z', 'Zi', 'Lz', 'Lzi'}
        }
end)
