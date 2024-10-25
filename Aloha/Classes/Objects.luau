--------------------
local Message = {}
Message.__index = Message

local User = {}
User.__index = User

local Channel = {}
Channel.__index = Channel

local Guild = {}
Guild.__index = Guild
-----------------------------

local Cache = require("../Lib/Cache")
local DiscordTypes = require("../Lib/DiscordTypes")
local API = require("../Lib/API")
local Endpoints = require("../Lib/Endpoints")
local net = require("@lune/net")


export type Guild = DiscordTypes.GuildData & {

} & typeof(Guild)

export type User = DiscordTypes.UserData & {

} & typeof(User)

export type Channel = DiscordTypes.ChannelData & {
	guild: Guild
} & typeof(Channel)

export type Message = DiscordTypes.MessageData & {
	channel: Channel,
	author: User,
} & typeof(Message)
-- Functions -----------------
local function GetChannel(id: string) : Channel
	if Cache.Channels[id] then
		return Cache.Channels[id]
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.GET_CHANNEL:format(id)}`
	local _, response = pcall(function() 
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	response = net.jsonDecode(response.body)

	Cache.Channels[id] = Channel.new(response)

	return Cache.Channels[id]
end

local function GetUser(data: DiscordTypes.UserData) : User
	if Cache.Users[data.id] then
		return Cache.Users[data.id]
	end

	Cache.Users[data.id] = User.new(data)

	return Cache.Users[data.id]
end

local function GetMessage(data: DiscordTypes.MessageData, noCreate: boolean?) : Message?
	if Cache.Messages[data.id] then
		return Cache.Messages[data.id]
	end

	if not data then return end
	if noCreate then return end

	Cache.Messages[data.id] = Message.new(data)

	return Cache.Messages[data.id]
end

local function GetGuild(id: string) : Guild
	if Cache.Guilds[id] then
		return Cache.Guilds[id]
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD:format(id)}`
	local _, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	response = net.jsonDecode(response.body)

	Cache.Guilds[id] = Guild.new(response)

	return Cache.Guilds[id]
end
------------------------------ Message
function Message.new(data: DiscordTypes.MessageData) : Message
	local self = setmetatable({}, Message)

	for key, value in data do
		self[key] = value
	end
	
	self.channel = GetChannel(self.channel_id)
	self.author = GetUser(self.author)
	
	Cache.Messages[self.id] = self
	return self
end

function Message:Delete()
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_MESSAGE:format(self.channel_id, self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "DELETE",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Message:Reply(content: string, embeds: {DiscordTypes.EmbedData}?)
	self.channel:Send(content, embeds, {
		type = 0,
		message_id = self.id,
		channel_id = self.channel_id,
		guild_id = self.channel.guild_id
	})
end

function Message:AddReaction(emoji: string)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_REACTION:format(self.channel_id, self.id, net.urlEncode(emoji))}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PUT",
		})
	end)

	return success, response
end
------------------------------ Channel
function Channel.new(data: DiscordTypes.ChannelData) : Channel
	local self = setmetatable({}, Channel)

	for key, value in data do
		self[key] = value
	end

	self.guild = GetGuild(self.guild_id)

	return self
end

function Channel:Send(content: string, embeds: {DiscordTypes.EmbedData}?, reference: DiscordTypes.MessageReferenceData?)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_MESSAGE:format(self.id)}`

	local success, response = pcall(function()  
		return net.request({
			url = url,
			method = "POST",
			body = net.jsonEncode({
				content = content,
				embeds = embeds,
				message_reference = reference 
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`,
				['Content-Type'] = "application/json"
			}
		})
	end)

	return success, response
end

function Channel:Delete(message_id: string)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_MESSAGE:format(self.id, message_id)}`

	local success, response = pcall(function() 
		return net.request({
			url = url,
			method = "DELETE",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end
------------------------------  User
function User.new(data: DiscordTypes.UserData) : User
	local self = setmetatable({}, User)

	for key, value in data do
		self[key] = value
	end

	return self
end
------------------------------ Guild
function Guild.new(data: DiscordTypes.GuildData) : Guild
	local self = setmetatable({}, Guild)

	for key, value in data do
		self[key] = value
	end

	return self
end

function Guild:GetChannel(id: string) : Channel
	return GetChannel(id)
end

------------------------------
return {
	Message = Message,
	User = User,
	Channel = Channel,
	Guild = Guild,

	GetChannel = GetChannel,
	GetUser = GetUser,
	GetMessage = GetMessage,
	GetGuild = GetGuild
}