require "utils"

str=interp([[-:o
o:w
w:t
t:c
tt:cc
ti:ci
ta:ca
c:y
cc:yy
ci:yi
ca:ya
y:i
i:l
l:u
u:k
h:b
b:e
e:j
j:<C-r>
v:p
p:;
;:n
n:h
k:v
_:O
O:W
W:T
T:C 
C:Y
Y:I
I:L
L:U
U:H
H:B
B:E
E:J
J:<C-r>
V:P
P:,
,:N
N:K
K:V,
<C-BS>:X<Esc>lbce
<up>:gk
<down>:gj
<Home>:g0
<End>:g$
sw:<C-w>+
sa:<C-w><
sr:<C-w>-
ss:<C-w>>
<S-Up>:v<Up>
<S-Down>:v<Down>
<S-Left>:v<Left>
<S-Right>:v<Right>
<leader>+:<C-a>
<leader>-:<C-x>
<leader>pa::term pandoc ${pandocParam} "%" -o "%:r.pdf"<CR>
<leader>tc:yy$p
<leader>w-:<C-w>s
<leader>w|:<C-w>v
<leader>wi:<c-w>l
<leader>wu:<c-w>k
<leader>we:<c-w>j
<leader>wn:<c-w>h
<leader>ww:<c-w><Up>
<leader>wa:<c-w><Left>
<leader>ws:<c-w><Right>
<leader>wr:<c-w><Down>
<C-down>:<Plug>newCursor
<space>tts::set tabstop=2 shiftwidth=2 expandtab | retab
<space>tde::v/./d<CR>
<space>tw::set wrap!<CR>
<space>ss::sp<CR><C-w><Down>:term<CR>
<space>sd::Drawing
<space>cm::e ~/.config/nvim/init.lua<CR>
<C-a>:<Esc>ggVG<CR>
<leader>tw::set wrap!<CR>
<leader>sl::set number!<CR>
<leader>ttt::Pantran<CR>]], {pandocParam = g.md_args} )

iExprStr = [[<S-Tab>:pumvisible() ? "\<C-p>" : "\<C-h>"
":getline(".")[col(".")-1] !~ '\w' ? '"<left>"' : '"'
(:getline(".")[col(".")-1] !~ '\w' ? "()<left>" : "("
(<BS>:""
[:getline(".")[col(".")-1] !~ '\w' ? "[]<left>" : "["
[<BS>:""
{:getline(".")[col(".")-1] !~ '\w'? "{}<left>" : "{"
{<BS>:""
```:```<cr><cr>```<up>]]

iStr = [[<C-Bs>:<C-w>
"":""
():()
[]:[]
{}:{}
<C-down>:<Plug>newCursor
<C-a>:<Esc>ggVG<CR>
<C-s>:<Esc>:w<CR>i
<C-l>:<c-g>u<Esc>[s1z=`]a<c-g>u]]

vStr = [[>:>gv
<C-c>:"+y<Esc>i
<:<gv
v:p:let @"=@0<CR>]]





colonIter(function (from, to) vim.api.nvim_set_keymap('', from, to, { noremap = true }) end, str)
colonIter(function (from, to) vim.api.nvim_set_keymap('i', from, to, { noremap = true }) end, iStr)
colonIter(function (from, to) vim.api.nvim_set_keymap('v', from, to, { noremap = true }) end, vStr)


