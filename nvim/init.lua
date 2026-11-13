-- config/data/state paths follow XDG_* via stdpath(), on Linux and macOS
require('config')

-- machine-local overrides, mirrors ~/.local/bashrc
local local_rc = vim.fn.expand('~/.local/vimrc')
if vim.fn.filereadable(local_rc) == 1 then
    vim.cmd.source(local_rc)
end
