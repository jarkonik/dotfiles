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
		opts = {
			auto_open = false,
		},
	},
	{ "j-hui/fidget.nvim", tag = "legacy" },
	"terrortylor/nvim-comment",
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
	"ojroques/nvim-osc52",
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
	"onsails/lspkind.nvim",
	"edluffy/hologram.nvim",
	"xiyaowong/transparent.nvim",
	"ellisonleao/gruvbox.nvim",
	"rebelot/kanagawa.nvim",
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
	},
	{
		"rebelot/heirline.nvim",
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
		-- event = "UiEnter",
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
	"nvim-pack/nvim-spectre",
	{ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/notes",
							},
						},
					},
				},
			})
		end,
	},
})

require("dapui").setup()

require("lualine").setup()

-- Terminal tabs
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local heirline = require("heirline")
local colors = {
	bright_bg = utils.get_highlight("Folded").bg,
	bright_fg = utils.get_highlight("Folded").fg,
	red = utils.get_highlight("DiagnosticError").fg,
	dark_red = utils.get_highlight("DiffDelete").bg,
	green = utils.get_highlight("String").fg,
	blue = utils.get_highlight("Function").fg,
	gray = utils.get_highlight("NonText").fg,
	orange = utils.get_highlight("Constant").fg,
	purple = utils.get_highlight("Statement").fg,
	cyan = utils.get_highlight("Special").fg,
	diag_warn = utils.get_highlight("DiagnosticWarn").fg,
	diag_error = utils.get_highlight("DiagnosticError").fg,
	diag_hint = utils.get_highlight("DiagnosticHint").fg,
	diag_info = utils.get_highlight("DiagnosticInfo").fg,
	git_del = utils.get_highlight("diffDeleted").fg,
	git_add = utils.get_highlight("diffAdded").fg,
	git_change = utils.get_highlight("diffChanged").fg,
}
heirline.load_colors(colors)
local TablineFileName = {
	provider = function(self)
		-- self.filename will be defined later, just keep looking at the example!
		local filename = self.filename
		filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active or self.is_visible, italic = true }
	end,
}

local TablineFileFlags = {
	{
		condition = function(self)
			return vim.api.nvim_buf_get_option(self.bufnr, "modified")
		end,
		provider = "[+]",
		hl = { fg = "green" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
				or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
		end,
		provider = function(self)
			if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
				return "  "
			else
				return ""
			end
		end,
		hl = { fg = "orange" },
	},
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
		else
			return "TabLine"
		end
	end,
	FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
	TablineFileName,
	TablineFileFlags, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
}
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { TablineFileNameBlock })

local TerminalLineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
		else
			return "TabLine"
		end
	end,
	TablineFileName,
}
local TerminalLineBufferBlock = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { TerminalLineFileNameBlock })

local function safe_get_buffer_var(bufnr, key, default_value)
	local success, value = pcall(vim.api.nvim_buf_get_var, bufnr, key)
	return success and value or default_value
end

local function get_terminal_bufs()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
			and safe_get_buffer_var(bufnr, "show_in_terminal_bar", false)
	end, vim.api.nvim_list_bufs())
end

local function get_non_terminal_bufs()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "terminal"
			and vim.api.nvim_buf_get_option(bufnr, "buflisted")
	end, vim.api.nvim_list_bufs())
end

local TerminalLine = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "terminal" },
		})
	end,
	utils.make_buflist(TerminalLineBufferBlock, nil, nil, get_terminal_bufs),
}
local BufferLine = {
	utils.make_buflist(TablineBufferBlock, nil, nil, get_non_terminal_bufs),
}
require("heirline").setup({
	winbar = { TerminalLine },
	statusline = { TerminalLine },
	tabline = { BufferLine },
})

require("overseer").setup()

require("transparent").setup()

local wk = require("which-key")

-- Stick buffer
require("stickybuf").setup()

-- LSP Status
require("fidget").setup({})

-- Git gutter
require("gitsigns").setup()

