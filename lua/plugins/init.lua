keymap = vim.keymap.set
require "utils"
require "binds"

opts = {noremap = true, silent = true}



g.table_mode_map_prefix = '<leader>T'
g.table_mode_tableize_d_map = '<leader>TT'
g.table_mode_insert_column_after_map = '<leader>Tac'

g["pandoc#filetypes#pandoc_markdown"] = 0
if BINDINGS == "colemak" then
	g["pandoc#keyboard#display_motions"] = 0;
end


g.tagbar_position = "rightbelow"

local plugin_setups = {
	-- {{{ COMMON DEPENDENCIES
	'nvim-tree/nvim-web-devicons', -- icons
	'nvim-lua/plenary.nvim', -- utility functions
	-- }}}

	-- {{{ DEVELOPER ESSENTIALS
	'tpope/vim-fugitive', -- git integration
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>sg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},
	--  }}}


	-- {{{ FABULOUS
	'morhetz/gruvbox', -- colorscheme
	{'daschw/leaf.nvim', opts = {contrast = "medium"}}, -- colorscheme
	-- ]}}

	-- {{{ LSP & DAP 
	{'neovim/nvim-lspconfig',
		config = function()

			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap=true, silent=true, buffer=bufnr }
				keymap('n', '<leader>jD', vim.lsp.buf.declaration, bufopts)
				keymap('n', '<leader>jd', vim.lsp.buf.definition, bufopts)
				keymap('n', '<leader>ji', vim.lsp.buf.implementation, bufopts)
				keymap('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
				keymap('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
				keymap('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
				keymap('n', '<leader>lwl', function()
					print(vim.inspect(vim.lsp.buf.list_work_folders()))
				end, bufopts)
				keymap('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
				keymap('n', '<leader>jr', vim.lsp.buf.references, bufopts)

				vim.api.nvim_create_autocmd("CursorHold", {
				buffer = bufnr,
				callback = function()
					local opts = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = 'rounded',
						source = 'always',
						prefix = ' ',
						scope = 'cursor',
					}
					vim.diagnostic.open_float(nil, opts)
				end
			})
			end

			local lsp_flags = {}
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require('lspconfig')
			lspconfig.pylsp.setup{}
			lspconfig.ts_ls.setup{  on_attach = on_attach, flags = lsp_flags   }
			lspconfig.elixirls.setup{  cmd = { "elixir-ls" }, on_attach = on_attach   }
			lspconfig.clangd.setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig.slint_lsp.setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig.wgsl_analyzer.setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig.texlab.setup{
				flags = lsp_flags,
				on_attach = on_attach,
				filetypes = { "tex", "plaintex", "bib", "markdown" }
			}

			lspconfig.rust_analyzer.setup{
				flags = lsp_flags,
				on_attach = on_attach,
				-- settings = {
				--	['rust-analyzer'] = {
				--		diagnostics = {
				--			disable = { "unresolved-proc-macro" }
				--		}
				--	}
				-- }
			}
			lspconfig.golangci_lint_ls.setup{}
			lspconfig.hls.setup{ flags = lsp_flags, on_attach = on_attach }
			lspconfig.asm_lsp.setup{ flags = lsp_flags, on_attach = on_attach }
			lspconfig.svelte.setup{}
			-- lspconfig.typst_lsp.setup{
			--	settings = {
			--		-- exportPdf = "onSave" -- Choose onType, onSave or never.
			--		-- serverPath = "" -- Normally, there is no need to uncomment it.
			--	}
			-- }
			lspconfig.tinymist.setup{
				root_dir = function()
					return vim.fn.getcwd()
				end,
				on_init = function(client)
					client.offset_encoding = "utf-8"
				end,
			}
			lspconfig.csharp_ls.setup{}
			lspconfig.lua_ls.setup {
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = 'LuaJIT',
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {'vim'},
						},
						work = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = true,
						},
					},
				},
			}
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.emmet_language_server.setup{
				capabilities = capabilities,
				filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
			}



			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics,
				{
					virtual_text = false,
					signs = true,
					update_in_insert = false,
					underline = true,
					severity_sort = true,
				}
			) -- removes virtual text 
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end
	, dependencies = { 'williamboman/mason-lspconfig.nvim' }},-- lsp config
	{'williamboman/mason.nvim', config = function()
		require("mason").setup()
	end, cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" } }, -- lsp installer
	{'williamboman/mason-lspconfig.nvim', setup=true, dependencies= { 'williamboman/mason.nvim'} },
	{ 'mfussenegger/nvim-dap', config = function () -- debugger
			local dap = require("dap")

			dap.adapters.lldb = {
				type = 'executable',
				command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
				name = 'lldb'
			}

			dap.configurations.cpp = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workFolder}',
					stopOnEntry = true,
					args = function ()
						local t={}
						local argstring = vim.fn.input("Args: ")
						for strn in string.gmatch(argstring, "([^%s]+)") do
							table.insert(t, strn)
						end
						return t
					end,
					},
				}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
					end,
					cwd = '${workFolder}',
					stopOnEntry = true,
					args = {},
					runInTerminal = false
				},
			}
			dap.adapters.coreclr = {
				type = 'executable',
				command = '/Users/anhthu/.local/share/nvim/mason/bin/netcoredbg',
				args = {'--interpreter=vscode'}
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
					end,
				},
			}
		end,
		keys = {
			{ "<leader>db", function() require"dap".toggle_breakpoint() end, unpack(opts) },
			{ "<leader>dB", function() require"dap".set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, unpack(opts) },
			{ "<leader>dc", function() require"dap".continue() end, unpack(opts) },
			{ "<leader>ds", function() require"dap".step_over() end, unpack(opts) },
			{ "<leader>di", function() require"dap".step_into() end, unpack(opts) },
			{ "<leader>dr", function() require"dap".repl.open() end, unpack(opts) },
		},
		lazy = true

	},

	{ 'theHamsta/nvim-dap-virtual-text', requires = {'mfussenegger/nvim-dap'}},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",

			-- Adapters
			"nvim-neotest/neotest-python"
		},
		lazy = true,
		config = function() 
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						args = { "-s" }
					})
				}
			})
		end,
		keys = {
			{ "<leader>mr", function() require("neotest").run.run() end, unpack(opts), desc="nearest" },
			{ "<leader>mf", function() require("neotest").run.run(vim.fn.expand("%")) end, unpack(opts), desc="file" },
			{ "<leader>mo", function() require("neotest").output_panel.open() end, unpack(opts), desc="output panel" },
			{ "<leader>md", function() require("neotest").run.run({strategy = "dap"}) end, unpack(opts), desc="debug" },
			{ "<leader>mx", function() require("neotest").run.stop() end, unpack(opts), desc="stop" },
			{ "<leader>mp", function() require("neotest").jump.prev({status = 'failed'}) end, unpack(opts), desc="jump previous failed" },
			{ "<leader>mn", function() require("neotest").jump.next({status = 'failed'}) end, unpack(opts), desc="jump next failed" },
			{ "<leader>ms", function() require("neotest").summary.toggle() end, unpack(opts), desc="toggle summary" },
		}
	},
	{ 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'}, config = function ()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		keymap("n", "<leader>sx", function() dapui.open() end, opts)

		keymap("n", BINDINGS == "colemak" and"<M-n>" or "<M-k>", "<Cmd>lua require(\"dapui\").eval()<CR>", opts)
	end},

	{
		'nvimtools/none-ls.nvim',
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
			})
		end
	}, -- linter and formatter
	{
		'glepnir/lspsaga.nvim',
		event = 'BufRead',
		opts = { -- same as require "lspsaga".setup 
			border_style = "rounded",
			outline = {
				keys = {
					jump = '<CR>',
					expand_collapse = "<Tab>"
				}
			},
			ui = {
				title = false,
				colors = {
					title_bg = '#504945',
					normal_bg = '#504945',
				}
			},
			symbol_in_winbar = {
				enable = false
			}
		},
		dependencies = { {'nvim-tree/nvim-web-devicons'} },
		keys = {
			{ '<leader>la', "<cmd>Lspsaga code_action<CR>", mode = {'n', 'v'}, desc = "Code Action", unpack(opts) },
			{'gh', "<cmd>Lspsaga lsp_finder<CR>", unpack(opts) },
			{"gd", "<cmd>Lspsaga peek_definition<CR>", unpack(opts)},
			{BINDINGS == "colemak" and "N" or "K", "<cmd>Lspsaga hover_doc<CR>"},
			{"<leader>lr", "<cmd>Lspsaga rename<CR>", desc="Rename var", unpack(opts)},
			{"<leader>lp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc="previous diagnostic", unpack(opts)},
			{"<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc="next diagnostic", unpack(opts)},
			{"<leader>lb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc="buffer diagnostics", unpack(opts)},
			{"<leader>lo", "<cmd>Lspsaga outline<CR>", desc="Outline", unpack(opts)}
		}
	},
	{ 'mfussenegger/nvim-jdtls', ft = {'java'} },
	{ 'hrsh7th/cmp-nvim-lsp', lazy = true , event = "InsertEnter" },
	{ 'hrsh7th/nvim-cmp', lazy = true, event = "InsertEnter",
		dependencies = {
			'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'f3fora/cmp-spell',
			-- 'quangnguyen30192/cmp-nvim-ultisnips',
			'hrsh7th/cmp-nvim-lsp-signature-help', 'onsails/lspkind.nvim', 'saadparwaiz1/cmp_luasnip'
		},
		config = function()

			local lspkind = require('lspkind');
			lspkind.init()
			local cmp = require'cmp'
			local select_opts = {behavior = cmp.SelectBehavior.Select}
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local luasnip = require("luasnip");

			vim.opt.spell = true
			vim.opt.spelllang = { 'en_us', 'de_de' }
			cmp.setup {
				completion = {
				},
				snippet = {
					expand = function(args)
						 -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = {
					-- ... Your other mappings ...
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- ['<esc>'] = cmp.mapping.abort()
				},
				sources = cmp.config.sources({
						{ name = 'nvim_lsp_signature_help' },
						-- { name = "codeium" },
						{ name = 'path' },
						{ name = 'nvim_lsp', keyword_length = 2 },
						-- { name = 'ultisnips' },
						{ name = 'cmp_tabnine' },
						{ name = 'luasnip' },
				}, {{ name = 'buffer', keyword_length = 3 }, { name = 'spell' }}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = '...',
						symbol_map = { Codeium = "", }
					})
				},
				experimental = {
					ghost_text = true
				}

			}

			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end
	},
	-- { 'sirver/ultisnips',
	--	requires = { {'nvim-lua/plenary.nvim'} }, --because of plenary path
	--	dependencies = {'honza/vim-snippets'},
	--	keys = {"<leader>cs", ":UltiSnipsEdit<CR>", desc="snippets", unpack(opts)},
	--	lazy = false,
	--	config = function()
	--		g.UltiSnipsExpandTrigger = '<tab>'
	--		g.UltiSnipsJumpForwardTrigger = '<tab>'
	--		g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
	--		g.UltiSnipsSnippetDirectories={ g.CURRENT_CONFIG_FOLDER .. 'ultisnippets' }
	--	end
	-- },
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			local ls = require("luasnip")



			local util = require("luasnip.util.util")
			local node_util = require("luasnip.nodes.util")

			ls.setup({


				-- Enable autotriggered snippets
				enable_autosnippets = true,
				update_events = {"TextChanged", "TextChangedI"},

				-- Use Tab (or some other key if you prefer) to trigger visual selection
				store_selection_keys = "<Tab>",
				parser_nested_assembler = function(_, snippetNode)
					local select = function(snip, no_move, dry_run)
						if dry_run then
							return
						end
						snip:focus()
						-- make sure the inner nodes will all shift to one side when the
						-- entire text is replaced.
						snip:subtree_set_rgrav(true)
						-- fix own extmark-gravities, subtree_set_rgrav affects them as well.
						snip.mark:set_rgravs(false, true)

						-- SELECT all text inside the snippet.
						if not no_move then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
							node_util.select_node(snip)
						end
					end

					local original_extmarks_valid = snippetNode.extmarks_valid
					function snippetNode:extmarks_valid()
						-- the contents of this snippetNode are supposed to be deleted, and
						-- we don't want the snippet to be considered invalid because of
						-- that -> always return true.
						return true
					end

					function snippetNode:init_dry_run_active(dry_run)
						if dry_run and dry_run.active[self] == nil then
							dry_run.active[self] = self.active
						end
					end

					function snippetNode:is_active(dry_run)
						return (not dry_run and self.active) or (dry_run and dry_run.active[self])
					end

					function snippetNode:jump_into(dir, no_move, dry_run)
						self:init_dry_run_active(dry_run)
						if self:is_active(dry_run) then
							-- inside snippet, but not selected.
							if dir == 1 then
								self:input_leave(no_move, dry_run)
								return self.next:jump_into(dir, no_move, dry_run)
							else
								select(self, no_move, dry_run)
								return self
							end
						else
							-- jumping in from outside snippet.
							self:input_enter(no_move, dry_run)
							if dir == 1 then
								select(self, no_move, dry_run)
								return self
							else
								return self.inner_last:jump_into(dir, no_move, dry_run)
							end
						end
					end

					-- this is called only if the snippet is currently selected.
					function snippetNode:jump_from(dir, no_move, dry_run)
						if dir == 1 then
							if original_extmarks_valid(snippetNode) then
								return self.inner_first:jump_into(dir, no_move, dry_run)
							else
								return self.next:jump_into(dir, no_move, dry_run)
							end
						else
							self:input_leave(no_move, dry_run)
							return self.prev:jump_into(dir, no_move, dry_run)
						end
					end

					return snippetNode
				end,
			})

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
		end
	},
	{ 'mrcjkb/rustaceanvim', lazy = false, version = '^5'},
	{'tzachar/cmp-tabnine', build='./install.sh', lazy = true, event = "InsertEnter"},
	-- {
	-- 	"Exafunction/codeium.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"hrsh7th/nvim-cmp",
	-- 	},
	-- 	lazy = true, event = "InsertEnter"
	-- },

	-- }}}
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},

	-- {{{ utilities while writing
	{ 'junegunn/limelight.vim'
		, keys = {{"<leader>tf", "<cmd>Limelight!!<CR>", desc="focus mode"}, unpack(opts) }, lazy = true, cmd = { "Limelight" }
		, config = function ()
			-- Color name (:help cterm-colors) or ANSI code
			g.limelight_conceal_ctermfg = 'gray'
			g.limelight_conceal_ctermfg = 240
			-- Color name (:help gui-colors) or RGB color
			g.limelight_conceal_guifg = 'DarkGray'
			g.limelight_conceal_guifg = '#777777'
		end
	},
	'junegunn/vim-easy-align',
	{'mg979/vim-visual-multi', config = function()
		g.VM_mouse_mappings = 1
	end, keys = {{"<C-down>", "<Plug>newCursor<CR>", unpack(opts)}}},
	{"ziontee113/color-picker.nvim",
		setup = true, lazy = true, keys = {{"<leader>sa", ":PickColor<cr>", desc = "Color Picker"}}
	},
	{'rhysd/vim-grammarous', lazy = true,
		keys = {{"<leader>tg", "<cmd>GrammarousCheck<CR>", desc = "Grammar checker", unpack(opts)}}, cmd = {'GrammarousCheck'} },
	{ 'folke/todo-comments.nvim', setup = true },
	{ 'norcalli/nvim-colorizer.lua', setup = true },
	'tpope/vim-commentary',
	{ 'chrisbra/NrrwRgn', cmd = {'NR', 'NW', 'NRP', 'NRM'} },
	'lambdalisue/suda.vim',
	-- }}}

	-- {{{ UI Utilities
	{ 'tweekmonster/startuptime.vim', lazy = true, cmd = { "StartupTime"}}, -- timer
	{ 'mhinz/vim-startify' , config = function()
			g.startify_bookmarks={ { t = '~/.todo.md' }, { c = '~/.config/nvim/init.lua' }, { k = '~/.config/kitty/kitty.conf' }, { z = '~/.zshrc' } }
			g.startify_change_to_dir = 0
		end
	}, -- start menu
	{ 'nvim-tree/nvim-tree.lua'
		, dependencies = { 'nvim-tree/nvim-web-devicons' }
		, config = function ()
			require("nvim-tree").setup()
		end,
		lazy = true,
		cmd = {"NvimTreeOpen", "NvimTreeToggle"},
		keys = {{"<leader>sf", "<cmd>NvimTreeToggle<CR>", desc="file tree", unpack(opts)}}

	}, -- file tree
	{'akinsho/bufferline.nvim', version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' }
		, config = function ()
			vim.opt.termguicolors = true
			require("bufferline").setup{
				options = {
					numbers = "both",
					number_style = { "subscript" },
					diagnostics = "nvim_lsp"
				}
			}
		end
	}, -- bufferline
	-- }}}


	{ 'folke/which-key.nvim'
		, opts = { triggers = { "<leader>" }, triggers_blacklist = { i = {"<leader>"} }, notify = false, defer = function(ctx)
			if vim.list_contains({ "d", "y" }, ctx.operator) then
				return true
			end
			return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
		end, }
		, config = function ()
			local wk = require("which-key")

			wk.add(
			{
				{ "<leader>+", desc = "increase" },
				{ "<leader>-", desc = "decrease" },
				{ "<leader>m", group = "test" },
				{ "<leader>T", group = "table" },
				{ "<leader>TT", desc = "tableize delim" },
				{ "<leader>Ta", group = "append" },
				{ "<leader>Tac", desc = "append column" },
				{ "<leader>Td", group = "delete" },
				{ "<leader>Tdc", desc = "delete column" },
				{ "<leader>Tdd", desc = "delete row" },
				{ "<leader>Tf", group = "formulas" },
				{ "<leader>Tfa", desc = "add formula" },
				{ "<leader>Tfe", desc = "eval form" },
				{ "<leader>Ti", group = "insert" },
				{ "<leader>Tic", desc = "insert column" },
				{ "<leader>Tm", desc = "toggle" },
				{ "<leader>Tr", desc = "realign" },
				{ "<leader>Tt", desc = "tableize csv" },
				{ "<leader>c", group = "config" },
				{ "<leader>cm", desc = "main config" },
				{ "<leader>d", group = "debugger" },
				{ "<leader>db", desc = "breakpoint" },
				{ "<leader>dc", desc = "continue" },
				{ "<leader>di", desc = "step into" },
				{ "<leader>ds", desc = "step over" },
				{ "<leader>f", group = "funky" },
				{ "<leader>fc", desc = "color chooser" },
				{ "<leader>j", group = "jump" },
				{ "<leader>jD", desc = "declaration" },
				{ "<leader>jd", desc = "definition" },
				{ "<leader>ji", desc = "implementation" },
				{ "<leader>jr", desc = "references" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>lf", desc = "formatting" },
				{ "<leader>n", group = "navigation" },
				{ "<leader>nb", desc = "buffers" },
				{ "<leader>nf", desc = "files" },
				{ "<leader>nh", desc = "help tags" },
				{ "<leader>ns", desc = "string" },
				{ "<leader>nt", desc = "tabs" },
				{ "<leader>s", group = "show" },
				{ "<leader>sc", desc = "copy window" },
				{ "<leader>sd", desc = "drawing" },
				{ "<leader>se", desc = "ez swap window" },
				{ "<leader>sf", desc = "file tree" },
				{ "<leader>sp", desc = "tree sitter" },
				{ "<leader>ss", desc = "shell" },
				{ "<leader>sv", desc = "paste/swap window" },
				{ "<leader>sx", desc = "debugger ui" },
				{ "<leader>t", group = "text" },
				{ "<leader>tc", desc = "duplicate line" },
				{ "<leader>td", group = "delete" },
				{ "<leader>tde", desc = "empty lines" },
				{ "<leader>te", desc = "emojify" },
				{ "<leader>tg", desc = "grammar check" },
				{ "<leader>tr", desc = "motion translate" },
				{ "<leader>tt", group = "tabs" },
				{ "<leader>tts", desc = "to " },
				{ "<leader>tw", desc = "word wrap" },
				{ "<leader>w", group = "window" },
				{ "<leader>w-", desc = "split" },
				{ "<leader>wr", desc = "rename current" },
				{ "<leader>ws", desc = "select index" },
				{ "<leader>wt", desc = "default in new tab" },
				{ "<leader>ww", desc = "default index" },
				{ "<leader>w|", desc = "vertsplit" },
				{ "<leader>p", group = "preview" },
			})
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} },
		config = function()
			require('telescope').setup()
		end, lazy = true, cmd = "Telescope",
		keys = { {"<leader>nf", ":Telescope find_files<CR>", desc="files", unpack(opts)},
				{"<leader>nb", ":Telescope buffers<CR>", desc="buffers", unpack(opts)},
				{"<leader>ns", ":Telescope live_grep<CR>", desc="strings", unpack(opts)},
				{"<leader>nh", ":Telescope help_tags<CR>", desc="help tags", unpack(opts)}
			}
	},
	{ 'nvim-telescope/telescope-bibtex.nvim'
		, requires = { 'nvim-telescope/telescope.nvim' }
		, config = function ()
			require('telescope').load_extension("bibtex")
		end,
		lazy = true, cmd = "Telescope",
		ft = {'markdown', 'tex'}
	},
	{ 't9md/vim-choosewin'
		, config = function()
			g.choosewin_overlay_enable = 1
		end,
		keys = {{"+", "<Plug>(choosewin)"}}
	}, -- window chooser
	{ 'wesQ3/vim-windowswap'
		, config = function()
			g.windowswap_map_keys = 0
			keymap("n", BINDINGS == "colemak" and "<leader>sc" or "<leader>sy", ":call WindowSwap#MarkWindowSwap()<CR>", opts)
			keymap("n", BINDINGS == "colemak" and "<leader>sv" or "<leader>sp", ":call WindowSwap#DoWindowSwap()<CR>", opts)
			keymap("n", "<leader>se", ":call WindowSwap#EasyWindowSwap()<CR>", opts)
		end
	},
	{
		'jinh0/eyeliner.nvim',
		config = function()
			require'eyeliner'.setup {
				-- show highlights only after keypress
				highlight_on_key = true,

				-- dim all other characters if set to true (recommended!)
				dim = true,	

				-- set the maximum number of characters eyeliner.nvim will check from
				-- your current cursor position; this is useful if you are dealing with
				-- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
				max_length = 9999,

				-- filetypes for which eyeliner should be disabled;
				-- e.g., to disable on help files:
				-- disabled_filetypes = {"help"}
				disabled_filetypes = {},

				-- buftypes for which eyeliner should be disabled
				-- e.g., disabled_buftypes = {"nofile"}
				disabled_buftypes = {},

				-- add eyeliner to f/F/t/T keymaps;
				-- see section on advanced configuration for more information
				default_keymaps = BINDINGS ~= "colemak",
			}
		
		if BINDINGS == "colemak" then
			vim.keymap.set(
				{"n", "x", "o"},
				"f",
				function() 
					require("eyeliner").highlight({ forward = true })
					return "f"
				end,
				{expr = true, remap = false}
			)
			vim.keymap.set(
				{"n", "x", "o"},
				"w",
				function() 
					require("eyeliner").highlight({ forward = true })
					return "t"
				end,
				{expr = true, remap = false}
			)
		end
		end
	},
	{
		'jinh0/eyeliner.nvim',
		opts = { highlight_on_key = true, dim = true, default_keymaps = false },
	},
	{'wfxr/minimap.vim', cmd = {'Minimap', 'MinimapToggle'}, keys = {{"<leader>sm", ":Minimap<CR>", desc = "Code Minimap"}} },
	'kana/vim-metarw', -- fake paths 
	{'majutsushi/tagbar', lazy = true, cmd = {'Tagbar', 'TagbarToggle'}, keys = {{"<leader>st", ":TagbarToggle<CR>", "Tagbar"}} },
	{'mbbill/undotree', lazy = true, cmd = {'UndoTree', 'UndotreeToggle' }, keys = {{"<leader>su", ":UndotreeToggle<CR>", "Undotree"}} },
	{'KabbAmine/vCoolor.vim', lazy = true, cmd = {'VCoolor'}, keys = {"<leader>fc", ":VCoolor<CR>", desc="Color picker"}},
	{'kabbamine/zeavim.vim', lazy = true, keys = { {"<leader>sz", "<Plug>Zeavim"}, '<Plug>Zeavim', '<Plug>ZVVisSelection', '<Plug>ZVOperator', '<Plug>ZVKeyDocset' }, cmd = { 'Zeavim', 'ZeavimV'}},
	{'is0n/jaq-nvim', keys={{"<leader>sq", ":Jaq<CR>", desc="Quickrun"}}, opts = {
		cmds = {
			internal = { lua = "luafile %", vim = "source %" },
			external = { python = "python %", go = "go run %", rust = "cargo run", sh = "sh %" }
		}
	}, lazy = true },
	{'nvim-pack/nvim-spectre', keys = {
		{'<leader>nS', '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre"},
		{'<leader>nw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = "Search current word"},
		{'<leader>nw', '<esc><cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = "Search current word", mode="v"},
		{'<leader>np', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', desc = "Search on current file"},
	} },











	-- {{{ TREESITTER PLUGINS
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		event = "BufEnter",
		config = function()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "css", "html", "haskell", "c_sharp", "markdown", "markdown_inline", "vala", "blueprint" },
				rainbow = {
					enable = true,
					disable = {'bash'} -- please disable bash until I figure #1 out
				},
				autotag = {
					enable = true,
				},
				textsubjects = {
					enable = true,
					prev_selection = ',', -- (Optional) keymap to select the previous selection
					keymaps = {
						['.'] = 'textsubjects-smart',
						[';'] = 'textsubjects-container-outer',
						['i;'] = 'textsubjects-container-inner',
					},
				},
				highlight = {
					enable = true,
				}
			}


			vim.api.nvim_set_hl(0, "@line_comment", { link = "comment" })

		end,
	},
	{ 'HiPhish/rainbow-delimiters.nvim', dependencies = {'nvim-treesitter/nvim-treesitter'} },
	{ 'romgrk/nvim-treesitter-context', dependencies = {'nvim-treesitter/nvim-treesitter'} }, -- first line shows ctx
	{ 'RRethy/nvim-treesitter-textsubjects', dependencies = {'nvim-treesitter/nvim-treesitter'} }, -- context aware selection
	{ 'nvim-treesitter/playground',
		lazy= true,
		cmd = {'TSPlaygroundToggle'},
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		keys = {{"<leader>sp", ":TSPlaygroundToggle<CR>", desc = "TS Playground" }}
	},
	{ 'windwp/nvim-ts-autotag' },
	-- }}} 
	-- {{{ FILE TYPE SPECIFICS
	{ 'cespare/vim-toml',           ft = {'toml'} },
	{ 'elzr/vim-json',              ft = {'json'} },
	{ 'vim-scripts/xml.vim',        ft = {'xml'}  },
	{ 'tpope/vim-markdown',         ft = {'markdown'} },
	{ 'purescript-contrib/purescript-vim', ft = {'purescript'} },
	{ 'vmchale/dhall-vim',          ft = {'dhall'} },
	{ 'ElmCast/elm-vim',            ft = {'elm'} },
	{ 'lervag/vimtex',          ft = {'latex', 'tex'} },
	{ 'donRaphaco/neotex',          ft = {'latex', 'tex'}
		, config = function()
			g.tex_flavor = 'latex' -- neotex
			g.vimtex_quickfix_mode=0
		end
	},
	{ 'edwinb/idris2-vim',          ft = {'idris', 'idr'} },
	{ 'elixir-editors/vim-elixir',  ft = {'elixir'} },
	{ 'DingDean/wgsl.vim',          ft = {'wgsl'} },
	{ 'mpickering/hlint-refactor-vim', ft = {'haskell'} },
	{ 'honza/dockerfile.vim',       ft = {'Dockerfile'} },
	{'neoclide/vim-jsx-improve',    ft = {'javascript', 'jsx', 'javascript.jsx'} },
	{ 'kmonad/kmonad-vim',          ft = {'kbd'} }, -- kmonad config
	{'slint-ui/vim-slint', ft={'slint'}},
	{ 'kaarmu/typst.vim', ft = 'typst'},
	{
		'chomosuke/typst-preview.nvim',
		ft = 'typst',
		version = '1.*',
		build = function() require 'typst-preview'.update() end,
		keys = {
			{"<leader>pt", ":TypstPreview<CR>", desc="Typst Preview"}
		}
	},
	{
		'TobinPalmer/pastify.nvim',
		lazy = true,
		cmd = {'Pastify'},
		opts = {
			ft = {
				html = '<img src="$IMG$" alt="">',
				markdown = '![]($IMG$)',
				tex = [[\includegraphics[width=\linewidth]{$IMG$}]],
				typst = '#figure(image("$IMG$"))'
			}
		},
		keys = {
			{"<leader>vi", ":Pastify<CR>", desc="Paste image"}
		}
	},
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
				["core.norg.dirman"] = { -- Manages Neorg works
					config = {
						works = {
							notes = "~/notes",
						},
					},
				},
			},
		},
		lazy = true,
		ft = "norg",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{ 'mfussenegger/nvim-dap-python', ft = {'python'}, requires = {'mfussenegger/nvim-dap'}},
	{ 'dhruvasagar/vim-table-mode'
		, ft = {'markdown'}
		, config = function()
			g.table_mode_corner='+'
			g.table_mode_corner_corner='+'
			g.table_mode_header_fillchar='='
			g.table_mode_align_char = ':'

			g.table_mode_corner_corner='+'
			g.table_mode_header_fillchar='='
		end,
		lazy = true
	},
	{ 'rafaqz/citation.vim', ft = {'markdown'}, lazy = true },

	{ 'vim-pandoc/vim-pandoc', ft = {'markdown'} },
	{ 'vim-pandoc/vim-pandoc-syntax', ft = {'markdown'} },
	{ 'skywind3000/asyncrun.vim', ft =  {'markdown', 'markdown.pandoc'}, cmd = 'StartMdPreview', config = function()
		keymap("n", "<leader>pm", ":StartMdPreview<CR>", opts)
	end },
	{'conornewton/vim-pandoc-markdown-preview', ft =  {'markdown', 'markdown.pandoc'}, cmd = 'StartMdPreview'},
	{'elkowar/yuck.vim', ft = {"yuck"}},
	{'shiracamus/vim-syntax-x86-objdump-d'},
	-- }}}

	{ 'Bekaboo/deadcolumn.nvim', config = function()
		set.colorcolumn = "72"
		require('deadcolumn').setup({warning = { hlgroup = {'Error', 'foreground'} } })
	end },
}

