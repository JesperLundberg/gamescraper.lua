local busted = require("busted")
local describe, it, assert, stub, before_each, after_each =
	busted.describe, busted.it, busted.assert, busted.stub, busted.before_each, busted.after_each

-- System under test
local sut = require("logic.create_report_layer")

-- Get necessary modules in order to stub them
local database_raw_data = require("database.raw_data")

describe("create_report_layer", function()
	-- Stubs
	local database_raw_data_get_raw_data_by_date_stub

	before_each(function()
		database_raw_data_get_raw_data_by_date_stub = stub(database_raw_data, "get_raw_data_by_date")
	end)

	after_each(function()
		database_raw_data_get_raw_data_by_date_stub:revert()
	end)

	describe("when called with a valid date", function()
		it("it should return nil if there is no raw data for that date", function()
			database_raw_data_get_raw_data_by_date_stub.returns({})

			local result = sut.create_report_layer("2021-01-01")

			assert.is_nil(result)
		end)
	end)
end)
