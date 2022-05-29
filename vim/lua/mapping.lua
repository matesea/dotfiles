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

-- buffers
map {'n', ']b', ':bnext<cr>', silent = true}
map {'n', '[b', ':bprev<cr>', silent = true}
-- quickfix
map {'n', ']q', ':cnext<cr>', silent = true}
map {'n', '[q', ':cprev<cr>', silent = true}
-- localtion list
map {'n', ']l', ':lnext<cr>', silent = true}
map {'n', '[l', ':lprev<cr>', silent = true}
-- tabs
map {'n', ']t', ':tabn<cr>', silent = true}
map {'n', '[t', ':tabp<cr>', silent = true}

-- command mode
map {'c', '<C-h>', '<Home>'}
map {'c', '<C-l>', '<End>'}
map {'c', '<C-f>', '<Right>'}
map {'c', '<C-b>', '<Left>'}

map {'', '<leader>cd', ':lcd %:p:h<cr>:pwd<cr>'}

-- reload current buffer
map {'n', '<leader>rd', ':edit!<cr>'}
-- fileter all except lines match the pattern
map {'n', '<leader>vd', ':%v##d<left><left>'}
-- filter all lines except matching current word
map {'n', '<leader>vw', ':%v#<c-r><c-w>#d<cr>'}

-- write
map {'n', '<leader>w', ':write<cr>'}
map {'x', '<leader>w', '<esc>:write<cr>'}

-- XXX: forgot what are these for?
--[[
  map {'n', '<c-s>', '<c-u>write<cr>'}
  map {'x', '<c-s>', '<c-u>write<cr>'}
  map {'c', '<c-s>', '<c-u>write<cr>'}
]]--

-- toggle wrap
map {'n', '<leader>tw', ':setlocal wrap!<cr>', silent = true}
-- toggle relative line number
map {'n', '<leader>tr', ':setlocal relativenumber!<cr>', silent = true}

map {'n', '!', ':!'}

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

-- plugin fzf.lua
map {'n', '<space>/', "<cmd>FzfLua search_history<cr>"}
map {'n', '<space>;', "<cmd>FzfLua command_history<cr>"}
map {'n', '<space>a', "<cmd>FzfLua lines<cr>"}
map {'n', '<space>b', "<cmd>FzfLua buffers<cr>"}
map {'n', '<space>e', '<cmd>FzfLua files<cr>'}
map {'n', '<space>g', "<cmd>FzfLua live_grep<cr>"}
map {'n', '<space>j', "<cmd>FzfLua jumps<cr>"}
map {'n', '<space>w', "<cmd>FzfLua grep_cword<cr>"}
map {'n', '<space>x', "<cmd>FzfLua oldfiles<cr>"}

vim.cmd[[nnoremap <space>c :FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>]]
