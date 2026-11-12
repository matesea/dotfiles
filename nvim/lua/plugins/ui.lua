return {
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

    -- disable search highlighting when search is done
    { "romainl/vim-cool" },

    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = {
            hide_target_hack = true,
            cursor_color = "none",
            delay_disable = 50,
            -- default: 0.6, range: [0, 1]
            stiffness = 0.8,
            -- default: 0.45, range: [0, 1]
            trailing_stiffness = 0.6,
            -- default: 0.5, range: [0, 1]
            stiffness_insert_mode = 0.7,
            -- default: 0.5, range: [0, 1]
            trailing_stiffness_insert_mode = 0.7,
            -- default: 0.85, range: [0, 1]
            damping = 0.95,
            -- default: 0.9, range: [0, 1]
            damping_insert_mode = 0.95,
            -- default: 0.1, range: > 0
            distance_stop_animating = 0.5,
            -- ms, for low framerate machines
            time_interval = 7,
        },
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
        "nvim-focus/focus.nvim",
        cmd = { "FocusEnable" },
        config = function()
            require("focus").setup()
            if _G.Snacks then
                Snacks.toggle({
                    name = "Toggle Focus",
                    get = function()
                        return vim.g.focus_disable ~= true
                    end,
                    set = function(state)
                        require("focus").focus_toggle_window()
                    end,
                }):map("<leader>uf")
            end
        end,
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
            { "j", "<Plug>(accelerated_jk_gj)", desc = "Accel j" },
            { "k", "<Plug>(accelerated_jk_gk)", desc = "Accel k" },
        },
        opts = {},
    },

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
            { "<c-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = { "n", "t" }, desc = "Go to Left Window" },
            { "<c-j>", "<cmd>TmuxNavigateDown<cr>",  mode = { "n", "t" }, desc = "Go to Down Window" },
            { "<c-k>", "<cmd>TmuxNavigateUp<cr>",    mode = { "n", "t" }, desc = "Go to Upper Window" },
            { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "Go to Right Window" },
        },
    },

    {
        "ghillb/cybu.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "[b", "<Plug>(CybuPrev)", desc = "Prev Buffer" },
            { "]b", "<Plug>(CybuNext)", desc = "Next Buffer" },
        },
        opts = {
            style = {
                devicons = { enabled = false },
            },
        },
    },

    -- floating status line
    {
        "b0o/incline.nvim",
        event = "VeryLazy",
        opts = {
            ignore = {
                filetypes = { "gitcommit" },
            },
        },
    },
}
