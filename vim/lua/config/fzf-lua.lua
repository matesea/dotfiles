local M = {}

function M.setup()
    local status_ok, fzf_lua = pcall(require, "fzf-lua")

    if not status_ok then
        return
    end

    fzf_lua.setup{
        files = {
            cmd = 'ff',
            git_icons = false,
            file_icons = false,
            color_icons = false,
            previewer = false,
        },
        git = {
            files = {
                git_icons = false,
                file_icons = false,
                color_icons = false,
                previewer = false,
            },
            status = {
                git_icons = false,
                file_icons = false,
                color_icons = false,
            },
        },
        grep = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        buffers = {
            file_icons = false,
            color_icons = false,
        },
        tabs = {
            file_icons = false,
            color_icons = false,
        },
        tags = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        btags = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
        },
        quickfix = {
            git_icons = false,
            file_icons = false,
        },
    }
end

return M
