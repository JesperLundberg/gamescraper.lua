--- This file should be used to store local configuration settings that are specific to your environment.
--- @class configuration
--- @field steam_api_key string Your Steam API key
--- @field steam_user_id string Your Steam user ID
--- @field database_path string The path to the SQLite database file
--- @field report_path string The path to where the reports should be stored
local M = {}

M.steam_api_key = "YOUR_STEAM_API_KEY"
M.steam_user_id = "YOUR_STEAM_USER_ID"

-- Only change this if you're not running inside a docker container
M.database_path = "/db/"
M.report_path = "/report/"

return M
