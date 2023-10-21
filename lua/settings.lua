require "utils"

BINDINGS = "colemak" -- can be qwerty or colemak

set.mouse = "a"
set.clipboard = "unnamedplus"

run("set foldmethod=indent")
set.foldlevelstart=99
run("set foldcolumn=1")
set.hidden = true
set.wrap=false

set.colorcolumn = "72"
set.textwidth = "72"

g.mapleader = ' '
g.maplocalleader = ','

set.timeoutlen = 300
set.hidden = true
set.cmdheight = 2
set.showmode = false
set.shortmess = set.shortmess .. 'c'

set.termguicolors = true
set.smartindent = true

set.conceallevel = 2

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

set.updatetime = 250

g.md_args = "--template /usr/share/pandoc/data/templates/eisvogel.latex --from markdown+grid_tables --listings --filter pandoc-imagine --pdf-engine=xelatex" -- markdown previewer
g.tagbar_type_elixir = {
     ctagstype = 'elixir',
     kinds = {
         'p:protocols',
         'm:modules',
         'e:exceptions',
         'y:types',
         'd:delegates',
         'f:functions',
         'c:callbacks',
         'a:macros',
         't:tests',
         'i:implementations',
         'o:operators',
         'r:records'
     },
     sro = '.',
     kind2scope = {
         p = 'protocol',
         m = 'module'
   },
     scope2kind = {
         protocol = 'p',
         module = 'm'
     },
    sort = 0
 }
run("command! -nargs=1 Draw !cat <args> && ((inkscape <args> &) || true) || (echo \"<svg></svg>\" > <args> && inkscape <args> &)")
function draw()
  local i = 0
  while not fn.filereadable(fn.expand('%:r') .. tostring(i) .. ".svg") do
    i = i + 1
  end
  run("Draw " .. fn.expand('%:r') .. tostring(i) .. ".svg")
end
run("command! Drawing call v:lua.draw()")

g.matchparen_timeout = 20
g.matchparen_insert_timeout = 20

g.CURRENT_CONFIG_FOLDER = string.gsub(os.getenv("MYVIMRC") or "~/.config/nvim/", "/[^/]*$", "/", 1)

g.gruvbox_contrast_dark = "hard"

autocmd(
  {"BufRead", "BufNewFile"},
  {
      pattern = '*.typ',
      callback = function()
          vim.opt_local.ft = "typst"
      end,
      group = numbertogglegroup
  })
