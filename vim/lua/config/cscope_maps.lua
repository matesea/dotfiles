local M = {}

function M.setup()
    local ver = vim.version()
    if ver.major == 0 and ver.minor < 9 then
        -- WA when using nvim <0.9
        -- cscope_maps.nvim attemps to load db at startup, but GTAGS is unrecognized
        -- so csprg is required before startup
        vim.cmd("set csprg=gtags-cscope")
    end

    require("cscope_maps").setup({
        disable_maps = false, -- true disables keymaps, only :Cscope will be loaded
        cscope = {
            db_file = "GTAGS", -- location of cscope db file
            exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
            picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
            skip_picker_for_single_result = true, -- jump directly to position for single result
            -- db_build_cmd_args = { "-bqkv" }, -- args used for db build (:Cscope build)
        },
    })
    if ver.major == 0 and ver.minor < 9 then
        vim.api.nvim_set_keymap('n', '<leader>cf', ':cscope find<space>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cs', ':cscope find s <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cg', ':cscope find g <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cc', ':cscope find c <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ct', ':cscope find t <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ce', ':cscope find e <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cf', ':cscope find f <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ci', ':cscope find i <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cd', ':cscope find d <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ca', ':cscope find a <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
    else
        vim.api.nvim_set_keymap('n', '<leader>cf', ':Cscope find<space>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cs', ':Cscope find s <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cg', ':Cscope find g <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cc', ':Cscope find c <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ct', ':Cscope find t <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ce', ':Cscope find e <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cf', ':Cscope find f <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ci', ':Cscope find i <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>cd', ':Cscope find d <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<leader>ca', ':Cscope find a <C-R>=expand("<cword>")<cr><cr>', {noremap = true})
    end
end

return M
