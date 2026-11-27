-- Persistent selection of which AI plugin is enabled.
-- State is stored in stdpath("state")/ai-plugin.json as {"enabled": "<id>"}.
-- Specs in lua/plugins/ai.lua register their id and gate `cond` on `is_enabled(id)`.
local M = {}

M.names = {} -- ordered ids
M.default = nil ---@type string? preferred fallback; else first registered
M.state_file = vim.fn.stdpath("state") .. "/ai-plugin.json"

local cached ---@type string?

function M.register(id)
    if not vim.list_contains(M.names, id) then
        table.insert(M.names, id)
    end
end

local function valid(id)
    return id ~= nil and vim.list_contains(M.names, id)
end

local function read()
    local ok, lines = pcall(vim.fn.readfile, M.state_file)
    if not ok then
        return nil
    end
    local ok2, data = pcall(vim.json.decode, table.concat(lines, "\n"))
    if ok2 and type(data) == "table" then
        return data.enabled
    end
end

--- Id of the enabled plugin (falls back to the first registered one).
function M.enabled()
    if cached == nil then
        local id = read()
        cached = valid(id) and id or (valid(M.default) and M.default or M.names[1])
    end
    return cached
end

function M.is_enabled(id)
    return M.enabled() == id
end

function M.set(id)
    if not valid(id) then
        vim.notify(
            ("AIPick: unknown plugin '%s' (available: %s)"):format(id, table.concat(M.names, ", ")),
            vim.log.levels.ERROR
        )
        return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(M.state_file, ":h"), "p")
    local ok, err = pcall(vim.fn.writefile, { vim.json.encode({ enabled = id }) }, M.state_file)
    if not ok then
        vim.notify("AIPick: failed to write state: " .. tostring(err), vim.log.levels.ERROR)
        return
    end
    vim.notify(("AI plugin set to '%s'. Restart Neovim to apply."):format(id))
end

vim.api.nvim_create_user_command("AIPick", function(opts)
    if opts.args ~= "" then
        M.set(opts.args)
        return
    end
    local current = M.enabled()
    vim.ui.select(M.names, {
        prompt = "Enabled AI plugin (current: " .. tostring(current) .. ")",
        format_item = function(id)
            return id == current and (id .. " (current)") or id
        end,
    }, function(choice)
        if choice then
            M.set(choice)
        end
    end)
end, {
    nargs = "?",
    complete = function()
        return M.names
    end,
    desc = "Choose which AI plugin is enabled (persists across restarts)",
})

return M
