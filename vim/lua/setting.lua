local opt = vim.opt -- global options
local g = vim.g     -- global variable
local fn = vim.fn
local cmd = vim.cmd
local env = vim.env -- environment variables

-- disable built-in plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- local wopt = vim.wo -- window-local options
-- local bopt = vim.bo -- buffer-local options
-- local execute = vim.api.nvim_command
-- local call = vim.call

g.mapleader = ','
opt.cindent = true
opt.showmode = true
opt.number = true

-- iwhite: ignore changes in amount of white space
opt.diffopt:append({'filler', 'internal', 'algorithm:histogram', 'indent-heuristic'})

-- less window redraw to speed up
opt.ttyfast = true
opt.lazyredraw = true

-- set how many lines of history vim has to remember
opt.history = 2000

-- Enable filetype plugin
-- load plugins according to different file type
cmd([[
    filetype plugin indent off
    syntax sync minlines=250
]])

-- cmd("set shada=!,'300,<50,@100,s10,h,n$VIMINFO/.viminfo.shada")

-- omni completion, smart autocompletion for programs
-- when invoked, the text before the cursor is inspected to guess what might follow
-- A popup menu offers word completion choices that may include struct and class members, system functions
opt.ofu = 'syntaxcomplete#Completion'

opt.so = 7
opt.cmdheight = 1
opt.hidden = true
opt.whichwrap:append('<,>,h,l')
opt.magic = true
opt.showmatch = true
opt.mat = 2
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.errorbells = false
opt.visualbell = false

opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500 -- Time out on mappings
opt.ttimeoutlen = 10 -- Time out on key codes
opt.updatetime = 200 -- idle time to write swap and trigger CursorHold
opt.redrawtime = 2000 -- time in milliseconds for stopping display redraw

opt.encoding = 'utf8'
cmd([[
    try
        lang en_US
    catch
    endtry
    ]])
opt.fileformats = {'unix', 'dos', 'mac'}
-- opt.t_vb = ''

opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- setup undo
opt.undofile = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.scrolloff = 999
opt.linebreak = true
opt.textwidth = 500

opt.wrap = false

opt.switchbuf = 'usetab'
opt.showtabline = 1

-- set fold
opt.foldmethod = 'syntax'
opt.foldlevel = 100

-- setup grep parameters and format
if fn.executable('rg') then
    opt.grepprg = 'rg -S --vimgrep --no-heading --no-column'
    opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
elseif fn.executable('ag') then
    opt.grepprg = 'ag --group --nocolor --vimgrep'
    opt.grepformat = '%f:%1:%c%m'
else
    opt.grepprg = 'grep -nH'
end

-- setup terminal colors
cmd('set t_Co=256')
opt.termguicolors = true
opt.background = 'dark'

-- set as 'a' to allow mouse scroll
opt.mouse = ''

--[[
 == execute command and put the results into new buffer ==
 # alternative file name which is the last edit file, % for current file name
 they are readonly registers
 check https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
 or https://www.brianstorti.com/vim-registers/
 eg, find pattern in current file :R rg <pattern> #
--]]

 g.python3_host_skip_check = 1
 g.python_host_skip_check = 1

cmd([[
    set shada=!,'300,<50,@100,s10,h,n$VIMINFO/.viminfo.shada
]])

-- exclude quickfix from bnext/bprev
cmd([[
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
]])
