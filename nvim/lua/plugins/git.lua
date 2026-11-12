local has_git = vim.fn.executable("git") == 1

return {
    {
        "tpope/vim-fugitive",
        lazy = true,
        cond = has_git,
        cmd = { "Git", "GV", "Gcd" },
    },

    { "junegunn/gv.vim", dependencies = { "tpope/vim-fugitive" }, cmd = "GV" },

    {
        "lewis6991/gitsigns.nvim",
        -- version = 'release',
        cond = has_git,
        keys = {
            -- stylua: ignore start
            { "]c",          remap = true,                                                   desc = "Next Hunk" },
            { "[c",          remap = true,                                                   desc = "Previous Hunk" },
            { "<leader>ghr", function() require("gitsigns").reset_hunk() end,                mode = { "n", "x" },   desc = "Reset Hunk", },
            { "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line", },
            { "<leader>ghB", function() require("gitsigns").blame() end,                     desc = "Blame Buffer", },
            --stylua: ignore end
        },
        config = function()
            require("gitsigns").setup({
                max_file_length = 20000,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
                    end

                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end, "Next Hunk")

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end, "Prev Hunk")

                    -- Actions
                    map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                    map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Buffer")
                    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                    map("n", "<leader>ghb", function()
                        gs.blame_line({ full = true })
                    end, "Blame Line")
                    map("n", "<leader>ghB", function()
                        gs.blame()
                    end, "Blame Buffer")
                    map("n", "<leader>ghd", gs.diffthis, "Diff This")

                    -- -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
                end,
            })
            vim.opt.updatetime = 300

            ---@param fn string
            local function gs(fn)
                return function()
                    require("gitsigns")[fn]()
                end
            end

            local function map(lhs, rhs, desc, opts)
                opts = vim.tbl_extend("force", { desc = desc }, opts or {})
                vim.keymap.set("n", lhs, rhs, opts)
            end
            map("<leader>ghtb", gs("toggle_current_line_blame"), "Toggle Git line blame")
            map("<leader>ghtd", gs("toggle_deleted"), "Toggle Git deleted")
            map("<leader>ghtw", gs("toggle_word_diff"), "Toggle Git word diff")
            map("<leader>ghtn", gs("toggle_numhl"), "Toggle Git number highlight")
            map("<leader>ghts", gs("toggle_signs"), "Toggle Git signs")

            if _G.Snacks then
                Snacks.toggle({
                    name = "Git Signs",
                    get = function()
                        return require("gitsigns.config").config.signcolumn
                    end,
                    set = function(state)
                        require("gitsigns").toggle_signs(state)
                    end,
                }):map("<leader>uG")
            end
        end,
    },
}
