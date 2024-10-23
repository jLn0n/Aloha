local Message = {}
Message.__index = Message

local Cache = require("../Lib/Cache")

local DiscordTypes = require("../Lib/DiscordTypes")
local API = require("../Lib/API")

export type Message = {

}

function Message.new(data: DiscordTypes.MessageData)
	local self = setmetatable({}, Message)

	for key, value in data do
		self[key] = value
	end

	Cache.Messages[self.id] = self

	self.channel = API.GetChannel(self.channel_id)
	self.author = API.GetUser(self.author.id)
	

	return self
end
return Message