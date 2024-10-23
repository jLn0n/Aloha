local API = {}

local Cache = require("./Cache")
local net = require("@lune/net")
local Endpoints = require("./Endpoints")

API.DISCORD_API_VERSION = "10"
API.ALOHA_VERSION = "0.0.1"

API.OS = "linux"
API.BROWSER = "lune"
API.DEVICE = "lune"

API.TOKEN = ""

API.INTENTS = 53608447

API.OP = {
	["HELLO"] = function(token: string)
		return {
			op = 2,
			d = {
				token = token,
				properties = {
					os = API.OS,
					browser = API.BROWSER,
					device = API.DEVICE
				}, 
				intents = API.INTENTS
			}
		}	
	end,

	["HEARTBEAT"] = function(sequence: number)
		return {
			op = 1,
			d = sequence
		}
	end
}

function API.GetChannel(id: string)
	if Cache.Channels[id] then
		return Cache.Channels[id]
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.GET_CHANNEL:format(id)}`
	local response = net.request({
		url = url,
		method = "GET",
		headers = {
			['Authorization'] = `Bot {API.TOKEN}`
		}
	})

	response = net.jsonDecode(response.body)

	local Channel = require("../Classes/Channel")
	Cache.Channels[id] = Channel.new(response)

	return Cache.Channels[id]
end

function API.GetUser(id: string)
	if Cache.Users[id] then
		return Cache.Users[id]
	end

	return
end

return API