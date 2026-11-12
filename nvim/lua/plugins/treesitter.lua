return {
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
        keys = {
            -- stylua: ignore start
            {
                "]f",
                mode = { "n", "x", "o" },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        "@function.outer")
                end,
                desc = "Next Function Start",
            },
            {
                "[f",
                mode = { "n", "x", "o" },
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start(
                        "@function.outer")
                end,
                desc = "Previous Function Start",
            },
            {
                "]s",
                mode = { "n", "x", "o" },
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        "@class.outer")
                end,
                desc = "Next Class Start",
            },
            {
                "[s",
                mode = { "n", "x", "o" },
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start(
                        "@class.outer")
                end,
                desc = "Previous Class Start",
            },
            -- stylua: ignore end
        },
        opts = {
            select = { lookahead = true },
            move = { set_jumps = true },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        ft = ft_code,
        opts = {
            mode = "cursor",
            max_lines = 3,
            line_numbers = true,
            trim_scope = "outer",
        },
    },

    {
        "kevinhwang91/nvim-ufo",
        lazy = true,
        keys = {
            -- stylua: ignore start
            { "zM", function() require("ufo").closeAllFolds() end,  desc = "Close All Folds", },
            { "zR", function() require("ufo").openAllFolds() end,   desc = "Open All Folds", },
            { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close Fold with v:count", },
            -- {'zr', function() require('ufo').openFoldsExceptKinds end, desc = 'open all folds'},
            -- stylua: ignore end
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
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },

}
