-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter
-- rafi settings

-- Setup extra parsers.
--[[
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.http = {
	filetype = 'http',
	install_info = {
		url = 'https://github.com/rest-nvim/tree-sitter-http',
		files = { 'src/parser.c' },
		branch = 'main',
	},
}
]]

-- Setup treesitter
require('nvim-treesitter.configs').setup({
	-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
	ensure_installed = {
        'bash', 'c', 'cmake', 'comment', 'cpp', 'css', 'diff',
        'fennel', 'fish', 'gitattributes', 'gitignore', 'go',
        'html', 'http', 'ini', 'java', 'javascript', 'jsdoc', 'json',
        'json5', 'jsonc', 'jsonnet', 'julia', 'kotlin', 'llvm',
        'lua', 'make', 'markdown', 'markdown_inline', 'ninja', 'nix',
        'perl', 'php', 'python', 'query', 'r', 'regex', 'rst',
        'ruby', 'rust', 'vim',
	},

	highlight = {
		enable = false,
		additional_vim_regex_highlighting = false,
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = false,
			node_incremental = 'v',
			scope_incremental = false,
			node_decremental = 'V',
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
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				['],'] = '@parameter.inner',
			},
			goto_previous_start = {
				['[,'] = '@parameter.inner',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['>,'] = '@parameter.inner',
			},
			swap_previous = {
				['<,'] = '@parameter.inner',
			},
		},
	},

	-- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
	context_commentstring = {
		enable = true,
		-- Let other plugins (kommentary) call 'update_commentstring()' manually.
		enable_autocmd = false,
	},

	-- See: https://github.com/windwp/nvim-ts-autotag
	--[[ autotag = {
		enable = true,
		filetypes = {
			'html',
			'javascript',
			'javascriptreact',
			'typescriptreact',
			'svelte',
			'vue',
		}
	} ]]

})
