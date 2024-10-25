local API = {}

local Cache = require("./Cache")
local net = require("@lune/net")
local process = require("@lune/process")
local Endpoints = require("./Endpoints")

API.DISCORD_API_VERSION = "10"
API.ALOHA_VERSION = "0.0.1"

API.PROCESS_ID = 0

API.TOKEN = ""

API.RESUME_URL = ""
API.SESSION_ID = ""

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
				intents = API.INTENTS
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
			d = sequence
		}
	end
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