-- Vim options
vim.cmd("autocmd FileType qf set nobuflisted")
vim.g.transparent_enabled = true
vim.o.hidden = true
vim.cmd("autocmd FileType markdown setlocal fo+=a")
vim.wo.number = true
vim.o.wrap = false
vim.o.colorcolumn = "80"
vim.o.showtabline = 2
vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.wo.signcolumn = "yes" -- prevents jitter
vim.opt.updatetime = 100
vim.o.background = "dark" -- or "light" for light mode
vim.cmd("colorscheme kanagawa")
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
					filter = function(cl)
						return cl.name ~= "tsserver"
					end,
				})
			end,
		})
	end

	local keymap_opts = { buffer = buffer }

	wk.register({
		w = {
			name = "Word",
			r = { vim.lsp.buf.rename, "Rename" },
		},
	}, { prefix = "<leader>" })

	-- TODO: Register all in which-key
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
	vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, keymap_opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
	vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, keymap_opts)
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
local lspkind = require("lspkind")

cmp.setup({
	formatting = {
		format = lspkind.cmp_format({}),
	},
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

local timers = {}

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("TermOpenCallback", { clear = true }),
	pattern = "term://*",
	callback = function()
		vim.cmd("PinBuftype")
		vim.cmd("set nobl")

		local timer = vim.loop.new_timer()
		local bufnr = vim.api.nvim_get_current_buf()

		vim.api.nvim_buf_set_var(bufnr, "show_in_terminal_bar", true)

		timers[bufnr] = timer
		timer:start(1000, 750, function()
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					local tji = vim.api.nvim_buf_get_var(bufnr, "terminal_job_id")
					local pid = vim.fn.jobpid(tji)
					local result = vim.fn.system("pgrep -lP " .. pid)
					local first_child = result:gmatch("([^\n]*)\n?")()

					local words_iterator = first_child:gmatch("%S+")
					words_iterator()

					local words = {}
					for word in words_iterator do
						table.insert(words, word)
					end

					local process_name = table.concat(words, " ")
					if process_name ~= "" then
						vim.api.nvim_buf_set_name(bufnr, bufnr .. " " .. process_name)
					else
						vim.api.nvim_buf_set_name(bufnr, tostring(bufnr))
					end
				end
			end)
		end)
	end,
})
vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("TermCloseCallback", { clear = true }),
	pattern = "term://*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		timers[bufnr]:close()
	end,
})

-- Comments
require("nvim_comment").setup()

-- Scope
require("scope").setup({
	restore_state = false,
})

-- Keybinds
local telescope_builtin = require("telescope.builtin")

wk.register({
	c = {
		name = "Config",
		e = { "<cmd>e ~/src/dotfiles/init.lua<CR>", "Edit config" },
		u = {
			function()
				os.execute('git -C ~/src/dotfiles commit -am "update" && git -C ~/src/dotfiles push')
			end,
			"Upload config",
		},
		d = {
			function()
				os.execute("git -C ~/src/dotfiles pull")
			end,
			"Download config",
		},
	},
	d = {
		name = "Debug",
		c = { require("dap").continue, "Continue" },
		t = { require("dapui").toggle, "Toggle UI" },
	},
	n = {
		name = "New",
		t = { "<cmd>terminal<CR>", "New Terminal" },
	},
	f = {
		name = "Find",
		f = { telescope_builtin.find_files, "Find files" },
		g = { telescope_builtin.live_grep, "Grep" },
		b = { telescope_builtin.buffers, "Find buffers" },
		h = { telescope_builtin.help_tags, "Find help tags" },
		d = { telescope_builtin.diagnostics, "List diagnostics" },
		s = { require("spectre").toggle, "Search" },
	},
	t = {
		name = "Tree",
		f = { "<cmd>NvimTreeFindFile<CR>", "Focus current file in tree" },
		t = { require("nvim-tree.api").tree.toggle, "Toggle tree" },
	},
	g = {
		name = "Git",
		o = { neogit.open, "Open Git" },
	},
	r = {
		name = "Run",
		j = {
			"<cmd>OverseerRun<cr>",
			"Job",
		},
		t = {
			"<cmd>TestNearest<cr>",
			"Test",
		},
		f = {
			"<cmd>TestFile<cr>",
			"Test File",
		},
		s = {
			"<cmd>TestSuite<cr>",
			"Test Suite",
		},
	},
	p = {
		name = "Refresh",
		d = { vim.diagnostic.reset, "Diagnostic" },
	},
	e = {
		name = "Eval",
		r = { "<cmd>w !ruby<cr>", "Ruby" },
	},
	o = {
		name = "Organizer",
		i = { "<cmd>Neorg<cr>", "Index" },
		n = { "<cmd>Neorg workspace notes<cr>", "Notes" },
		j = {
			name = "Journal",
			t = { "<cmd>Neorg journal today<cr>", "Today" },
			i = { "<cmd>Neorg journal toc<cr>", "Index" },
		},
	},
	b = {
		name = "Buffer",
		p = { "<cmd>PinBuffer<CR>", "Pin buffer" },
		u = { "<cmd>Unpin<CR>", "Unpin buffer" },
		d = {
			name = "Delete",
			o = {
				function()
					local current_buf_nr = vim.fn.bufnr()
					local all = vim.tbl_filter(function(bufnr)
						return current_buf_nr ~= bufnr
							and vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "terminal"
							and vim.api.nvim_buf_get_option(bufnr, "buflisted")
					end, vim.api.nvim_list_bufs())
					for _, bufnr in ipairs(all) do
						require("bufdelete").bufdelete(bufnr, false)
					end
				end,
				"Delete others",
			},
		},
	},
}, { prefix = "<leader>" })

