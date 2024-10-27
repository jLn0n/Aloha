local Aloha = {}

local Endpoints = require("./Lib/Endpoints")
local Bot = require("./Lib/Bot")
local Objects = require("./Classes/Objects")
local Commands = require("./Lib/Commands")
local User = Objects.User
local Client = require("./Lib/Client")
local task = require("@lune/task")
local lfs = require("@lune/fs")
local Network = require("./Lib/Network")
local DiscordWebSocket = require("./Util/DiscordWebSocket")
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
		Bot.Shards[shard_id] = {Sent = 0, Socket = DiscordWebSocket.new(gateway_url, `Bot {token}`, shard_id, shards)}
	end

	Bot.SHARD_COUNT = shards

	task.spawn(function()
		while true do
			task.wait(1)

			for _, shard in Bot.Shards do
				shard.Sent = 0
			end
		end
	end)

	return Bot.Shards
end

function Aloha.RegisterDefaultCommands() : {Commands.Command}
	local commands = {}

	for _, file in lfs.readDir("./Aloha/DefaultCommands") do
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