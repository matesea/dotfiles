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
-- map {'n', ']q', ':cnext<cr>', silent = true}
-- map {'n', '[q', ':cprev<cr>', silent = true}
-- localtion list
-- map {'n', ']f', ':lnext<cr>', silent = true}
-- map {'n', '[f', ':lprev<cr>', silent = true}
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
map {'n', '!', ':!'}

-- grep into location list
map {'n', '<leader>gl', ':lgrep<space>'}
map {'n', '<leader>ga', ':lgrepadd<space>'}

-- remap ZQ to quit without saving anything
map {'n', 'ZQ', ':qa!<cr>'}

-- wipe out buffer
map {'n', 'bd', '<cmd>bwipeout<cr>', {desc = 'Buffer wipeout'}}

-- colemak-dh arrow keys
map {'n', 'm', 'h', {desc = 'left'}}
map {'n', 'n', 'j', {desc = 'down'}}
map {'n', 'e', 'k', {desc = 'up'}}
map {'n', 'i', 'l', {desc = 'right'}}
