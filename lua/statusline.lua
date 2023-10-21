require "utils"

local api = vim.api

local M = {}

local active_sep = 'slanted' 

M.separators = {
	arrow = { '', '' },
	rounded = { '', '' },
	slanted = {'🭋', '🭛'},
	blank = { '', '' },
}

-- highlight groups
M.colors = {
	active        = '%#StatusLine#',
	inactive      = '%#StatuslineNC#',
	mode          = '%#Mode#',
	mode_alt      = '%#ModeAlt#',
	git           = '%#Git#',
	git_alt       = '%#GitAlt#',
	filetype      = '%#Filetype#',
	filetype_alt  = '%#FiletypeAlt#',
	line_col      = '%#LineCol#',
	line_col_alt  = '%#LineColAlt#',
	lsp_errors    = '%#LSPErrors#',
	lsp_warnings  = '%#LSPWarnings#',
	lsp_info      = '%#LSPInfo#',
	lsp_hints     = '%#LSPHints#',
	bg_alt        = '%#BGAlt#'
}

M.trunc_width = setmetatable({
	mode       = 80,
	git_status = 90,
	filename   = 140,
	line_col   = 60,
}, {
	__index = function()
		return 80
	end
})

M.is_truncated = function(_, width)
	local current_width = api.nvim_win_get_width(0)
	return current_width < width
end


M.modes = setmetatable({
	['n']  = {'Normal ', 'N', 1};
	['nt']  = {'Normal ', 'N', 1};
	['no'] = {'N·Pending', 'N·P', 2} ;
	['v']  = {'Visual', 'V', 3};
	['V']  = {'V·Line', 'V·L', 4};
	[''] = {'V·Block', 'V·B', 5}; -- this is not ^V, but it's , they're different
	['s']  = {'Select', 'S', 6};
	['S']  = {'S·Line', 'S·L', 7};
	[''] = {'S·Block', 'S·B', 8}; -- same with this one, it's not ^S but it's 
	['i']  = {'Insert ', 'I', 9};
	['ic'] = {'Insert', 'I', 10};
	['R']  = {'Replace ⇆', 'R', 11};
	['Rv'] = {'V·Replace', 'V·R', 12};
	['c']  = {'Command ', 'C', 13};
	['cv'] = {'Vim·Ex ', 'V·E', 14};
	['ce'] = {'Ex ', 'E', 15};
	['r']  = {'Prompt ', 'P', 16};
	['rm'] = {'More ', 'M', 17};
	['r?'] = {'Confirm ', 'C', 18};
	['!']  = {'Shell $', 'T', 19};
	['t']  = {'Terminal ', 'T', 20};
}, {
	__index = function()
		return {'Unknown', 'U'} -- handle edge cases
	end
})

local fg_col1_start = '#80c566'
Fg_col1 = '#80c566'
local fg_col2_start = '#73b05b'
Fg_col2 = '#73b05b'

local last_mode = ""

M.get_current_mode = function(self)
	local current_mode = api.nvim_get_mode().mode
	if current_mode ~= last_mode then
		last_mode = current_mode
		Fg_col1 = mapHSV(fg_col1_start, function(h, s, v) return (h + self.modes[current_mode][3] * 0.3)%6, s, v end)
		Fg_col2 = mapHSV(fg_col2_start, function(h, s, v) return (h + self.modes[current_mode][3] *  0.3)%6, s, v end)
		update_colors()
	end
	if self:is_truncated(self.trunc_width.mode) then
		return string.format(' %s ', self.modes[current_mode][2]):upper()
	end
		return string.format(' %s ', self.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
	-- use fallback because it doesn't set this variable on the initial `BufEnter`
	local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
	local is_head_empty = signs.head ~= ''

	if self:is_truncated(self.trunc_width.git_status) then
		return is_head_empty and string.format('  %s ', signs.head or '') or ''
	end

	return is_head_empty
		and string.format(
			' +%s ~%s -%s |  %s ',
			signs.added, signs.changed, signs.removed, signs.head
		)
		or ''
end

M.get_filetype = function(self)
	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype

	if filetype == '' then return '' end
	if self:is_truncated(self.trunc_width.mode) then
		return string.format('%s', icon) 
	else 
		return string.format(' %s %s ', icon, filetype):lower()
	end
end

M.get_lsp_diagnostic = function(self)
	local result = {
		errors = #vim.diagnostic.get(0, { severity =  vim.diagnostic.severity.ERROR }),
		warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARNING }),
		info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
		hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	}

	local colors = M.colors
	if self:is_truncated(self.trunc_width.diagnostic) then
		return ''
	else
		local errors = colors.lsp_errors .. ":" .. tostring(result.errors)
		local warnings = colors.lsp_warnings .. " :" .. tostring(result.warnings)
		local info = colors.lsp_info .. " :" .. tostring(result.info)
		local hints = colors.lsp_hints .. " :" .. tostring(result.hints)
		local any = result.errors + result.warnings + result.info + result.hints
		return
			colors.active .. (any > 0 and "| " or "") .. (result.errors > 0 and errors or "") .. (result.warnings > 0 and warnings or "") .. (result.info > 0 and info or "") .. (result.hints > 0 and hints or "") .. " "
	end
