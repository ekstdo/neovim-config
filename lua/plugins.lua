keymap = vim.keymap.set
require "utils"
require "binds"

opts = {noremap = true, silent = true}

return require('packer').startup(function (use)
	use 'wbthomason/packer.nvim'


	-- FABULOUS
	use 'morhetz/gruvbox'

	-- utilities while writing

	use { 'junegunn/limelight.vim'
		, config = function ()
			-- Color name (:help cterm-colors) or ANSI code
			g.limelight_conceal_ctermfg = 'gray'
			g.limelight_conceal_ctermfg = 240
			-- Color name (:help gui-colors) or RGB color
			g.limelight_conceal_guifg = 'DarkGray'
			g.limelight_conceal_guifg = '#777777'

			keymap("n", "<space>tf", ":Limelight!!<CR>", opts)
		end
	}



	-- utilities in general
	use 'mhinz/vim-startify' -- start menu
	use { 'kyazdani42/nvim-tree.lua'
		, requires = { 'kyazdani42/nvim-web-devicons' }
		, tag = 'nightly'
		, config = function ()
			require("nvim-tree").setup()
			keymap("n", "<space>sf", ":NvimTreeToggle<CR>", opts)
		end
	} -- file tree
	use {'akinsho/bufferline.nvim', tag = "v2.*", requires = { 'kyazdani42/nvim-web-devicons' }
		, config = function ()
			vim.opt.termguicolors = true
			require("bufferline").setup{}
		end
	} -- bufferline
	use { 'tweekmonster/startuptime.vim'
		, opt = true
		, cmd = { "StartupTime"}
	} -- timer
	use { 'folke/which-key.nvim'
		, config = function ()
			local wk = require("which-key")
			wk.setup({ triggers = { "<leader>" } })

			wk.register({
				s = {
					name = "+show",
					f = "file tree",
					c = "copy window",
					v = "paste/swap window",
					e = "ez swap window"
				},
				t = {
					name = "+text",
					f = "focus!",
					c = "duplicate line",
				}
			}, { prefix = "<leader>" })
		end
	}
	use { 't9md/vim-choosewin'
		, config = function()
			keymap("n", "+" , "<Plug>(choosewin)", {})
		end
	} -- window chooser
	use { 'wesQ3/vim-windowswap'
		, config = function()
			g.windowswap_map_keys = 0
			keymap("n", "<leader>sc", ":call WindowSwap#MarkWindowSwap()<CR>", opts)
			keymap("n", "<leader>sv", ":call WindowSwap#DoWindowSwap()<CR>", opts)
			keymap("n", "<leader>se", ":call WindowSwap#EasyWindowSwap()<CR>", opts)
		end
	}

	-- LSP
	use {
		"glepnir/lspsaga.nvim",
		branch = "main",
		config = function()
			local saga = require("lspsaga")

			saga.init_lsp_saga({
				-- your configuration
				border_style = "rounded",
			})

			keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
		end,
	}


	-- file types
	use { 'cespare/vim-toml',           ft = {'toml'} }
	use { 'elzr/vim-json',              ft = {'json'} }
	use { 'vim-scripts/xml.vim',        ft = {'xml'}  }
	use { 'tpope/vim-markdown',         ft = {'markdown'} }
	use { 'purescript-contrib/purescript-vim', ft = {'purescript'} }
	use { 'vmchale/dhall-vim',          ft = {'dhall'} }
	use { 'ElmCast/elm-vim',            ft = {'elm'} }
	use { 'donRaphaco/neotex',          ft = {'latex'} }
	use { 'edwinb/idris2-vim',          ft = {'idris', 'idr'} }
	use { 'elixir-editors/vim-elixir',  ft = {'elixir'} }
	use { 'DingDean/wgsl.vim',          ft = {'wgsl'} }


	-- fun
	use { 'potamides/pantran.nvim'
		, config = function()
			pantran = require("pantran")
			keymap("n", "<leader>tr", pantran.motion_translate, opts)
			keymap("n", "<leader>trr", function() return pantran.motion_translate() .. "_" end, opts)
			keymap("x", "<leader>tr", pantran.motion_translate, opts)
		end,
	}
-- 'dhruvasagar/vim-table-mode'; ['for'
-- 'vim-pandoc/vim-pandoc'; ["for"] = {
-- 'vim-pandoc/vim-pandoc-syntax'; ["fo
-- 'mpickering/hlint-refactor-vim'; ['f
-- 'honza/dockerfile.vim'; ['for'] = {'
-- 'neoclide/vim-jsx-improve', ['for'] 
-- 'skywind3000/asyncrun.vim'; ['for'] 
-- 'conornewton/vim-pandoc-markdown-pre
-- 'lervag/vimtex'; ['for'] = { 'tex', 
-- ';
-- skywind3000/vim-quickui';
-- nvim-telescope/telescope-bibtex.nvim
-- nvim-orgmode/orgmode';
-- ziontee113/color-picker.nvim';
-- kmonad/kmonad-vim'; -- Kmonad config

end)
