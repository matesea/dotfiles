-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/matesea/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/matesea/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/matesea/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/matesea/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/matesea/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["accelerated-jk"] = {
    config = { "\27LJ\2\n≈\1\0\0\6\0\n\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0005\5\t\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\1\30<Plug>(accelerated_jk_gk)\6k\1\0\2\vsilent\2\fnoremap\1\30<Plug>(accelerated_jk_gj)\6j\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/accelerated-jk",
    url = "https://github.com/rhysd/accelerated-jk"
  },
  ["aerial.nvim"] = {
    commands = { "AerialToggle" },
    config = { "\27LJ\2\n[\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rbackends\1\0\0\1\2\0\0\15treesitter\nsetup\vaerial\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/aerial.nvim",
    url = "https://github.com/stevearc/aerial.nvim"
  },
  ["close-buffers.nvim"] = {
    commands = { "BDelete", "BWipeout" },
    config = { "\27LJ\2\nË\1\0\0\6\0\r\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\n\0'\4\v\0005\5\f\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\23:BDelete other<cr>\abo\1\0\2\vsilent\2\fnoremap\2\22:BDelete this<cr>\abd\6n\20nvim_set_keymap\bapi\bvim\nsetup\18close_buffers\frequire\0" },
    keys = { { "n", "bd" }, { "n", "bo" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/close-buffers.nvim",
    url = "https://github.com/kazhala/close-buffers.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-path"] = {
    after_files = { "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-tmux"] = {
    after_files = { "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-tmux/after/plugin/cmp_tmux.vim" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-tmux",
    url = "https://github.com/andersevenrud/cmp-tmux"
  },
  ["cmp-vsnip"] = {
    after_files = { "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-vsnip/after/plugin/cmp_vsnip.vim" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["filetype.nvim"] = {
    config = { "\27LJ\2\nx\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\14overrides\1\0\0\15extensions\1\0\0\1\0\2\btxt\blog\blog\blog\nsetup\rfiletype\frequire\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  ["focus.nvim"] = {
    commands = { "FocusSplitNicely", "FocusSplitCycle" },
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\17hybridnumber\2\nsetup\nfocus\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/focus.nvim",
    url = "https://github.com/beauwilliams/focus.nvim"
  },
  fzf = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf-lua"] = {
    commands = { "FzfLua" },
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19config.fzf-lua\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/fzf-lua",
    url = "https://github.com/ibhagwan/fzf-lua"
  },
  ["fzf.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["gtags-scope"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.gtags\frequire\0" },
    keys = { { "n", "<leader>cf" }, { "n", "<leader>cs" }, { "n", "<leader>cg" }, { "n", "<leader>cc" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/gtags-scope",
    url = "https://github.com/joereynolds/gtags-scope"
  },
  ["gv.vim"] = {
    after = { "vim-fugitive" },
    commands = { "GV" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/gv.vim",
    url = "https://github.com/junegunn/gv.vim"
  },
  ["hlargs.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vhlargs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/hlargs.nvim",
    url = "https://github.com/m-demare/hlargs.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  kommentary = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["leap.nvim"] = {
    config = { "\27LJ\2\ns\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0027\0\1\0006\0\1\0009\0\2\0005\2\3\0B\0\2\0016\0\1\0009\0\4\0B\0\1\1K\0\1\0\24set_default_keymaps\1\0\1\21case_insensitive\2\nsetup\tleap\frequire\0" },
    keys = { { "", "s" }, { "", "S" }, { "", "f" }, { "", "F" }, { "", "t" }, { "", "T" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["neovim-molokai"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme molokai\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/neovim-molokai",
    url = "https://github.com/tamelion/neovim-molokai"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rfunc_map\1\0\0\1\0\2\14pscrollup\5\16pscrolldown\5\nsetup\bbqf\frequire\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    after = { "cmp-buffer", "cmp-cmdline", "cmp-path", "vim-vsnip", "cmp-tmux", "cmp-vsnip" },
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15config.cmp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lastplace"] = {
    config = { "\27LJ\2\n⁄\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\30lastplace_ignore_filetype\1\5\0\0\14gitcommit\14gitrebase\bsvn\rhgcommit\29lastplace_ignore_buftype\1\0\1\25lastplace_open_folds\2\1\4\0\0\rquickfix\vnofile\thelp\nsetup\19nvim-lastplace\frequire\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/nvim-lastplace",
    url = "https://github.com/ethanholz/nvim-lastplace"
  },
  ["nvim-treesitter"] = {
    load_after = {
      ["nvim-treesitter-context"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    after = { "nvim-treesitter" },
    commands = { "TSContextEnable" },
    config = { "\27LJ\2\nY\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rthrottle\2\venable\2\nsetup\23treesitter-context\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-context",
    url = "https://github.com/lewis6991/nvim-treesitter-context"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["scratch.vim"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/scratch.vim",
    url = "https://github.com/mtth/scratch.vim"
  },
  ["trace32-practice.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/trace32-practice.vim",
    url = "https://github.com/matesea/trace32-practice.vim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-buftabline"] = {
    config = { "\27LJ\2\nü\6\0\0\6\0\"\0Q6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\2\0=\1\3\0006\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\16\0'\4\17\0005\5\18\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\19\0'\4\20\0005\5\21\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\22\0'\4\23\0005\5\24\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\25\0'\4\26\0005\5\27\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\28\0'\4\29\0005\5\30\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\31\0'\4 \0005\5!\0B\0\5\1K\0\1\0\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(9)\14<leader>9\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(8)\14<leader>8\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(7)\14<leader>7\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(6)\14<leader>6\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(5)\14<leader>5\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(4)\14<leader>4\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(3)\14<leader>3\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(2)\14<leader>2\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(1)\14<leader>1\6n\20nvim_set_keymap\bapi\23buftabline_numbers\20buftabline_show\6g\bvim\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/vim-buftabline",
    url = "https://github.com/ap/vim-buftabline"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-cpp-enhanced-highlight"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-cpp-enhanced-highlight",
    url = "https://github.com/octol/vim-cpp-enhanced-highlight"
  },
  ["vim-foldsearch"] = {
    commands = { "Fp", "Fw", "Fs" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-foldsearch",
    url = "https://github.com/embear/vim-foldsearch"
  },
  ["vim-fugitive"] = {
    commands = { "Gread", "Gwrite", "Git", "Ggrep", "Gblame", "GV" },
    load_after = {
      ["gv.vim"] = true
    },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gtfo"] = {
    keys = { { "n", "got" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-gtfo",
    url = "https://github.com/justinmk/vim-gtfo"
  },
  ["vim-highlighter"] = {
    config = { "\27LJ\2\n≤\2\0\0\6\0\t\0\r6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Ω\1                nn - <Cmd>Hi/next<CR>\n                nn _ <Cmd>Hi/previous<CR>\n                nn f<left> <Cmd>Hi/older<cr>\n                nn f<right> <Cmd>Hi/newer<cr>\n             \bcmd\1\0\1\fnoremap\2\16:Hi+<space>\vf<c-h>\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/vim-highlighter",
    url = "https://github.com/azabiong/vim-highlighter"
  },
  ["vim-hugefile"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-hugefile",
    url = "https://github.com/mhinz/vim-hugefile"
  },
  ["vim-indent-guides"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-indent-guides",
    url = "https://github.com/nathanaelkane/vim-indent-guides"
  },
  ["vim-linux-coding-style"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-linux-coding-style",
    url = "https://github.com/vivien/vim-linux-coding-style"
  },
  ["vim-log-syntax"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-log-syntax",
    url = "https://github.com/matesea/vim-log-syntax"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-showmarks"] = {
    commands = { "DoShowMarks" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-showmarks",
    url = "https://github.com/jacquesbh/vim-showmarks"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["vim-toggle-quickfix"] = {
    commands = { "<Plug>window:quickfix:toggle", "<Plug>window:location:toggle" },
    config = { "\27LJ\2\nÀ\1\0\0\6\0\n\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0005\5\t\0B\0\5\1K\0\1\0\1\0\1\fnoremap\1!<Plug>window:location:toggle\14<leader>f\1\0\1\fnoremap\1!<Plug>window:quickfix:toggle\14<leader>q\6n\20nvim_set_keymap\bapi\bvim\0" },
    keys = { { "n", "<leader>q" }, { "n", "<leader>f" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-toggle-quickfix",
    url = "https://github.com/drmingdrmer/vim-toggle-quickfix"
  },
  ["vim-trailing-whitespace"] = {
    loaded = true,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/start/vim-trailing-whitespace",
    url = "https://github.com/bronson/vim-trailing-whitespace"
  },
  ["vim-vp4"] = {
    commands = { "Vp4FileLog", "Vp4Annotate", "Vp4Describe", "Vp4" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-vp4",
    url = "https://github.com/ngemily/vim-vp4"
  },
  ["vim-vsnip"] = {
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/vista.vim",
    url = "https://github.com/liuchengxu/vista.vim"
  },
  ["zoxide.vim"] = {
    commands = { "Z", "Zi", "Lz", "Lzi" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matesea/.local/share/nvim/site/pack/packer/opt/zoxide.vim",
    url = "https://github.com/nanotee/zoxide.vim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^focus"] = "focus.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: neovim-molokai
time([[Config for neovim-molokai]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme molokai\bcmd\bvim\0", "config", "neovim-molokai")
time([[Config for neovim-molokai]], false)
-- Config for: nvim-lastplace
time([[Config for nvim-lastplace]], true)
try_loadstring("\27LJ\2\n⁄\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\30lastplace_ignore_filetype\1\5\0\0\14gitcommit\14gitrebase\bsvn\rhgcommit\29lastplace_ignore_buftype\1\0\1\25lastplace_open_folds\2\1\4\0\0\rquickfix\vnofile\thelp\nsetup\19nvim-lastplace\frequire\0", "config", "nvim-lastplace")
time([[Config for nvim-lastplace]], false)
-- Config for: vim-buftabline
time([[Config for vim-buftabline]], true)
try_loadstring("\27LJ\2\nü\6\0\0\6\0\"\0Q6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\2\0=\1\3\0006\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\16\0'\4\17\0005\5\18\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\19\0'\4\20\0005\5\21\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\22\0'\4\23\0005\5\24\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\25\0'\4\26\0005\5\27\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\28\0'\4\29\0005\5\30\0B\0\5\0016\0\0\0009\0\4\0009\0\5\0'\2\6\0'\3\31\0'\4 \0005\5!\0B\0\5\1K\0\1\0\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(9)\14<leader>9\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(8)\14<leader>8\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(7)\14<leader>7\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(6)\14<leader>6\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(5)\14<leader>5\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(4)\14<leader>4\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(3)\14<leader>3\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(2)\14<leader>2\1\0\1\fnoremap\1\27<Plug>BufTabLine.Go(1)\14<leader>1\6n\20nvim_set_keymap\bapi\23buftabline_numbers\20buftabline_show\6g\bvim\0", "config", "vim-buftabline")
time([[Config for vim-buftabline]], false)
-- Config for: vim-highlighter
time([[Config for vim-highlighter]], true)
try_loadstring("\27LJ\2\n≤\2\0\0\6\0\t\0\r6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Ω\1                nn - <Cmd>Hi/next<CR>\n                nn _ <Cmd>Hi/previous<CR>\n                nn f<left> <Cmd>Hi/older<cr>\n                nn f<right> <Cmd>Hi/newer<cr>\n             \bcmd\1\0\1\fnoremap\2\16:Hi+<space>\vf<c-h>\6n\20nvim_set_keymap\bapi\bvim\0", "config", "vim-highlighter")
time([[Config for vim-highlighter]], false)
-- Config for: filetype.nvim
time([[Config for filetype.nvim]], true)
try_loadstring("\27LJ\2\nx\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\14overrides\1\0\0\15extensions\1\0\0\1\0\2\btxt\blog\blog\blog\nsetup\rfiletype\frequire\0", "config", "filetype.nvim")
time([[Config for filetype.nvim]], false)
-- Config for: nvim-bqf
time([[Config for nvim-bqf]], true)
try_loadstring("\27LJ\2\nd\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rfunc_map\1\0\0\1\0\2\14pscrollup\5\16pscrolldown\5\nsetup\bbqf\frequire\0", "config", "nvim-bqf")
time([[Config for nvim-bqf]], false)
-- Config for: accelerated-jk
time([[Config for accelerated-jk]], true)
try_loadstring("\27LJ\2\n≈\1\0\0\6\0\n\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0005\5\t\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\1\30<Plug>(accelerated_jk_gk)\6k\1\0\2\vsilent\2\fnoremap\1\30<Plug>(accelerated_jk_gj)\6j\6n\20nvim_set_keymap\bapi\bvim\0", "config", "accelerated-jk")
time([[Config for accelerated-jk]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DoShowMarks lua require("packer.load")({'vim-showmarks'}, { cmd = "DoShowMarks", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Z lua require("packer.load")({'zoxide.vim'}, { cmd = "Z", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[au CmdUndefined <Plug>window:location:toggle ++once lua require"packer.load"({'vim-toggle-quickfix'}, {}, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file FocusSplitNicely lua require("packer.load")({'focus.nvim'}, { cmd = "FocusSplitNicely", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Zi lua require("packer.load")({'zoxide.vim'}, { cmd = "Zi", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Fp lua require("packer.load")({'vim-foldsearch'}, { cmd = "Fp", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Fw lua require("packer.load")({'vim-foldsearch'}, { cmd = "Fw", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Fs lua require("packer.load")({'vim-foldsearch'}, { cmd = "Fs", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file FzfLua lua require("packer.load")({'fzf-lua'}, { cmd = "FzfLua", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vp4FileLog lua require("packer.load")({'vim-vp4'}, { cmd = "Vp4FileLog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vp4Annotate lua require("packer.load")({'vim-vp4'}, { cmd = "Vp4Annotate", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vp4Describe lua require("packer.load")({'vim-vp4'}, { cmd = "Vp4Describe", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vp4 lua require("packer.load")({'vim-vp4'}, { cmd = "Vp4", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file BDelete lua require("packer.load")({'close-buffers.nvim'}, { cmd = "BDelete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file BWipeout lua require("packer.load")({'close-buffers.nvim'}, { cmd = "BWipeout", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file FocusSplitCycle lua require("packer.load")({'focus.nvim'}, { cmd = "FocusSplitCycle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Lz lua require("packer.load")({'zoxide.vim'}, { cmd = "Lz", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Lzi lua require("packer.load")({'zoxide.vim'}, { cmd = "Lzi", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file AerialToggle lua require("packer.load")({'aerial.nvim'}, { cmd = "AerialToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gread lua require("packer.load")({'vim-fugitive'}, { cmd = "Gread", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gwrite lua require("packer.load")({'vim-fugitive'}, { cmd = "Gwrite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Ggrep lua require("packer.load")({'vim-fugitive'}, { cmd = "Ggrep", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gblame lua require("packer.load")({'vim-fugitive'}, { cmd = "Gblame", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GV lua require("packer.load")({'vim-fugitive', 'gv.vim'}, { cmd = "GV", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSContextEnable lua require("packer.load")({'nvim-treesitter-context'}, { cmd = "TSContextEnable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[au CmdUndefined <Plug>window:quickfix:toggle ++once lua require"packer.load"({'vim-toggle-quickfix'}, {}, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[nnoremap <silent> <leader>cc <cmd>lua require("packer.load")({'gtags-scope'}, { keys = "<lt>leader>cc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> got <cmd>lua require("packer.load")({'vim-gtfo'}, { keys = "got", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <leader>cg <cmd>lua require("packer.load")({'gtags-scope'}, { keys = "<lt>leader>cg", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> t <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "t", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> bd <cmd>lua require("packer.load")({'close-buffers.nvim'}, { keys = "bd", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> s <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "s", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <leader>cs <cmd>lua require("packer.load")({'gtags-scope'}, { keys = "<lt>leader>cs", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> F <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "F", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <leader>q <cmd>lua require("packer.load")({'vim-toggle-quickfix'}, { keys = "<lt>leader>q", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> bo <cmd>lua require("packer.load")({'close-buffers.nvim'}, { keys = "bo", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> S <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "S", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> f <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "f", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <leader>f <cmd>lua require("packer.load")({'vim-toggle-quickfix'}, { keys = "<lt>leader>f", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> T <cmd>lua require("packer.load")({'leap.nvim'}, { keys = "T", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> <leader>cf <cmd>lua require("packer.load")({'gtags-scope'}, { keys = "<lt>leader>cf", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType c ++once lua require("packer.load")({'vim-linux-coding-style', 'vim-cpp-enhanced-highlight', 'kommentary', 'vim-indent-guides'}, { ft = "c" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'kommentary', 'vim-indent-guides'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType log ++once lua require("packer.load")({'vim-log-syntax', 'vim-hugefile'}, { ft = "log" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'kommentary'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'kommentary', 'vim-indent-guides'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType S ++once lua require("packer.load")({'vim-linux-coding-style', 'vim-cpp-enhanced-highlight', 'kommentary', 'vim-indent-guides'}, { ft = "S" }, _G.packer_plugins)]]
vim.cmd [[au FileType h ++once lua require("packer.load")({'vim-linux-coding-style', 'vim-cpp-enhanced-highlight', 'kommentary', 'vim-indent-guides'}, { ft = "h" }, _G.packer_plugins)]]
vim.cmd [[au FileType text ++once lua require("packer.load")({'vim-log-syntax', 'vim-hugefile'}, { ft = "text" }, _G.packer_plugins)]]
vim.cmd [[au FileType cmm ++once lua require("packer.load")({'trace32-practice.vim'}, { ft = "cmm" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'kommentary', 'vim-indent-guides'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType cpp ++once lua require("packer.load")({'vim-cpp-enhanced-highlight', 'kommentary', 'vim-indent-guides'}, { ft = "cpp" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'fzf.vim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-cmp', 'nvim-autopairs'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-log-syntax/ftdetect/log.vim]], true)
vim.cmd [[source /Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-log-syntax/ftdetect/log.vim]]
time([[Sourcing ftdetect script at: /Users/matesea/.local/share/nvim/site/pack/packer/opt/vim-log-syntax/ftdetect/log.vim]], false)
time([[Sourcing ftdetect script at: /Users/matesea/.local/share/nvim/site/pack/packer/opt/trace32-practice.vim/ftdetect/practice.vim]], true)
vim.cmd [[source /Users/matesea/.local/share/nvim/site/pack/packer/opt/trace32-practice.vim/ftdetect/practice.vim]]
time([[Sourcing ftdetect script at: /Users/matesea/.local/share/nvim/site/pack/packer/opt/trace32-practice.vim/ftdetect/practice.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(0) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
