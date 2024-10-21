require "utils"





BINDINGS = "colemak"

-- some of the keymap settings are inspired by and/or copied from LazyVim

if BINDINGS == "colemak" then
  -- Standard movement

  vim.keymap.set({ "n", "x" }, "e", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  vim.keymap.set("", "E", "L", { desc = "End of screen" })
  vim.keymap.set({ "n", "x" }, "u", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
  vim.keymap.set("", "U", "H", { desc = "Top of screen" })
  vim.keymap.set("", "i", "l", { desc = "Right" })
  vim.keymap.set("", "n", "h", { desc = "Left" })

  -- wordwise movement
  vim.keymap.set("", "h", "b", { desc = "Previous word" })
  vim.keymap.set("", "H", "B", { desc = "Previous WORD" })
  vim.keymap.set("", "o", "w", { desc = "Next word" })
  vim.keymap.set("", "O", "W", { desc = "Next WORD" })

  -- copy, paste, undo
  vim.keymap.set("", "v", "p", { desc = "Paste after" })
  vim.keymap.set("", "V", "P", { desc = "Paste before" })
  vim.keymap.set("", "t", "c", { desc = "Cut (into insert)" })
  vim.keymap.set("", "T", "C", { desc = "Cut until EOL" })
  vim.keymap.set("", "c", "y", { desc = "Copy" })
  vim.keymap.set("", "C", "Y", { desc = "Copy line" })
  vim.keymap.set("", "cc", "yy", { desc = "Copy" })
  vim.keymap.set("", "ci", "yi", { desc = "Copy inside" })
  vim.keymap.set("", "ca", "ya", { desc = "Copy around" })
  vim.keymap.set("", "CC", "YY", { desc = "Copy line" })
  vim.keymap.set("", "tt", "cc", { desc = "Cut" })
  vim.keymap.set("", "ti", "ci", { desc = "Cut inside" })
  vim.keymap.set("", "ta", "ca", { desc = "Cut around" })

  vim.keymap.set("", "l", "u", { desc = "Undo" })
  vim.keymap.set("", "j", "<C-r>", { desc = "Redo" })

  -- insert
  vim.keymap.set("", "y", "i", { desc = "Insert mode" })
  vim.keymap.set("", "Y", "I", { desc = "Insert EOL" })
  vim.keymap.set("", "-", "o", { desc = "Insert new line" })
  vim.keymap.set("", "_", "O", { desc = "Insert new line" })

  -- window stuff

  vim.keymap.set("n", "<C-n>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  vim.keymap.set("n", "<C-e>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  vim.keymap.set("n", "<C-u>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  vim.keymap.set("n", "<C-i>", "<C-w>l", { desc = "Go to Right Window", remap = true })

  vim.keymap.set("t", "<C-n>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  vim.keymap.set("t", "<C-e>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  vim.keymap.set("t", "<C-u>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  vim.keymap.set("t", "<C-i>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

  vim.keymap.set("n", "<A-e>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
  vim.keymap.set("n", "<A-u>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
  vim.keymap.set("i", "<A-e>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  vim.keymap.set("i", "<A-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  vim.keymap.set("v", "<A-e>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
  vim.keymap.set("v", "<A-u>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

  vim.keymap.set("n", "<leader>bn", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<leader>bi", "<cmd>bnext<cr>", { desc = "Next Buffer" })
else
  vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

  vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })


  vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
  vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
  vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
  vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

  vim.keymap.set("n", "<leader>bh", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<leader>bl", "<cmd>bnext<cr>", { desc = "Next Buffer" })
end
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete Buffer and Window" })

vim.keymap.set({ "i", "x" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

vim.keymap.set("n", "<S-Up>", "v<Up>", { desc = "Visual Up" })
vim.keymap.set("n", "<S-Right>", "v<Right>", { desc = "Visual Right" })
vim.keymap.set("n", "<S-Left>", "v<Left>", { desc = "Visual Left" })
vim.keymap.set("n", "<S-Down>", "v<Down>", { desc = "Visual Down" })


vim.keymap.set("", "<leader>tc", "yy$p", { desc = "Duplicate line" })
vim.keymap.set("", "<leader>tde", "<cmd>v/./d<CR>", { desc = "Remove empty lines" })
vim.keymap.set("", "<leader>tts", ":set tabstop=2 shiftwidth=2 expandtab | retab<Home>", { desc = "Tabs to spaces" })
vim.keymap.set("", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Tabs to spaces" })
vim.keymap.set("t", "<tab>", "<tab>", { desc = "just tab pls" })

run = function(e)
  return vim.api.nvim_exec(e, false)
end

function interp(s, tab)
  return (s:gsub("($%b{})", function(w)
    return tab[w:sub(3, -2)] or w
  end))
end

function colonIter(f, x)
  for line in x:gmatch("([^\n]+)\n?") do
    local ind = line:find(":")
    f(line:sub(0, ind - 1), line:sub(ind + 1))
  end
end

colemak_remap = [[-:o
w:t
u:k
b:e
p:;
k:v
_:O
W:T
;:N
,:n
Y:I
I:L
L:U
B:E
E:J
J:<C-r>
P:,
N:K
K:V
]]

str = interp((BINDINGS == "colemak" and colemak_remap .. [[
<leader>wu:<c-w>k
<leader>we:<c-w>j
<leader>wn:<c-w>h
<leader>ww:<c-w><Up>
<leader>wa:<c-w><Left>
<leader>ws:<c-w><Right>
<leader>wr:<c-w><Down>
]] or "") .. [[<C-BS>:X<Esc>lbce
<up>:gk
<down>:gj
<Home>:g0
<End>:g$
sw:<C-w>+
sa:<C-w><
sr:<C-w>-
ss:<C-w>>
<leader>+:<C-a>
<leader>-:<C-x>
<leader>pa::term pandoc ${pandocParam} "%" -o "%:r.pdf"<CR>
<leader>w-:<C-w>s
<leader>w|:<C-w>v
<leader>wi:<c-w>l
<space>ss::sp<CR><C-w><Down>:term<CR>
<space>sd::Drawing
<space>cm::e ~/.config/nvim/init.lua<CR>
<C-a>:<Esc>ggVG<CR>
<leader>tw::set wrap!<CR>
<leader>sl::set number!<CR>
<leader>ttt::Pantran<CR>]], { pandocParam = vim.g.md_args })

vim.keymap.set("i", "<C-Bs>", "<C-w>", { desc = "Window" })
--vim.keymap.set("i", "<C-del>", "<C-right><C-w>", { desc = "Delete word" })
vim.keymap.set("i", "<C-p>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Fix last spelling mistake" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG<CR>", { desc = "Select all" })

colonIter(function(from, to)
  vim.keymap.set("", from, to, { noremap = true })
end, str)





iExprStr = [[<S-Tab>:pumvisible() ? "\<C-p>" : "\<C-h>"]]

iStr = [[<C-down>:<Esc><Plug>newCursor<CR>
<C-s>:<Esc>:w<CR>i]]


vStr = [[>:>gv
<C-c>:"+y<Esc>i
<:<gv
v:p:let @"=@0<CR>]]





-- run("let g:VM_maps = {}")
-- colonIter(function (from, to) run("let g:VM_maps['" .. from .. "'] = '" .. to .. "'") end, colemak_remap)
colonIter(function (from, to) vim.api.nvim_set_keymap('i', from, to, { noremap = true }) end, iStr)
colonIter(function (from, to) vim.api.nvim_set_keymap('v', from, to, { noremap = true }) end, vStr)

