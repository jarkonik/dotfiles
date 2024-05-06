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

if vim.g.vscode then
	require("lazy").setup({
		"terrortylor/nvim-comment",
	})
	require("nvim_comment").setup()
	return
end

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

require("lazy").setup({
	{
		"3rd/image.nvim",
		config = function()
			-- ...
		end
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		build = ":UpdateRemotePlugins",
		init = function()
			-- this is an example, not a default. Please see the readme for more configuration options
			vim.g.molten_output_win_max_height = 12
		end,
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
	"terrortylor/nvim-comment",
	"nvim-tree/nvim-tree.lua",
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
		},
		version = '^1.0.0',
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	"lewis6991/gitsigns.nvim",
	{ "folke/neodev.nvim",               opts = {} },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{ "catppuccin/nvim",      name = "catppuccin",                                                priority = 1000 },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	"jose-elias-alvarez/null-ls.nvim"
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.yapf
	},
})

require("image").setup({})

vim.cmd.colorscheme "catppuccin-mocha"

local dap = require('dap')
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-dap',
	name = 'lldb'
}

require("dapui").setup()

require('lualine').setup({})

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

require('gitsigns').setup()

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

require("nvim_comment").setup()

require("neodev").setup({
	override = function(_, library)
		library.enabled = true
		library.plugins = true
	end,
})
require('lspconfig').lua_ls.setup({})

require("lspconfig").pyright.setup({})
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format()
	end,
})
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
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
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
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require("nvim-tree").setup()
vim.keymap.set('n', '<leader>tt', require("nvim-tree.api").tree.toggle)

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
vim.g.molten_image_provider = "image.nvim"

vim.keymap.set('n', '<leader>bdo', function()
	if vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
		return
	end

	local bufs = vim.api.nvim_list_bufs()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, i in ipairs(bufs) do
		if i ~= current_buf and vim.api.nvim_buf_get_option(i, "filetype") ~= "NvimTree" then
			vim.api.nvim_buf_delete(i, {})
		end
	end
end, {})
