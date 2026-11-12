
--[[
local function zoxide()
    Snacks.picker.zoxide({
        confirm = function(picker)
            picker:close()
            local item = picker:current()
            if item and item.file then
                vim.cmd.tcd(item.file)
            end
        end,
    })
end
]]

-- Terminal Mappings
local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			toggle = {
				map = function(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.silent = opts.silent ~= false
					Snacks.keymap.set(mode, lhs, rhs, opts)
				end,
			},
			dim = { enabled = true },
			indent = { enabled = true },
			quickfile = { enabled = true },
			git = {},
			picker = {},
			bigfile = {
				notify = true, -- show notification when big file detected
				size = 3 * 1024 * 1024, -- 3MB
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
					vim.b.completion = false
				end,
			},
			terminal = {
				win = {
					style = "terminal",
					wo = { winbar = "" },
                    -- stylua: ignore
                    keys = {
                        nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
                        nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
                        nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
                        nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
                        hide_slash = { '<C-/>', 'hide', desc = 'Hide Terminal', mode = 't' },
                        hide_underscore = { '<c-_>', 'hide', desc = 'which_key_ignore', mode = 't' },
                    },
				},
			},
		},
		keys = {
            -- stylua: ignore start
            --[[

            {'<leader><localleader>', function() Snacks.picker() end, 'Pickers'},
            {'<leader>sz', zoxide, 'Zoxide'},
            {'<leader>sb', function() Snacks.picker.lines() end, desc = 'Lines'},
            {'<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers'},
            {'<leader>fr', function() Snacks.picker.picker('oldfiles') end, desc = 'Recent'},
            {'<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers'},
            {'<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History'},
            {'<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands'},
            {'<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History'},
            {'<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps'},
            {'<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks'},
            {'<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List'},

            -- grep
            { '<leader>sg', function() Snacks.picker.grep() end, desc = "Live Grep"},
            { '<leader>sG', function() Snacks.picker.grep({cwd = vim.fn.expand("%:h")}) end, desc = "Live Grep in Current Directory"},
            { '<leader>sw', function() Snacks.picker.grep_word() end, desc = "Live Grep cword"},

            -- git
            {'<leader>gb', function() Snacks.picker.git_log_line() end, desc = 'Git Blame Line'},
            {'<leader>gc', function() Snacks.picker.git_log_file() end, desc = 'Git Log File'},

          ]]
            { "<leader>ft", function() Snacks.terminal() end,          desc = "Toggle Terminal", },
            { "<c-/>",      function() Snacks.terminal.focus(nil) end, mode = { "n", "t" },      desc = "Terminal Focus", },
            { "<c-_>",      function() Snacks.terminal.focus(nil) end, mode = { "n", "t" },      desc = "Terminal Focus", },

            {
                "<leader>cr",
                function()
                    vim.fn.chdir(Snacks.git.get_root())
                    print(vim.fn.getcwd())
                end,
                desc = "cd File's Project Root",
            },
            { "<leader>bd", function() Snacks.bufdelete() end,           desc = "Delete Buffer", },
            { "<leader>bo", function() Snacks.bufdelete.other() end,     desc = "Delete Other Buffer", },
            { "<leader>bi", function() Snacks.bufdelete.invisible() end, desc = "Delete Invisible Buffer", },
			--stylua: ignore end
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					Snacks.toggle.zoom():map("sz")
					Snacks.toggle.zen():map("sZ")
					Snacks.toggle.zoom():map("<leader>uz")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option(
							"showtabline",
							{ off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }
						)
						:map("<leader>ua")
					Snacks.toggle.dim():map("<leader>ud")
					Snacks.toggle.indent():map("<leader>ui")
				end,
			})
		end,
	},
}
