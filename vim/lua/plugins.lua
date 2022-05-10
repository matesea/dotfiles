local M = {}

function M.setup()
 local cmd = vim.cmd
 local g = vim.g     -- global variable
 local opt = vim.opt -- global options

 local conf = {
    profile = {
      enable = true,
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
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

 -- workaround: nvim-yarp autoload vimscript not loaded
 -- cmd [[packadd nvim-yarp]]

 local function plugins(use)
     use 'lewis6991/impatient.nvim'

     use 'wbthomason/packer.nvim'

     use {'tamelion/neovim-molokai',
         config = function()
             vim.cmd('colorscheme molokai')
         end
     }

     use {
         'lewis6991/gitsigns.nvim',
         event = 'BufReadPre',
         requires = {'nvim-lua/plenary.nvim'},
         config = function()
             require('config.gitsigns').setup()
         end
     }

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
         config = function()
             require('config.gtags').setup()
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
         -- requires = 'nvim-treesitter',
         -- module = {'nvim-autopairs.completion.cmp', 'nvim-autopairs'},
         config = function()
             require('nvim-autopairs').setup()
         end
     }

     use {'junegunn/fzf.vim',
         requires = {'junegunn/fzf',
             run = './install --completion --key-bindings --xdg --no-update-rc'
         },
         event = 'BufEnter',
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
             require('config.telescope').setup()
         end
     }

     use {
         'ibhagwan/fzf-lua',
         opt = true,
         requires = {'junegunn/fzf',
             run = './install --completion --key-bindings --xdg --no-update-rc'
         },
         cmd = {'FzfLua'},
         config = function()
             require('fzf-lua').setup{
                 files = {
                     cmd = 'ff',
                     git_icons = false,
                     file_icons = false,
                     color_icons = false,
                     previewer = false,
                 },
                 git = {
                     files = {
                         git_icons = false,
                         file_icons = false,
                         color_icons = false,
                         previewer = false,
                     },
                     status = {
                         git_icons = false,
                         file_icons = false,
                         color_icons = false,
                     },
                 },
                 grep = {
                     git_icons = false,
                     file_icons = false,
                     color_icons = false,
                 },
                 buffers = {
                     file_icons = false,
                     color_icons = false,
                 },
                 tabs = {
                     file_icons = false,
                     color_icons = false,
                 },
                 tags = {
                     git_icons = false,
                     file_icons = false,
                     color_icons = false,
                 },
                 btags = {
                     git_icons = false,
                     file_icons = false,
                     color_icons = false,
                 },
                 quickfix = {
                     git_icons = false,
                     file_icons = false,
                 },
             }
         end
     }
     -- plugin fzf.lua
     map {'n', ';e', ':FZF<cr>'}
     map {'n', '<space>e', '<cmd>FzfLua files<cr>'}
     map {'n', '<space>rg', "<cmd>FzfLua live_grep<cr>"}
     map {'n', '<space>rw', "<cmd>FzfLua grep_cword<cr>"}
     map {'n', '<space>b', "<cmd>FzfLua buffers<cr>"}
     map {'n', '<space>hc', "<cmd>FzfLua command_history<cr>"}
     map {'n', '<space>hf', "<cmd>FzfLua oldfiles<cr>"}
     map {'n', '<space>hs', "<cmd>FzfLua search_history<cr>"}
     map {'n', '<space>a', "<cmd>FzfLua lines<cr>"}
     vim.cmd[[nnoremap <space>c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>]]

     use {'mileszs/ack.vim',
         config = function()
             vim.g.ackprg = 'rg -S --vimgrep --no-heading --no-column'
             vim.g.ackhighlight = 1
         end
     }
     use {'kazhala/close-buffers.nvim',
         opt = true,
         cmd = {"BDelete", "BWipeout"},
         keys = {{'n', 'bd'}, {'n', 'bo'}},
         config = function()
             require('close_buffers').setup()
             vim.api.nvim_set_keymap('n', 'bd', ':BDelete this<cr>', {silent = true, noremap = true})
             vim.api.nvim_set_keymap('n', 'bo', ':BDelete other<cr>', {silent = true, noremap = true})
         end
     }

     use {'ggandor/lightspeed.nvim',
        keys = {'s', 'S', 'f', 'F', 't', 'T'},
        config = function()
            require('lightspeed').setup {}
        end
    }

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

     -- use 'farmergreg/vim-lastplace'
     use {'ethanholz/nvim-lastplace',
         config = function()
             require('nvim-lastplace').setup{
                 lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
                 lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
                 lastplace_open_folds = true
             }
         end
     }

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
         -- 'tyru/caw.vim',
         'b3nj5m1n/kommentary',
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

     use {'kevinhwang91/nvim-bqf',
         config = function()
             require('bqf').setup({
                 func_map = {
                     pscrollup = "",
                     pscrolldown = "",
                 },
             })
         end
     }

     use {
         'lewis6991/nvim-treesitter-context',
         opt = true,
         -- ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'lua'}, -- auto enable for those filetype
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
      use {
          'm-demare/hlargs.nvim',
          opt = true,
          -- ft = {'c', 'h', 'S', 'cpp', 'python', 'vim', 'sh', 'lua'},
          requires = {
              {'nvim-treesitter/nvim-treesitter',
              opt = true,
              run = 'TSUpdate',
             },
          },
          config = function()
              require('hlargs').setup()
          end
      }

     use {
         'hrsh7th/nvim-cmp',
         opt = true,
         requires = {
             {'hrsh7th/cmp-buffer', opt = true},
             {'hrsh7th/cmp-path', opt = true},
             {'hrsh7th/cmp-cmdline', opt = true},
             {'hrsh7th/cmp-vsnip', opt = true},
             {'hrsh7th/vim-vsnip', opt = true},
             {'andersevenrud/cmp-tmux', opt = true},
             -- {'quangnguyen30192/cmp-nvim-tags', opt = true, ft = {'c', 'h', 'python', 'cpp'}}
         },
         event = 'InsertEnter',
         config = function()
             require('config.cmp').setup()
         end
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
     use { 'beauwilliams/focus.nvim',
         cmd = { "FocusSplitNicely", "FocusSplitCycle" },
         module = "focus",
         config = function()
             require("focus").setup({hybridnumber = true})
         end
     }

     use {'nathom/filetype.nvim',
         config = function()
             require("filetype").setup({
                 overrides = {
                     extensions = {
                         log = "log",
                         txt = "log",
                     }
                 }
             })
         end
     }
     use {'gelguy/wilder.nvim',
         disable = true,
         config = function()
             local wilder = require('wilder')
             wilder.setup({modes = {':', '/', '?'}})
         end,
     }
     use {'stevearc/aerial.nvim',
         opt = true,
         cmd = {'AerialToggle'},
         config = function()
             require("aerial").setup({
                 backends = {"treesitter"}
             })
         end,
     }
     use {'matesea/trace32-practice.vim',
         opt = true,
         ft = {'cmm'}
     }
 end

 packer_init()
 local packer = require 'packer'

 pcall(require, 'impatient')

 packer.init(conf)
 packer.startup(plugins)

 -- load packer_compiled with lua cache impatient
 pcall(require, 'packer_compiled')
 -- require('lspconfig')
end

return M
