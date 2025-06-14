--[=[
	@class Snowflake
	A utility class for decoding and encoding Discord snowflakes.
]=]

local Snowflake = {}

export type Snowflake = {
	id: string,
	timestamp: string,
	workerId: string,
	processId: string,
	increment: string,
}

local bit64 = require("./Bit64")

--[=[
	@private
	@param id string -- The snowflake ID
	@return Snowflake -- The decoded snowflake
	@within Snowflake
]=]
local function decodeSnowflake(id: string)
	local discordEpoch = 1420070400000

	local snowflake = bit64.from_string(id)
	local timestamp = bit64.add(bit64.rshift(snowflake, 22), bit64.from_u32(discordEpoch))
	local workerId = bit64.band(bit64.rshift(snowflake, 17), bit64.from_u32(0x1F))
	local processId = bit64.band(bit64.rshift(snowflake, 12), bit64.from_u32(0x1F))
	local increment = bit64.band(snowflake, bit64.from_u32(0x3F))

	return {
		timestamp = bit64.to_string(timestamp),
		workerId = bit64.to_string(workerId),
		processId = bit64.to_string(processId),
		increment = bit64.to_string(increment),
	}
end

--[=[
	@within Snowflake
	@param id string -- The snowflake ID
	@return Snowflake -- The decoded snowflake
]=]
function Snowflake.new(id: string)
	local self = setmetatable({}, {
		__index = Snowflake,

		__tostring = function(self)
			return self.id
		end,

		__eq = function(self, other)
			return self.id == other.id
		end,
	})

	self.id = id

	local decoded = decodeSnowflake(id)

	self.timestamp = decoded.timestamp
	self.workerId = decoded.workerId
	self.processId = decoded.processId
	self.increment = decoded.increment

	return self
end

return Snowflake