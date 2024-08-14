local M = {}

local sqlite = require("sqlite")
local utils = require("utils")
local config = utils.get_config()

-- The database
local database

--- Ensure the database exists
function M.setup()
	-- NOTE: Make sure the directory exists
	-- if not vim.loop.fs_stat(dbdir) then
	-- 	vim.loop.fs_mkdir(dbdir, 493)
	-- end

	local db = sqlite:open(config.database_path)

	-- Initialize the database
	-- db = sqlite({
	-- 	uri = config.database_path,
	-- bronze_layer = {
	-- 	date = { "date", unique = true, primary = true },
	-- 	appid = "number",
	-- 	name = "text",
	-- 	playtime_2weeks = "number",
	-- 	playtime_forever = "number",
	-- 	img_icon_url = "text",
	-- 	playtime_windows_forever = "number",
	-- 	playtime_mac_forever = "number",
	-- 	playtime_linux_forever = "number",
	-- 	playtime_deck_forever = "number",
	-- },
	-- opt = {
	-- 	lazy = true,
	-- },
	-- })

	-- NOTE: The below works fine in online tester
	-- CREATE TABLE IF NOT EXISTS bronze_layer (
	-- date TEXT,
	-- appid INTEGER,
	-- name TEXT NOT NULL,
	-- playtime_2weeks INTEGER,
	-- playtime_forever INTEGER,
	-- img_icon_url TEXT,
	-- playtime_windows_forever INTEGER,
	-- playtime_mac_forever INTEGER,
	-- playtime_linux_forever INTEGER,
	-- playtime_deck_forever INTEGER,
	-- PRIMARY KEY(date, appid));
	--
	-- INSERT INTO bronze_layer VALUES ('2023-01-01', 123, 'game1', 0, 0, '', 0, 0, 0, 0);
	--
	-- SELECT * FROM bronze_layer;

	db:execute([[CREATE TABLE IF NOT EXISTS bronze_layer (
	     date TEXT,
	     appid INTEGER,
	     name TEXT NOT NULL,
	     playtime_2weeks INTEGER,
	     playtime_forever INTEGER,
	     img_icon_url TEXT,
	     playtime_windows_forever INTEGER,
	     playtime_mac_forever INTEGER,
	     playtime_linux_forever INTEGER,
	     playtime_deck_forever INTEGER,
	     PRIMARY KEY(date, appid)
	   );]])

	database = db
end

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @return table The record
function M.get_bronze_data_by_date(date)
	-- Find the record
	return database.bronze_layer:get({ where = { date = date } })
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param bronze_data table The table to update
function M.update_bronze_data(date, bronze_data)
	-- Find the record and update it
	database.bronze_layer:update({
		where = { date = date },
		set = { bronze_data = bronze_data },
	})
end

--- Insert a new record into the database
--- @param bronze_data table The table to insert
function M.insert_bronze_data(bronze_data)
	-- Find out if the record already exists
	if M.get_bronze_data_by_date(bronze_data.date) then
		-- If it does, update it
		M.update_bronze_layer(bronze_data.date, bronze_data)

		-- Exit early
		return
	end

	-- Otherwise, insert it
	database.bronze_layer:insert({
		date = bronze_data.date,
		bronze_data = bronze_data,
	})
end

return M
