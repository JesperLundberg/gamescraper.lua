local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

--- Get the path to the database
--- @param db_name string The name of the database (with extension)
--- @return string The path to the database
local function get_database_path(db_name)
	if string.find(db_name, ":inmemory:") then
		return ":inmemory:"
	end

	return config.database_path .. db_name
end

--- Create the raw data database and set the schema
--- @param db_name string The name of the database (with extension)
--- @return table The database object
local function create_raw_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = get_database_path(db_name),
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

--- Create the report layer database and set the schema
--- @param db_name string The name of the database (with extension)
--- @return table The database object
local function create_report_layer_database(db_name)
	-- Initialize the database
	local db = sqlite({
		uri = get_database_path(db_name),
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

	if db_name == "raw_data.sqlite" or ":inmemory:raw_data.sqlite" then
		db = create_raw_database(db_name)
	elseif db_name == "report_layer.sqlite" or ":inmemory:report_layer.sqlite" then
		db = create_report_layer_database(db_name)
	end

	db.new(config.database_path)

	return db
end

return M
