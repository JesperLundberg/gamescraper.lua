local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

local function create_raw_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = config.database_path .. db_name,
		raw_data = {
			date = { "date", unique = true, primary = true },
			json = "text",
		},
		opt = {
			lazy = true,
		},
	})

	-- Return the database object
	return db
end

local function create_bronze_layer_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = config.database_path .. db_name,
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

	-- Return the database object
	return db
end

--- Create the database and set the schema
--- @param db_name string The name of the database (with extension)
--- @return table The database object
function M.setup(db_name)
	local db

	if db_name == "raw_data.db" then
		db = create_raw_database(db_name)
	elseif db_name == "bronze_layer.db" then
		db = create_bronze_layer_database(db_name)
	end

	db.new(config.database_path)

	return db
end

return M
