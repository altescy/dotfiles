require("config.base")
require("config.lazy")

vim.o.exrc = true
vim.o.secure = true

-- Set transparent background
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight LineNr guibg=none
  highlight CursorLineNr guibg=none
  highlight StatusLine guibg=none
  highlight StatusLineNC guibg=none
  highlight Tabline guibg=none
  highlight TabLineFill guibg=none
  highlight TabLineSel guibg=none
  highlight Winbar guibg=none
  highlight WinbarNC guibg=none
  highlight Folded guibg=none
  highlight SignColumn guibg=none
  highlight TelescopeNormal guibg=none
  highlight TelescopeBorder guibg=none
  highlight TelescopeTitle guibg=none
  highlight FloatBorder guibg=none
  highlight NoiceCmdlinePopup guibg=none
  highlight NoiceCmdlinePopupBorder guibg=none
  highlight GitSignsAdd guibg=NONE
  highlight GitSignsChange guibg=NONE
  highlight GitSignsDelete guibg=NONE
  highlight DiagnosticSignError guibg=NONE
  highlight DiagnosticSignWarn  guibg=NONE
  highlight DiagnosticSignInfo  guibg=NONE
  highlight DiagnosticSignHint  guibg=NONE
]])
