--------------------
local Message = {}
Message.__index = Message

local User = {}
User.__index = User

local Channel = {}
Channel.__index = Channel

local Guild = {}
Guild.__index = Guild

local Member = {}
Member.__index = Member
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

export type Member = DiscordTypes.MemberData & {
	user: User,
	guild: Guild
} & typeof(Member)
-- Functions -----------------
local function GetChannel(id: string) : Channel
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

	return Channel.new(response)
end

local function GetUser(data: DiscordTypes.UserData) : User
	return User.new(data)
end

local function GetMessage(data: DiscordTypes.MessageData) : Message
	return Message.new(data)
end

local function GetMessageInChannel(channelId: string, messageId: string) : Message?
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_CHANNEL_MESSAGE:format(channelId, messageId)}`
	local _, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return Message.new(response)
end

local function GetGuild(id: string) : Guild?
	if not id then return end

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

	return Guild.new(response)
end
local function GetMember(userId: string, guildId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_MEMBER:format(guildId, userId)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	if not success then return false, response end

	return Member.new(net.jsonDecode(response.body), guildId)
end
------------------------------ Message
function Message.new(data: DiscordTypes.MessageData) : Message
	local self = setmetatable({}, Message)

	for key, value in data do
		self[key] = value
	end
	
	self.channel = GetChannel(self.channel_id)
	self.author = GetUser(self.author)

	local mentions = {}

	for _, user in data.mentions do
		mentions[user] = GetUser(user)
	end

	self.mentions = mentions
	
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
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Message:RemoveReaction(emoji: string, userId: string?)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_USER_REACTION:format(self.channel_id, self.id, net.urlEncode(emoji), userId or "@me")}`

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

function Message:RemoveAllReactions()
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_ALL_REACTIONS:format(self.channel_id, self.id)}`

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

function Channel:GetMessage(id: string) : Message
	local msg = GetMessageInChannel(self.id, id)

	return msg
end

function Channel:Modify(data: DiscordTypes.ChannelData & {icon: string?}) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.MODIFY_CHANNEL:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PATCH",
			body = net.jsonEncode(data),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`,
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

function User:GetDirectMessageChannel() : (Channel? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_DM}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "POST",
			body = net.jsonEncode({
				recipient_id = self.id
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`,
				['Content-Type'] = "application/json"
			}
		})
	end)

	if not success then return false, response end		

	return Channel.new(net.jsonDecode(response.body))
end

function Member.new(data: DiscordTypes.MemberData, guild: Guild? | string?) : Member
	local self = setmetatable({}, Member)

	for key, value in data do
		self[key] = value
	end

	local user = data.user
	if user then
		self.user = GetUser(user)
	end

	self.guild = guild and (type(guild) == "string" and GetGuild(guild) or guild) or nil

	return self
end

function Member:Kick()
	local url = `{Endpoints.BASE_URL}{Endpoints.REMOVE_GUILD_MEMBER:format(self.guild.id, self.user.id)}`

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

function Member:Ban(delete_message_seconds: number?)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_BAN:format(self.guild.id, self.user.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PUT",
			body = net.jsonEncode({
				delete_message_seconds = delete_message_seconds
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
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

function Guild:GetMember(userId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_MEMBER:format(self.id, userId)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	if not success then return false, response end

	return Member.new(net.jsonDecode(response.body), self)
end

function Guild:BulkBan(userIds: {string}, delete_message_seconds: number?)
	local url = `{Endpoints.BASE_URL}{Endpoints.BULK_GUILD_BAN:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "POST",
			body = net.jsonEncode({
				user_ids = userIds,
				delete_message_seconds = delete_message_seconds
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Guild:CreateRole(name: string, permissions: string, color: number, hoist: boolean, icon: string?, unicode_emoji: string?, mentionable: boolean)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_ROLE:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "POST",
			body = net.jsonEncode({
				name = name,
				permissions = permissions,
				color = color,
				hoist = hoist,
				icon = icon,
				unicode_emoji = unicode_emoji,
				mentionable = mentionable
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Guild:GetRoles() : ({DiscordTypes.RoleData} | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLES:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	if not success then return false, response end

	return net.jsonDecode(response.body)
end

function Guild:GetRole(id: string) : (DiscordTypes.RoleData? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLE:format(self.id, id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	if not success then return false, response end

	return net.jsonDecode(response.body)
end	

function Guild:DeleteRole(id: string) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_GUILD_ROLE:format(self.id, id)}`

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

function Guild:ModifyRole(id: string, data: {name: string?, permissions: string?, color: number?, hoist: boolean?, icon: string?, unicode_emoji: string?, mentionable: boolean?}) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.MODIFY_GUILD_ROLE:format(self.id, id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PATCH",
			body = net.jsonEncode(data),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Guild:MoveRole(id: string, position: number) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLES:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PATCH",
			body = net.jsonEncode({
				id = id,
				position = position
			}),
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	return success, response
end

function Guild:GetVanityURL() : ({code: string, uses: number}? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_VANITY_URL:format(self.id)}`

	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = {
				['Authorization'] = `Bot {API.TOKEN}`
			}
		})
	end)

	if not success then return false, response end

	return net.jsonDecode(response.body)
end
------------------------------
return {
	Message = Message,
	User = User,
	Channel = Channel,
	Guild = Guild,
	Member = Member,

	GetChannel = GetChannel,
	GetUser = GetUser,
	GetMessage = GetMessage,
	GetGuild = GetGuild
}