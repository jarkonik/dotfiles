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
	{ "NeogitOrg/neogit", dependencies = "nvim-lua/plenary.nvim" },
	"lewis6991/fileline.nvim",
	"mfussenegger/nvim-dap",
	{
		"stevearc/stickybuf.nvim",
		opts = {},
	},
	"famiu/bufdelete.nvim",
	"neovim/nvim-lspconfig",
	"jose-elias-alvarez/null-ls.nvim",
	"tiagovla/scope.nvim",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{ "j-hui/fidget.nvim", tag = "legacy" },
	"terrortylor/nvim-comment",
	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	"petertriho/nvim-scrollbar",
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/vim-vsnip",
	"simrat39/rust-tools.nvim",
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-lualine/lualine.nvim",
	"ojroques/nvim-osc52",
	{ "EdenEast/nightfox.nvim" },
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	"f-person/git-blame.nvim",
	"lewis6991/gitsigns.nvim",
	"nvim-treesitter/nvim-treesitter",
	"vim-test/vim-test",
	"sindrets/diffview.nvim",
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
})

-- Stick buffer
require("stickybuf").setup()

-- LSP Status
require("fidget").setup({})

-- Git gutter
require("gitsigns").setup()

-- Vim options
vim.cmd("autocmd FileType qf set nobuflisted")
vim.o.hidden = true
vim.wo.number = true
vim.o.wrap = false
vim.g.mapleader = ","
vim.wo.signcolumn = "yes" -- prevents jitter
vim.opt.updatetime = 100
vim.o.background = "dark" -- or "light" for light mode
vim.cmd("colorscheme nightfox")
-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"
-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local function on_attach(client, buffer)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			buffer = buffer,
			callback = function()
				vim.lsp.buf.format({
					async = false,
					filter = function(client)
						return client.name ~= "tsserver"
					end,
				})
			end,
		})
	end

	local keymap_opts = { buffer = buffer }

	-- TODO: Register in which-key
	vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
	vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
	vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
	vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
	vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, keymap_opts)

	-- Show diagnostic popup on cursor hover
	local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, { focusable = false })
		end,
		group = diag_float_grp,
	})

	vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
	vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
end

require("rust-tools").setup({
	tools = {
		runnables = {
			use_telescope = true,
		},
		inlay_hints = {
			auto = true,
			show_parameter_hints = false,
			parameter_hints_prefix = "",
			other_hints_prefix = "",
		},
	},
	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
})

-- Completion
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
})

-- Git
local neogit = require("neogit")
neogit.setup({
	integrations = {
		diffview = true,
	},
})

-- Folder tree
local function open_nvim_tree(data)
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then
		return
	end
	vim.cmd.cd(data.file)

	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
	pattern = "NvimTree_*",
	callback = function()
		local layout = vim.api.nvim_call_function("winlayout", {})
		if
			layout[1] == "leaf"
			and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
			and layout[3] == nil
		then
			vim.cmd("confirm quit")
		end
	end,
})

-- Comments
require("nvim_comment").setup()

-- Buffer line
require("bufferline").setup({
	options = {
		close_command = false,
		show_buffer_close_icons = false,
		right_mouse_command = "",
	},
})

-- Scope
require("scope").setup({
	restore_state = false,
})

-- Keybinds
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

wk.register({
	o = {
		name = "Open",
		t = { "<cmd>terminal<CR>", "Open Terminal" },
	},
	f = {
		name = "Find",
		f = { telescope_builtin.find_files, "Find files" },
		g = { telescope_builtin.live_grep, "Grep" },
		b = { telescope_builtin.buffers, "Find buffers" },
		h = { telescope_builtin.help_tags, "Find help tags" },
	},
	t = {
		name = "Tree",
		f = { "<cmd>NvimTreeFindFile<CR>", "Focus current file in tree" },
		t = { require("nvim-tree.api").tree.toggle, "Toggle tree" },
	},
	g = { neogit.open, "Open git" },
	r = {
		name = "Refresh",
		d = { vim.diagnostic.reset, "Refresh diagnostic" },
	},
	b = {
		name = "Buffer",
		p = { "<cmd>PinBuffer<CR>", "Pin buffer" },
		u = { "<cmd>Unpin<CR>", "Unpin buffer" },
	},
}, { prefix = "<leader>" })

vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", {})
vim.keymap.set("n", "<c-p>", telescope_builtin.find_files, {})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("n", "<c-c>", function()
	if vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "terminal" then
		require("bufdelete").bufdelete(0, false)
	end
end, keymap_opts)

-- LSP Config
require("lspconfig").tsserver.setup({})
require("lspconfig").gdscript.setup({
	on_attach = on_attach,
})
require("lspconfig").ruby_ls.setup({
	cmd = { "bundle", "exec", "ruby-lsp" },
	on_attach = on_attach,
})
require("lspconfig").solargraph.setup({
	cmd = { "bundle", "exec", "solargraph", "stdio" },
	on_attach = on_attach,
})
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.code_actions.gitsigns,
	},
	on_attach = on_attach,
})

-- Scroll bar
require("scrollbar").setup()

-- Status line
require("lualine").setup()

-- OSC52 copy/paste
local function copy(lines, _)
	require("osc52").copy(table.concat(lines, "\n"))
end
local function paste()
	return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end
vim.g.clipboard = {
	name = "osc52",
	copy = { ["+"] = copy, ["*"] = copy },
	paste = { ["+"] = paste, ["*"] = paste },
}

-- Language Syntax
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})

-- Tests
vim.g["test#strategy"] = "neovim"
