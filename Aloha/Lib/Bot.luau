--[=[
	@class Bot
	The main Bot class that handles Discord gateway connections and core functionality.
]=]
local Bot = {}

local process = require("@lune/process")
local DiscordTypes = require("./DiscordTypes")

type WebSocket = {
	Close: () -> (),
	Next: () -> (any),
	Send: (data: string) -> ()
}

--[=[
	@prop DISCORD_API_VERSION string
	@within Bot
	The Discord API version being used.
]=]
Bot.DISCORD_API_VERSION = "10"

--[=[
	@prop ALOHA_VERSION string
	@within Bot
	The current version of Aloha.
]=]
Bot.ALOHA_VERSION = "0.3.5"

--[=[
	@prop PROCESS_ID number
	@within Bot
	The current process ID.
]=]
Bot.PROCESS_ID = 0

--[=[
	@prop TOKEN string
	@within Bot
	The bot's authentication token.
]=]
Bot.TOKEN = ""

--[=[
	@prop Client any
	@within Bot
	The Discord client instance.
]=]
Bot.Client = nil

--[=[
	@prop Shards {[number]: {Sent: number, Socket: WebSocket, ResumeURL: string, SessionID: string}}
	@within Bot
	Table of active shards and their data.
]=]
Bot.Shards = {} :: {[number]: {Sent: number, Socket: WebSocket, ResumeURL: string, SessionID: string}}

--[=[
	@prop SHARD_COUNT number
	@within Bot
	The total number of shards.
]=]
Bot.SHARD_COUNT = 0

--[=[
	@prop STARTED_AT number
	@within Bot
	Unix timestamp of when the bot started.
]=]
Bot.STARTED_AT = 0

--[=[
	@prop RATE_LIMIT number
	@within Bot
	Current rate limit value.
]=]
Bot.RATE_LIMIT = 0

--[=[
	@prop INTENTS number
	@within Bot
	The gateway intents being used.
]=]
Bot.INTENTS = 53608447

--[=[
	@prop GLOBAL_RATE_LIMIT boolean
	@within Bot
	Whether a global rate limit is active.
]=]
Bot.GLOBAL_RATE_LIMIT = false

--[=[
	@private
	@param seconds number -- Number of seconds to format
	@within Bot
	@return string -- Formatted time string
	Formats seconds into a human readable duration string.
]=]
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

--[=[
	@prop OP {[string]: (...any) -> {op: number, d: any}}
	@within Bot
	Gateway operation code handlers.
]=]
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
				session_id = Bot.Shards[shard_id].SessionID,
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

--[=[
	@prop CLOSE_REASONS {[number]: string}
	@within Bot
	Mapping of WebSocket close codes to readable reasons.
]=]
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

--[=[
	@within Bot
	@param wrapInBraces boolean? -- Whether to wrap the GUID in braces
	@return string -- The generated GUID
	Generates a random GUID string.
]=]
function Bot.GenerateGUID(wrapInBraces: boolean?) : string
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	local function randomHex(char)
		local v = (char == 'x') and math.random(0, 15) or math.random(8, 11)
		return string.format("%x", v)
	end

	local s = string.gsub(template, "[xy]", randomHex)

	return wrapInBraces and `\{{s}\}` or s
end

--[=[
	@within Bot
	@param guild_id DiscordTypes.snowflake -- The guild ID to get shard for
	@return number? -- The shard ID for the guild
	Calculates which shard a guild belongs to.
]=]
function Bot.GetShard(guild_id: DiscordTypes.snowflake) : number?
	local id = tonumber(guild_id)	
	if not id then return end
	
	local shard_id = bit32.rshift(id, 22) % Bot.SHARD_COUNT

	return shard_id
end

--[=[
	@within Bot
	@param enabled boolean -- Whether to enable global rate limiting
	Sets the global rate limit state.
]=]
function Bot.SetGlobalRateLimit(enabled: boolean)
	Bot.GLOBAL_RATE_LIMIT = enabled
end

return Bot
