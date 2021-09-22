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

        use 'mhinz/vim-signify'
        opt.updatetime = 300

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

        use 'ap/vim-buftabline'
        g.buftabline_show = 1
        g.buftabline_numbers = 2

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
            cmd = 'GtagsCscope'
        }
        opt.csto = 0
        -- show msg when any other cscope db added
        opt.cscopeverbose = true
        -- display result in quickfix
        opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
        opt.cscoperelative = true

        use {'drmingdrmer/vim-toggle-quickfix',
            opt = true,
            cmd = {
                '<Plug>window:quickfix:toggle',
                '<Plug>window:location:toggle'
            }
        }

        use 'jiangmiao/auto-pairs'

        use {'junegunn/fzf',
            run = './install --completion --key-bindings --xdg --no-update-rc'
        }
        use 'junegunn/fzf.vim'
        -- g.fzf_layout = {'down': '~40%'}

        g.python3_host_skip_check = 1
        g.python_host_skip_check = 1

        -- use 'mileszs/ack.vim'
        use {
            'moll/vim-bbye',
            opt = true,
            cmd = 'Bdelete'
        }

        use {
            'justinmk/vim-sneak',
            opt = true,
            cmd = {'<Plug>Sneak_s', '<Plug>Sneak_S'}
        }

        --[[
        use {
            'deris/vim-shot-f',
            opt = true,
            cmd = {
                '<Plug>(shot-f-f)',
                '<Plug>(shot-f-F)',
                '<Plug>(shot-f-t)',
                '<Plug>(shot-f-T)',
            }
        }
        g.shot_f_no_default_key_mappings = 1
        ]]--

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
            }
        }
        g.mwDefaultHighlightingPalette = 'maximum'
        g.mwHistAdd = '/@'
        g.mw_no_mappings = 1
        g.mwAutoLoadMarks = 0
        -- map {'n', '<Plug>IgnoreMarkSearchNext', '<Plug>MarkSearchNext', noremap = false}
        -- map {'n', '<Plug>IgnoreMarkSearchPrev', '<Plug>MarkSearchPrev', noremap = false}
        map {'n', '<leader>m', '<Plug>MarkSet', noremap = false}
        map {'x', '<leader>m', '<Plug>MarkSet', noremap = false}
        map {'n', '<leader>r', '<Plug>MarkRegex', noremap = false}
        map {'x', '<leader>r', '<Plug>MarkRegex', noremap = false}
        map {'n', '<leader>n', '<Plug>MarkClear', noremap = false}

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
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh'}
        }

        use {'nathanaelkane/vim-indent-guides',
            opt = true,
            ft = {'c', 'h', 'S', 'cpp', 'python', 'vim'}
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

        use 'rhysd/accelerated-jk'

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
