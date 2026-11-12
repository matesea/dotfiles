local bigfile = function(bufnr)
    local max_filesize = 3 * 1024 * 1024 -- 3MB
    local check_stats = vim.loop.fs_stat
    local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
        return true
    else
        return false
    end
end

local bigfile_current_buf = function()
    -- return true if current buffer is bigfile
    return bigfile(vim.api.nvim_get_current_buf())
end

return {
    {
        "saghen/blink.cmp",
        lazy = true,
        cond = not bigfile_current_buf(),
        event = "InsertEnter",
        dependencies = {
            "mgalliou/blink-cmp-tmux",
            "saghen/blink.lib",
            {
                "mikavilpas/blink-ripgrep.nvim",
                version = "*", -- use the latest stable version
            },
        },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source
        -- build = 'cargo build --release',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = "default",
                -- 👇🏻👇🏻 (optional) add a keymap to invoke the search manually
                ["<c-g>"] = {
                    function()
                        require("blink-cmp").show({ providers = { "ripgrep" } })
                    end,
                },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {
                    -- "snippets",
                    "buffer",
                    "path",
                    "tmux",
                    -- "ripgrep",
                },
                providers = {
                    tmux = {
                        module = "blink-cmp-tmux",
                        name = "tmux",
                        -- default options
                        opts = {
                            -- `panes` option supports these values:
                            -- * `window`  - completions from current tmux window panes only
                            -- * `session` - completions from current tmux session panes only
                            -- * `all`     - completions from all tmux panes
                            panes = "all",
                            -- min_keyword_length = 5,
                            capture_history = false,
                            -- only suggest completions from `tmux` if the `trigger_chars` are
                            -- used
                            triggered_only = false,
                        },
                        min_keyword_length = 4,
                        async = true,
                        max_items = 15,
                    },
                    buffer = {
                        name = "buffer",
                        module = "blink.cmp.sources.buffer",
                        opts = {
                            -- (recommended) filter to only "normal" buffers
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                            -- Maximum total number of characters (in an individual buffer) for which buffer completion runs synchronously. Above this, asynchronous processing is used.
                            max_sync_buffer_size = 20000,
                            -- Maximum total number of characters (in an individual buffer) for which buffer completion runs asynchronously. Above this, the buffer will be skipped.
                            max_async_buffer_size = 400000,
                            -- Maximum text size across all buffers (default: 500KB)
                            max_total_buffer_size = 1500000,
                        },
                        min_keyword_length = 3,
                    },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        -- see the full configuration below for all available options
                        ---@module "blink-ripgrep"
                        ---@type blink-ripgrep.Options
                        opts = {
                            backend = {
                                use = "ripgrep",
                            },
                            max_filesize = "200K",
                            prefix_min_len = 4,
                        },
                        async = true,
                        max_items = 15,
                    },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {
                sorts = {
                    "exact",
                    -- defaults
                    "score",
                    "sort_text",
                },
                implementation = "prefer_rust_with_warning",
            },
        },
        opts_extend = { "sources.default" },
    },
}
