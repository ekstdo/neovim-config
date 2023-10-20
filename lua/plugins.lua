keymap = vim.keymap.set
require "utils"
require "binds"

opts = {noremap = true, silent = true}



g.table_mode_map_prefix = '<space>T'
g.table_mode_tableize_d_map = '<space>TT'
g.table_mode_insert_column_after_map = '<space>Tac'

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
	--  }}}


	-- {{{ FABULOUS
	'morhetz/gruvbox', -- colorscheme
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
				keymap('n', '<space>jD', vim.lsp.buf.declaration, bufopts)
				keymap('n', '<space>jd', vim.lsp.buf.definition, bufopts)
				keymap('n', '<space>ji', vim.lsp.buf.implementation, bufopts)
				keymap('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
				keymap('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
				keymap('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
				keymap('n', '<space>lwl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
				keymap('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
				keymap('n', '<space>jr', vim.lsp.buf.references, bufopts)
				keymap('n', '<space>lf', vim.lsp.buf.formatting, bufopts)

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
			lspconfig.pylsp.setup{   on_attach = on_attach, flags = lsp_flags  }
			lspconfig.tsserver.setup{  on_attach = on_attach, flags = lsp_flags   }
			lspconfig.elixirls.setup{  cmd = { "elixir-ls" }, on_attach = on_attach   }
			lspconfig.clangd.setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig.wgsl_analyzer.setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig.texlab.setup{
				flags = lsp_flags,
				on_attach = on_attach,
				filetypes = { "tex", "plaintex", "bib", "markdown" }
			}

			lspconfig.rust_analyzer.setup{
				flags = lsp_flags,
				on_attach = on_attach,
				settings = {
					['rust-analyzer'] = {
						diagnostics = {
							disable = { "unresolved-proc-macro" }
						}
					}
				}
			}
			lspconfig.golangci_lint_ls.setup{}
			lspconfig.hls.setup{ flags = lsp_flags, on_attach = on_attach }
			lspconfig.asm_lsp.setup{ flags = lsp_flags, on_attach = on_attach }
			lspconfig.svelte.setup{}
			lspconfig.typst_lsp.setup{}
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
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			}
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.emmet_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				}
			})


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
					cwd = '${workspaceFolder}',
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
					cwd = '${workspaceFolder}',
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
			{ "<space>db", function() require"dap".toggle_breakpoint() end, unpack(opts) },
			{ "<space>dB", function() require"dap".set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, unpack(opts) },
			{ "<space>dc", function() require"dap".continue() end, unpack(opts) },
			{ "<space>ds", function() require"dap".step_over() end, unpack(opts) },
			{ "<space>di", function() require"dap".step_into() end, unpack(opts) },
			{ "<space>dr", function() require"dap".repl.open() end, unpack(opts) },
		},
		lazy = true

	},

	{ 'theHamsta/nvim-dap-virtual-text', requires = {'mfussenegger/nvim-dap'}},
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

		keymap("n", "<space>sx", function() dapui.open() end, opts)

		keymap("n", BINDINGS == "colemak" and"<M-n>" or "<M-k>", "<Cmd>lua require(\"dapui\").eval()<CR>", opts)
	end},

	'jose-elias-alvarez/null-ls.nvim', -- linter and formatter
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
			ui = { title = false,
				colors = {
					title_bg = '#504945',
					normal_bg = '#504945',
				}
			},
			symbol_in_winbar = {
				enable = false,
				color_mode = false,
			}
		},
		dependencies = { {'nvim-tree/nvim-web-devicons'} },
		keys = {
			{ '<leader>la', "<cmd>Lspsaga code_action<CR>", mode = {'n', 'v'}, desc = "Code Action", unpack(opts) },
			{'gh', "<cmd>Lspsaga lsp_finder<CR>", unpack(opts) },
			{"gd", "<cmd>Lspsaga peek_definition<CR>", unpack(opts)},
			{BINDINGS == "colemak" and "N" or "K", "<cmd>Lspsaga hover_doc<CR>"},
			{"<space>lr", "<cmd>Lspsaga rename<CR>", desc="Rename var", unpack(opts)},
			{"<space>lp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc="previous diagnostic", unpack(opts)},
			{"<space>ln", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc="next diagnostic", unpack(opts)},
			{"<space>lb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc="buffer diagnostics", unpack(opts)},
			{"<space>lo", "<cmd>Lspsaga outline<CR>", desc="Outline", unpack(opts)}
		}
	},
	{ 'mfussenegger/nvim-jdtls', ft = {'java'}, config = function()
		end
	},
	{ 'hrsh7th/cmp-nvim-lsp', lazy = true },
	{ 'hrsh7th/nvim-cmp', lazy = true, event = "InsertEnter" },
	{ 'hrsh7th/cmp-buffer', lazy = true, event = "InsertEnter" },
	{ 'hrsh7th/cmp-path', lazy = true, event = "InsertEnter" },
	{ 'hrsh7th/cmp-cmdline', lazy = true, event = "InsertEnter" },
	{ 'f3fora/cmp-spell', lazy = true, event = "InsertEnter" },
	{ 'sirver/ultisnips',
			requires = { {'nvim-lua/plenary.nvim'} }, --because of plenary path
			keys = {"<leader>cs", ":UltiSnipsEdit<CR>", desc="snippets", unpack(opts)},
			lazy = false,
			config = function()
			g.UltiSnipsExpandTrigger = '<tab>'
			g.UltiSnipsJumpForwardTrigger = '<tab>'
			g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
			g.UltiSnipsSnippetDirectories={ g.CURRENT_CONFIG_FOLDER .. 'ultisnippets' }
		end
	},
	{ 'quangnguyen30192/cmp-nvim-ultisnips', lazy = true, event = "InsertEnter" },
	{ 'hrsh7th/cmp-nvim-lsp-signature-help', lazy = true, event = "InsertEnter" },
	{ 'simrat39/rust-tools.nvim', lazy = true, ft = {"rust"},
			after = "nvim-lspconfig", config =  function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						local bufopts = { noremap=true, silent=true, buffer=bufnr }
						-- Hover actions
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, bufopts)
						-- Code action groups
						vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, bufopts)
					end,
				},
			})
		end
	},
	{'tzachar/cmp-tabnine', build='./install.sh', dependencies = { 'hrsh7th/nvim-cmp', 'onsails/lspkind.nvim' }
		, config = function()

			local lspkind = require('lspkind');
			lspkind.init()
			local cmp = require'cmp'
			local select_opts = {behavior = cmp.SelectBehavior.Select}
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')

			vim.opt.spell = true
			vim.opt.spelllang = { 'en_us', 'de_de' }
			cmp.setup {
				completion = {
				},
				snippet = {
					expand = function(args)
						 vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				mapping = {
					['<S-Tab>'] = cmp.mapping.select_prev_item(select_opts),
					['<Tab>'] = cmp.mapping.select_next_item(select_opts),
					['<CR>'] = cmp.mapping.confirm({ select = false }),
					-- ['<esc>'] = cmp.mapping.abort()
				},
				sources = cmp.config.sources({
						{ name = 'nvim_lsp_signature_help' },
						-- { name = "codeium" },
						{ name = 'path' },
						{ name = 'nvim_lsp', keyword_length = 2 },
						{ name = 'ultisnips' },
						{ name = 'cmp_tabnine' },
				}, {{ name = 'buffer', keyword_length = 3 }, { name = 'spell' }}),
				formatting = {
					format = lspkind.cmp_format({})
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
	, lazy = true, event = "InsertEnter"},

	-- }}}
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},

	-- {{{ utilities while writing
	{ 'junegunn/limelight.vim'
		, keys = {{"<space>tf", "<cmd>Limelight!!<CR>", desc="focus mode"}, unpack(opts) }, lazy = true, cmd = { "Limelight" }
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
		setup = true, lazy = true, keys = {{"<space>s", ":PickColor<cr>", desc = "Color Picker"}}
	},
	{'rhysd/vim-grammarous', lazy = true,
		keys = {{"<space>tg", "<cmd>GrammarousCheck<CR>", desc = "Grammar checker", unpack(opts)}}, cmd = {'GrammarousCheck'} },
	{ 'folke/todo-comments.nvim', setup = true },
	{ 'norcalli/nvim-colorizer.lua', setup = true },
	'honza/vim-snippets',
	'tpope/vim-commentary',
	{ 'chrisbra/NrrwRgn', cmd = {'NR', 'NW', 'NRP', 'NRM'} },
	'lambdalisue/suda.vim',
	-- }}}

	-- {{{ UI Utilities
	{ 'tweekmonster/startuptime.vim', lazy = true, cmd = { "StartupTime"}}, -- timer
	{ 'mhinz/vim-startify' , config = function()
			g.startify_bookmarks={ { t = '~/.todo.md' }, { c = '~/.config/nvim/init.lua' }, { k = '~/.config/kitty/kitty.conf' }, { z = '~/.zshrc' } }
		end
	}, -- start menu
	{ 'nvim-tree/nvim-tree.lua'
		, dependencies = { 'nvim-tree/nvim-web-devicons' }
		, tag = 'nightly'
		, config = function ()
			require("nvim-tree").setup()
		end,
		lazy = true,
		cmd = {"NvimTreeOpen", "NvimTreeToggle"},
		keys = {{"<space>sf", "<cmd>NvimTreeToggle<CR>", desc="file tree", unpack(opts)}}

	}, -- file tree
	{'akinsho/bufferline.nvim', tag = "v3.*", dependencies = { 'nvim-tree/nvim-web-devicons' }
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
		, lazy=true
		, keys="<space>"
		, config = function ()
			local wk = require("which-key")
			wk.setup({ triggers = { "<leader>" }, triggers_blacklist = { i = {"<leader>"} } })

			wk.register({
				c = {
					name = "+config",
					m = 'main config',
				},
				f = {
					name = "+funky",
					c = "color chooser"
				},
				j = {
					name = "+jump",
					d = "definition",
					D = "declaration",
					i = "implementation",
					r = "references"
				},
				l = {
					name = "+lsp",
					f = "formatting",
				},
				n = {
					name = "+navigation",
					f = "files",
					b = "buffers",
					t = "tabs",
					s = "string",
					h = "help tags"
				},
				s = {
					name = "+show",
					f = "file tree",
					c = "copy window",
					v = "paste/swap window",
					e = "ez swap window",
					s = "shell",
					x = "debugger ui",
					p = "tree sitter",
					d = "drawing"
				},
				t = {
					name = "+text",
					c = "duplicate line",
					g = "grammar check",
					r = "motion translate",
					d = {
						name = "+delete",
						e = "empty lines"
					},
					e = "emojify",
					t = {
						name = "tabs",
						s = "to space"
					},
					w = "word wrap"
				},
				T = {
					name = "+table",
					m = "toggle",
					r = "realign",
					t = "tableize csv",
					T = "tableize delim",
					f = { name = '+formulas', a = 'add formula', e = 'eval form'},
					d = { name = '+delete', d = 'delete row', c = 'delete column'},
					a = { name = '+append', c = 'append column'},
					i = { name = '+insert', c = 'insert column'},
				},
				w = {
					name = "+window",
					w = "default index",
					t = "default in new tab",
					s = "select index",
					r = "rename current",
					["-"] = "split",
					["|"] = "vertsplit"
				},
				d = {
					name = "+debugger",
					s = "step over",
					i = "step into",
					c = "continue",
					b = "breakpoint"
				},
				["+"] = "increase",
				["-"] = "decrease"
			}, { prefix = "<leader>" })
		end
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.4',
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
	{'wfxr/minimap.vim', cmd = {'Minimap', 'MinimapToggle'}, keys = {{"<leader>sm", ":Minimap<CR>", desc = "Code Minimap"}} },
	'kana/vim-metarw', -- fake paths 
	{'majutsushi/tagbar', lazy = true, cmd = {'Tagbar', 'TagbarToggle'}, keys = {{"<leader>st", ":TagbarToggle<CR>", "Tagbar"}} },
	{'mbbill/undotree', lazy = true, cmd = {'UndoTree', 'UndotreeToggle' }, keys = {{"<leader>su", ":UndotreeToggle<CR>", "Undotree"}} },
	{'KabbAmine/vCoolor.vim', lazy = true, cmd = 'VCoolor', keys = {"<leader>fc", ":VCoolor<CR>", desc="Color picker"}},
	{'kabbamine/zeavim.vim', lazy = true, keys = { {"<leader>sz", "<Plug>Zeavim"}, '<Plug>Zeavim', '<Plug>ZVVisSelection', '<Plug>ZVOperator', '<Plug>ZVKeyDocset' }, cmd = { 'Zeavim', 'ZeavimV'}},
	{'is0n/jaq-nvim', keys={{"<leader>sq", ":Jaq<CR>", desc="Quickrun"}}, opts = {
		cmds = {
			internal = { lua = "luafile %", vim = "source %" },
			external = { python = "python %", go = "go run %", rust = "cargo run", sh = "sh %" }
		}
	}, lazy = true },

	-- {{{ TREESITTER PLUGINS
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require 'nvim-treesitter.configs'.setup {
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
		end,
	},
	{ 'p00f/nvim-ts-rainbow', dependencies = {'nvim-treesitter/nvim-treesitter'} },
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
	{ 'kaarmu/typst.vim', ft = 'typst'},
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
				["core.norg.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
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
	-- }}}

	{ 'Bekaboo/deadcolumn.nvim', config = function()
		set.colorcolumn = "72"
		require('deadcolumn').setup({warning = { hlgroup = {'Error', 'foreground'} } })
	end },

	-- {
	-- 	"jcdickinson/codeium.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"hrsh7th/nvim-cmp",
	-- 	},
	-- 	config = function()
	-- 		require("codeium").setup({
	-- 		})
	-- 	end
	-- }
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
	, keys = {{'<space>fp', '<cmd>PetsNew yeeeee<cr>', desc = 'new pet :D'},
	}
	, lazy = true
	, cmd = {'PetsNew', 'PetsNewCustom'}
	}
, -- }}}
	-- {{{ LaTeX To unicode 
	{'joom/latex-unicoder.vim'
	, keys = {
		{'<space>fu', ":call unicoder#start(0)<CR>", desc = "convert LaTeX to unicode"}
	} },
	-- }}}
	-- {{{ some UI 
	{'skywind3000/vim-quickui', keys={{'<space><space>', ':call quickui#menu#open()<CR>'}, desc="Quickui"}, lazy = true},
	-- }}}
}








return plugin_setups

