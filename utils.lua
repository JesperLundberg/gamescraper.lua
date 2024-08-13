local M = {}

--- Get the configuration from the config_local.lua file if it exists, otherwise get the configuration from the config.lua file
function M.get_config()
	-- Check if the config_local.lua file exists
	local status, config = pcall(require, "config_local")

	-- If the config_local.lua file exists, return the configuration from that file
	if status then
		return config
	end

	-- Return the configuration from the config.lua file as a fallback
	return require("config")
end

return M