require("spectre").setup({
	live_update = true,
})

vim.keymap.set("n", "<Tab>", function()
	if vim.bo.buftype == "terminal" then
		local current_buf_nr = vim.fn.bufnr()
		local current_idx = nil
		local terminals = get_terminal_bufs()
		for i, v in pairs(terminals) do
			if v == current_buf_nr then
				current_idx = i
				break
			end
		end

		if current_idx < #terminals then
			vim.cmd("buffer " .. terminals[current_idx + 1])
		else
			vim.cmd("buffer " .. terminals[1])
		end
	else
		vim.cmd("bnext")
	end
end, {})
vim.keymap.set("n", "<c-o>", "<cmd>BufferLinePick<CR>", {})
vim.keymap.set("n", "<c-p>", telescope_builtin.find_files, {})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("n", "<c-c>", function()
	if vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "terminal" then
		require("bufdelete").bufdelete(0, false)
	end
end, {})

-- LSP Config
require("lspconfig").pylsp.setup({})
require("lspconfig").gopls.setup({})
require("lspconfig").tsserver.setup({})
require("lspconfig").zls.setup({})
require("lspconfig").gdscript.setup({
	on_attach = on_attach,
})
require("lspconfig").ruby_ls.setup({
	cmd = { "bundle", "exec", "ruby-lsp" },
	on_attach = on_attach,
})
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
		},
	},
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

-- Install LSPs
require("mason").setup()

-- Scroll bar
require("scrollbar").setup()

-- OSC52 copy/paste
local function copy(lines, _)
	require("osc52").copy(table.concat(lines, "\n"))
end
local function paste()
	return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end
vim.o.clipboard = "unnamedplus"
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

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.fn.expand("~") .. "/notes/*",
	callback = function()
		vim.fn.jobstart('git add . && git -C ~/notes commit -am "update" && git -C ~/notes push')
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local newbuf = vim.api.nvim_create_buf(false, true)
		local windows = vim.fn.getwininfo()
		for _, i in ipairs(windows) do
			if i.bufnr == buf then
				vim.api.nvim_win_set_buf(i.winid, newbuf)
			end
		end

		local current_idx = nil
		local terminals = get_terminal_bufs()
		for i, v in pairs(terminals) do
			if v == buf then
				current_idx = i
				break
			end
		end

		if current_idx < #terminals then
			vim.cmd("buffer " .. terminals[current_idx + 1])
		else
			vim.cmd("buffer " .. terminals[1])
		end

		vim.api.nvim_buf_delete(buf, {})
	end,
})

local dap = require("dap")
dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}
vim.keymap.set("n", "gb", dap.toggle_breakpoint, {})

dap.configurations.rust = {
	{
		-- initCommands = function()
		-- 	-- Find out where to look for the pretty printer Python module
		-- 	local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
		--
		-- 	local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
		-- 	local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
		--
		-- 	local commands = {}
		-- 	local file = io.open(commands_file, "r")
		-- 	if file then
		-- 		for line in file:lines() do
		-- 			table.insert(commands, line)
		-- 		end
		-- 		file:close()
		-- 	end
		-- 	table.insert(commands, 1, script_import)
		--
		-- 	return commands
		-- end,
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			vim.fn.jobstart("cargo build")
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		runInTerminal = true,
	},
}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})
