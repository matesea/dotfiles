-- help function to map unique keys
local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { unique = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

if not vim.fn.has("nvim-0.11") then
    -- buffers
    vim.keymap.set("n", "]b", ":bnext<cr>", { desc = "Next Buffer" })
    vim.keymap.set("n", "[b", ":bprev<cr>", { desc = "Previous Buffer" })
end

-- tabs
vim.keymap.set("n", "]t", ":tabn<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[t", ":tabp<cr>", { desc = "Previous Tab" })

-- command mode
map("c", "<C-h>", "<Home>")
map("c", "<C-l>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-b>", "<Left>")

map("n", "<leader>cd", ":lcd %:h<cr>:pwd<cr>", { desc = "cd File's Directory" })

-- reload current buffer
map("n", "<leader>rd", ":edit!<cr>", { desc = "Reload Buffer" })
-- fileter all except lines match the pattern
map("n", "<leader>vd", ":%v##d<left><left>", { desc = "Filter Line" })
-- filter all lines except matching current word
map("n", "<leader>vw", ":%v#<c-r><c-w>#d<cr>", { desc = "Filter Line with Word" })

-- buffer
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- write
map("n", "<leader>w", ":write<cr>", { desc = "Save File" })
map("x", "<leader>w", "<esc>:write<cr>", { desc = "Save File" })
map("n", "!", ":!", { desc = "Enter Command" })
map("n", "<leader>qq", "<cmd>quitall!<cr>", { desc = "Quit All" })

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

-- location list
map("n", "<leader>xl", function()
    local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
    end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
    end
end, { desc = "Quickfix List" })

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
    local is_visual = vim.tbl_contains({ "v", "V", "\22" }, mode)
    if is_visual then
        -- if we are in visual mode use the live position
        _, csrow, cscol, _ = unpack(vim.fn.getpos(".") or { 0, 0, 0, 0 })
        _, cerow, cecol, _ = unpack(vim.fn.getpos("v") or { 0, 0, 0, 0 })
        if mode == "V" then
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
    if n <= 0 or type(lines) ~= "table" then
        return ""
    end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    return table.concat(lines, "\n")
end -- }}}

-- visual select and substitute
map(
    "x",
    "<C-r>",
    ":<C-u>%s/\\V<C-R>=v:lua.get_visual_selection()<CR>" .. "//gc<Left><Left><Left>",
    { desc = "Replace Selection" }
)

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Use tab for indenting in visual/select mode
map("x", "<Tab>", ">", { remap = true, desc = "Indent Left" })
map("x", "<S-Tab>", "<", { remap = true, desc = "Indent Right" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<c-g>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })

map("n", "sc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "sd", "<cmd>bdelete<CR>", { desc = "Buffer Delete" })
map("n", "sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "sg", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "st", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "so", "<cmd>only<CR>", { desc = "Close other windows" })
map("n", "sq", "<cmd>quit<CR>", { desc = "Quit" })

-- keymaps for fzf/grep
map("n", "<localleader>/", "<leader>s/", { desc = "Search History", remap = true })
map("n", "<localleader>:", "<leader>sC", { desc = "Command", remap = true })
map("n", "<localleader>;", "<leader>sc", { desc = "Command History", remap = true })
map("n", "<localleader>b", "<leader>fb", { desc = "Buffers", remap = true })
map("n", "<localleader>E", "<leader>fE", { desc = "Find Files in Current Directory", remap = true })
map("n", "<localleader>e", "<leader>ff", { desc = "Find files", remap = true })
map("n", "<localleader>g", "<leader>sg", { desc = "Live Grep", remap = true })
map("n", "<localleader>G", "<leader>sG", { desc = "Live Grep in Current Directory", remap = true })
map("n", "<localleader>j", "<leader>sj", { desc = "Jump", remap = true })
map("n", "<localleader>l", "<leader>sb", { desc = "Buffer Lines", remap = true })
map("n", "<localleader>m", "<leader>sm", { desc = "Marks", remap = true })
map("n", "<localleader>q", "<leader>sq", { desc = "Quickfix", remap = true })
map("n", "<localleader>t", "<leader>st", { desc = "Buffer Tags", remap = true })
map("n", "<localleader>v", '<leader>s"', { desc = "Register", remap = true })
map("n", "<localleader>w", "<leader>sw", { desc = "Live Grep cword", remap = true })
map("n", "<localleader>x", "<leader>fr", { desc = "Recent File", remap = true })
map("n", "<localleader>z", "<leader>sz", { desc = "Zoxide", remap = true })
