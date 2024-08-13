local M = {}

local sqlite = require("sqlite")

local utils = require("utils")
local config = utils.get_config()

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

--- Get a record from the database by date
--- @param date osdate The date of the record
--- @return table The record
function M.get_raw_data_by_date(date)
	-- Find the record
	return db.raw_data:get({ where = { date = date } })
end

--- Update a record in the database
--- @param date osdate The date of the record
--- @param json string The JSON data to update
function M.update_raw_data(date, json)
	-- Find the record and update it
	db.raw_data:update({
		where = { date = date },
		set = { json = json },
	})
end

--- Insert a new record into the database
--- @param date osdate The date of the record
--- @param json string The JSON data to insert
function M.insert_raw_data(date, json)
	-- Find out if the record already exists
	if M.get_raw_data_by_date(date) then
		-- If it does, update it
		M.update_raw_data(date, json)

		-- Exit early
		return
	end

	-- Otherwise, insert it
	db.raw_data:insert({
		date = date,
		json = json,
	})
end

return M