end

local set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

local universal_bg = '#504945'
local universal_bg_dark = '#1D2021'
local dark_font = '#1D2021'
local bright_font = '#FFFFFF'
function update_colors()
	local highlights = {
	  {'StatusLine', { fg = universal_bg, bg = bright_font, }},
	  {'StatusLineNC', { fg = universal_bg_dark, bg = bright_font }},
	  {'Mode', { bg = Fg_col1, fg = dark_font, gui="bold" }},
	  {'ModeAlt', { bg = Fg_col1, fg = Fg_col2 }},
	  {'Git', { bg = Fg_col2, fg = bright_font }},
	  {'GitAlt', { bg = universal_bg, fg = Fg_col2 }},
	  {'BGAlt', {bg = universal_bg_dark, fg = universal_bg}},

	  {'Filetype', { bg = '#504945', fg = universal_bg }},
	  {'Filename', { bg = '#504945', fg = universal_bg }},
	  {'LineColAlt', { bg = '#504945', fg = '#928374' }},
	  {'FiletypeAlt', { bg = '#3C3836', fg = '#504945' }},
	}

	for _, highlight in ipairs(highlights) do
	  set_hl(highlight[1], highlight[2])
	end
end

update_colors()

local constant_highlights = {
	{'LineCol', { bg = universal_bg_dark, fg = bright_font, gui="bold" }},

	{'LSPErrors', {fg = '#CC4530', bg = universal_bg}},
	{'LSPWarnings', {fg = '#DEA712', bg = universal_bg}},
	{'LSPInfo', {fg = '#2290DF', bg = universal_bg}},
	{'LSPHints', {fg = '#DDEEAA', bg = universal_bg}}

}

for _, highlight in ipairs(constant_highlights) do
	set_hl(highlight[1], highlight[2])
end


M.set_active = function(self)
	local colors = self.colors
	local mode = colors.mode .. self:get_current_mode() .. colors.mode_alt .. self.separators[active_sep][1] .. colors.active
	local git = colors.git .. '%<  %{FugitiveHead()} ' .. colors.git_alt .. self.separators.arrow[1]
	local position = colors.line_col .. "  %l,↔%c%V%, %P "
	local file =  colors.active .. ' %f' .. ' %h%m%r%w ' .. colors.git_alt .. self:get_filetype()
	local sagabar
	if isModuleAvailable('lspsaga.symbol.winbar') then
		sagabar = require('lspsaga.symbol.winbar'):get_bar()
	else
		sagabar = require('lspsaga.symbolwinbar'):get_winbar()
	end
	local location = self:is_truncated(self.trunc_width.diagnostic) and "" or sagabar or ""
	return colors.active .. mode .. git .. file .. self:get_lsp_diagnostic() .. colors.bg_alt ..  self.separators.arrow[1] .. '%=' .. colors.inactive .. location .. colors.inactive .. '%=' .. position
end

M.set_inactive = function(self)
	return self.colors.inactive .. '%= %F %='
end

M.set_explorer = function(self)
	return "%= Filetree %="
end

Statusline = setmetatable(M, {
	__call = function(statusline, mode)
		if mode == "active" then
			return statusline:set_active()
		end
		if mode == "inactive" then return statusline:set_inactive() end
		if mode == "explorer" then return statusline:set_explorer() end
	end
})

-- set statusline
-- TODO: replace this once we can define autocmd using lua
run([[
  augroup Statusline
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]])
