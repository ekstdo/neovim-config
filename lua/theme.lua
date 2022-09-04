require "utils"

run("set cursorline")
run("set cursorcolumn")
g.gruvbox_italic = 1
run("colo gruvbox")
run("set number")
run("hi Normal guibg=NONE ctermbg=NONE")
set.conceallevel = 1
set.colorcolumn = "72"
g.tex_conceal='abdmg'

run("set list")
set.listchars = "tab:▸ ,eol:¬,trail:~,extends:>,precedes:<,space:␣"
set.tabstop = 4
set.shiftwidth = 4

