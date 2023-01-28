local M = {}

local completion_labels = {
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
    cmdline = "[Cmd]",
	-- buffer   = "[Buf]",
	path     = "[Path]",
	-- vsnip    = "[VSnip]",
	tmux     = "[Tmux]",
}

function M.setup()
    local status_ok, cmp = pcall(require, "cmp")
    local filetype = vim.bo.filetype

    if not status_ok then
        return
    end

    -- disable completion for log/text
    if filetype == 'log' or filetype == 'text' then
        return
    end

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    vim.opt.completeopt = {'noinsert', 'menuone', 'noselect'}
    vim.opt.shortmess:append({c = true})

    cmp.setup({
        -- snippet = {
        --     expand = function(args)
        --       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        --     end,
        -- },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },

    formatting = {
		format = function(entry, vim_item)
			-- Set menu source name
            vim_item.kind = vim_item.kind
			if completion_labels[entry.source.name] then
				vim_item.menu = completion_labels[entry.source.name]
			end

			vim_item.dup = ({
				nvim_lua = 0,
				buffer = 0,
			})[entry.source.name] or 1

			return vim_item
		end,
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
            "c",
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
          -- { name = 'vsnip' }, -- For vsnip users.
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
      sources = cmp.config.sources(
      -- {{name = 'buffer'}},
      {{name = 'cmdline'}}
      -- {{name = 'path'},}
      )
    })
end

return M
