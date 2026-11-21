local opt = vim.opt -- global options
local g = vim.g     -- global variable
local fn = vim.fn
local cmd = vim.cmd

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
    "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- local wopt = vim.wo -- window-local options
-- local bopt = vim.bo -- buffer-local options
-- local execute = vim.api.nvim_command
-- local call = vim.call

g.mapleader = " "
g.maplocalleader = ";"
g.have_nerd_font = true
opt.cindent = true
opt.showmode = false
opt.number = true
-- set as 'a' to allow mouse scroll
opt.mouse = ""

opt.breakindent = true
opt.signcolumn = "yes"

-- iwhite: ignore changes in amount of white space
opt.diffopt:append({
    "iwhite",
    "indent-heuristic",
    "algorithm:patience",
    "context:999999",
})

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


-- omni completion, smart autocompletion for programs
-- when invoked, the text before the cursor is inspected to guess what might follow
-- A popup menu offers word completion choices that may include struct and class members, system functions
opt.ofu = "syntaxcomplete#Completion"

opt.cmdheight = 0
opt.hidden = true
opt.whichwrap:append("<,>,h,l")
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
opt.timeoutlen = 300  -- Time out on mappings
opt.ttimeoutlen = 10  -- Time out on key codes
opt.updatetime = 250  -- idle time to write swap and trigger CursorHold
opt.redrawtime = 2000 -- time in milliseconds for stopping display redraw

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

if vim.fn.has("nvim-0.11") == 1 then
    opt.tabclose:append({ "uselast" })
end

opt.encoding = "utf8"
cmd([[
    try
        lang en_US
    catch
    endtry
    ]])
opt.fileformats = { "unix", "dos", "mac" }
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
opt.winborder = "single"

opt.switchbuf = "usetab"
opt.showtabline = 1

-- set fold
opt.foldmethod = "syntax"
opt.foldlevel = 100

-- setup grep parameters and format
if fn.executable("rg") == 1 then
    opt.grepprg = "rg -S --vimgrep --no-heading --no-column"
    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
else
    opt.grepprg = "grep -nH"
end

-- setup terminal colors
cmd("set t_Co=256")
opt.termguicolors = true

g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

--[[
  ShDa (viminfo for vim): session data history
  --------------------------------------------
  ! - Save and restore global variables (their names should be without lowercase letter).
  ' - Specify the maximum number of marked files remembered. It also saves the jump list and the change list.
  < - Maximum of lines saved for each register. All the lines are saved if this is not included, <0 to disable pessistent registers.
  % - Save and restore the buffer list. You can specify the maximum number of buffer stored with a number.
  / or : - Number of search patterns and entries from the command-line history saved. vim.o.history is used if it’s not specified.
  f - Store file (uppercase) marks, use 'f0' to disable.
  s - Specify the maximum size of an item’s content in KiB (kilobyte).
      For the viminfo file, it only applies to register.
      For the shada file, it applies to all items except for the buffer list and header.
  h - Disable the effect of 'hlsearch' when loading the shada file.

  :oldfiles - all files with a mark in the shada file
  :rshada   - read the shada file (:rviminfo for vim)
  :wshada   - write the shada file (:wrviminfo for vim)
]]
vim.o.shada = [[!,'10000,<0,s100,h]]

-- For floating cmdline and messages
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
