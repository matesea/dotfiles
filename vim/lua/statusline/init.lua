 local function status_line()
  local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
  -- base directory name of current working directory
  local cwd = "%{v:lua.vim.fn.fnamemodify(v:lua.vim.fn.getcwd(), ':t')}"
  local file_name = " %-.40t"
  -- local buf_nr = "[%n]"
  local fileformat = " [%{&fileformat}/"
  local fileencoding = "/%{&fileencoding?&fileencoding:&encoding}]"
  local modified = " %-m"
  local file_type = " %y"
  local right_align = "%="
  local line_no = "%10([%l/%L%)]"
  local pct_thru_file = "%5p%%"

  return string.format(
    "%s%s%s%s%s%s%s%s%s%s",
    mode,
    cwd,
    file_name,
    modified,
    file_type,
    right_align,
    fileformat,
    fileencoding,
    line_no,
    pct_thru_file
  )
end

vim.opt.statusline = status_line()
