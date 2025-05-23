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
    is_math_mode = vim.api.nvim_eval("typst#in_math()") == 1
    -- local synstack = vim.iter(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.') - (vim.fn.col('.')>=2 and 1 or 0))):map(function(v) return vim.fn.synIDattr(v, 'name') end):totable()
    -- is_math_mode = table.contains(synstack, "typstMarkupDollar")
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
  s(
    { trig = "$$", snippetType="autosnippet", wordTrig=false },
    fmta("$<> $<>", {i(1), i(0)})
  ),

  s(
    { trig = "code", dscr = "codeblock", wordTrig=false },
    fmta("```<>\n<>\n```\n<>", {i(1), i(2), i(0)})
  ),

  s(
    { trig = "sum", snippetType="autosnippet", wordTrig=true },
    fmta("sum_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "inv", wordTrig=true },
    fmta("^(-1)<>", {i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "prod", wordTrig=true },
    fmta("prod_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "tensorprod", wordTrig=true },
    fmta("limits(times.circle.big)_(<>)^(<>)<>", {i(2, "i=0"), i(1,"n"), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "over" },
    fmta("limits(<>)^(<>)<>", {i(1), i(2), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "_%((%d+)%)(%d)", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("_(<><>)", {
      f( function(_, snip) return snip.captures[1] end ),
      f( function(_, snip) return snip.captures[2] end ),
    }),
    { condition = is_math_mode, show_condition = is_math_mode, priority = 2000 }
  ),

  s(
    { trig = "([%a%)%]%}])(%d)", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>_<>", {
      f( function(_, snip) return snip.captures[1] end ),
      f( function(_, snip) return snip.captures[2] end ),
    }),
    { condition = is_math_mode, show_condition = is_math_mode, priority = 1000 }
  ),

  s(
    { trig = "([%a%)%]%}])_(%d%d)", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>_(<>)", {
      f( function(_, snip) return snip.captures[1] end ),
      f( function(_, snip) return snip.captures[2] end ),
    }),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),





  s(
    { trig = "__", snippetType="autosnippet", wordTrig = false },
    fmta("_(<>)<>", {i(1), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "^^", snippetType="autosnippet", wordTrig = false },
    fmta("^(<>)<>", {i(1), i(0)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "([%a]+[%d_]?%d?)bar", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("overline(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "([%a]+[%d_]?%d?)til", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("tilde(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),




  s(
    { trig = "([%a]+[%d_]?%d?)hat", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("hat(<>)", {f( function(_, snip) return snip.captures[1] end )}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "(%b())xb", dscr="underbrace", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("underbrace(<>, <>)", {f( function(_, snip) return string.sub(snip.captures[1], 2, -2) end ), i(1)}),
    { condition = is_math_mode, show_condition = is_math_mode }
  ),

  s(
    { trig = "figure(%b())nofig", dscr="undo figure", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("align(center)[#<> <>]", {f( function(_, snip) return string.sub(snip.captures[1], 2, -2) end ), i(1)})
  ),

  s(
    { trig = "TABLE(%d+)x(%d+)", dscr="generate table", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta([[table(
  columns: <>,
  <>
)]], {
      f(function(_, snip) return snip.captures[2] end ),
      d(1, function(_, snip)
        local rows = tonumber(snip.captures[1])
        local columns = tonumber(snip.captures[2])
        local snip_inner = {}

        local counter = 0
        for _=1,rows  do
          for _=1,columns do
            counter = counter + 1
            table.insert(snip_inner, t"[")
            table.insert(snip_inner, i(counter))
            table.insert(snip_inner, t"], ")
          end
          table.insert(snip_inner, t{"", "  "}) -- inserting a newline
        end

        return sn(nil, snip_inner)
      end)
    })

  ),

  s(
    { trig = "(%b())sympy", dscr="sympy", snippetType="autosnippet", wordTrig=false, regTrig=true },
    fmta("<>", {f( function(_, snip)
        local output = vim.fn.system{'python', '-c', [[print(__import__('sympy').sympify(']] .. string.sub(snip.captures[1], 2, -2) .. [['))]] }
        if output == nil or string.find(output, "Traceback") ~= nil then
          return snip.captures[1]
        end
        output = string.sub(output, 1, -2)
        return output
      end
    ) })
  ),


  s(
    { trig = "cetz-canvas" },
    fmta([[cetz.canvas({
  import cetz.draw: *
  <>
})]], { i(0) })
  ),

  s(
	  { trig = "plot-function"},

	  fmta([[cetz.canvas({
  import cetz.draw: *
  import cetz-plot: *

  plot.plot(size: (5, 4), x-tick-step: 1, y-tick-step: 1, {
    plot.add(domain: (<>, <>), samples: 100, x =>> <>)
  })
}
	  ]], { i(1, "-5"), i(2, "5"), i(3, "calc.sin(x)") })
  )

}
