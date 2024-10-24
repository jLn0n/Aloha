local Aloha = {}

local Endpoints = require("./Lib/Endpoints")
local Cache = require("./Lib/Cache")
local WebSocket = require("./Util/WebSocket")
local Intents = require("./Lib/Intents")
local API = require("./Lib/API")
local Objects = require("./Classes/Objects")
local Commands = require("./Lib/Commands")
local User = Objects.User
local net = require("@lune/net")
local lfs = require("@lune/fs")

function Aloha.Run(token: string, intents: number?)
	API.INTENTS = intents or Intents.DEFAULT

	local response = net.request({
		url =  `{Endpoints.BASE_URL}{Endpoints.GET_GATEWAY_BOT}`,
		method = "GET",
		headers = {
			["Authorization"] = `Bot {token}`,
			["Content-Type"] = "application/json",
		}
	})

	local base = net.jsonDecode(response.body).url

	local gateway_url = `{base}/?v={API.DISCORD_API_VERSION}&encoding=json`

	API.TOKEN = token

	local clientUserData = net.request({
		url = `{Endpoints.BASE_URL}{Endpoints.GET_CURRENT_USER}`,
		headers = {
			["Authorization"] = `Bot {token}`,
			["Content-Type"] = "application/json",
		}
	})

	Cache.Client = User.new(net.jsonDecode(clientUserData.body))

	return WebSocket.new(gateway_url, token)
end

function Aloha.RegisterDefaultCommands() : {Commands.Command}
	local commands = {}

	for _, file in lfs.readDir("./Aloha/DefaultCommands") do
		local command = require(`./DefaultCommands/{file}`)

		Commands.RegisterGlobal(command.Data):SetResponse(command.Response)

		table.insert(commands, Commands.Cache[command.Data.name])
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