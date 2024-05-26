local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.o.background = "dark"
vim.opt.updatetime = 1000
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.wo.number = true
vim.opt.shortmess:append("sI")
vim.opt.wrap = false
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')}]]

if vim.g.vscode then
	require("lazy").setup({
		{
			"terrortylor/nvim-comment",
			config = function()
				require("nvim_comment").setup()
			end
		},
	})
	return
end

require("lazy").setup({
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_output_win_max_height = 12
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {}
	},
	"rcarriga/nvim-notify",
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-vsnip',
	'hrsh7th/vim-vsnip',
	"neovim/nvim-lspconfig",
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {},
		init = function()
			vim.keymap.set('n', '<leader>tt', require("nvim-tree.api").tree.toggle)
		end

	},
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			no_name_title = "unnamed",
			icons = {
				pinned = { button = '', filename = true },
			}
		},
		version = '^1.0.0',
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {}
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"lewis6991/gitsigns.nvim", opts = {}
	},
	{
		"folke/neodev.nvim",
		opts = {
			override = function(_, library)
				library.enabled = true
				library.plugins = true
			end,

		}
	},
	{
		'nvim-lualine/lualine.nvim',
		opts = {
			sections = {
				lualine_c = {
					function()
						return require('lsp-progress').progress()
					end,
				},
			}
		},
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme "catppuccin-mocha"
		end
	},
	{ "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		'mrcjkb/rustaceanvim',
		version = '^4',
		lazy = false,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	"dstein64/nvim-scrollview",
	"sindrets/diffview.nvim",
	'nvim-lua/plenary.nvim',
	'nvim-pack/nvim-spectre',
	{
		'linrongbin16/lsp-progress.nvim',
		opts = {}
	},
	{ "cappyzawa/trim.nvim", opts = {} },
})

require 'nvim-treesitter.configs'.setup({
	ensure_installed = {},
	auto_install = true,
	highlight = {
		enable = true
	},
	sync_install = false,
	ignore_install = {},
	modules = {}
})

local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
})

require('lspconfig').lua_ls.setup({})
require("lspconfig").pyright.setup({})
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format()
	end,
})
require('lspconfig').ruff.setup {
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			args = {},
		}
	}
}
require 'lspconfig'.gdscript.setup {}
local on_attach = function(bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { buffer = bufnr, noremap = true, silent = true }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
end
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		on_attach(bufnr)
	end,
})

local dap = require('dap')
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-dap',
	name = 'lldb'
}
require("dapui").setup()
vim.keymap.set('n', '<leader>dd', require("dapui").toggle, {})
vim.keymap.set('n', '<leader>db', require("dap").toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dr', function()
	vim.cmd.RustLsp('debug')
end, {})
vim.fn.sign_define('DapBreakpoint', {
	text = '',
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl =
	'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition',
	{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
	{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>",
	{ silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
	{ silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>",
	{ silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>",
	{ silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
	{ silent = true, desc = "evaluate visual selection" })

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
map('n', '<leader>bdo', "<Cmd>BufferCloseAllButCurrentOrPinned<CR>", opts);
map('n', '<leader>bp', '<Cmd>BufferPin<CR>', opts)
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-n>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A-m>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
map('n', '<A-p>', '<Cmd>BufferPick<CR>', opts)

vim.keymap.set('n', '<leader>fg', '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre"
})

vim.keymap.set('n', '<leader>bf', function()
	print(vim.api.nvim_buf_get_name(0))
end)

vim.api.nvim_create_autocmd('BufEnter', {
	pattern = { "*.gd" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
	end,
})

vim.api.nvim_create_autocmd('BufEnter', {
	pattern = { "*/notes/**" },
	callback = function()
		vim.loop.spawn("git", { args = { "pull" } })
	end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = { "*/notes/**" },
	callback = function()
		local filename = vim.fn.expand('%')
		local command = 'git add ' .. filename .. '; git commit -m "Auto-commit: saved ' .. filename .. '"'
		vim.fn.system(command)
		vim.loop.spawn("git", { args = { "push" } })
	end
})
