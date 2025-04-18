-------------------------------------------------------------------------------
-- Bootstrap
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Basic settings
-------------------------------------------------------------------------------
vim.opt.autoread = true
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
vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = require('vim.ui.clipboard.osc52').paste('+'),
		['*'] = require('vim.ui.clipboard.osc52').paste('*'),
	},
}

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
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
		'rmagatti/auto-session',
		lazy = false,
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
		}
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
	"nvimtools/none-ls.nvim",
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {},
		init = function()
			vim.keymap.set('n', '<leader>tt', require("nvim-tree.api").tree.toggle)
			vim.keymap.set('n', '<leader>tf', require("nvim-tree.api").tree.find_file)
		end

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
		dependencies = {
			'nvim-lua/plenary.nvim',
			{

				"isak102/telescope-git-file-history.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"tpope/vim-fugitive"
				}
			},
			config = function()
				require("telescope").load_extension("git_file_history")
			end
		}
	},
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			icons = {
				pinned = { button = '', filename = true },
			}

		},
		version = '^1.0.0',
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				options = {
					signcolumn = "no",
					number = false,
				}
			}
		}
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require('gitsigns')


				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gitsigns.nav_hunk('next')
					end
				end)
				map('n', '[c', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gitsigns.nav_hunk('prev')
					end
				end)

				-- Actions
				local wk = require("which-key")

				wk.add({
					{

						'<leader>h',
						group = "hunks",
						mode = "n",
						{
							{ '<leader>hs', gitsigns.stage_hunk, desc = "Stage Hunk" },
							{ '<leader>hr', gitsigns.reset_hunk, desc = "Reset Hunk" },
							{
								'<leader>hS',
								gitsigns.stage_buffer,
								desc = "Stage Buffer"
							},
							{
								'<leader>hu',
								gitsigns.undo_stage_hunk,
								desc = "Undo Stage Hunk"
							},
							{
								'<leader>hR',
								gitsigns.reset_buffer,
								desc = "Reset Buffer"
							},
							{
								'<leader>hp',
								gitsigns.preview_hunk,
								desc = "Preview Hunk"
							},
							{
								'<leader>hb',
								function() gitsigns.blame_line { full = true } end,
								desc = "Blame line"
							},
							{
								'<leader>tb',
								gitsigns.toggle_current_line_blame,
								desc = "Toggle current line blame"
							},
							{
								'<leader>hd',
								gitsigns.diffthis,
								desc = "Diff this"
							},
							{
								'<leader>hD',
								function() gitsigns.diffthis('~') end,
								desc = "Diff this ~"
							},
							{
								'<leader>ht',
								gitsigns.toggle_deleted,
								desc = "Toggle deleted"
							},
						},
					},
					{
						'<leader>h',
						group = "vhunks",
						mode = "v",
						{
							'<leader>hs',
							function()
								gitsigns.stage_hunk { vim.fn.line('.'),
									vim.fn.line('v') }
							end,
							desc = "Stage Hunk",
						},
						{
							'<leader>hr',
							function()
								gitsigns.reset_hunk { vim.fn.line('.'),
									vim.fn.line('v') }
							end,
							desc = "Reset Hunk",
						},
					}
				})

				-- Text object
				map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end



		}
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
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd.colorscheme "kanagawa"
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
	},
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
	{
		'nvim-pack/nvim-spectre',
		opts = {
			live_update = true
		}
	},
	{
		'linrongbin16/lsp-progress.nvim',
		opts = {}
	},
	{ "cappyzawa/trim.nvim",             opts = {} },
	{
		'tribela/transparent.nvim',
		event = 'VimEnter',
		config = true,
	}
})

-------------------------------------------------------------------------------
-- Treesitter
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Autocomplete
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
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
	vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
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

-------------------------------------------------------------------------------
-- LSP Sources
-------------------------------------------------------------------------------
local null_ls = require("null-ls")
local sources = {
	null_ls.builtins.formatting.prettier,
}
null_ls.setup({ sources = sources })
require('lspconfig').clangd.setup {}
require('lspconfig').zls.setup {}
require('lspconfig').ruby_lsp.setup {}
require('lspconfig').ts_ls.setup {}
require('lspconfig').gopls.setup {}
require('lspconfig').basedpyright.setup {}
require 'lspconfig'.lua_ls.setup {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
	settings = {
		Lua = {}
	}
}
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { "*.zig" },
	callback = function()
		local orignal = vim.notify
		vim.notify = function(msg, level, opts)
			if msg == 'No code actions available' then
				return
			end
			orignal(msg, level, opts)
		end
		vim.lsp.buf.code_action({
			context = { only = { "source.fixAll" } },
			apply = true,
		})
	end
})
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format({
			filter = function(client)
				-- apply whatever logic you want (in this example, we'll only use null-ls)
				return client.name ~= "ts_ls"
			end,
		})
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

-------------------------------------------------------------------------------
-- Debugging
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Bindings
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Eval
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------
local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-A-p>', builtin.commands, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gh', telescope.extensions.git_file_history.git_file_history, {})

-------------------------------------------------------------------------------
-- Search
-------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>fg', '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>bf', function()
	print(vim.api.nvim_buf_get_name(0))
end)

-------------------------------------------------------------------------------
-- Godot
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = { "*.gd" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
	end,
})

-------------------------------------------------------------------------------
-- Markdown
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = { "*.md" },
	callback = function()
		vim.opt.textwidth = 80
	end,
})

-------------------------------------------------------------------------------
-- Notes
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Comments
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufEnter', {
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
})
