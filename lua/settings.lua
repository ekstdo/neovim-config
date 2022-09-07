require "utils"

set.mouse = "a"
set.clipboard = "unnamedplus"

run("set foldmethod=indent")
set.foldlevelstart=99
run("set foldcolumn=1")
set.hidden = true
set.wrap=false


g.mapleader = ' '
g.maplocalleader = ','

set.timeoutlen = 300
set.hidden = true
set.cmdheight = 2
set.shortmess = set.shortmess .. 'c'

set.termguicolors = true
set.smartindent = true

set.conceallevel = 2

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

