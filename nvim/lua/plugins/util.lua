return {
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
                {
                    '>',
                    function()
                        require('quicker').expand({
                            before = 2,
                            after = 2,
                            add_to_existing = true
                        })
                    end,
                    desc = 'Expand Quickfix Context'
                },
                {
                    '<',
                    function()
                        require('quicker').collapse()
                    end,
                    desc = 'Collapse Quickfix Context'
                },
            },
            max_filename_width = function()
                return math.floor(vim.o.columns / 2)
            end,
        },
    },

    {
        "trmckay/based.nvim",
        lazy = true,
        cmd = "BasedConvert",
        opts = {},
    },

    {
        "azabiong/vim-highlighter",
        keys = {
            { "<leader>hh", ":Hi+<space>", desc = "Highlight Input" },
            {
                "f<cr>",
                mode = { "n", "v" },
                remap = true,
                desc = "Highlight Word",
            },
        },
        config = function()
            vim.cmd([[
                nn [g <cmd>Hi {<cr>
                nn ]g <cmd>Hi }<cr>
                nn [w <cmd>Hi <<cr>
                nn ]w <cmd>Hi ><cr>
            ]])
        end,
        -- [g: jump to any highlight backward
        -- ]g: jump to any highlight forward
        -- [w: jump to highlight under cursor backward
        -- ]w: jump to highlight under cursor forward

        -- f + <cr>: HiSet, hightlight current word
        -- f + <backspace>: HiErase
        -- f + <C-L>: HiClear
        -- f + tab: HiFind
        -- :Hi + <pattern>: highlight one pattern
        -- :Hi save <name>: save current highlight to file
    },

    { "vladdoster/remember.nvim",         config = true },

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


    { -- Autoformat
        "stevearc/conform.nvim",
        cmd = { "ConformInfo", "FormatBuffer" },
        ---@module 'conform'
        ---@type conform.setupOpts
        config = function()
            require("conform").setup()
            vim.api.nvim_create_user_command("FormatBuffer", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "Format buffer" })
        end,
    },

    -- Perform diffs on blocks of code
    {
        "AndrewRadev/linediff.vim",
        lazy = true,
        cmd = { "Linediff", "LinediffAdd" },
        keys = {
            { "<leader>mdf", ":Linediff<CR>",          mode = "x",              desc = "Line diff" },
            { "<leader>mda", ":LinediffAdd<CR>",       mode = "x",              desc = "Line diff add" },
            { "<leader>mds", "<cmd>LinediffShow<CR>",  desc = "Line diff show" },
            { "<leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
        },
    },

    {
        "dhananjaylatkar/cscope_maps.nvim",
        lazy = true,
        keys = {
            -- stylua: ignore start
            { "<leader>cf", ":Cscope find<space>",                            desc = "Cscope" },
            { "<leader>cs", ':Cscope find s <C-R>=expand("<cword>")<cr><cr>', desc = "Cscope: Find All References", },
            { "<leader>cg", ':Cscope find g <C-R>=expand("<cword>")<cr><cr>', desc = "Cscope: Find Definition", },
            { "<leader>cc", ':Cscope find c <C-R>=expand("<cword>")<cr><cr>', desc = "Cscope: Find All Calls", },
            -- stylua: ignore end
        },
        cmd = { "Cscope" },
        opts = {
            disable_maps = true, -- true disables keymaps, only :Cscope will be loaded
            skip_input_prompt = true, -- "true" doesn't ask for input
            cscope = {
                db_file = "GTAGS", -- location of cscope db file
                exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
                picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
                picker_opts = {
                    -- size of quickfix window
                    window_size = 10,     -- any positive integer
                    -- position of quickfix window
                    window_pos = "bottom", -- "bottom", "right", "left" or "top"
                },
                skip_picker_for_single_result = true, -- jump directly to position for single result
                -- these args are directly passed to "cscope -f <db_file> <args>"
                -- db_build_cmd_args = { "-bqkv" },
                -- statusline indicator, default is cscope executable
                statusline_indicator = nil,
            },
        },
    },
}
