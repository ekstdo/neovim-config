local function is_math_mode() 
  local buf = vim.api.nvim_get_current_buf()
  local highlighter = require "vim.treesitter.highlighter"
  local is_math_mode = false
  if highlighter.active[buf] then
   -- treesitter highlighting is enabled
    local inspect_out = vim.inspect_pos()
    local obj = inspect_out["treesitter"]
    if #obj == 0 then
      obj = inspect_out["semantic_tokens"]
      for i = 1, #obj do
        local str = obj[i]["opts"]["hl_group"]
        if string.find(str, "math") then
          is_math_mode = true
          break
        end
      end
    else 
      for i = #obj, 1, -1 do
        if obj[i]["capture"] == "string" or obj[i]["capture"] == "spell" then
          break
        end

        if obj[i]["capture"] == "markup.math" then
          is_math_mode = true
          break
        end
      end
    end

  else 
   -- treesitter highlighting is disabled
   -- using synstack instead
    local synstack = vim.iter(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.') - (vim.fn.col('.')>=2 and 1 or 0))):map(function(v) return vim.fn.synIDattr(v, 'name') end):totable()
    is_math_mode = table.contains(synstack, "typstMarkupDollar")
  end
  return is_math_mode
end

function concatlines(a, b)
  local new_table = {unpack(a)}
  new_table[#new_table] = new_table[#new_table] .. b[1]
  if #b > 1 then
    for i = 2, #b do
      new_table[#a + i - 1] = b[i]
    end
  end
  return new_table
end

local ls = require("luasnip");

return {
  ls.snippet(
    { trig = "$$", snippetType="autosnippet", wordTrig=false },
    fmta("$<> $<>", {i(1), i(0)})
  ),

  ls.snippet(
    { trig = "code", dscr = "codeblock", wordTrig=false },
    fmta("```<>\n<>\n```\n<>", {i(1), i(2), i(0)})
  ),

  ls.snippet(
    { trig = "sum", snippetType="autosnippet", wordTrig=true },
    fmta("sum_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "prod", wordTrig=true },
    fmta("prod_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "tensorprod", wordTrig=true },
    fmta("limits(times.circle.big)_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "over" },
    fmta("limits(<>)^(<>)<>", {i(1), i(2), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "([%a%)%]%}])(%d)", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>_<>", {
      f( function(_, snip) return snip.captures[1] end ),
      f( function(_, snip) return snip.captures[2] end ),
    }),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "([%a%)%]%}])_(%d%d)", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>_(<>)", {
      f( function(_, snip) return snip.captures[1] end ),
      f( function(_, snip) return snip.captures[2] end ),
    }),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "__", snippetType="autosnippet", wordTrig = false },
    fmta("_(<>)<>", {i(1), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "^^", snippetType="autosnippet", wordTrig = false },
    fmta("^(<>)<>", {i(1), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "([%a][%d_]?%d?)bar", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("overline(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "([%a][%d_]?%d?)til", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("tilde(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),


  ls.snippet(
    { trig = "([%a][%d_]?%d?)hat", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("hat(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "(%b())xb", dscr="underbrace", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("underbrace(<>, <>)", {f( function(_, snip) return string.sub(snip.captures[1], 2, -2) end ), i(1)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  ls.snippet(
    { trig = "figure(%b())nofig", dscr="undo figure", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("align(center)[#<> <>]", {f( function(_, snip) return string.sub(snip.captures[1], 2, -2) end ), i(1)})
  ),



  ls.snippet(
    { trig = "(%b())sympy", dscr="sympy", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>", {f( function(_, snip)
        local output = vim.fn.system{'python', '-c', [[print(__import__('sympy').sympify(']] .. string.sub(snip.captures[1], 2, -2) .. [['))]] }
        output = string.sub(output, 1, -2)
        return output
      end
    ) })
  ),

}
