local M = {}

function M.setup()
    vim.opt.completeopt = {'noinsert', 'menuone', 'noselect'}
    vim.opt.shortmess:append({c = true})

    local cmp = require'cmp'
    cmp.setup({
        snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
 	     ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
 	     ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

 	     ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
 	     ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),

          ['<C-c>'] = function(fallback)
              cmp.close()
              fallback()
          end,
          ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false
          }),
        },
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'tmux' },
          { name = 'path' },
          -- { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
        }),
    })
    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'buffer' }
      },{
          {name = 'path'}
      })
    })
end

return M
