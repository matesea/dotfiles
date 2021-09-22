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

--[[
-- plugin vim-signify
map {'n', ']c', '<plug>(signify-next-hunk)', silent = true}
map {'n', '[c', '<plug>(signify-prev-hunk)', silent = true}

-- plugin vim-buftabline
map {'n', '<leader>1', '<Plug>BufTabLine.Go(1)'}
map {'n', '<leader>2', '<Plug>BufTabLine.Go(2)'}
map {'n', '<leader>3', '<Plug>BufTabLine.Go(3)'}
map {'n', '<leader>4', '<Plug>BufTabLine.Go(4)'}
map {'n', '<leader>5', '<Plug>BufTabLine.Go(5)'}
map {'n', '<leader>6', '<Plug>BufTabLine.Go(6)'}
map {'n', '<leader>7', '<Plug>BufTabLine.Go(7)'}
map {'n', '<leader>8', '<Plug>BufTabLine.Go(8)'}
map {'n', '<leader>9', '<Plug>BufTabLine.Go(9)'}

-- plugin gtags-scope
map {'n', '<leader>cf', ':cscope find<space>'}
map {'n', '<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>'}
map {'n', '<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>'}
map {'n', '<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>'}
map {'n', '<leader>ca', ':cscope add<space>'}

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

-- plugin vim-bbye
map {'n', 'bd', ':Bdelete!<cr>', silent = true}

-- plugin vim-sneak
map {'n', 's', '<Plug>Sneak_s'}
map {'n', 'S', '<Plug>Sneak_S'}
map {'x', 's', '<Plug>Sneak_s'}
map {'x', 'S', '<Plug>Sneak_S'}
map {'o', 's', '<Plug>Sneak_s'}
map {'o', 'S', '<Plug>Sneak_S'}

-- plugin vim-shot-f
-- map {'n', 'f', '<Plug>(shot-f-f)', noremap = false}
-- map {'n', 'F', '<Plug>(shot-f-F)', noremap = false}
-- map {'n', 't', '<Plug>(shot-f-t)', noremap = false}
-- map {'n', 'T', '<Plug>(shot-f-T)', noremap = false}
-- map {'x', 'f', '<Plug>(shot-f-f)', noremap = false}
-- map {'x', 'F', '<Plug>(shot-f-F)', noremap = false}
-- map {'x', 't', '<Plug>(shot-f-t)', noremap = false}
-- map {'x', 'T', '<Plug>(shot-f-T)', noremap = false}
-- map {'o', 'f', '<Plug>(shot-f-f)', noremap = false}
-- map {'o', 'F', '<Plug>(shot-f-F)', noremap = false}
-- map {'o', 't', '<Plug>(shot-f-t)', noremap = false}
-- map {'o', 'T', '<Plug>(shot-f-T)', noremap = false}

-- plugin vim-mark
-- map {'n', '<Plug>IgnoreMarkSearchNext', '<Plug>MarkSearchNext', noremap = false}
-- map {'n', '<Plug>IgnoreMarkSearchPrev', '<Plug>MarkSearchPrev', noremap = false}
-- map {'n', '<leader>m', '<Plug>MarkSet', noremap = false}
-- map {'x', '<leader>m', '<Plug>MarkSet', noremap = false}
-- map {'n', '<leader>r', '<Plug>MarkRegex', noremap = false}
-- map {'x', '<leader>r', '<Plug>MarkRegex', noremap = false}
-- map {'n', '<leader>n', '<Plug>MarkClear', noremap = false}

-- plugin accelerated-jk
map {'n', 'j', '<Plug>(accelerated_jk_gj)', silent = true, noremap = false}
map {'n', 'k', '<Plug>(accelerated_jk_gk)', silent = true, noremap = false}
--]]
