require "utils"

run("set cursorline")
run("set cursorcolumn")
vim.cmd.colorscheme "leaf"
g.gruvbox_italic = 1
run("set number")
-- run("hi Normal guibg=NONE ctermbg=NONE")
set.conceallevel = 1
set.colorcolumn = "72"
g.tex_conceal='abdmg'

run("set list")
set.listchars = "tab:▸ ,eol:¬,trail:~,extends:>,precedes:<,space:␣"
set.tabstop = 4
set.shiftwidth = 4

run("hi NvimTreeNormal guibg=#353535")
run("hi WinSeparator guifg=#353535 guibg=#1D2021")
run("hi! link SignColumn LineNr")
run("hi! link FoldColumn LineNr")
run("hi NvimTreeWinSeparator guibg=#353535 guifg=#1D2021")
