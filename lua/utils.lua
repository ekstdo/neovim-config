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

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

packer_bootstrap = ensure_packer()


CURRENT_CONFIG_FOLDER = ""

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function parseRGB(RGB)
	local num = tonumber(string.sub(RGB, 2), 16)
	local B = num % 0x100
	num = math.floor(num / 0x100)
	local G = num % 0x100 
	num = math.floor(num / 0x100)
	local R = num 
	return R, G, B
end

function normalizeRGB(R, G, B)
	return R/255, G/255, B/255 
end

function rgb2hsv(r, g, b)
	local cmax = math.max(r, g, b)
	local cmin = math.min(r, g, b)
	local delta = cmax - cmin
	local H =  delta == 0 and 0 or  cmax == r and ((g - b)/delta) % 6 or  cmax == g and (b - r)/delta + 2 or (r - g) / delta + 4
	local S =  cmax == 0 and 0 or delta / cmax
	local V = cmax

	return H, S, V -- H in [0,6[, S in [0,1] and V in [0,1]
end

function hsv2rgb(h, s, v)
	local c = s * v
	local x = c * (1 - math.abs(h % 2 - 1))
	local m = v - c
	local r = 0 
	local g = 0
	local b = 0
	if h < 1 then
		r, g, b = c, x, 0
	elseif h < 2 then
		r, g, b = x, c, 0
	elseif h < 3 then
		r, g, b = 0, c, x
	elseif h < 4 then
		r, g, b = 0, x, c
	elseif h < 5 then
		r, g, b = x, 0 ,c
	else
		r, g, b = c, 0, x
	end
	return (r + m) * 255, (g + m) * 255, (b + m) * 255
end

function rgb2str(r, g, b)
	return "#" .. string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
end


function mapHSV(RGB, mapper)
	return rgb2str(hsv2rgb(mapper(rgb2hsv(normalizeRGB(parseRGB(RGB))))))
end
