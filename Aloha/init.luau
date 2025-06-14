--[=[
	@class Aloha
	The main entry point for the Aloha Discord bot framework
]=]
local Aloha = {
	Lib = {
		Bot = require("@self/Lib/Bot"),
		Client = require("@self/Lib/Client"),
		Commands = require("@self/Lib/Commands"),
		Endpoints = require("@self/Lib/Endpoints"),
		Enum = require("@self/Lib/Enum"),
		Network = require("@self/Lib/Network"),
		Components = require("@self/Lib/Components"),
		Debug = require("@self/Lib/Debug"),
		DiscordTypes = require("@self/Lib/DiscordTypes")
	},

	Classes = {
		Embed = require("@self/Classes/Embed"),
		Color3 = require("@self/Classes/Color3"),
		DiscordWebSocket = require("@self/Classes/DiscordWebSocket"),
		LinkedList = require("@self/Classes/LinkedList"),
		Objects = require("@self/Classes/Objects"),
		Sweeper = require("@self/Classes/Sweeper"),
		Timer = require("@self/Classes/Timer"),
		Snowflake = require("@self/Classes/Snowflake")
	},

	Util = {
		Base64 = require("@self/Util/Base64"),
		Cache = require("@self/Util/Cache"),
		Misc = require("@self/Util/Misc"),
		Mutex = require("@self/Util/Mutex"),
		Sha1 = require("@self/Util/Sha1"),
		Task = require("@self/Util/Task")
	}
}


local Endpoints = Aloha.Lib.Endpoints
local Bot = Aloha.Lib.Bot
local Objects = Aloha.Classes.Objects
local Commands = Aloha.Lib.Commands
local User = Objects.User
local Network = Aloha.Lib.Network
local DiscordWebSocket = Aloha.Classes.DiscordWebSocket
local Enum = Aloha.Lib.Enum


local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

--[=[
	@function ClearTemp
	@within Aloha
	Clears the temporary directory used by Aloha
]=]
function Aloha.ClearTemp()
	if fs.isDir("./Aloha/temp") then
		fs.removeDir("./Aloha/temp")
	end
	fs.writeDir("./Aloha/temp")
end

--[=[
	@function Run
	@within Aloha
	@param token string -- The Discord bot token
	@param intents number? -- Optional gateway intents bitmask
	@return {[number]: {Socket: DiscordWebSocket, ResumeURL: string, SessionID: string}} -- Table of shards
	Starts the Discord bot with the given token and intents. Must be called last.
]=]
function Aloha.Run(token: string, intents: number?)
	Bot.INTENTS = intents or Enum.INTENTS.DEFAULT
	Bot.TOKEN = token

	local pid_process = process.create([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
	Bot.PROCESS_ID = pid_process.stdout:readToEnd():match("%d+")

	local _, response = Network.Request({
		method = "GET",
		endpoint = Endpoints.GET_GATEWAY_BOT
	})

	Aloha.ClearTemp()
	
	local shards = response.shards
	local base = response.url

	local gateway_url = `{base}/?v={Bot.DISCORD_API_VERSION}&encoding=json`

	local success, clientUserData = Network.Request({
		method = "GET",
		endpoint = Endpoints.GET_CURRENT_USER
	})

	if success then
		Bot.Client = User.new(clientUserData)
	else
		error("Failed to fetch client user data")
	end

	Bot.STARTED_AT = os.time()
	for shard_id = 0, shards - 1 do
		Aloha.Util.Task.Defer(function()
			DiscordWebSocket.new(gateway_url, `Bot {token}`, shard_id, shards)
		end)
	end

	Bot.SHARD_COUNT = shards

	return Bot.Shards
end

return Aloha