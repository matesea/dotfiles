local M = {}

local opts = function()
    vim.api.nvim_set_hl(
        0,
        'CmpGhostText',
        { link = 'Comment', default = true }
    )
    local cmp = require('cmp')
    local defaults = require('cmp.config.default')()
    local completion_labels = {
        buffer   = "[Buf]",
        path     = "[Path]",
        tmux     = "[Tmux]",
        rg       = "[Rg]",
        cmdline  = "[Cmd]",
    }

    local function has_words_before()
        if vim.bo.buftype == 'prompt' then
            return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- stylua: ignore
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local all_sources = {
        {
            name = 'buffer',
            priority = 50,
            label = 'buffer',
            keyword_length = 3,
            option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
        },
        {
            name = 'path',
            keyword_length = 3,
            priority = 30
        },
        {
            name = 'tmux',
            priority = 10,
            keyword_length = 3,
            option = { all_panes = true, label = 'tmux'},
        },
        {
            name = 'rg',
            priority = 10,
            keyword_length = 3,
            label = 'rg'
        },
    }

    local choose_sources = function(bufnr)
        local tooBig = function(bufnr)
            local max_filesize = 1024 * 1024 -- 1MB
            local check_stats = vim.loop.fs_stat
            local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
                return true
            else
                return false
            end
        end

        if tooBig(bufnr) then
            return {}
        end
        return all_sources
    end

    vim.api.nvim_create_autocmd("BufReadPre", {
        callback = function(ev)
            local sources = choose_sources(ev.buf)
            cmp.setup.buffer({
                sources = cmp.config.sources(sources),
            })
        end,
    })

    return {
        sorting = defaults.sorting,
        experimental = {
            ghost_text = {
                hl_group = 'Comment',
            },
        },
        completion = {
            completeopt = 'menu,menuone,noinsert'
                .. (auto_select and '' or ',noselect'),
        },
        preselect = auto_select and cmp.PreselectMode.Item
            or cmp.PreselectMode.None,
        view = {
            entries = {follow_cursor = true},
        },
        sources = cmp.config.sources(choose_sources(vim.api.nvim_get_current_buf())),
        performance = {
            max_view_entries = 20,
        },
        mapping = cmp.mapping.preset.insert({
            -- <CR> accepts currently selected item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<S-CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-n>'] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Insert,
            }),
            ['<C-p>'] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert,
            }),
            --[[ disable c-k/c-j select to not conflict with vim-tmux-navigator
            ['<C-j>'] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Insert,
            }),
            ['<C-k>'] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert,
            }),
            ]]
            ['<C-d>'] = cmp.mapping.select_next_item({ count = 5 }),
            ['<C-u>'] = cmp.mapping.select_prev_item({ count = 5 }),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-c>'] = function(fallback)
                cmp.close()
                fallback()
            end,
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        formatting = {
            format = function(entry, item)
                -- Set menu source name
                item.kind = item.kind
                if completion_labels[entry.source.name] then
                    item.menu = completion_labels[entry.source.name]
                end

                local widths = {
                    abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                    menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                }

                for key, width in pairs(widths) do
                    if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                        item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
                    end
                end

                return item
            end,
        },
    }
end

function M.setup()
    local cmp = require('cmp')
    cmp.setup(opts())
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = 'buffer',
                priority = 50,
                keyword_length = 3,
                option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
            },
            {
                name = "cmdline",
                priority = 40,
                keyword_length = 3,
                option = {igonre_cmd = {"Man", "!"}}
            },
            {
                name = 'path',
                priority = 40,
                keyword_length = 3,
            },
            {
                name = 'tmux',
                priority = 10,
                keyword_length = 3,
                option = {
                    all_panes = true,
                    label = 'tmux'
                },
            },
        })
    })
    cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = 'buffer',
                priority = 50,
                keyword_length = 3,
                option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
            },
            --[[
            {
                name = 'tmux',
                priority = 10,
                option = { all_panes = true, label = 'tmux' },
            },
            ]]
        })
    })
end

return M
