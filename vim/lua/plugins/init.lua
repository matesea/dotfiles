local function lazy_init()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

-- workaround: nvim-yarp autoload vimscript not loaded
-- cmd [[packadd nvim-yarp]]

local ft_code = { "c", "h", "S", "cpp", "python", "vim", "sh", "lua", "java" }
local has_git = vim.fn.executable("git") == 1

local plugins = {
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.sonokai_style = "default"
			vim.g.sonokai_better_performance = 1
			-- vim.g.sonokai_transparent_background = 1
			vim.g.sonokai_dim_inactive_windows = 1
			vim.cmd.colorscheme("sonokai")
		end,
	},

	{
		"folke/tokyonight.nvim",
		enabled = false,
		lazy = true,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon",
				cache = true,
				dim_inactive = true,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		enabled = false,
		lazy = true,
		init = function()
			vim.cmd.colorscheme("kanagawa")
		end,
		opts = {
			compile = true, -- enable compiling the colorscheme
			dimInactive = true, -- dim inactive window `:h hl-NormalNC`
		},
	},

	{
		"tpope/vim-fugitive",
		lazy = true,
		cond = has_git,
		cmd = { "Git", "GV", "Gcd" },
	},

	{
		"lewis6991/gitsigns.nvim",
		-- version = 'release',
		cond = has_git,
		keys = {
			{ "]c", remap = true, desc = "Next Hunk" },
			{ "[c", remap = true, desc = "Previous Hunk" },
			{
				"<leader>hr",
				function()
					package.loaded.gitsigns.reset_hunk()
				end,
				desc = "Reset Hunk",
			},
			{
				"<leader>hb",
				function()
					package.loaded.gitsigns.blame_line({ full = true })
				end,
				desc = "Blame Line",
			},
		},
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					max_file_length =
						20000,
						-- Navigation
						-- map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
						-- map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
						map("n", "]c", function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end, { expr = true })
					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					-- map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
					-- map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
					-- map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
					-- map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
					-- map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
					-- map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
					-- map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
					-- map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
					-- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
					-- map('n', '<leader>tb', gs.toggle_current_line_blame)
					map("n", "<leader>hd", gs.diffthis)
					-- map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
					map("n", "<leader>td", gs.toggle_deleted)
					-- -- Text object
					-- map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
					-- map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				end,
			})
			vim.opt.updatetime = 300
		end,
	},

	{ "junegunn/gv.vim", dependencies = { "tpope/vim-fugitive" }, cmd = "GV" },

	{
		"nvim-mini/mini.nvim",
		lazy = false,
		config = function()
			require("mini.icons").setup()
			require("mini.tabline").setup()
			require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })

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
							update_n_lines = "gzn", -- Update `n_lines`
						},
					})

					require("mini.pairs").setup()
					require("mini.align").setup({
						mappings = {
							start = "gb",
							start_with_preview = "gB",
						},
					})
				end,
			})
		end,
	},

	{
		"stevearc/quicker.nvim",
		ft = "qf",
		event = "QuickFixCmdPost",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			edit = {
				enabled = true,
				autosave = false,
			},
			highlight = {
				lsp = false,
				load_buffers = false,
			},
            -- stylua: ignore
            keys = {
                { '>',
                    function()
                        require('quicker').expand({
                                before = 2, after = 2,
                                add_to_existing = true })
                    end, desc = 'Expand quickfix context'
                },
                { '<',
                    function()
                        require('quicker').collapse()
                    end, desc = 'Collapse quickfix context'
                },
            },
			max_filename_width = function()
				return math.floor(vim.o.columns / 2)
			end,
		},
	},

	{
		"junegunn/fzf",
		lazy = true,
		-- fzf is loaded either by fzf to filter quickfix or caused by dependencies
		build = "./install --completion --key-bindings --xdg --no-update-rc",
	},

	{
		"ibhagwan/fzf-lua",
		-- url = 'https://gitlab.com/ibhagwan/fzf-lua', -- XXX: github fzf-lua not found
		lazy = true,
		dependencies = { "fzf" },
		cmd = "FzfLua",
		keys = {
			{ "<leader>;", "<cmd>FzfLua builtin<cr>", desc = "pick fzf-lua builtin" },

			{ ";a", "<cmd>FzfLua lines<cr>", desc = "all buffer lines" },
			{ ";b", "<cmd>FzfLua buffers<cr>", desc = "open buffers" },
			{ ";c", ':FzfLua files cwd=<C-R>=expand("%:h")<cr><cr>', desc = "find files with cwd" },

			{ ";e", "<cmd>FzfLua files<cr>", desc = "pick file" },
			{ ";f", "<cmd>FzfLua global<cr>", desc = "global picker for file/buffer/tag" },

			-- grep related
			{
				";gc",
				':FzfLua live_grep_native cwd=<C-R>=expand("%:h")<cr><cr>',
				desc = "grep files in the same folder of current open buffer",
			},
			{
				";gd",
				function()
					local fzf = require("fzf-lua")
					fzf.fzf_exec("fd -t d", {
						prompt = "Folder:",
						actions = {
							["default"] = function(selected)
								if selected and #selected > 0 then
									fzf.live_grep({ cwd = selected[1] })
								end
							end,
						},
					})
				end,
				desc = "grep on selected folder",
			},
			{ ";gl", "<cmd>FzfLua live_grep_native<cr>", desc = "live grep" },
			{ ";gw", "<cmd>FzfLua grep_cword<cr>", desc = "search word under cursor" },

			{ ";h", "<cmd>FzfLua oldfiles<cr>", desc = "pick from history" },
			{ ";j", "<cmd>FzfLua jumps<cr>", desc = "pick from jumps" },
			{ ";q", "<cmd>FzfLua quickfix<cr>", desc = "pick from quickfix" },
			{ ";r", "<cmd>FzfLua registers<cr>", desc = "pick from registers" },
			{ ";s", "<cmd>FzfLua tagstack<cr>", desc = "pick tagstack" },

			{ ";t", "<cmd>FzfLua btags<cr>", desc = "search buffer tags" },

			{ ";zd", "<cmd>FzfLua zoxide<cr>", desc = "jump directory with zoxide" },

			{ ";;", "<cmd>FzfLua command_history<cr>", desc = "command history" },
			{ ";:", "<cmd>FzfLua commands<cr>", desc = "commands" },
			{ ";/", "<cmd>FzfLua search_history<cr>", desc = "search history" },
		},
		config = function()
			local status_ok, fzf_lua = pcall(require, "fzf-lua")

			if not status_ok then
				return
			end

			local previewer = "builtin"

			local actions = require("fzf-lua.actions")

			local fzf_lua_table = {
				"max-perf",
				defaults = {
					color_icons = false,
					file_icons = false,
					git_icons = false,
				},
				actions = {
					-- Below are the default actions, setting any value in these tables will override
					-- the defaults, to inherit from the defaults change [1] from `false` to `true`
					files = {
						true, -- uncomment to inherit all the below in your custom config
						-- Pickers inheriting these actions:
						--   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
						--   tags, btags, args, buffers, tabs, lines, blines
						-- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
						-- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
						-- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
						["enter"] = FzfLua.actions.file_edit,
						["ctrl-s"] = FzfLua.actions.file_split,
						["ctrl-v"] = FzfLua.actions.file_vsplit,
						["ctrl-t"] = FzfLua.actions.file_tabedit,
						["alt-q"] = FzfLua.actions.file_sel_to_qf,
						["alt-Q"] = FzfLua.actions.file_sel_to_ll,
						["alt-i"] = FzfLua.actions.toggle_ignore,
						["alt-h"] = FzfLua.actions.toggle_hidden,
						["alt-f"] = FzfLua.actions.toggle_follow,
					},
				},
				files = {
					previewer = false,
				},
				oldfiles = {
					include_current_session = true,
				},
				previewers = {
					builtin = {
						-- fzf-lua is very fast, but it really struggled to preview a couple files
						-- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
						-- It turns out it was Treesitter having trouble parsing the files.
						-- With this change, the previewer will not add syntax highlighting to files larger than 100KB
						-- (Yes, I know you shouldn't have 100KB minified files in source control.)
						syntax_limit_b = 1024 * 100, -- 100KB
					},
				},
				grep = {
					-- One thing I missed from Telescope was the ability to live_grep and the
					-- run a filter on the filenames.
					-- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
					-- With this change, I can sort of get the same behaviour in live_grep.
					-- ex: > enable --*/plugins/*
					-- I still find this a bit cumbersome. There's probably a better way of doing this.
					rg_glob = true, -- enable glob parsing
					glob_flag = "--iglob", -- case insensitive globs
					glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
				},
				winopts = {
					width = 0.95,
					height = 0.95,
					preview = {
						default = previewer,
						layout = "vertical",
						vertical = "down:45%",
					},
				},
			}

			local fzf_tmux_opts = vim.env.FZF_TMUX_OPTS
			if fzf_tmux_opts ~= nil then
				-- FZF_TMUX_OPTS set, choose with fzf-tmux popup window
				if vim.fn.executable("bat") == 1 then
					previewer = "bat"
				end
				fzf_lua_table.fzf_bin = "fzf-tmux"
				fzf_lua_table.fzf_opts = { ["--border"] = "rounded" }
				fzf_lua_table.fzf_tmux_opts = { ["-p"] = "80%,90%" }
				fzf_lua_table.winopts = {
					preview = {
						default = previewer,
						layout = "vertical",
						vertical = "down:45%",
					},
				}
			end
			fzf_lua.setup(fzf_lua_table)
		end,
	},

	{
		"folke/flash.nvim",
		-- event = "VeryLazy",
		---@type Flash.Config
		lazy = true,
		opts = {},
		keys = {
			{
				"ss",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			--[[
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            --]]
		},
	},

	{
		"gennaro-tedesco/nvim-possession",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		lazy = true,
		config = true,
		keys = {
			{
				"<leader>sl",
				function()
					require("nvim-possession").list()
				end,
				desc = "list existing sessions",
			},
			{
				"<leader>sn",
				function()
					require("nvim-possession").new()
				end,
				desc = "create new session",
			},
			{
				"<leader>su",
				function()
					require("nvim-possession").update()
				end,
				desc = "update current session",
			},
			{
				"<leader>sd",
				function()
					require("nvim-possession").delete()
				end,
				desc = "delete current session",
			},
		},
	},

	{
		"trmckay/based.nvim",
		lazy = true,
		cmd = "BasedConvert",
		config = function()
			require("based").setup({})
		end,
	},

	{
		"chentoast/marks.nvim",
		lazy = true,
		config = function()
			require("marks").setup()
		end,
	},

	{
		"azabiong/vim-highlighter",
		config = function()
			vim.api.nvim_set_keymap("n", "f<c-h>", ":Hi+<space>", { noremap = true })
			vim.cmd([[
                nn [g <cmd>Hi {<cr>
                nn ]g <cmd>Hi }<cr>
                nn [f <cmd>Hi <<cr>
                nn ]f <cmd>Hi ><cr>
            ]])
		end,
		-- [g: jump to any highlight backward
		-- ]g: jump to any highlight forward
		-- [f: jump to highlight under cursor backward
		-- ]f: jump to highlight under cursor forward

		-- f + <cr>: HiSet, hightlight current word
		-- f + <backspace>: HiErase
		-- f + <C-L>: HiClear
		-- f + tab: HiFind
		-- :Hi + <pattern>: highlight one pattern
		-- :Hi save <name>: save current highlight to file
	},

	{ "vladdoster/remember.nvim", config = true },

	{
		"fei6409/log-highlight.nvim",
		ft = "log",
		opts = {
			extension = "log",
			keyword = {
				error = {
					"bug",
					"panic",
					"Panic",
					"Oops",
					"oops",
				},
				warning = {
					"retry",
					"retrying",
					"timeout",
					"Timed out",
					"timed out",
				},
				info = {
					"INFORMATION",
					"INFO",
					"info",
				},
			},
		},
	},

	{ "vivien/vim-linux-coding-style", lazy = true },

	{ "Vimjas/vim-python-pep8-indent", lazy = true, ft = { "python" } },

	{ "octol/vim-cpp-enhanced-highlight", lazy = true, ft = { "c", "h", "S", "cpp" } },

	{
		"nvim-mini/mini.comment",
		version = false,
		ft = ft_code,
		dependencies = { "nvim-ts-context-commentstring" },
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},

	{
		"embear/vim-foldsearch",
		lazy = true,
		cmd = {
			"Fp", -- Show the lines that contain the given regular expression
			"Fw", -- Show lines which contain the word under the cursor
			"Fs", -- Show lines which contain previous search pattern
			-- zE to clear all fold
			-- zo close fold, zC to close all fold
			-- zo open fold, zO to open all fold
			-- za toggle fold, zA toggle it recursively
		},
	},

	{
		"ngemily/vim-vp4",
		lazy = true,
		cmd = { "Vp4FileLog", "Vp4Annotate", "Vp4Describe", "Vp4" },
		config = function()
			if vim.fn.exists(":TSContextDisable") > 0 then
				vim.cmd("TSContextDisable")
			end
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
		version = false,
		lazy = true,
		-- event = 'BufRead',
		dependencies = {
			{ "nvim-treesitter-textobjects" },
			-- {'nvim-ts-context-commentstring'},
			{ "nvim-treesitter-context" },
		},
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"comment",
				"cpp",
				"diff",
				"gitattributes",
				"gitignore",
				"go",
				"html",
				"http",
				"java",
				"javascript",
				"jsdoc",
				"json",
				"julia",
				"kotlin",
				"llvm",
				"lua",
				"luadoc",
				"luap",
				"make",
				"markdown",
				"markdown_inline",
				"ninja",
				"nix",
				"perl",
				"printf",
				"python",
				"query",
				"regex",
				"ruby",
				"toml",
				"rust",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},

			highlight = {
				enable = false,
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = false,
					node_incremental = "v",
					scope_incremental = false,
					node_decremental = "V",
				},
			},

			indent = {
				enable = true,
			},

			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = true },
			},

			-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["],"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[,"] = "@parameter.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">,"] = "@parameter.inner",
					},
					swap_previous = {
						["<,"] = "@parameter.inner",
					},
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = true,
		ft = ft_code,
		keys = {
			{
				"gd",
				mode = "n",
				function()
					require("treesitter-context").go_to_context()
				end,
				desc = "jump to definition",
			},
		},
		opts = {
			mode = "cursor",
			max_lines = 3,
			line_numbers = true,
			trim_scope = "outer",
		},
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- nvim-cmp source for buffer words
			"hrsh7th/cmp-buffer",
			-- nvim-cmp source for path
			"hrsh7th/cmp-path",
			-- Tmux completion source for nvim-cmp
			"andersevenrud/cmp-tmux",
			-- rip grep source
			"lukas-reineke/cmp-rg",
			-- nvim-cmp source for cmdline
			"hrsh7th/cmp-cmdline",
		},
		event = "InsertEnter",
		config = function()
			local opts = function()
				vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
				local cmp = require("cmp")
				local defaults = require("cmp.config.default")()
				local completion_labels = {
					buffer = "[Buf]",
					path = "[Path]",
					tmux = "[Tmux]",
					rg = "[Rg]",
					cmdline = "[Cmd]",
				}

				local function has_words_before()
					if vim.bo.buftype == "prompt" then
						return false
					end
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    -- stylua: ignore
                    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
				end

				local all_sources = {
					{
						name = "buffer",
						priority = 50,
						label = "buffer",
						keyword_length = 3,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{
						name = "path",
						keyword_length = 3,
						priority = 30,
					},
					{
						name = "tmux",
						priority = 10,
						keyword_length = 3,
						option = { all_panes = true, label = "tmux" },
					},
					{
						name = "rg",
						priority = 10,
						keyword_length = 3,
						label = "rg",
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
							hl_group = "Comment",
						},
					},
					completion = {
						completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
					},
					preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
					view = {
						entries = { follow_cursor = true },
					},
					sources = cmp.config.sources(choose_sources(vim.api.nvim_get_current_buf())),
					performance = {
						max_view_entries = 20,
					},
					mapping = cmp.mapping.preset.insert({
						-- <CR> accepts currently selected item.
						-- Set `select` to `false` to only confirm explicitly selected items.
						["<CR>"] = cmp.mapping.confirm({ select = false }),
						["<S-CR>"] = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = false,
						}),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-n>"] = cmp.mapping.select_next_item({
							behavior = cmp.SelectBehavior.Insert,
						}),
						["<C-p>"] = cmp.mapping.select_prev_item({
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
						["<C-d>"] = cmp.mapping.select_next_item({ count = 5 }),
						["<C-u>"] = cmp.mapping.select_prev_item({ count = 5 }),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-c>"] = function(fallback)
							cmp.close()
							fallback()
						end,
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							elseif has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
							else
								fallback()
							end
						end, { "i", "s" }),
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
									item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
								end
							end

							return item
						end,
					},
				}
			end
			local cmp = require("cmp")
			cmp.setup(opts())
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "buffer",
						priority = 50,
						keyword_length = 3,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{
						name = "cmdline",
						priority = 40,
						keyword_length = 3,
						option = { igonre_cmd = { "Man", "!" } },
					},
					{
						name = "path",
						priority = 40,
						keyword_length = 3,
					},
					{
						name = "tmux",
						priority = 10,
						keyword_length = 3,
						option = {
							all_panes = true,
							label = "tmux",
						},
					},
				}),
			})
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "buffer",
						priority = 50,
						keyword_length = 3,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					--[[
                    {
                        name = 'tmux',
                        priority = 10,
                        option = { all_panes = true, label = 'tmux' },
                    },
                    ]]
				}),
			})
		end,
	},

	{ -- dim inactive window
		"levouh/tint.nvim",
		lazy = true,
		config = function()
			require("tint").setup()
		end,
	},

	{
		"b0o/incline.nvim",
		lazy = true,
		event = "VeryLazy",
		dependencies = { "mini.nvim" },
		config = function()
			local helpers = require("incline.helpers")
			local mini_icons = require("mini.icons")
			require("incline").setup({
				ignore = {
					buftypes = "special",
					filetypes = { "gitcommit" },
				},
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = mini_icons.get("file", filename)
					local modified = vim.bo[props.buf].modified
					return {
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						" ",
						ft_icon and { ft_icon, " ", guibg = "none", group = ft_color } or "",
					}
				end,
			})
		end,
	},

	{
		"nvim-focus/focus.nvim",
		cmd = {
			"FocusSplitNicely",
			"FocusSplitCycle",
			"FocusToggle",
		},
		module = "focus",
		dependencies = {
			"levouh/tint.nvim",
		},
		keys = {
			{ "<leader>fn", "<cmd>FocusSplitNicely<cr>", "split focus nicely" },
		},
		config = function()
			require("focus").setup()
		end,
	},

	{
		"stevearc/aerial.nvim",
		lazy = true,
		dependencies = {
			{ "nvim-treesitter" },
		},
		keys = {
			{ "]a", "<cmd>AerialNext<cr>", desc = "[Aerial]jump to next symbol" },
			{ "[a", "<cmd>AerialPrev<cr>", desc = "[Aerial]jump to prevoius symbol" },
			{ "<leader>a", "<cmd>AerialToggle<cr>", desc = "toggle Aerial window" },
		},
		config = function()
			require("aerial").setup({
				backends = { "treesitter" },
			})

			-- shortcut to find function in fzf mode
			-- faster than fzf.vim/fzf-lua BTags
			-- vim.keymap.set('n', ';z', '<cmd>call aerial#fzf()<cr>')
		end,
	},

	{ "matesea/trace32-practice.vim", lazy = true, ft = "cmm" },

	{ "vim-scripts/scons.vim", lazy = true, ft = "scons" },

	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		lazy = true,
		ft = "lua",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{
				"mason-org/mason.nvim",
				---@module 'mason.settings'
				---@type MasonSettings
				---@diagnostic disable-next-line: missing-fields
				opts = {},
			},
			-- Maps LSP server names between nvim-lspconfig and Mason package names.
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			-- Brief aside: **What is LSP?**
			--
			-- LSP is an initialism you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--  See `:help lsp-config` for information about keys and how to configure
			---@type table<string, vim.lsp.Config>
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},

				stylua = {}, -- Used to format Lua code

				-- Special Lua Config, as recommended by neovim help docs
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
								path = { "lua/?.lua", "lua/?/init.lua" },
							},
							workspace = {
								checkThirdParty = false,
								-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
								--  See https://github.com/neovim/nvim-lspconfig/issues/3189
								library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
									"${3rd}/luv/library",
									"${3rd}/busted/library",
								}),
							},
						})
					end,
					settings = {
						Lua = {},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- You can add other tools here that you want Mason to install
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		-- event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		---@module 'conform'
		---@type conform.setupOpts
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ "rickhowe/spotdiff.vim", lazy = true, cmd = "Diffthis" },

	-- Perform diffs on blocks of code
	{
		"AndrewRadev/linediff.vim",
		lazy = true,
		cmd = { "Linediff", "LinediffAdd" },
		keys = {
			{ "<leader>mdf", ":Linediff<CR>", mode = "x", desc = "Line diff" },
			{ "<leader>mda", ":LinediffAdd<CR>", mode = "x", desc = "Line diff add" },
			{ "<leader>mds", "<cmd>LinediffShow<CR>", desc = "Line diff show" },
			{ "<leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
		},
	},

	{
		"s1n7ax/nvim-window-picker",
		keys = function(_, keys)
			local pick_window = function()
				local picked_window_id = require("window-picker").pick_window()
				if picked_window_id ~= nil then
					vim.api.nvim_set_current_win(picked_window_id)
				end
			end

			local swap_window = function()
				local picked_window_id = require("window-picker").pick_window()
				if picked_window_id ~= nil then
					local current_winnr = vim.api.nvim_get_current_win()
					local current_bufnr = vim.api.nvim_get_current_buf()
					local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
					vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
					vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
				end
			end

			local mappings = {
				{ "sp", pick_window, desc = "Pick window" },
				{ "sw", swap_window, desc = "Swap picked window" },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			hint = "floating-big-letter",
			show_prompt = false,
			filter_rules = {
				include_current_win = true,
				autoselect_one = true,
				bo = {
					filetype = { "notify", "noice", "neo-tree-popup" },
					buftype = { "prompt", "nofile", "quickfix" },
				},
			},
		},
	},

	{
		"rainbowhxch/accelerated-jk.nvim",
		lazy = true,
		keys = {
			{ "j", "<Plug>(accelerated_jk_gj)", desc = "accelerated j" },
			{ "k", "<Plug>(accelerated_jk_gk)", desc = "accelerated k" },
		},
		opts = {},
	},

	{
		"kevinhwang91/nvim-ufo",
		lazy = true,
		keys = {
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "close all folds",
			},
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "open all folds",
			},
			{
				"zm",
				function()
					require("ufo").closeFoldsWith()
				end,
				desc = "close fold with v:count",
			},
			-- {'zr', function() require('ufo').openFoldsExceptKinds end, desc = 'open all folds'},
		},
		dependencies = {
			{ "kevinhwang91/promise-async", lazy = true },
			{ "nvim-treesitter" },
			-- {'nvim-lspconfig'},
		},
		config = function()
			local status_ok, ufo = pcall(require, "ufo")
			if not status_ok then
				return
			end
			local backend = "treesitter"

			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "K", function()
				local winid = ufo.peekFoldedLinesUnderCursor()
				if not winid then
					-- choose one of coc.nvim and nvim lsp
					vim.lsp.buf.hover()
				end
			end)

			if backend == "lspconfig" then
				-- Option 2: nvim lsp as LSP client
				-- Tell the server the capability of foldingRange,
				-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				}
				local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
				for _, ls in ipairs(language_servers) do
					require("lspconfig")[ls].setup({
						capabilities = capabilities,
						-- you can add other fields for setting up lsp server in this table
					})
				end
				ufo.setup()
			elseif backend == "treesitter" then
				-- Option 3: treesitter as a main provider instead
				-- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
				-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
				ufo.setup({
					provider_selector = function(bufnr, filetype, buftype)
						return { "treesitter", "indent" }
					end,
				})
			end
		end,
	},

	{
		"AndrewRadev/dsf.vim",
        -- stylua: ignore
        lazy = true,
		keys = {
			{ "dsf", "<Plug>DsfDelete", noremap = true, desc = "Delete Surrounding Function" },
			{ "csf", "<Plug>DsfChange", noremap = true, desc = "Change Surrounding Function" },
		},
		init = function()
			vim.g.dsf_no_mappings = 1
		end,
	},

	{ "westeri/asl-vim", lazy = true, ft = "asl" },

	{
		"christoomey/vim-tmux-navigator",
		cond = vim.env.TMUX,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = true
		end,
		keys = {
			{ "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t" }, desc = "go to left window" },
			{ "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t" }, desc = "go to down window" },
			{ "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t" }, desc = "go to upper window" },
			{ "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "go to right window" },
		},
	},

	-- jk to escape
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({})
		end,
	},

	{
		"pechorin/any-jump.vim",
		cmd = { "AnyJump", "AnyJumpVisual" },
		keys = {
			{ "<leader>ii", "<cmd>AnyJump<CR>", desc = "Any Jump" },
			{ "<leader>ii", "<cmd>AnyJumpVisual<CR>", mode = "x", desc = "Any Jump" },
			{ "<leader>ib", "<cmd>AnyJumpBack<CR>", desc = "Any Jump Back" },
			{ "<leader>il", "<cmd>AnyJumpLastResults<CR>", desc = "Any Jump Resume" },
		},
		config = function()
			vim.g.any_jump_disable_default_keybindings = 1
		end,
	},

	{
		"dhananjaylatkar/cscope_maps.nvim",
		lazy = true,
		keys = {
			{ "<space>f", ":Cscope find<space>", desc = "trigger Cscope" },
			{
				"<space>s",
				':Cscope find s <C-R>=expand("<cword>")<cr><cr>',
				silent = true,
				desc = "find all references to a token under cursor",
			},
			{
				"<space>g",
				':Cscope find g <C-R>=expand("<cword>")<cr><cr>',
				silent = true,
				desc = "find definition of the token under cursor",
			},
			{
				"<space>c",
				':Cscope find c <C-R>=expand("<cword>")<cr><cr>',
				silent = true,
				desc = "find all calls to the function under cursor",
			},
		},
		cmd = { "Cscope" },
		config = function()
			require("cscope_maps").setup({
				disable_maps = true, -- true disables keymaps, only :Cscope will be loaded
				skip_input_prompt = true, -- "true" doesn't ask for input
				cscope = {
					db_file = "GTAGS", -- location of cscope db file
					exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
					picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
					-- size of quickfix window
					qf_window_size = 10, -- any positive integer
					-- position of quickfix window
					qf_window_pos = "bottom", -- "bottom", "right", "left" or "top"
					skip_picker_for_single_result = true, -- jump directly to position for single result
					-- these args are directly passed to "cscope -f <db_file> <args>"
					-- db_build_cmd_args = { "-bqkv" },
					-- statusline indicator, default is cscope executable
					statusline_indicator = nil,
				},
			})
		end,
	},

	-- Git blame visualizer
	{
		"FabijanZulj/blame.nvim",
		cond = has_git,
		cmd = "BlameToggle",
        -- stylua: ignore
        keys = {
            { '<leader>gb', '<cmd>BlameToggle window<CR>', desc = 'Git blame (window)' },
        },
		opts = {
			date_format = "%Y-%m-%d %H:%M",
			merge_consecutive = false,
			max_summary_width = 30,
			mappings = {
				commit_info = "K",
				stack_push = ">",
				stack_pop = "<",
				show_commit = "<CR>",
				close = { "<Esc>", "q" },
			},
		},
	},

	{
		"ghillb/cybu.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "[b", "<Plug>(CybuPrev)" },
			{ "]b", "<Plug>(CybuNext)" },
			--[[
            { '<C-S-Tab>', '<Plug>(CybuLastusedPrev)' },
            { '<C-Tab>', '<Plug>(CybuLastusedNext)' },
            ]]
		},
		opts = {
			style = {
				devicons = { enabled = false },
			},
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			toggle = { enabled = true },
			indent = { enabled = true },
			zen = {
				enabled = true,
				zoom = {
					show = { tabline = false },
					win = { backdrop = true },
				},
			},
			bigfile = {
				notify = true, -- show notification when big file detected
				size = 3 * 1024 * 1024, -- 1.5MB
				line_length = 1000, -- average line length (useful for minified files)
				-- Enable or disable features when big file detected
				---@param ctx {buf: number, ft:string}
				setup = function(ctx)
					if vim.fn.exists(":NoMatchParen") ~= 0 then
						vim.cmd([[NoMatchParen]])
					end
					Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
					vim.b.completion = false
					vim.b.minianimate_disable = true
					vim.b.minihipatterns_disable = true
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ctx.buf) then
							vim.bo[ctx.buf].syntax = ctx.ft
						end
					end)
					-- vimopts
					vim.b.swapfile = false
					vim.b.foldmethod = "manual"
					vim.b.list = false
					vim.b.undolevels = -1
					vim.b.undoreload = 0
					vim.b.syntax = "OFF"
					vim.b.filetype = ""
				end,
			},
			picker = {
				win = {
					-- Make file truncation consider window width.
					-- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
					list = {
						on_buf = function(self)
							self:execute("calculate_file_truncate_width")
						end,
					},
					preview = {
						on_buf = function(self)
							self:execute("calculate_file_truncate_width")
						end,
						on_close = function(self)
							self:execute("calculate_file_truncate_width")
						end,
					},
				},
				actions = {
					-- Make file truncation consider window width.
					-- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
					calculate_file_truncate_width = function(self)
						local width = self.list.win:size().width
						self.opts.formatters.file.truncate = width - 6
					end,
				},
				layouts = {
					default = {
						layout = {
							-- Make the default popup window use 100% of screen not 80%.
							width = 0,
							height = 0,
						},
					},
				},
			},
		},
		keys = {
			--[[

          {';a', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers'},
          {';b', function() Snacks.picker.buffers() end, desc = 'Buffers'},
          {';c', function() Snacks.picker.files({cwd = vim.fn.expand('%:h')}) end, desc = 'Find Files in cwd'},
          {';d', function() Snacks.picker.grep({cwd = vim.fn.expand('%:h')}) end, desc = 'Grep in cwd'},
          {';e', function() Snacks.picker.smart() end, desc = 'Smart Find Files'},
          {';g', function() Snacks.picker.grep() end, desc = 'Grep'},
          {';h', function() Snacks.picker.recent() end, desc = 'Recent'},
          {';j', function() Snacks.picker.jumps() end, desc = 'Jumps'},
          {';q', function() Snacks.picker.qflist() end, desc = 'Quickfix List'},
          {';w', function() Snacks.picker.grep_word() end, desc = 'Grep Word'},

          {';;', function() Snacks.picker.command_history() end, desc = 'Command History'},
          {';:', function() Snacks.picker.commands() end, desc = 'Commands'},
          {';/', function() Snacks.picker.search_history() end, desc = 'Search History'},

          ]]
			{
				";zf",
				function()
					Snacks.picker.zoxide()
				end,
				desc = "Open File with Zoxide",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...) end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` commmand

					Snacks.toggle.indent():map("si")
					Snacks.toggle.zoom():map("sz")
					Snacks.toggle.zen():map("sZ")
				end,
			})
		end,
	},
}

lazy_init()
require("lazy").setup(plugins)
