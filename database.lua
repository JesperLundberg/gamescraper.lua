local M = {}

local sqlite = require("sqlite")

local config = require("config_local")

-- Get the database directory
local db

--- Ensure the database exists
function M.setup()
	-- NOTE: Make sure the directory exists
	-- if not vim.loop.fs_stat(dbdir) then
	-- 	vim.loop.fs_mkdir(dbdir, 493)
	-- end

	-- Initialize the database
	db = sqlite({
		uri = config.database_path,
		raw_data = {
			date = { "date", unique = true, primary = true },
			json = "text",
		},
		opt = {
			lazy = true,
		},
	})
end

--- Insert a new record into the database
--- @param date string The date of the record
--- @param json string The JSON data to insert
function M.insert(date, json)
	db:insert({
		date = date,
		json = json,
	})
end

return M
