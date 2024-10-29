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

function Aloha.ClearTemp()
	if lfs.isDir("./Aloha/temp") then
		lfs.removeDir("./Aloha/temp")
	end
	lfs.writeDir("./Aloha/temp")
end

function Aloha.Run(token: string, intents: number?)
	Bot.INTENTS = intents or Enum.INTENTS.DEFAULT

	local pid_process = process.spawn([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
	Bot.PROCESS_ID = pid_process.stdout:match("%d+")

	local success,response = Network.Get(`{Endpoints.BASE_URL}{Endpoints.GET_GATEWAY_BOT}`, {
		["Authorization"] = `Bot {token}`,
		["Content-Type"] = "application/json",
	})

	Aloha.ClearTemp()

	local body = Network.JsonDecode(response.body)
	
	local shards = body.shards
	local base = body.url

	local gateway_url = `{base}/?v={Bot.DISCORD_API_VERSION}&encoding=json`

	Bot.TOKEN = token

	local success, clientUserData = Network.Get(`{Endpoints.BASE_URL}{Endpoints.GET_CURRENT_USER}`, {
		["Authorization"] = `Bot {token}`,
		["Content-Type"] = "application/json",
	})

	if success then
		Bot.Client = User.new(Network.JsonDecode(clientUserData.body))
	else
		error("Failed to fetch client user data")
	end


	Bot.STARTED_AT = os.time()

	for shard_id = 0, shards - 1 do
		local socket = DiscordWebSocket.new(gateway_url, `Bot {token}`, shard_id, shards)
		Bot.Shards[shard_id] = {Sent = 0, Socket = socket}

		socket.OnClose:Connect(function(code, reason)
			print(`[Shard {shard_id}] DISCONNECTED: {code} - {reason}`)
		end)
	end

	Bot.SHARD_COUNT = shards

	return Bot.Shards
end

type DefaultCommandOptions = {
	rateLimit: number?
}

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