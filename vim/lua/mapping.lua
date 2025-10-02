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

if not vim.fn.has('nvim-0.11') then
    -- buffers
    map {'n', ']b', ':bnext<cr>', silent = true}
    map {'n', '[b', ':bprev<cr>', silent = true}
end

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

-- delete buffer
map{'n', 'bd', '<cmd>bdelete<CR>', { desc = 'Buffer delete' }}

-- remap ZQ to quit without saving anything
map {'n', 'ZQ', ':qa!<cr>'}

-- ctags jump to definition, in case of gtags/cscope not available
map {'n', '<space>t', ':tjump <c-r><c-w><cr>', silent = true}

-- Jump to next/previous whitespace error.
---@param direction 1 | -1
function _G.whitespace_jump(direction) -- {{{
	local opts = 'wz'
	if direction < 1 then
		opts = opts .. 'b'
	end

	-- Whitespace pattern: Trailing whitespace or mixed tabs/spaces.
	local pat = '\\s\\+$\\| \\+\\ze\\t'
	vim.fn.search(pat, opts)
end -- }}}

vim.keymap.set('n', ']z', function() whitespace_jump(1) end, { desc = 'Next Whitespace' })
vim.keymap.set('n', '[z', function() whitespace_jump(-1) end, { desc = 'Previous Whitespace' })

function _G.toggle_list(name)
    for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == 'loclist' then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end -- }}}

-- toggle quickfix/location list window
vim.keymap.set('n', '<leader>l', function() toggle_list('loclist') end, {desc = "toggle location list"})
vim.keymap.set('n', '<leader>q', function() toggle_list('quickfix') end, {desc = "toggle quickfix"})

if vim.env.TMUX then
    -- split tmux window vertically or horizontally based on file path in current window
    -- inspired by gtfo.vim, only support tmux 1.6+
    vim.keymap.set('n', '<leader>ts',
            function()
                vim.fn.system({'tmux', 'split-window', '-v', '-c',
                    vim.fn.expand('%:p:h')})
            end,
            {desc = "split tmux window vertically"})
    vim.keymap.set('n', '<leader>tv',
            function()
                vim.fn.system({'tmux', 'split-window', '-h', '-c',
                    vim.fn.expand('%:p:h')})
            end,
            {desc = "split tmux window horizontally"})
end
