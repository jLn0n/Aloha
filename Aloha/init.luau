--[=[
	@class Aloha
	The main entry point for the Aloha Discord bot framework
]=]
local Aloha = {}

local Endpoints = require("./Lib/Endpoints")
local Bot = require("./Lib/Bot")
local Objects = require("./Classes/Objects")
local Commands = require("./Lib/Commands")
local User = Objects.User
local Client = require("./Lib/Client")
local task = require("@lune/task")
local Timer = require("./Classes/Timer")
local lfs = require("@lune/fs")
local Network = require("./Lib/Network")
local DiscordWebSocket = require("./Classes/DiscordWebSocket")
local Enum = require("./Lib/Enum")
local process = require("@lune/process")

--[=[
	@function ClearTemp
	@within Aloha
	Clears the temporary directory used by Aloha
]=]
function Aloha.ClearTemp()
	if lfs.isDir("./Aloha/temp") then
		lfs.removeDir("./Aloha/temp")
	end
	lfs.writeDir("./Aloha/temp")
end

--[=[
	@function Run
	@within Aloha
	@param token string -- The Discord bot token
	@param intents number? -- Optional gateway intents bitmask
	@return {[number]: {Socket: DiscordWebSocket, ResumeURL: string, SessionID: string}} -- Table of shards
	Starts the Discord bot with the given token and intents
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
		local socket = DiscordWebSocket.new(gateway_url, `Bot {token}`, shard_id, shards)
		Bot.Shards[shard_id] = {Socket = socket, ResumeURL = "", SessionID = ""}

		socket.OnClose:Connect(function(code, reason)
			print(`[Shard {shard_id}] DISCONNECTED: {code} - {reason}`)
		end)
	end

	Bot.SHARD_COUNT = shards

	return Bot.Shards
end

--[=[
	@type DefaultCommandOptions {rateLimit: number?}
	@within Aloha
]=]
type DefaultCommandOptions = {
	rateLimit: number?
}

--[=[
	@function RegisterDefaultCommands
	@within Aloha
	@param options DefaultCommandOptions? -- Optional configuration for default commands
	@return {Commands.Command} -- Array of registered commands
	Registers the default commands included with Aloha
]=]
function Aloha.RegisterDefaultCommands(options: DefaultCommandOptions?) : {Commands.Command}
	local commands = {}

	if options and options.rateLimit then
		Bot.RATE_LIMIT = options.rateLimit
	end


	for _, file in lfs.readDir("Aloha/DefaultCommands") do
		local command = require(`./DefaultCommands/{file}`)

		local cmd = Commands.RegisterGlobal(command.Data)
		cmd:SetResponse(command.Response)

		table.insert(commands, Commands.Cache[cmd.id])
	end
	
	return commands
end

--[=[
	@function RegisterCommandsIn
	@within Aloha
	@param directory string -- Directory containing command modules
	Registers all commands in the specified directory
]=]
function Aloha.RegisterCommandsIn(directory: string)
	for _, file in lfs.readDir(directory) do
		local command = require(`{directory}/{file}`)

		local newCommand = Commands.RegisterGlobal(command.Data)

		if command.Response then
			newCommand:SetResponse(command.Response(newCommand.Response))
		end
	end
end


return Aloha