-- {{{ Helper functions for organizing
plugin_setups.__index = plugin_setups
plugin_setups.insert = function(a)
	table.insert(a, b)
end

function plugin_setups:load()
	require('lazy').setup(self)
end

function plugin_setups:insert(a)
	table.insert(self, a)
end

function plugin_setups:concat(a)
	for k, v in pairs(a) do
		table.insert(self, v)
	end
end
-- }}}

-- FUN PLUGINS
plugin_setups:concat {
	-- {{{ pets 
	{ 'giusgad/pets.nvim'
	, dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" }
	, config = function ()
		require("pets").setup{}
	end
	, keys = {{'<leader>fp', '<cmd>PetsNew yeeeee<cr>', desc = 'new pet :D'},
	}
	, lazy = true
	, cmd = {'PetsNew', 'PetsNewCustom'}
	},
	-- }}}
	-- {{{ LaTeX To unicode 
	{'joom/latex-unicoder.vim'
	, keys = {
		{'<leader>fu', ":call unicoder#start(0)<CR>", desc = "convert LaTeX to unicode"}
	} },
	-- }}}
	-- {{{ some UI 
	{'skywind3000/vim-quickui', keys={{'<leader><leader>', ':call quickui#menu#open()<CR>'}, desc="Quickui"}, lazy = true},
	-- }}}
}








return plugin_setups

