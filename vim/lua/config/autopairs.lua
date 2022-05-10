local M = {}

function M.setup()
    local status_ok, npairs = pcall(require, "nvim-autopairs")
    if not status_ok then
        return
    end
    npairs.setup {
      check_ts = true,
    }
    npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
end

return M
