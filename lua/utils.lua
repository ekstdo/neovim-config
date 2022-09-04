set = vim.o
g = vim.g
run = function (e) return vim.api.nvim_exec(e, false) end
api = vim.api
fun = vim.fun
fn = vim.fn
keymap = vim.keymap.set


function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

function colonIter(f, x)
    for line in x:gmatch("([^\n]+)\n?") do
        local ind = line:find(":")
        f(line:sub(0, ind-1), line:sub(ind+1))
    end
end

function split(str, delim)
	if sep == nil then
		sep = '%s' -- sets whitespace as default delimiter
	end

	local result = {}

	for match in string.gmatch(str, "[^" .. delim .. "]+") do
		table.insert(result, match)
	end

	return match
end

