local has_claude = vim.fn.executable("claude") == 1

return {
    {
        "coder/claudecode.nvim",
        cond = has_claude,
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal = {
                snacks_win_opts = {
                    position = "float",
                    height = 0.9,
                    width = 0.9,
                    border = "single",

                    keys = {
                        claude_hide = {
                            "<c-\\>",
                            function(self)
                                self:hide()
                            end,
                            mode = "t",
                            desc = "Hide",
                        },
                    },
                },
                cwd_provider = function(ctx)
                    -- Prefer repo root; fallback to file's directory
                    local cwd = require("claudecode.cwd").git_root(ctx.file_dir or ctx.cwd) or ctx.file_dir or ctx.cwd
                    return cwd
                end,
            },
        },
        -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
        -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
        -- spec defers loading until a <leader>a* mapping is pressed and the commands
        -- would not exist yet.
        cmd = {
            "ClaudeCode",
            "ClaudeCodeFocus",
            "ClaudeCodeSelectModel",
            "ClaudeCodeAdd",
            "ClaudeCodeSend",
            "ClaudeCodeTreeAdd",
            "ClaudeCodeStatus",
            "ClaudeCodeStart",
            "ClaudeCodeStop",
            "ClaudeCodeOpen",
            "ClaudeCodeClose",
            "ClaudeCodeDiffAccept",
            "ClaudeCodeDiffDeny",
            "ClaudeCodeCloseAllDiffs",
        },
        keys = {
            -- stylua: ignore start
            { "<c-\\>",     "<cmd>ClaudeCodeFocus<cr>",       desc = "Toggle Claude" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeSend<cr>",
                mode = "v",
                desc = "Send to Claude",
            },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
            -- stylua: ignore end
        },
    },

    {
        "folke/sidekick.nvim",
        enabled = false,
        opts = {
            cli = {
                win = {
                    layout = "float",
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>"
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-\\>",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "t" },
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select({ filter = { installed = true } })
                end,
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
        },
    },
}
