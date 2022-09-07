keymap = vim.keymap.set
require "utils"
require "binds"

opts = {noremap = true, silent = true}

return require('packer').startup(function (use)
	keymap("n", "<leader>cr", ":PackerCompile<CR>", opts)
	use 'wbthomason/packer.nvim'


	-- FABULOUS
	use 'morhetz/gruvbox'

	-- utilities while writing

	keymap("n", "<space>tf", ":Limelight!!<CR>", opts)
	use { 'junegunn/limelight.vim'
		, config = function ()
			-- Color name (:help cterm-colors) or ANSI code
			g.limelight_conceal_ctermfg = 'gray'
			g.limelight_conceal_ctermfg = 240
			-- Color name (:help gui-colors) or RGB color
			g.limelight_conceal_guifg = 'DarkGray'
			g.limelight_conceal_guifg = '#777777'

		end
		, opt = true
		, cmd = { "Limelight", "Limelight!", "Limelight!!" }
	}
	use 'junegunn/vim-easy-align'
	use 'mg979/vim-visual-multi'
	use {"ziontee113/color-picker.nvim",
		config = function()
			require("color-picker")

			keymap("n", "<space><C-c>", "<cmd>PickColor<cr>", opts)
		end,
	}
	keymap("n", "<space>tg", ":GrammarousCheck<CR>", opts)
	use {'rhysd/vim-grammarous', opt = true, cmd = {'GrammarousCheck'} }
	use { 'sirver/ultisnips', config = function()
			g.UltiSnipsExpandTrigger = '<tab>'
			g.UltiSnipsJumpForwardTrigger = '<tab>'
			g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
			g.UltiSnipsSnippetDirectories={ CURRENT_CONFIG_FOLDER .. '/ultisnippets/' }
			keymap("n", "<leader>cs", ":UltiSnipsEdit<CR>", opts)
		end
	}
	use { 'folke/todo-comments.nvim'
		, config = function()
			require("todo-comments").setup { }
		end
	}
	use { 'norcalli/nvim-colorizer.lua', config = function() require 'colorizer'.setup() end }
	use 'honza/vim-snippets'
	use 'tpope/vim-commentary'
	use { 'chrisbra/NrrwRgn', cmd = {'NR', 'NW', 'NRP', 'NRM'} }



	-- utilities in general
	use { 'mhinz/vim-startify' , config = function()
			g.startify_bookmarks={ { t = '~/.todo.md' }, { c = '~/.config/nvim/init.lua' } }
		end
	} -- start menu
	use 'lambdalisue/suda.vim'

	keymap("n", "<space>sf", ":NvimTreeToggle<CR>", opts)
	use { 'kyazdani42/nvim-tree.lua'
		, requires = { 'kyazdani42/nvim-web-devicons' }
		, tag = 'nightly'
		, config = function ()
			require("nvim-tree").setup()
		end,
	} -- file tree
	use {'akinsho/bufferline.nvim', tag = "v2.*", requires = { 'kyazdani42/nvim-web-devicons' }
		, config = function ()
			vim.opt.termguicolors = true
			require("bufferline").setup{
				options = {
					numbers = "both",
					number_style = { "subscript" }
				}
			}
		end
	} -- bufferline
	use { 'tweekmonster/startuptime.vim'
		, opt = true
		, cmd = { "StartupTime"}
	} -- timer
	use { 'folke/which-key.nvim'
		, opt=true
		, keys="<space>"
		, config = function ()
			local wk = require("which-key")
			wk.setup({ triggers = { "<leader>" }, triggers_blacklist = { i = {"<leader>"} } })

			wk.register({
				c = {
					name = "+config",
					m = { ':e ~/.config/nvim/init.lua', 'main config' },
					s = "snippets"
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
					t = "tagbar",
					u = "undotree",
					p = "tree sitter"
				},
				t = {
					name = "+text",
					f = "focus!",
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
				["+"] = "increase",
				["-"] = "decrease"
			}, { prefix = "<leader>" })
		end
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { {'nvim-lua/plenary.nvim'} },
		config = function()
			require('telescope').setup()

			keymap("n", "<leader>nf", ":Telescope find_files<CR>", opts)
			keymap("n", "<leader>nb", ":Telescope buffers<CR>", opts)
			keymap("n", "<leader>ns", ":Telescope live_grep<CR>", opts)
			keymap("n", "<leader>nh", ":Telescope help_tags<CR>", opts)
		end
	}
	use { 'nvim-telescope/telescope-bibtex.nvim'
		, requires = { 'nvim-telescope/telescope.nvim' }
		, config = function ()
			require('telescope').load_extension("bibtex")
		end
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim'
		, requires = { 'nvim-telescope/telescope.nvim' }
		, run = 'make'
		, config = function ()
			require('telescope').load_extension("fzf")
		end
	}
	keymap("n", "+" , "<Plug>(choosewin)", {})
	use { 't9md/vim-choosewin'
		, config = function()
			g.choosewin_overlay_enable = 1
		end,
		keys = { "<Plug>(choosewin)"}
	} -- window chooser
	use { 'wesQ3/vim-windowswap'
		, config = function()
			g.windowswap_map_keys = 0
			keymap("n", "<leader>sc", ":call WindowSwap#MarkWindowSwap()<CR>", opts)
			keymap("n", "<leader>sv", ":call WindowSwap#DoWindowSwap()<CR>", opts)
			keymap("n", "<leader>se", ":call WindowSwap#EasyWindowSwap()<CR>", opts)
		end
	}
	use 'tpope/vim-fugitive' -- git integration
	keymap("n", "<leader>sm", ":Minimap<CR>", opts)
	use {'wfxr/minimap.vim', cmd = {'Minimap', 'MinimapToggle'} }
	use 'kana/vim-metarw' -- fake paths 
	keymap("n", "<leader>st", ":TagbarToggle<CR>", opts)
	use {'majutsushi/tagbar', opt = true, cmd = {'Tagbar', 'TagbarToggle'} }
	keymap("n", "<leader>su", ":UndotreeToggle<CR>", opts)
	use {'mbbill/undotree', opt = true, cmd = {'UndoTree', 'UndotreeToggle' } }
	keymap("n", "<leader>fc", ":VCoolor<CR>", opts)
	use {'KabbAmine/vCoolor.vim', cmd = 'VCoolor'}
	keymap("n", "<leader>sz", "<Plug>Zeavim", opts)
	use {'kabbamine/zeavim.vim', keys = {'<Plug>Zeavim', '<Plug>ZVVisSelection', '<Plug>ZVOperator', '<Plug>ZVKeyDocset' }, cmd = { 'Zeavim', 'ZeavimV', 'Zeavim!'}}
	keymap("n", "<leader>sq", ":Quickrun<CR>", opts)
	use {'thinca/vim-quickrun', cmd = 'QuickRun' }

	-- LSP
	use { 'neovim/nvim-lspconfig'
		, config = function()
			keymap('n', '<space>e', vim.diagnostic.open_float, opts)
			keymap('n', '[d', vim.diagnostic.goto_prev, opts)
			keymap('n', ']d', vim.diagnostic.goto_next, opts)
			keymap('n', '<space>q', vim.diagnostic.setloclist, opts)

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
			end

			local lsp_flags = {}
			local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

			local lspconfig = require('lspconfig')
			lspconfig['pyright'].setup{   on_attach = on_attach, flags = lsp_flags, capabilities = capabilities   }
			lspconfig['tsserver'].setup{  on_attach = on_attach, flags = lsp_flags   }
			lspconfig['elixirls'].setup{  cmd = { "elixir-ls" }, on_attach = on_attach   }
			lspconfig['clangd'].setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig['wgsl_analyzer'].setup{    flags = lsp_flags, on_attach = on_attach   }
			lspconfig['texlab'].setup{
				flags = lsp_flags,
				on_attach = on_attach,
				filetypes = { "tex", "plaintex", "bib", "markdown" }
			}

			lspconfig['rust_analyzer'].setup{
				flags = lsp_flags,
				on_attach = on_attach,
			}
			lspconfig['asm_lsp'].setup{
				flags = lsp_flags,
				on_attach = on_attach,
			}
			lspconfig.sumneko_lua.setup {
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

		end
	}
	use {
		"glepnir/lspsaga.nvim",
		branch = "main",
		config = function()
			local saga = require("lspsaga")

			saga.init_lsp_saga({
				-- your configuration
				border_style = "rounded",
			})

			keymap('n', '<leader>la', "<cmd>Lspsaga code_action<CR>", opts)
			keymap('v', "<leader>la", "<cmd>Lspsaga range_code_action<CR>", opts)
			keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
			keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", opts)
			keymap("n", "<space>lr", "<cmd>Lspsaga rename<CR>", opts)
			keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		end,
	}
	use { 'mfussenegger/nvim-jdtls', ft = {'java'}, config = function()
			
		end
	}
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/nvim-cmp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/cmp-cmdline' }
	use { 'f3fora/cmp-spell' }
	use { 'quangnguyen30192/cmp-nvim-ultisnips' }
	use {'tzachar/cmp-tabnine', run='./install.sh', requires = { 'hrsh7th/nvim-cmp', 'onsails/lspkind.nvim' }
		, config = function()

			local lspkind = require('lspkind');
			lspkind.init()
			local cmp = require'cmp'
			local select_opts = {behavior = cmp.SelectBehavior.Select}

			vim.opt.spell = true
			vim.opt.spelllang = { 'en_us', 'de_de' }
			cmp.setup {
				snippet = {
					expand = function(args)
						 vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				mapping = {
					['<S-Tab>'] = cmp.mapping.select_prev_item(select_opts),
					['<Tab>'] = cmp.mapping.select_next_item(select_opts),
					['<CR>'] = cmp.mapping.confirm({ select = true })
				},
				sources = cmp.config.sources({
						{ name = 'path' },
						{ name = 'nvim_lsp', keyword_length = 3 },
						{ name = 'ultisnips' },
						{ name = 'cmp_tabnine' },
				}, {{ name = 'buffer', keyword_length = 3 }, { name = 'spell' }}),
				formatting = {
					format = lspkind.cmp_format({})
				}

			}
		end
	}

	-- use {'neoclide/coc.nvim'; branch = 'release'}
	--
	-- a memorial of the past

	-- LSP related
	use { 'puremourning/vimspector'
		, config = function()
			g.vimspector_enable_mappings = 'HUMAN'
		end
	}
	use 'mfussenegger/nvim-dap'


	-- file types
	use { 'cespare/vim-toml',           ft = {'toml'} }
	use { 'elzr/vim-json',              ft = {'json'} }
	use { 'vim-scripts/xml.vim',        ft = {'xml'}  }
	use { 'tpope/vim-markdown',         ft = {'markdown'} }
	use { 'purescript-contrib/purescript-vim', ft = {'purescript'} }
	use { 'vmchale/dhall-vim',          ft = {'dhall'} }
	use { 'ElmCast/elm-vim',            ft = {'elm'} }
	use { 'lervag/vimtex',          ft = {'latex', 'tex'} }
	use { 'donRaphaco/neotex',          ft = {'latex', 'tex'}
		, config = function()
			g.tex_flavor = 'latex' -- neotex
			g.vimtex_quickfix_mode=0
		end
	}
	use { 'edwinb/idris2-vim',          ft = {'idris', 'idr'} }
	use { 'elixir-editors/vim-elixir',  ft = {'elixir'} }
	use { 'DingDean/wgsl.vim',          ft = {'wgsl'} }
	use { 'mpickering/hlint-refactor-vim', ft = {'haskell'} }
	use { 'honza/dockerfile.vim',       ft = {'Dockerfile'} }
	use {'neoclide/vim-jsx-improve',    ft = {'javascript', 'jsx', 'javascript.jsx'} }
	use { 'kmonad/kmonad-vim',          ft = {'kbd'} } -- kmonad config
	use 'nvim-orgmode/orgmode'

	-- markdown
	g.table_mode_map_prefix = '<space>T'
	g.table_mode_tableize_d_map = '<space>TT'
	g.table_mode_insert_column_after_map = '<space>Tac'
	use { 'dhruvasagar/vim-table-mode'
		, ft = {'markdown'}
		, config = function()
			g.table_mode_corner='+'
			g.table_mode_corner_corner='+'
			g.table_mode_header_fillchar='='
			g.table_mode_align_char = ':'

			g.table_mode_corner_corner='+'
			g.table_mode_header_fillchar='='

		end
	}
	use { 'rafaqz/citation.vim', ft = {'markdown'} }
	g["pandoc#filetypes#pandoc_markdown"] = 0
	use { 'vim-pandoc/vim-pandoc', ft = {'markdown'} }
	use { 'vim-pandoc/vim-pandoc-syntax', ft = {'markdown'} }

	-- treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require 'nvim-treesitter.configs'.setup {
				rainbow = {
					enable = true,
					disable = {'bash'} -- please disable bash until I figure #1 out
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
			}

			keymap("n", "<leader>sp", ":TSPlaygroundToggle<CR>", opts)
		end
	}
	use { 'p00f/nvim-ts-rainbow', requires = {'nvim-treesitter/nvim-treesitter'} }
	use { 'romgrk/nvim-treesitter-context', requires = {'nvim-treesitter/nvim-treesitter'} }
	use { 'RRethy/nvim-treesitter-textsubjects', requires = {'nvim-treesitter/nvim-treesitter'} }
	use { 'nvim-treesitter/playground', opt= true, cmd = {'TSPlaygroundToggle'}, requires = {'nvim-treesitter/nvim-treesitter'} }

	-- fun
	use { 'potamides/pantran.nvim'
		, config = function()
			local pantran = require("pantran")
			keymap("n", "<leader>tr", pantran.motion_translate, opts)
			keymap("n", "<leader>trr", function() return pantran.motion_translate() .. "_" end, opts)
			keymap("x", "<leader>tr", pantran.motion_translate, opts)
		end,
	}
	use { "Pocco81/HighStr.nvim"
		, config = function()
			keymap("v", "<F3>", ":<c-u>HSHighlight 1<CR>", opts)
		end
	}
	run("command! Emojify s/:\\([^:]\\+\\):/\\=emoji#for(submatch(1), submatch(0))/g")
	keymap("n", "<leader>te", ":Emojify<CR>", opts)
	use {'junegunn/vim-emoji', opt = true, cmd = { 'Emojify' }}
	use {'joom/latex-unicoder.vim'}

--[[
  ;
  

  'dense-analysis/ale';

  'glepnir/galaxyline.nvim';
  'nvim-lua/popup.nvim';

  -- filetypes
  {'skywind3000/asyncrun.vim'; ['for'] =  {'markdown', 'markdown.pandoc'}, on = 'StartMdPreview'};
  {'conornewton/vim-pandoc-markdown-preview'; ['for'] =  {'markdown', 'markdown.pandoc'}, on = 'StartMdPreview'};
  'skywind3000/vim-quickui';

  ;
--]]
end)
