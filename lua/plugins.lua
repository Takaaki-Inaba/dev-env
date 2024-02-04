local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{"thinca/vim-qfreplace", lazy = false},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"go",
					"bash",
					"cpp",
					"html",
					"cmake",
					"make",
					"markdown",
					"python",
					"yaml",
					"toml"
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{"nvim-tree/nvim-web-devicons"},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end
	},
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end
	},
	{"RRethy/vim-illuminate"},
	{'akinsho/toggleterm.nvim', version = "*", config = true},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end
	},
	{"simeji/winresizer"},
	{"mtdl9/vim-log-highlighting"},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},
	{"lewis6991/gitsigns.nvim"},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true
	},
	{'neoclide/coc.nvim', branch = 'release'},
	{"HiPhish/rainbow-delimiters.nvim"},
	{"jackguo380/vim-lsp-cxx-highlight"},
	{
		"davvid/telescope-git-grep.nvim",
		branch = "main"
	},
	{"FabijanZulj/blame.nvim"},
})

vim.cmd("let g:lightline = { 'colorscheme': 'moonfly' }")
vim.g.moonflyItalics = false
vim.g.moonflyVirtualTextColor = true
vim.g.moonflyCursorColor = true
vim.cmd [[colorscheme moonfly]]

-- C-tでタブで開く
-- C-vでvertical open
-- C-xでsplit open
require("nvim-tree").setup({
	filters = {
		custom = {
			"$\\.o",
			"^\\.git",
			"^\\.github",
			"$\\.bak",
			"^\\.cache",
			"^\\.ccls-cache",
			"^\\.clangd",
		},
	},
	tab = {
		sync = {
			open = true,
			close = true,
		},
	},
})

-- nvim-treeでwindowsが最後になった場合に自動でcloseするための設定
local function tab_win_closed(winnr)
	local api = require"nvim-tree.api"
	local tabnr = vim.api.nvim_win_get_tabpage(winnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	local buf_info = vim.fn.getbufinfo(bufnr)[1]
	local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
	local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
	if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
		-- Close all nvim tree on :q
		if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
			api.tree.close()
		end
	else                                                      -- else closed buffer was normal buffer
		if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
			local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
			if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
				vim.schedule(function ()
					if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
						vim.cmd "quit"                                        -- then close all of vim
					else                                                  -- else there are more tabs open
						vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
					end
				end)
			end
		end
	end
end
vim.api.nvim_create_autocmd("WinClosed", {
	callback = function ()
		local winnr = tonumber(vim.fn.expand("<amatch>"))
		vim.schedule_wrap(tab_win_closed(winnr))
	end,
	nested = true
})
-- nvim-treeをopen
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

-- telescopeの設定
-- telescopeのkeymapping
-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings
-- <C-q>で検索結果をquickfix windowに移す
require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			-- 検索から除外するものを指定
			"^.git/",
			"^.cache/",
		},
	},
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
--vim.keymap.set('n', '<leader>r', builtin.live_grep, {})
vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
require('telescope').load_extension('git_grep')
vim.keymap.set('n', '<leader>g', function()
	require('git_grep').grep()
end)
vim.keymap.set('n', '<leader>q', builtin.quickfixhistory, {})

-- telescopeのlive grepはfuzzy検索できないので、live grepのみfzfを使用する
--vim.keymap.set("n", "<leader>g","<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true })
vim.keymap.set("n", "<leader>r","<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })


-- toggletermの設定
vim.keymap.set('n', '<leader><space>t', ':ToggleTerm size=20 direction=horizontal<CR>')
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

-- autopairs
require('nvim-autopairs').setup({
	disable_filetype = { "TelescopePrompt" , "vim" },
})

-- winresize
vim.keymap.set('n', '<space>w', ':WinResizerStartResize<CR>')

-- lualine
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {{'filename', path = 1,}},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress', 'searchcount'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {{'filename', path = 1,}},
		lualine_x = {'location'},
		lualine_y = {'searchcount'},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

-- gitsignsの設定
require('gitsigns').setup {
	signs = {
		add          = { text = '│' },
		change       = { text = '│' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true
	},
	auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
	yadm = {
		enable = false
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then return ']c' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
			end, {expr=true})

		map('n', '[c', function()
			if vim.wo.diff then return '[c' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
			end, {expr=true})

		-- Actions
		map('v', '<leader><space>r', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
		map('n', '<leader><space>r', gs.reset_hunk)
		map('n', '<leader><space>p', gs.preview_hunk)
		map('n', '<leader><space>b', gs.toggle_current_line_blame)
	end
}

-- blameの設定                                                    
vim.keymap.set('n', '<leader><space>B', ':ToggleBlame window<CR>')

-- neogitの設定
vim.keymap.set('n', '<leader><space>s', ':Neogit kind=split<CR>')

-- cocの設定
-- GoTo code navigation
-- <space>t で定義を新しいタブに表示
-- <space>v で定義を横分割して表示
-- <space>s で定義を縦分割して表示
vim.keymap.set("n", "<space>j", ":<C-u>call CocAction('jumpDefinition', 'edit')<CR>zz", {silent = true})
vim.keymap.set("n", "<space>t", ":<C-u>call CocAction('jumpDefinition', 'tab drop')<CR>zz", {silent = true})
vim.keymap.set("n", "<space>v", ":<C-u>call CocAction('jumpDefinition', 'vsplit')<CR>zz", {silent = true})
vim.keymap.set("n", "<space>s", ":<C-u>call CocAction('jumpDefinition', 'split')<CR>zz", {silent = true})
vim.keymap.set("n", "<space>k", "<C-o>", {silent = true})
-- スペースrfでReferences
vim.keymap.set("n", "<space>de", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "<space>im", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "<space>rf", "<Plug>(coc-references)", {silent = true})

-- スペースhでHover
function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end
vim.keymap.set("n", "<space>h", '<CMD>lua _G.show_docs()<CR>', {silent = true})
-- スペースfmでコードをformatting
vim.keymap.set("n", "<space>fm", "<Plug>(coc-format-selected)", {silent = true})

-- スペースdでdiagnosticを有効化
vim.keymap.set("n", "<space>d", ":<C-u>call CocAction('diagnosticToggle')<CR>", {silent = true})



