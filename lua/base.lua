local opt = vim.opt

vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
vim.wo.number = true
opt.clipboard = ""
opt.mouse = ""
opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.hlsearch = true
opt.backup = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 2
-- opt.expandtab = true
-- opt.scrolloff = 10
opt.shell = 'bash'
--opt.inccommand = 'split'
opt.ignorecase = true
opt.smartcase = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.backspace = 'start,eol,indent'
opt.path:append { '**' } -- Finding files - Search down into subdirectories
opt.wildignore:append { '*/node_modules/*' }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- netrwを無効化（nvim-treeの推奨設定）
vim.api.nvim_set_var('loaded_netrw', 1)
vim.api.nvim_set_var('loaded_netrwPlugin', 1)
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

