local fn = vim.fn
local env = vim.env -- environment variables
local cmd = vim.cmd

local xdg_config = env.XDG_CONFIG_HOME
local xdg_data = env.XDG_DATA_HOME
local home = env.HOME

if xdg_config ~= nil then
    if fn.isdirectory(xdg_config .. '/nvim') then
        env.VIMHOME = xdg_config .. '/nvim'
    elseif fn.isdirectory(xdg_config .. '/vim') then
        env.VIMHOME = xdg_config .. '/vim'
    end
elseif home ~= nil then
    env.VIMHOME = home .. '/dotfiles/vim'
end

if xdg_data ~= nil then
    env.VIMDATA = xdg_data .. '/vim'
    env.VIMINFO = xdg_data
else
    env.VIMDATA = home .. '/.local/vim'
    env.VIMINFO = home
end

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
    vim.g["loaded_" .. plugin] = 1
end

require('setting')
cmd('source $VIMHOME/function.vim')

cmd([[
    set shada=!,'300,<50,@100,s10,h,n$VIMINFO/.viminfo.shada
]])

-- import local settings
if xdg_data ~= nil and fn.filereadable(xdg_data .. '/vimrc') then
    cmd('source ' .. xdg_data .. '/vimrc')
elseif fn.filereadable(home .. '/.local/vimrc') then
    cmd('source ' .. home .. '/.local/vimrc')
end

require('plugin')
require('mapping')

-- exclude quickfix from bnext/bprev
cmd([[
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
]])
