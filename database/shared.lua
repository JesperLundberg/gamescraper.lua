local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

local function create_raw_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = ":inmemory:", -- config.database_path .. db_name,
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

local function create_report_layer_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = ":inmemory:", -- config.database_path .. db_name,
		report_layer = {
			date_fetched = "text",
			appid = "number",
			name = "text",
			playtime_forever = "number",
		},
		last_run = {
			timestamp = { "text", unique = true, primary = true },
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

	if db_name == "raw_data.sqlite" then
		db = create_raw_database(db_name)
	elseif db_name == "report_layer.sqlite" then
		db = create_report_layer_database(db_name)
	end

	db.new(config.database_path)

	return db
end

return M
