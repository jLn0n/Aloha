local Bot = {}

local process = require("@lune/process")
local DiscordTypes = require("./DiscordTypes")
local Network = require("./Network")

Bot.DISCORD_API_VERSION = "10"
Bot.ALOHA_VERSION = "0.3.5"

Bot.PROCESS_ID = 0

Bot.TOKEN = ""

Bot.Client = nil
Bot.Shards = {}

Bot.SHARD_COUNT = 0

Bot.RESUME_URL = ""
Bot.SESSION_ID = ""

Bot.STARTED_AT = 0
Bot.RATE_LIMIT = 0

Bot.INTENTS = 53608447

local function formatTime(seconds: number): string
    local days = math.floor(seconds / 86400)
    seconds %= 86400
    local hours = math.floor(seconds / 3600)
    seconds %= 3600
    local minutes = math.floor(seconds / 60)
    seconds %= 60

	seconds = math.floor(seconds * 1000) / 1000

    local result = ""
    if days > 0 then 
        result ..= days .. "d" 
    end
    if hours > 0 then 
        result ..= hours .. "h" 
    end
    if minutes > 0 then 
        result ..= minutes .. "m" 
    end
    if seconds > 0 or #result == 0 then
        result ..= seconds .. "s"
    end


    return result
end

Bot.OP = {
	-- Aloha!!
	["IDENTIFY"] = function(token: string, shard_id: number, shards: number, heartbeat_delay: number)
		print(`[Shard {shard_id}] 🔑 Identifying with intents {Bot.INTENTS}. Heartbeat in: {formatTime(heartbeat_delay)}`)
		return {
			op = 2,
			d = {
				token = token,
				properties = {
					os = process.os,
					browser = "aloha",
					device = "aloha"
				}, 
				intents = Bot.INTENTS,
				shard = {shard_id, shards},
				--compress = true
			}
		}	
	end,

	["RESUME"] = function(token: string, sequence: number, shard_id: number)
		print(`[Shard {shard_id}] 🔑 Resuming session with sequence {sequence}...`)
		return {
			op = 6,
			d = {
				token = token,
				session_id = Bot.SESSION_ID,
				seq = sequence or false
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

Bot.CLOSE_REASONS = {
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

function Bot.GenerateGUID(wrapInBraces: boolean?) : string
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	local function randomHex(char)
		local v = (char == 'x') and math.random(0, 15) or math.random(8, 11)
		return string.format("%x", v)
	end

	local s = string.gsub(template, "[xy]", randomHex)

	return wrapInBraces and `\{{s}\}` or s
end

function Bot.GetShard(guild_id: DiscordTypes.snowflake) : (number?, Network.WebSocket?)
	local id = tonumber(guild_id)
	if not id then return end
	
	local shard_id = bit32.rshift(id, 22) % Bot.SHARD_COUNT

	return shard_id, Bot.Shards[shard_id]
end

function Bot.IsRateLimited(shard_id: number)
	print("Checking ratelimit")
	return Bot.Shards[shard_id].Sent >= 50 / Bot.SHARD_COUNT
end

return Bot