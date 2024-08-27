local M = {}

local utils = require("utils")
local config = utils.get_config()

function M.create_files(date, data)
	local file_name = config.report_path .. date .. ".md"
end

return M
