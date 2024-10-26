local API = {}

local Cache = require("./Cache")
local net = require("@lune/net")
local process = require("@lune/process")
local Endpoints = require("./Endpoints")

API.DISCORD_API_VERSION = "10"
API.ALOHA_VERSION = "0.3.0"

API.PROCESS_ID = 0

API.TOKEN = ""

API.RESUME_URL = ""
API.SESSION_ID = ""

API.STARTED_AT = 0

API.INTENTS = 53608447

API.OP = {
	-- Aloha!!
	["HELLO"] = function(token: string)
		return {
			op = 2,
			d = {
				token = token,
				properties = {
					os = process.os,
					browser = "aloha",
					device = "aloha"
				}, 
				intents = API.INTENTS,
				compress = true
			}
		}	
	end,

	["RESUME"] = function(token: string, sequence: number)
		return {
			op = 6,
			d = {
				token = token,
				session_id = API.SESSION_ID,
				seq = sequence
			}
		}
	end,

	["HEARTBEAT"] = function(sequence: number)
		return {
			op = 1,
			d = sequence or false
		}
	end
}

API.CLOSE_REASONS = {
	[4000] = "UNKNOWN_ERROR",
	[4001] = "UNKNOWN_OPCODE",
	[4002] = "DECODE_ERROR",
	[4003] = "NOT_AUTHENTICATED",
	[4004] = "AUTHENTICATION_FAILED",
	[4005] = "ALREADY_AUTHENTICATED",
	[4007] = "INVALID_SEQUENCE",
	[4008] = "RATE_LIMITED",
	[4009] = "SESSION_TIMEOUT",
	[4010] = "INVALID_SHARD",
	[4011] = "SHARDING_REQUIRED",
	[4012] = "INVALID_API_VERSION",
	[4013] = "INVALID_INTENTS",
	[4014] = "DISALLOWED_INTENTS"
}

function API.GenerateGUID(wrapInBraces: boolean?) : string
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	local function randomHex(char)
		local v = (char == 'x') and math.random(0, 15) or math.random(8, 11)
		return string.format("%x", v)
	end

	local s = string.gsub(template, "[xy]", randomHex)

	return wrapInBraces and `\{{s}\}` or s
end

return API