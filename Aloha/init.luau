--[=[
	@class Aloha
	The main entry point for the Aloha Discord bot framework
]=]
local Aloha = {
	Lib = {
		Bot = require("./Lib/Bot"),
		Client = require("./Lib/Client"),
		Commands = require("./Lib/Commands"),
		Endpoints = require("./Lib/Endpoints"),
		Enum = require("./Lib/Enum"),
		Network = require("./Lib/Network"),
		Components = require("./Lib/Components"),
		Debug = require("./Lib/Debug"),
		DiscordTypes = require("./Lib/DiscordTypes")
	},

	Classes = {
		Embed = require("./Classes/Embed"),
		Color3 = require("./Classes/Color3"),
		DiscordWebSocket = require("./Classes/DiscordWebSocket"),
		LinkedList = require("./Classes/LinkedList"),
		Objects = require("./Classes/Objects"),
		Sweeper = require("./Classes/Sweeper"),
		Timer = require("./Classes/Timer")
	},

	Util = {
		Base64 = require("./Util/Base64"),
		Cache = require("./Util/Cache"),
		Misc = require("./Util/Misc"),
		Mutex = require("./Util/Mutex"),
		Sha1 = require("./Util/Sha1"),
		Task = require("./Util/Task")
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

	local pid_process = process.spawn([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
	Bot.PROCESS_ID = pid_process.stdout:match("%d+")

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