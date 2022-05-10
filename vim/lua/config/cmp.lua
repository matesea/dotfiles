local M = {}

function M.setup()
    local status_ok, cmp = pcall(require, "cmp")

    if not status_ok then
        return
    end

    vim.opt.completeopt = {'noinsert', 'menuone', 'noselect'}
    vim.opt.shortmess:append({c = true})

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
          { name = 'buffer',
            option = {
              get_bufnrs = function()
                  -- skip large files
                  local buf = vim.api.nvim_get_current_buf()
                  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  if byte_size > 1024 * 1024 then -- 1 Megabyte max
                      return {}
                  end
                  return vim.api.nvim_list_bufs()
              end}
          },
          { name = 'tmux',
            option = {
                all_panes = true,
                label = '[tmux]',
            }
          },
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
