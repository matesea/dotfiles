local ft_code = { "c", "h", "S", "cpp", "python", "vim", "sh", "lua", "java" }

return {
	{
		"fei6409/log-highlight.nvim",
		ft = { "text", "log" },
		config = function()
			require("log-highlight").setup({
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
			})
			vim.opt_local.filetype = "log"
			vim.opt_local.syntax = "ON"
		end,
	},

	{ "vivien/vim-linux-coding-style", lazy = true },

	{ "Vimjas/vim-python-pep8-indent", lazy = true, ft = { "python" } },

	{ "octol/vim-cpp-enhanced-highlight", lazy = true, ft = { "c", "h", "S", "cpp" } },

	{ "matesea/trace32-practice.vim", lazy = true, ft = "cmm" },

	{ "vim-scripts/scons.vim", lazy = true, ft = "scons" },

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
		config = function()
			if _G.Snacks then
				local rm = require("render-markdown")
				Snacks.toggle({
					name = "Render Markdown",
					get = rm.get,
					set = rm.set,
				}):map("<leader>um")
			end
		end,
	},

	{ "westeri/asl-vim", lazy = true, ft = "asl" },
}
