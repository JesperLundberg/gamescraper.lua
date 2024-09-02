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

		it("should call the database_raw_data.get_raw_data_by_date with the given date", function()
			database_raw_data_get_raw_data_by_date_stub.returns({})

			sut.create_report_layer("2021-01-01")

			assert.stub(database_raw_data_get_raw_data_by_date_stub).was_called_with("2021-01-01")
		end)

		it("should call the database_raw_data.insert_report_data with the data in table format", function()
			database_raw_data_get_raw_data_by_date_stub.returns({
				{ date = "2021-01-01", json = "{}" },
			})
		end)
	end)
end)

-- {"response":{"total_count":6,"games":[{"appid":2005010,"name":"Warhammer 40,000: Boltgun","playtime_2weeks":276,"playtime_forever":478,"img_icon_url":"2ffcd2f993a8dac66c8523fb579234ffa2c83bdf","playtime_windows_forever":0,"playtime_mac_forever":0,"playtime_linux_forever":478,"playtime_deck_forever":0},{"appid":274520,"name":"Darkwood","playtime_2weeks":213,"playtime_forever":1451,"img_icon_url":"c8d29a171cab2435eb5d540ed2f03c448ad6de5a","playtime_windows_forever":0,"playtime_mac_forever":0,"playtime_linux_forever":1314,"playtime_deck_forever":0},{"appid":214490,"name":"Alien: Isolation","playtime_2weeks":147,"playtime_forever":475,"img_icon_url":"7bf964858835da75630a43ac0ddbf0f66a40902f","playtime_windows_forever":171,"playtime_mac_forever":0,"playtime_linux_forever":228,"playtime_deck_forever":0},{"appid":632470,"name":"Disco Elysium","playtime_2weeks":57,"playtime_forever":1471,"img_icon_url":"b681544caa931c7c1a6788e6e3e33cb42892d17c","playtime_windows_forever":0,"playtime_mac_forever":0,"playtime_linux_forever":1471,"playtime_deck_forever":0},{"appid":1592280,"name":"Selaco","playtime_2weeks":1,"playtime_forever":905,"img_icon_url":"997920f8d6f3f4a15a36a5161e29081bcc22ec15","playtime_windows_forever":0,"playtime_mac_forever":0,"playtime_linux_forever":905,"playtime_deck_forever":0},{"appid":223830,"name":"Xenonauts","playtime_2weeks":1,"playtime_forever":3235,"img_icon_url":"b7e97ba62adc7281ecb014432dec35eb32d86ffb","playtime_windows_forever":0,"playtime_mac_forever":0,"playtime_linux_forever":1195,"playtime_deck_forever":0}]}}
