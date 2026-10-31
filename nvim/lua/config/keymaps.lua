-- help function to map keys
local map = vim.keymap.set

if not vim.fn.has("nvim-0.11") then
	-- buffers
	map("n", "]b", ":bnext<cr>", { silent = true, desc = "Next Buffer" })
	map("n", "[b", ":bprev<cr>", { silent = true, desc = "Previous Buffer" })
end

-- tabs
map("n", "]t", ":tabn<cr>", { silent = true, desc = "Next Tab" })
map("n", "[t", ":tabp<cr>", { silent = true, desc = "Previous Tab" })

-- command mode
map("c", "<C-h>", "<Home>")
map("c", "<C-l>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-b>", "<Left>")

map("n", "<leader>cd", ":lcd %:p:h<cr>:pwd<cr>", { desc = "Change to Current Directory" })

-- reload current buffer
map("n", "<leader>rd", ":edit!<cr>", { desc = "Reload Buffer" })
-- fileter all except lines match the pattern
map("n", "<leader>vd", ":%v##d<left><left>", { desc = "Filter Line" })
-- filter all lines except matching current word
map("n", "<leader>vw", ":%v#<c-r><c-w>#d<cr>", { desc = "Filter Line with Word" })

-- write
map("n", "<leader>w", ":write<cr>", { desc = "Write" })
map("x", "<leader>w", "<esc>:write<cr>", { desc = "Write" })
map("n", "!", ":!", { desc = "Enter Command" })

-- grep into location list
map("n", "<leader>gl", ":lgrep<space>", { desc = "Grep into Location List" })
map("n", "<leader>ga", ":lgrepadd<space>", { desc = "Add Grep into Loation List" })

-- delete buffer
map("n", "bd", "<cmd>bdelete<CR>", { desc = "Buffer Delete" })

-- ctags jump to definition, in case of gtags/cscope not available
map("n", "<leader>t", ":tjump <c-r><c-w><cr>", { silent = true, desc = "CTAGS jump" })

-- Jump to next/previous whitespace error.
---@param direction 1 | -1
function _G.whitespace_jump(direction) -- {{{
	local opts = "wz"
	if direction < 1 then
		opts = opts .. "b"
	end

	-- Whitespace pattern: Trailing whitespace or mixed tabs/spaces.
	local pat = "\\s\\+$\\| \\+\\ze\\t"
	vim.fn.search(pat, opts)
end -- }}}

vim.keymap.set("n", "]z", function()
	whitespace_jump(1)
end, { desc = "Next Whitespace" })
vim.keymap.set("n", "[z", function()
	whitespace_jump(-1)
end, { desc = "Previous Whitespace" })

function _G.toggle_list(name)
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == "loclist" then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end -- }}}

-- toggle quickfix/location list window
vim.keymap.set("n", "<leader>l", function()
	toggle_list("loclist")
end, { desc = "Toggle Location List", unique = true })
vim.keymap.set("n", "<leader>q", function()
	toggle_list("quickfix")
end, { desc = "Toggle Quickfix", unique = true })

if vim.env.TMUX then
	-- split tmux window vertically or horizontally based on file path in current window
	-- inspired by gtfo.vim, only support tmux 1.6+
	vim.keymap.set("n", "<leader>ts", function()
		vim.fn.system({ "tmux", "split-window", "-v", "-c", vim.fn.expand("%:p:h") })
	end, { desc = "Split TMUX Window Vertically" })
	vim.keymap.set("n", "<leader>tv", function()
		vim.fn.system({ "tmux", "split-window", "-h", "-c", vim.fn.expand("%:p:h") })
	end, { desc = "Split Tmux Window Horizontally" })
end

function _G.get_visual_selection() -- {{{
	-- This exits visual mode. Use 'gv' to reselect the text.
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, mode)
	if is_visual then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if mode == 'V' then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<") or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>") or { 0, 0, 0, 0 })
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	-- local n = cerow-csrow+1
	local n = #lines
	if n <= 0 or type(lines) ~= 'table' then
		return ''
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, '\n')
end -- }}}

-- visual select and substitute
map(
	'x',
	'<C-r>',
	":<C-u>%s/\\V<C-R>=v:lua.get_visual_selection()<CR>"
		.. '//gc<Left><Left><Left>',
	{ desc = 'Replace Selection' }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<c-g>", "<C-\\><C-n>", { desc = "Enter Normal Mode", unique = true })

map('n', 'sg', '<cmd>split<CR>', { desc = 'Split window horizontally', unique = true })
map('n', 'sv', '<cmd>vsplit<CR>', { desc = 'Split window vertically', unique = true })
map('n', 'st', '<cmd>tabnew<CR>', { desc = 'New tab', unique = true })
map('n', 'so', '<cmd>only<CR>', { desc = 'Close other windows', unique = true })
map('n', 'sq', '<cmd>quit<CR>', { desc = 'Quit' })

-- keymaps for fzf/grep
map("n", "<localleader>/", "<leader>s/", { desc = "Search History", remap = true, unique = true })
map("n", "<localleader>:", "<leader>sC", { desc = "Command", remap = true, unique = true })
map("n", "<localleader>;", "<leader>sc", { desc = "Command History", remap = true, unique = true })
map("n", "<localleader>b", "<leader>fb", { desc = "Buffers", remap = true, unique = true })
map("n", "<localleader>c", "<leader>fc", { desc = "Find Files in Current Directory", remap = true, unique = true })
map("n", "<localleader>e", "<leader>ff", { desc = "Find files", remap = true, unique = true })
map("n", "<localleader>g", "<leader>sg", { desc = "Live Grep", remap = true, unique = true })
map("n", "<localleader>G", "<leader>sG", { desc = "Live Grep in Current Directory", remap = true, unique = true })
map("n", "<localleader>j", "<leader>sj", { desc = "Jump", remap = true, unique = true })
map("n", "<localleader>l", "<leader>fl", { desc = "Buffer Lines", remap = true, unique = true })
map("n", "<localleader>m", "<leader>sm", { desc = "Marks", remap = true, unique = true })
map("n", "<localleader>q", "<leader>sq", { desc = "Quickfix", remap = true, unique = true })
map("n", "<localleader>t", "<leader>st", { desc = "Buffer Tags", remap = true, unique = true })
map("n", "<localleader>v", '<leader>s"', { desc = "Register", remap = true, unique = true })
map("n", "<localleader>w", "<leader>sw", { desc = "Live Grep cword", remap = true, unique = true })
map("n", "<localleader>x", "<leader>fr", { desc = "Recent File", remap = true, unique = true })
map("n", "<localleader>z", "<leader>sz", { desc = "Zoxide", remap = true, unique = true })
