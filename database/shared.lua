local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

--- Create the database and set the schema
--- @return table The database object
function M.setup()
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

	-- This automatically creates the path/database if it does not exist
	db.new(config.database_path)

	-- Return the database object
	return db
end

return M
