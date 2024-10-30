local ls = require("luasnip");

local function is_math_mode()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local function is_comment()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

local function is_env(name)
  return function()
    local is_inside = vim.fn['vimtex#syntax#in_inside'](name)
    return (is_inside[0] > 0 and is_inside[1] > 1)
  end
end

return {
  ls.snippet(
    { trig = "^^", snippetType="autosnippet" },
    fmta("^(<>),<>", {i(1), i(0),}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig = "prob", dscr="probability", snippetType="autosnippet" },
    "\\mathbb{P}(${1:\\text{$2}}),$0",
    { condition = is_math_mode, show_condition = is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig = "under", dscr="underset"},
    "\\underset{${1:\\text{$2}}}{${3:=}}$0",
    { condition = is_math_mode, show_condition = is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig = "over", dscr="overset"},
    "\\overset{${1:\\text{$2}}}{${3:=}}$0",
    { condition = is_math_mode, show_condition = is_math_mode }
  ),
  ls.snippet(
    { trig = "$$", snippetType="autosnippet", wordTrig=false },
    fmta("$<> $<>", {i(1), i(0),})
  ),
  ls.snippet(
    { trig = "__", snippetType="autosnippet" },
    fmta("_(<>),<>", {i(1), i(0),}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="fora", dscr="forall", snippetType="autosnippet", wordTrig=false},
    "\\forall",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="exi", dscr="forall", snippetType="autosnippet", wordTrig=false},
    "\\exists",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="ooo", dscr="infinity", snippetType="autosnippet", wordTrig=false},
    "\\infty",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="omg", dscr="infinity", snippetType="autosnippet", wordTrig=false},
    "\\omega",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="ccc", dscr="subset", snippetType="autosnippet", wordTrig=false},
    "\\subset",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="<=", dscr="subset", snippetType="autosnippet", wordTrig=false},
    "\\leq",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig=">=", dscr="subset", snippetType="autosnippet", wordTrig=false},
    "\\geq",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="folge", dscr="Folge", snippetType="autosnippet", wordTrig=false},
    "($1_n),_{n\\geq m}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="reihe", dscr="Reihe", snippetType="autosnippet", wordTrig=false},
    "\\sum_{k = m}^{\\infty} $1_k",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="norm", dscr="Norm", snippetType="autosnippet", wordTrig=false},
    "\\|$1\\|$0",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="<(", dscr="predecessor", snippetType="autosnippet", wordTrig=false},
    "\\prec",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="),>", dscr="successor", snippetType="autosnippet", wordTrig=false},
    "\\succ",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="ddt", dscr="derivative", snippetType="autosnippet", wordTrig=false},
    "\\frac{d}{dt}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="floor", dscr="floor", snippetType="autosnippet", wordTrig=false},
    "\\lfloor $1 \\rfloor $0",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="ceil", dscr="ceil", snippetType="autosnippet", wordTrig=false},
    "\\lceil $1 \\rceil $0",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="ents", dscr="entspricht", snippetType="autosnippet", wordTrig=false},
    "\\widehat{=}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="potm", dscr="potenzmenge", snippetType="autosnippet", wordTrig=false},
    "\\mathfrak{P}($0),",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="umge", dscr="Umgebung", snippetType="autosnippet", wordTrig=false},
    "U_{\\epsilon}($0),",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="umgr", dscr="Umgebung", snippetType="autosnippet", wordTrig=false},
    "U_{\\rho}($0),",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="umgd", dscr="Umgebung", snippetType="autosnippet", wordTrig=false},
    "U_{\\delta}($0),",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="xx", dscr="times", snippetType="autosnippet", wordTrig=false},
    "\\times",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="LR", dscr="Leftrightarrow", snippetType="autosnippet", wordTrig=false},
    "\\Leftrightarrow",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="rarr", dscr="rightarrow", snippetType="autosnippet", wordTrig=false},
    "\\rightarrow",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="Rarr", dscr="Rightarrow", snippetType="autosnippet", wordTrig=false},
    "\\Rightarrow",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="srt", dscr="sqrt", snippetType="autosnippet", wordTrig=false},
    "\\sqrt{$1}$0",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="inv", dscr="inverted", snippetType="autosnippet", wordTrig=false},
    "^{-1}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="**", dscr="times", snippetType="autosnippet", wordTrig=false},
    "\\cdot",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="int", dscr="integral", snippetType="autosnippet", wordTrig=false},
    "\\int_{${1:0}}^{${2:\\infty}}$0 d${3:x}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="cc=", dscr="subset equals", snippetType="autosnippet", wordTrig=false},
    "\\subseteq",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="<=(", dscr="predecessor or equals", snippetType="autosnippet", wordTrig=false},
    "\\preceq",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="),=>", dscr="successor or equals", snippetType="autosnippet", wordTrig=false},
    "\\succeq",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig=">>", dscr="much greater", snippetType="autosnippet", wordTrig=false},
    "\\gg",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="<<", dscr="much less", snippetType="autosnippet", wordTrig=false},
    "\\ll",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="nat", dscr="natural numbers", snippetType="autosnippet", wordTrig=false},
    "\\mathbb{N}_0",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="comp", dscr="complex numbers", snippetType="autosnippet", wordTrig=false},
    "\\mathbb{C}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="zint", dscr="signed integers", snippetType="autosnippet", wordTrig=false},
    "\\mathbb{Z}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="rat", dscr="rational numbers", snippetType="autosnippet", wordTrig=false},
    "\\mathbb{Q}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="real", dscr="real numbers", snippetType="autosnippet", wordTrig=false},
    "\\mathbb{R}",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="'", dscr="rational numbers", snippetType="autosnippet", wordTrig=false},
    "\\textquotesingle",
    { condition=is_math_mode, show_condition=is_math_mode }
  ),
  ls.parser.parse_snippet(
    { trig="kbanach", dscr="K-Banachraum", wordTrig=true},
    "$\\mathbb{K}$-Banachraum"
  ),
  ls.parser.parse_snippet(
    { trig="bbracket", dscr="double brackets", wordTrig=true},
    "\\llbracket $1 \\rrbracket $0"
  ),
  ls.parser.parse_snippet(
    { trig="ce", dscr="chemistry", wordTrig=true},
    "\\ce{$1} $0"
  ),
  ls.parser.parse_snippet(
    { trig="sympy", dscr="sympy block ", wordTrig=true},
    "sympy $1 sympy$0"
  ),
  ls.parser.parse_snippet(
    { trig="col", dscr="mark in color (Latex),", wordTrig=true},
    "\\textcolor{$1}{$0}"
  ),
  ls.parser.parse_snippet(
    { trig="orange", dscr="mark in orange (Latex),", wordTrig=true},
    "\\textcolor{orange}{$0}"
  ),
  ls.parser.parse_snippet(
    { trig="in", dscr="index", wordTrig=true},
    "_{$0}"
  ),
  ls.parser.parse_snippet(
    { trig="un", dscr="underline", wordTrig=true},
    "\\underline{$0}"
  ),
  ls.parser.parse_snippet(
    { trig="körp", dscr="körper", wordTrig=true},
    "(\\mathbb{K}, +, \\cdot, 0_K, 1_K),"
  ),
  ls.parser.parse_snippet(
    { trig="kk", dscr="körper menge", wordTrig=true},
    "\\mathbb{K}"
  ),
  ls.parser.parse_snippet(
    { trig="kkvr", dscr="körper vektorraum", wordTrig=true},
    "$\\mathbb{K}$ Vektorraum"
  ),
  ls.parser.parse_snippet(
    { trig="F", dscr="some numbers", wordTrig=true},
    "\\mathbb{F}_"
  ),
  ls.parser.parse_snippet(
    { trig="fun", dscr="funktion", wordTrig=true},
    "f: \\mathbb{R} \\to \\mathbb{R}, x \\mapsto "
  ),
  ls.parser.parse_snippet(
    { trig="phi", dscr="phi", wordTrig=true},
    "\\varphi"
  ),
  ls.parser.parse_snippet(
    { trig="set", dscr="set", wordTrig=true},
    "\\{$1 | $0 \\}"
  ),
  ls.parser.parse_snippet(
    { trig="til", dscr="tilde", wordTrig=true},
    "\\textasciitilde"
  ),
  ls.parser.parse_snippet(
    { trig="img", dscr="image", wordTrig=true},
    "![$0](./assets/$1),"
  ),
  ls.parser.parse_snippet(
    { trig="vec", dscr="vectors", wordTrig=true},
    "\\left(\\begin{array}{c} $1 \\\\ $2 \\\\ $3 \\end{array}\\right),$0"
  ),
  ls.parser.parse_snippet(
    { trig="taylor", dscr="taylor", wordTrig=true},
    "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a),^$1 $0"
  ),
  ls.snippet(
    { trig = "box", dscr="Box", snippetType="autosnippet" },
    fmta("┌<top_border>┐\n│ <> │\n└<top_border>┘<>", {top_border = f(function(args) return string.rep("─", #args[1][1] +2) end, {1}), i(1), i(0)})
  ),
}

-- snippet reddd "mark in red (Latex)," wA
-- \\textcolor{red}{$0}
-- endsnippet
-- snippet <un "underline" wA
-- \\underline{$0}
-- endsnippet
-- context "math(),"
-- snippet not "not" i
-- \\lnot
-- endsnippet
-- context "math(),"
-- snippet cases "Zweige" iA
-- \\begin{cases}
--     $0
-- \\end{cases}
-- endsnippet
-- priority 10
-- context "math(),"
-- snippet "bar" "bar" riA
-- \\overline{$1}$0
-- endsnippet
-- priority 100
-- context "math(),"
-- snippet "([a-zA-Z]|[a-zA-Z][0-9_]\\d),bar" "bar" riA
-- \\overline{`!p snip.rv=match.group(1),`}
-- endsnippet
-- priority 100
-- context "math(),"
-- snippet "(\\([a-zA-Z\\0-9]+\\),),bar" "bar" riA
-- \\overline{`!p snip.rv=match.group(1),[1:-1]`}
-- endsnippet
-- priority 10
-- context "math(),"
-- snippet "hat" "hat" riA
-- \\hat{$1}$0
-- endsnippet
-- priority 100
-- context "math(),"
-- snippet "([a-zA-Z]|[a-zA-Z][0-9_]\\d),hat" "hat" riA
-- \\hat{`!p snip.rv=match.group(1),`}
-- endsnippet
-- priority 10
-- context "math(),"
-- snippet "til" "tilde" riA
-- \\tilde{$1}$0
-- endsnippet
-- priority 100
-- context "math(),"
-- snippet "([a-zA-Z]|[a-zA-Z][0-9_]\\d),til" "tilde" riA
-- \\tilde{`!p snip.rv=match.group(1),`}
-- endsnippet
-- context "math(),"
-- snippet sq "squared" i
-- ^{${1:2}}$0
-- endsnippet
-- snippet beg "begin{} / end{}" bA
-- \\begin{$1}
--     $0
-- \\end{$1}
-- endsnippet
-- context "math(),"
-- snippet '([A-Za-z]),(\\d),' "auto subscript" wrA
-- `!p snip.rv = match.group(1),`_`!p snip.rv = match.group(2),`
-- endsnippet
-- context "math(),"
-- snippet '([A-Za-z]),_(\\d\\d),' "auto subscript2" wrA
-- `!p snip.rv = match.group(1),`_{`!p snip.rv = match.group(2),`}
-- endsnippet
-- snippet mat "matrices" w
-- \\left(\\begin{matrix} 
-- $1 & $2 & $3 \\\\ 
-- $4 & $5 & $6 \\\\ 
-- $7 & $8 & $9
-- \\end{matrix}\\right),$0
-- endsnippet
-- snippet gto "matrices" w
-- \\begin{array}{|c} 
-- $1 \\\\ 
-- $2 \\\\ 
-- $3
-- \\end{array} \\leadsto \\left(\\begin{matrix}
-- $4 & $5 & $6 \\\\ 
-- $7 & $8 & $9 \\\\ 
-- $10 & $11 & $12
-- \\end{matrix}\\right),$0
-- endsnippet
-- snippet tab "table" w
-- \\begin{array}{ccc} 
-- $1 & $2 & $3 \\\\ 
-- $4 & $5 & $6 \\\\ 
-- $7 & $8 & $9
-- \\end{array}$0
-- endsnippet
-- priority 10000
-- snippet 'sympy(.*),sympy' "evaluate sympy" wr
-- `!p
-- from sympy import *
-- x, y, z, t = symbols('x y z t'),
-- k, m, n = symbols('k m n', integer=True),
-- f, g, h = symbols('f g h', cls=Function),
-- init_printing(),
-- snip.rv = eval('latex(' + match.group(1),.replace('\\', ''), \
--     .replace('^', '**'), \
--     .replace('{', '('), \
--     .replace('}', '),'), + '),'),
-- `
-- endsnippet
-- context "math(),"
-- snippet '((\\d+),|(\\d*),(\\),?([A-Za-z]+),((\\^|_),(\\{\\d+\\}|\\d),),*),/' "Fraction" wrA
-- \\frac{`!p snip.rv = match.group(1),`}{$1}$0
-- endsnippet
-- context "math(),"
-- priority 1000
-- snippet '^.*\\),/' "(), Fraction" wrA
-- `!p
-- stripped = match.string[:-1]
-- depth = 0
-- i = len(stripped), - 1
-- while True:
--     if stripped[i] == '),': depth += 1
--     if stripped[i] == '(': depth -= 1
--     if depth == 0: break;
--     i -= 1
-- snip.rv = stripped[0:i] + "\\frac{" + stripped[i+1:-1] + "}"
-- `{$1}$0
-- endsnippet
-- snippet lim "limits" w 
-- \\lim\\limits_{${2:n} \\to ${1:\\infty}} $0
-- endsnippet
-- snippet stac "stack" w 
-- \\stack{$1}{$0}
-- endsnippet
-- snippet qq "quad space" wA
-- \\quad
-- endsnippet
-- context "math(),"
-- snippet eps "eps" wA
-- \\epsilon
-- endsnippet
-- context "math(),"
-- snippet sum "sum" wA
-- \\sum_{${2:i}}^{${1:n}}$0
-- endsnippet
-- context "math(),"
-- snippet prod "prod" wA
-- \\prod_{${2:i}}^{${1:n}}$0
-- endsnippet
-- snippet pascals "pascals triangle" b
-- $$\\begin{tabular}{rccccccccc}
--   $n=0$:&    &    &    &    &  1\\\noalign{\\smallskip\\smallskip}
--   $n=1$:&    &    &    &  1 &    &  1\\\noalign{\\smallskip\\smallskip}
--   $n=2$:&    &    &  1 &    &  2 &    &  1\\\noalign{\\smallskip\\smallskip}
--   $n=3$:&    &  1 &    &  3 &    &  3 &    &  1\\\noalign{\\smallskip\\smallskip}
--   $n=4$:&  1 &    &  4 &    &  6 &    &  4 &    &  1\\\noalign{\\smallskip\\smallskip}
--   \\end{tabular}$$
-- endsnippet
-- snippet nrt "nth root" iA
-- \\sqrt[${1:n}]{$2}$0
-- endsnippet
-- snippet itrp "interpret" iA 
-- [\\![$2]\\!]^{\\mathcal ${1:I}}$0
-- endsnippet
