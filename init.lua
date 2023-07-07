local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").init({
	autoremove = true,
})

require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("lewis6991/fileline.nvim")

	use {
	      'stevearc/stickybuf.nvim',
	      config = function() require('stickybuf').setup() end
	    }

	-- use {"akinsho/toggleterm.nvim", tag = '*', config = function()
	--   require("toggleterm").setup()
	-- end}

	use 'famiu/bufdelete.nvim'

	use("neovim/nvim-lspconfig")
	use('jose-elias-alvarez/null-ls.nvim')

	use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

	use("tiagovla/scope.nvim")

	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				auto_open = true
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	-- Collection of common configurations for the Nvim LSP client
	-- Visualize lsp progress
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})
	use("terrortylor/nvim-comment")
	use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })

	use("petertriho/nvim-scrollbar")

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	})

	-- Autocompletion framework
	use("hrsh7th/nvim-cmp")
	use({
		-- cmp LSP completion
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",

		-- cmp Snippet completion
		"hrsh7th/cmp-vsnip",
		-- cmp Path completion
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		after = { "hrsh7th/nvim-cmp" },
		requires = { "hrsh7th/nvim-cmp" },
	})
	-- See hrsh7th other plugins for more great completion sources!
	-- Snippet engine
	use("hrsh7th/vim-vsnip")
	-- Adds extra functionality over rust analyzer
	use("simrat39/rust-tools.nvim")

	-- Optional
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")

	-- Some color scheme other then default
	use({ "ellisonleao/gruvbox.nvim" })
	use("rebelot/kanagawa.nvim")
end)

-- the first run will install packer and our plugins
if packer_bootstrap then
	require("packer").sync()
	return
end

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme kanagawa]])

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local function on_attach(client, buffer)
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		buffer = buffer,
		callback = function()
			vim.lsp.buf.format()

		end,
	})

	local keymap_opts = { buffer = buffer }
	-- Code navigation and shortcuts
	vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
	vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
	vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
	vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
	vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })

	-- Show diagnostic popup on cursor hover
	local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, { focusable = false })
		end,
		group = diag_float_grp,
	})

	-- Goto previous/next diagnostic warning/error
	vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
	vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
end

vim.keymap.set("n", "<c-c>", function()
        if vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "terminal" then
		require('bufdelete').bufdelete(0, false)
	end
end, keymap_opts)

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
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

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	server = {
		-- on_attach is a callback called when the language server attachs to the buffer
		on_attach = on_attach,
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				-- enable clippy on save
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}

require("rust-tools").setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
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
		-- Add tab support
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

	-- Installed sources
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
})

-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
-- set updatetime=300
vim.opt.updatetime = 100

local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

require("nvim_comment").setup()
require("bufferline").setup({
	options =  {
		close_command = function (bufnum)
			require('bufdelete').bufdelete(bufnum)
		end
	}
})
require("scrollbar").setup()

vim.g.mapleader = ","

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<c-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>t", require("nvim-tree.api").tree.toggle, {})
vim.keymap.set("n", "<leader>g", require("neogit").open, {})
vim.keymap.set("n", "<leader>tr", vim.diagnostic.reset, {})

vim.wo.number = true

vim.keymap.set("n", "<leader><leader>", ":luafile $MYVIMRC<CR>", {})

require("scope").setup({
    restore_state = false, -- experimental
})

require'lspconfig'.tsserver.setup {}
require'lspconfig'.ruby_ls.setup {
	cmd = { 'bundle', 'exec', 'ruby-lsp' },
	on_attach = function(client,bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format {
			    async = false,
		    }
                end,
            })
	end
}
require'lspconfig'.solargraph.setup{
	cmd = { "bundle", "exec", "solargraph", "stdio" },
	on_attach = on_attach
}

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    sources = {
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.formatting.rubocop
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                    vim.lsp.buf.format {
			    async = false,
			    filter = function(client) return client.name ~= "tsserver" end
		    }
                end,
            })
        end
    end,
})

vim.o.wrap = false
