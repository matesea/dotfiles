local ai = require("utils.persistent-ai-loader")

-- Used when no state file exists (or it names an unknown/disabled plugin).
ai.default = "sidekick"

-- Each entry: id -> lazy.nvim spec. Only the enabled one (see `:AIPick`) is loaded.
-- `enabled = false` on an entry removes it from the selectable list as well.
-- To add another AI plugin, append an entry here; `cond` is the usual availability check.
local specs = {
    {
        "claudecode",
        "coder/claudecode.nvim",
        cond = vim.fn.executable('claude') == 1,
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
                    local cwd = require("claudecode.cwd").git_root(ctx.file_dir) or ctx.cwd
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
        "sidekick",
        "folke/sidekick.nvim",
        opts = {
            cli = {
                win = {
                    layout = "float",
                    -- Dim the rest of the editor while the floating agent window is open.
                    -- sidekick has no native backdrop option, so draw a full-screen
                    -- blended float just below the terminal float (default zindex 50).
                    config = function(terminal)
                        local blend = 60 -- 0 = opaque black, 100 = no dimming
                        local backdrop ---@type integer?

                        local function close()
                            if backdrop and vim.api.nvim_win_is_valid(backdrop) then
                                pcall(vim.api.nvim_win_close, backdrop, true)
                            end
                            backdrop = nil
                        end

                        local function show()
                            local win = terminal.win
                            if not (win and vim.api.nvim_win_is_valid(win)) then
                                return
                            end
                            if vim.api.nvim_win_get_config(win).relative == "" then
                                return -- not a float
                            end
                            local cfg = {
                                relative = "editor",
                                row = 0,
                                col = 0,
                                width = vim.o.columns,
                                height = vim.o.lines,
                                focusable = false,
                                style = "minimal",
                                zindex = 40,
                            }
                            if backdrop and vim.api.nvim_win_is_valid(backdrop) then
                                vim.api.nvim_win_set_config(backdrop, cfg)
                                return
                            end
                            local buf = vim.api.nvim_create_buf(false, true)
                            vim.bo[buf].bufhidden = "wipe"
                            backdrop = vim.api.nvim_open_win(buf, false, cfg)
                            vim.wo[backdrop].winblend = blend
                            vim.wo[backdrop].winhighlight = "Normal:SidekickBackdrop,NormalFloat:SidekickBackdrop"
                        end

                        vim.api.nvim_set_hl(0, "SidekickBackdrop", { bg = "#000000", default = true })

                        -- terminal.win is assigned after nvim_open_win returns, so defer.
                        vim.api.nvim_create_autocmd("WinNew", {
                            group = terminal.group,
                            callback = function()
                                vim.schedule(show)
                            end,
                        })
                        vim.api.nvim_create_autocmd("WinClosed", {
                            group = terminal.group,
                            callback = function(args)
                                if tonumber(args.match) == terminal.win then
                                    close()
                                end
                            end,
                        })
                        vim.api.nvim_create_autocmd("VimResized", {
                            group = terminal.group,
                            callback = function()
                                if backdrop then
                                    show()
                                end
                            end,
                        })
                    end,
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

-- Evaluate a lazy.nvim `enabled`/`cond` value (boolean, function, or nil => true).
local function truthy(v, spec)
    if type(v) == "function" then
        v = v(spec)
    end
    return v ~= false
end

-- Register every id first so the persisted choice can be validated against the full list.
-- Specs with `enabled = false` are never selectable (lazy.nvim drops them anyway).
for _, entry in ipairs(specs) do
    if truthy(entry.enabled, entry) then
        ai.register(entry[1])
    end
end

-- Turn `{ id, "owner/repo", ... }` into a real lazy spec gated on the persisted choice.
-- `enabled` is left untouched for lazy.nvim; `cond` keeps the original availability check
-- AND requires this spec to be the chosen one.
local result = {}
for _, entry in ipairs(specs) do
    local id = table.remove(entry, 1)
    local orig_cond = entry.cond
    entry.cond = function(plugin)
        return ai.is_enabled(id) and truthy(orig_cond, plugin)
    end
    table.insert(result, entry)
end

return result
