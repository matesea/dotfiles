local M = {}

function M.setup()
    local status_ok, gitsigns = pcall(require, "gitsigns")

    if not status_ok then
        return
    end

    vim.opt.csto = 0
    -- show msg when any other cscope db added
    vim.opt.cscopeverbose = true
    -- display result in quickfix
    vim.opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
    vim.opt.cscoperelative = true
    gitsigns.setup{
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
                      opts = opts or {}
                      opts.buffer = bufnr
                      vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            -- map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
            -- map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})
            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- Actions
            -- map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            -- map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            -- map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            -- map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            -- map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
            -- map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            -- map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
            -- map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            -- map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
            map('n', '<leader>td', gs.toggle_deleted)
            -- -- Text object
            -- map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            -- map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
    vim.opt.updatetime = 300
end

return M
