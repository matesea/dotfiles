local M = {}

function M.setup()

    vim.opt.csto = 0
    -- show msg when any other cscope db added
    vim.opt.cscopeverbose = true
    -- display result in quickfix
    vim.opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
    vim.opt.cscoperelative = true
end

return M
