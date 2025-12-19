vim.scriptencoding = "utf-8"

-- LINE NUMBER
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = true
    end
  end,
  group = "numbertoggle",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
  group = "numbertoggle",
})

-- SWAP FILE
vim.opt.swapfile = false

-- DIAGNOSTIC
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    source = "always",
  },
})

-- INDENTATION AND FORMATTING
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- SEARCH AND HIGHLIGHTING
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- KEY MAPPINGS
vim.g.mapleader = " "
vim.keymap.set({ "n", "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kk", "<ESC>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-j>", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c><C-c>", ":nohlsearch<CR><ESC>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-N><C-N>", ":set relativenumber!<CR>", { noremap = true })

-- FOR TERMINAL
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- CURSORLINE AND CURSORCOLUMN
vim.opt.cursorline = false
vim.opt.cursorcolumn = false

-- MOUSE AND SPELLCHECK
vim.opt.mouse = "a"
vim.opt.spell = true
vim.opt.spelllang = { "en", "cjk" }
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "hi clear SpellBad | hi SpellBad cterm=underline",
})

-- ENABLE TRUE COLOR SUPPORT
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- DISABLE JSON CONCEAL
vim.g.vim_json_conceal = 0

-- SHOW DOUBLE BYTE SPACES
vim.cmd([[
  hi DoubleByteSpace term=underline ctermbg=blue guibg=darkgray
  match DoubleByteSpace /　/
]])

-- MISC
vim.opt.wrap = false
