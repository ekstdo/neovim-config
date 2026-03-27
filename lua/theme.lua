require "utils"


set.number = true
vim.cmd.colorscheme "leaf"
g.gruvbox_italic = 1
-- run("hi Normal guibg=NONE ctermbg=NONE")
set.conceallevel = 1
set.colorcolumn = "72"
g.tex_conceal='abdmg'

set.list = true
vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "~", extends =">", precedes = "<"}
set.tabstop = 4
set.shiftwidth = 4

run("hi NvimTreeNormal guibg=#353535")
run("hi WinSeparator guifg=#353535 guibg=#1D2021")
run("hi! link SignColumn LineNr")
run("hi! link FoldColumn LineNr")
run("hi NvimTreeWinSeparator guibg=#353535 guifg=#1D2021")

set.cursorline = true
-- vim.api.nvim_set_hl(0, "CursorLine", {bg = "#000000"})
-- run("hi CursorLine guibg=#000000")
