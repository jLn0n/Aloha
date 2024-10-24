local Aloha = {}

local Endpoints = require("./Lib/Endpoints")
local Cache = require("./Lib/Cache")
local WebSocket = require("./Util/WebSocket")
local Intents = require("./Lib/Intents")
local API = require("./Lib/API")
local Objects = require("./Classes/Objects")
local User = Objects.User

local net = require("@lune/net")

function Aloha.Run(token: string, data: {intents: number?,os: string?,browser: string?,device: string?}?)

	if data then
		API.INTENTS = data.intents or Intents.DEFAULT
		API.OS = data.os or API.OS
		API.BROWSER = data.browser or API.BROWSER
		API.DEVICE = data.device or API.DEVICE
	end

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


return Aloha