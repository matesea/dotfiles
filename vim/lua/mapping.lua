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

-- remap ZQ to quit without saving anything
map {'n', 'ZQ', ':qa!<cr>'}

-- ctags jump to definition, in case of gtags/cscope not available
map {'n', '<space>t', ':tjump <c-r><c-w><cr>', silent = true}

vim.keymap.set('n', '<leader>q',
        function()
            local windows = vim.fn.getwininfo()
            for _, win in pairs(windows) do
                if win["quickfix"] == 1 then
                    vim.cmd.cclose()
                    return
                end
            end
            vim.cmd.copen()
        end,
        {desc = "toggle quickfix"})

-- split tmux window vertically or horizontally based on file path in current window
-- inspired by gtfo.vim, only support tmux 1.6+
vim.keymap.set('n', '<leader>ts',
        function()
            vim.fn.system({'tmux', 'split-window', '-c',
                vim.fn.expand('%:p:h')})
        end,
        {desc = "split tmux window horizontally"})

vim.keymap.set('n', '<leader>tv',
        function()
            vim.fn.system({'tmux', 'split-window', '-h', '-c',
                vim.fn.expand('%:p:h')})
        end,
        {desc = "split tmux window vertically"})
