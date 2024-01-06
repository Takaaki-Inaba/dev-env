local keymap = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

-- leader keyを,にする
vim.g.mapleader = ","

-- x と sではyankしない
keymap.set('n', 'x', '"_x')
keymap.set('n', 's', '"_s')
keymap.set('n', 'S', '"_S')

-- 行末の余分なスペースを削除
autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

-- タブ移動をCtrl + g, Ctrl + lでやる
keymap.set('', '<C-g>', ':<C-u>tabp<CR>')
keymap.set('', '<C-l>', ':<C-u>tabn<CR>')

-- ,nでnohlsearchする
keymap.set('n', '<leader>n', ':nohlsearch<CR>')

-- スクロールをCtrl + j, Ctrl + k
keymap.set('', '<C-j>', '<C-e>')
keymap.set('', '<C-k>', '<C-y>')


-- jjでノーマルモードに移行する
keymap.set('i', 'jj', '<ESC>', { silent = true })

-- 画面分割ショートカット
keymap.set('n', '<leader>t', ':tabnew<CR>')
keymap.set('n', '<leader>v', ':vsplit<CR>')
keymap.set('n', '<leader>s', ':split<CR>')

-- make とか grep のあとに quickfix に移動する
vim.cmd("autocmd QuickfixCmdPost make,*grep*,grepadd,vimgrep cwindow")
keymap.set('', '<C-c>', ':cnext<CR>')
keymap.set('', '<C-s>', ':cprevious<CR>')
keymap.set('', '<C-q>', ':cclose<CR>')

-- quickfix: 編集許可と折り返し表示無効
vim.cmd(" \
function! OpenModifiableQF() \
cw \
set modifiable \
set nowrap \
endfunction \
autocmd QuickfixCmdPost *grep* call OpenModifiableQF() \
")

-- quickfix windowsのみになら終了
vim.cmd([[
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END
]])

-- vimgrepをrgにする
-- :vimgrepだとvimgrepでの検索になるので、:grepで検索すること
vim.cmd("let &grepprg='rg --vimgrep'")


