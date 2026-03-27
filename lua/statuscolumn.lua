-- Code is inspired by:
--
-- https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/
-- https://github.com/luukvbaal/statuscol.nvim/blob/main/lua/statuscol.lua
local ffi = require("ffi")

ffi.cdef([[
	typedef struct {} Error;
	typedef struct {} win_T;
	typedef struct {
		int start;  // line number where deepest fold starts
		int level;  // fold level, when zero other fields are N/A
		int llevel; // lowest level that starts in v:lnum
		int lines;  // number of lines from v:lnum to end of closed fold
	} foldinfo_T;
	foldinfo_T fold_info(win_T* wp, int lnum); // we need fold_info for fold info with a given window id
	win_T *find_window_by_handle(int Window, Error *err);
]])






local statuscolumn = {};

statuscolumn.border = function ()
	-- See how the characters is larger then the rest? That's how we make the border look like a single line
	return "│";
end

statuscolumn.myStatuscolumn = function ()
	local text = table.concat({
		"%s",
		"%l",
		"%@v:lua.Clicker@ ",
		statuscolumn.folds(),
		" "
	})

	return text;
end

Last_pos = {1, 0}

vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
  callback = function() Last_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()) end,
})

Clicker = function(args)
	local mouse_pos = vim.fn.getmousepos()
	local prev_win_id = vim.api.nvim_get_current_win()

	vim.api.nvim_set_current_win(mouse_pos.winid)
	vim.api.nvim_win_set_cursor(mouse_pos.winid, {mouse_pos.line, 0})
	local fold_closed = vim.fn.foldclosed(mouse_pos.line);
	local foldlevel = vim.fn.foldlevel(mouse_pos.line);
	if foldlevel == 0 then
		return
	end
	if fold_closed == mouse_pos.line then
		vim.cmd("foldopen")
	else
		vim.cmd("foldclose")
	end
	vim.api.nvim_set_current_win(prev_win_id)
	vim.api.nvim_win_set_cursor(prev_win_id, Last_pos)
end

local error = ffi.new("Error")
local function get_foldinfo(win_id, line)
	return ffi.C.fold_info(ffi.C.find_window_by_handle(win_id, error), line)
end

local superscript = {"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"}
local boxed_nf = {"󰎡", "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳", "󰎶", "󰎹", "󰎼", "󰽽"}



-- 
-- 1⃞
-- 1⃞
-- │
-- 2⃢
-- │
-- │
-- a⃤


local function to_superscript(num)
	local s = tostring(num)
	local l = {}
	for i = 1, #s do
		local c = tonumber(s:sub(i,i))
		table.insert(l, superscript[c + 1])
	end
	return table.concat(l)
end

statuscolumn.folds = function()
	local win = vim.g.statusline_winid

	local foldinfo = get_foldinfo(win, vim.v.lnum)
	local foldlevel = foldinfo.level
	local foldlevel_before = get_foldinfo(win, (vim.v.lnum - 1) >= 1 and vim.v.lnum - 1 or 1).level;
	local foldlevel_after = get_foldinfo(win, (vim.v.lnum + 1) <= vim.fn.line("$") and (vim.v.lnum + 1) or vim.fn.line("$")).level;


	local fold_closed = foldinfo.lines > 0;
	if foldlevel == 0 then
		return " "
	end


	local foldlevelstr = "+"
	if foldlevel <= 9 then
		foldlevelstr = tostring(foldlevel)
	end
	if fold_closed then

		return "%#AntiDark#" .. foldlevelstr .. "\u{20DE}"
		-- return ""
	end

	if foldlevel > foldlevel_before and foldlevel > foldlevel_after then
		if foldlevel == 1 then
			return "╶"
		end
		if foldlevel > 2 then
			return "╟"
		end
		-- return "🮥"
		return "├"
	end

	if foldlevel > foldlevel_before then
		return foldlevelstr .. "\u{20DE}"
		-- return "%#LSPErrors# 𜸈"
	end

	if foldlevel > foldlevel_after then
		return foldlevelstr .. "\u{20E4}"
		-- return "╰"
	end

	if foldlevel > 1 then
		return "║" -- to_superscript(foldlevel)
	end

	return "╎"
end

-- With this line we will be able to use myStatuscolumn by requiring this file and calling the function
return statuscolumn;
