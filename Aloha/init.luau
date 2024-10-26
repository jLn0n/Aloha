local Aloha = {}

local Endpoints = require("./Lib/Endpoints")
local Cache = require("./Lib/Cache")
local DiscordWebSocket = require("./Util/DiscordWebSocket")
local Bot = require("./Lib/Bot")
local Objects = require("./Classes/Objects")
local Commands = require("./Lib/Commands")
local User = Objects.User
local Client = require("./Lib/Client")
local lfs = require("@lune/fs")
local Network = require("./Lib/Network")
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

	local base = Network.JsonDecode(response.body).url

	local gateway_url = `{base}/?v={Bot.DISCORD_Bot_VERSION}&encoding=json`

	Bot.TOKEN = token

	local success, clientUserData = Network.Get(`{Endpoints.BASE_URL}{Endpoints.GET_CURRENT_USER}`, {
		["Authorization"] = `Bot {token}`,
		["Content-Type"] = "application/json",
	})

	if success then
		Cache.Client = User.new(Network.JsonDecode(clientUserData.body))
	else
		error("Failed to fetch client user data")
	end

	Client.User = Cache.Client

	Bot.STARTED_AT = os.time()

	local ws = DiscordWebSocket.new(gateway_url, `Bot {token}`)

	ws.OnClose:Connect(function(closeCode: number, reason: string)
		print(`[WebSocket] 🔌 Closed with code {closeCode}: {reason}`)
	end)

	return ws
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