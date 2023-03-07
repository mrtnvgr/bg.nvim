local M = {}

local handle = io.popen("tty")
local tty = handle:read("*a")
handle:close()

function M.reset()
	os.execute('printf "\\033]111\\007" > ' .. tty)
end

function M.update()
	local normal = vim.api.nvim_get_hl_by_name("Normal", true)
	local bg = normal["background"]
	local fg = normal["foreground"]
	if bg == nil then
		return M.reset()
	end

	local bghex = string.format("#%06x", bg)
	os.execute('printf "\\033]11;' .. bghex .. '\\007" > ' .. tty)

	local fghex = string.format("#%06x", fg)
	os.execute('printf "\\033]12;' .. fghex .. '\\007" > ' .. tty)
end

function M.setup()
	vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, { callback = M.update })
	vim.api.nvim_create_autocmd({ "VimLeavePre" }, { callback = M.reset })
end

return M
