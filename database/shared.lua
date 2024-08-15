local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

function M.setup()
	-- NOTE: Make sure the directory exists
	-- if not vim.loop.fs_stat(dbdir) then
	-- 	vim.loop.fs_mkdir(dbdir, 493)
	-- end

	-- Initialize the database
	local db = sqlite({
		uri = config.database_path,
		raw_data = {
			date = { "date", unique = true, primary = true },
			json = "text",
		},
		bronze_layer = {
			date = "date",
			appid = "number",
			name = "text",
			playtime_2weeks = "number",
			playtime_forever = "number",
			img_icon_url = "text",
			playtime_windows_forever = "number",
			playtime_mac_forever = "number",
			playtime_linux_forever = "number",
			playtime_deck_forever = "number",
		},
		opt = {
			lazy = true,
		},
	})

	return db
end

return M
