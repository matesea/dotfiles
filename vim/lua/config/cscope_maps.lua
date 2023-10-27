local M = {}

function M.setup()
    --[[
    local ver = vim.version()
    if ver.major == 0 and ver.minor < 9 then
        -- WA when using nvim <0.9
        -- cscope_maps.nvim attemps to load db at startup, but GTAGS is unrecognized
        -- so csprg is required before startup
        vim.cmd("set csprg=gtags-cscope")
    end
    ]]

    require("cscope_maps").setup({
        disable_maps = true, -- true disables keymaps, only :Cscope will be loaded
        skip_input_prompt = true, -- "true" doesn't ask for input
        cscope = {
            db_file = "GTAGS", -- location of cscope db file
            exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
            picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
            skip_picker_for_single_result = true, -- jump directly to position for single result
            -- these args are directly passed to "cscope -f <db_file> <args>"
            -- db_build_cmd_args = { "-bqkv" },
            -- statusline indicator, default is cscope executable
            statusline_indicator = nil,

        },
    })
    vim.api.nvim_set_keymap('n', '<leader>cf', ':Cscope find<space>', {silent = false, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cs', ':Cscope find s <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cg', ':Cscope find g <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>cc', ':Cscope find c <C-R>=expand("<cword>")<cr><cr>', {silent = true, noremap = true})
end

return M
