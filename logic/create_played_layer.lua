local database_report_layer = require("database.report_layer")
local database_played_layer = require("database.played_layer")
local utils = require("utils")

local M = {}

--- Create a row in the played layer for the supplied date
--- @param date osdate|string The date of the report layer
function M.create_played_layer(date)
	-- Get the report layer by sent in date or todays date
	local report_layer = database_report_layer.get_report_layer_by_date(date or os.date("%Y-%m-%d"))
	local played_layer

	-- If there is no report data, return
	if not next(report_layer) then
		return
	end

	-- TODO: Compare each game in the report layer with the previous day and see if the playtime has changed
	-- If it has, that means that the game was played that day and we should insert it into the played_layer

	-- Insert the report layer into the database (or update if it already exists)
	for _, v in pairs(played_layer) do
		database_played_layer.insert_report_data({
			date = date,
			appid = v.appid,
			name = v.name,
			playtime_forever = v.playtime_forever,
		})
	end
end
--
-- --- Create report data from the last run date to today
-- function M.create_report_data_to_today()
-- 	-- Get the last run date
-- 	local last_run = database_played_layer.get_last_run()
--
-- 	-- if the last run date is today, do nothing
-- 	if last_run == os.date("%Y-%m-%d") then
-- 		return
-- 	end
--
-- 	-- For each date between the last run date and today, run create_played_layer(date)
-- 	local current_date = last_run
--
-- 	while current_date ~= os.date("%Y-%m-%d") do
-- 		print("Creating report layer for " .. current_date)
--
-- 		-- Create the report layer for the current date
-- 		M.create_played_layer(current_date)
--
-- 		-- Get the next day in the loop
-- 		current_date = utils.get_next_day(current_date)
-- 	end
--
-- 	-- Update the last run date to today
-- 	database_played_layer.update_last_run(last_run)
-- end

return M

-- -- local previous_day_date = utils.get_previous_day(played_data.date)
-- -- local previous_day = M.get_played_data_by_date_and_appid(previous_day_date, played_data.appid)
-- -- local current_day = M.get_played_data_by_date_and_appid(played_data.date, played_data.appid)
-- --
-- -- -- If the game hasn't been played since previous day, don't insert
-- -- -- If the played time hasn't changed then the game has not been played since
-- -- if previous_day.playtime_forever == current_day.playtime_forever then
-- -- 	return
-- -- end
