local ft_code = { "c", "h", "S", "cpp", "python", "vim", "sh", "lua", "java" }

return {
	{
		"nvim-mini/mini.nvim",
		lazy = false,
		config = function()
			local miniclue = require("mini.clue")
			require("mini.tabline").setup({ show_icons = false })
			require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
			-- require('mini.animate').setup()
			require("mini.clue").setup({
				clues = {
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
				triggers = {
					-- Leader triggers
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
					{ mode = "n", keys = "<LocalLeader>" },
					{ mode = "x", keys = "<LocalLeader>" },

					-- Built-in completion
					{ mode = "i", keys = "<C-x>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },

					-- `s` key
					{ mode = "n", keys = "s" },
					{ mode = "x", keys = "s" },

					-- `[` and `]` key
					{ mode = "n", keys = "]" },
					{ mode = "n", keys = "[" },
				},
			})

			-- enable these modules only if filetype matches
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("code_edit", { clear = true }),
				pattern = ft_code,
				once = true,
				callback = function(event)
					require("mini.trailspace").setup({ only_in_normal_buffers = true })

					-- Better Around/Inside textobjects
					--
					-- Examples:
					--  - va)  - [V]isually select [A]round [)]paren
					--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
					--  - ci'  - [C]hange [I]nside [']quote
					require("mini.ai").setup({ n_lines = 500 })

					-- Add/delete/replace surroundings (brackets, quotes, etc.)
					--
					-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
					-- - sd'   - [S]urround [D]elete [']quotes
					-- - sr)'  - [S]urround [R]eplace [)] [']
					require("mini.surround").setup({
						mappings = {
							add = "sa", -- Add surrounding in Normal and Visual modes
							delete = "ds", -- Delete surrounding
							find = "gzf", -- Find surrounding (to the right)
							find_left = "gzF", -- Find surrounding (to the left)
							highlight = "gzh", -- Highlight surrounding
							replace = "cs", -- Replace surrounding
						},
					})

					require("mini.pairs").setup()
					require("mini.align").setup({
						mappings = {
							start = "gb",
							start_with_preview = "gB",
						},
					})

					-- manually load nvim-ts-context-commentstring
					require("lazy").load({ plugins = { "nvim-ts-context-commentstring" } })
					require("mini.comment").setup({
						options = {
							custom_commentstring = function()
								return require("ts_context_commentstring.internal").calculate_commentstring()
									or vim.bo.commentstring
							end,
						},
					})
				end,
			})
		end,
	},
}
