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


require('setting')

-- import local settings if exist
local local_rc = nil
if xdg_data ~= nil then
    local_rc = fn.glob(xdg_data .. '/vimrc')
else
    local_rc = fn.glob(home .. '/.local/vimrc')
end
if fn.empty(local_rc) == 0 then
    cmd('source ' .. local_rc)
end

require('plugins').setup()
require('mapping')
