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

local DiscordTypes = require("../Lib/DiscordTypes")
local Bot = require("../Lib/Bot")
local Endpoints = require("../Lib/Endpoints")
local Network = require("../Lib/Network")
local task = require("@lune/task")
export type Guild = DiscordTypes.GuildData & {

} & typeof(Guild)

export type User = DiscordTypes.UserData & {

} & typeof(User)

export type Channel = DiscordTypes.ChannelData & {
	guild: Guild
} & typeof(Channel)

export type Message = typeof(Message) & {
	channel: Channel,
	author: User,
	mentions: {User},
	id: DiscordTypes.snowflake,
	channel_id: DiscordTypes.snowflake,
	content: string,
	timestamp: string,
	edited_timestamp: string?,
	tts: boolean,
	mention_everyone: boolean,
	mention_roles: {number},
	mention_channels: {DiscordTypes.ChannelMentionData},
	attachments: {DiscordTypes.AttachmentData},
	embeds: {DiscordTypes.EmbedData},
	reactions: {DiscordTypes.ReactionData}?,
	nonce: (number | string)?,
	pinned: boolean,
	webhook_id: DiscordTypes.snowflake?,
	type: number,
	activity: DiscordTypes.ActivityData?,
	application: DiscordTypes.ApplicationData?,
	application_id: DiscordTypes.snowflake?,
	flags: number?,
	message_reference: DiscordTypes.MessageReferenceData?,
	message_snapshots: {DiscordTypes.MessageSnapshotData}?,
	referenced_message: Message?,
	interaction_metadata: DiscordTypes.InteractionMetadataData?,
	interaction: DiscordTypes.InteractionData?,
	thread: DiscordTypes.ChannelData?,
	components: {DiscordTypes.ComponentData}?,
	sticker_items: {DiscordTypes.StickerItemData}?,
	stickers: {DiscordTypes.StickerData}?,
	position: number?,
	role_subscription_data: DiscordTypes.RoleSubscriptionData?,
	resolved: DiscordTypes.ResolvedData?,
	poll: DiscordTypes.PollData?,
	call: DiscordTypes.CallData?
}

export type Member = DiscordTypes.MemberData & {
	user: User,
	guild: Guild
} & typeof(Member)
-- Functions -----------------
local function GetChannel(id: string) : Channel
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_CHANNEL:format(id)}`
	local success,response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	response = Network.JsonDecode(response.body)

	return Channel.new(response)
end

local function rateLimit(guild_id: string)
	if not guild_id then return end
	local shard_id, shard = Bot.GetShard(guild_id)
	shard.Sent += 1
	task.delay(1, function()
		shard.Sent = 0
	end)

	if Bot.IsRateLimited(shard_id) then
		print(`[Shard {shard_id}] MESSAGE_DELETE Rate limited. Deferring to next cycle.`)
		task.wait(1)
	end
end

local function GetUser(data: DiscordTypes.UserData) : User
	return User.new(data)
end

local function GetMessage(data: DiscordTypes.MessageData) : Message
	return Message.new(data)
end

local function GetMessageInChannel(channelId: string, messageId: string) : Message?
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_CHANNEL_MESSAGE:format(channelId, messageId)}`
	local success,response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	if success then
		return Message.new(Network.JsonDecode(response.body))
	end

	return nil
end

local function GetGuild(id: string) : Guild?
	if not id then return end

	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD:format(id)}`
	local success,response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	response = Network.JsonDecode(response.body)

	return Guild.new(response)
end
local function GetMember(userId: string, guildId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_MEMBER:format(guildId, userId)}`

	local success,response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Member.new(Network.JsonDecode(response.body), guildId)
end
------------------------------ Message
function Message.new(data: DiscordTypes.MessageData) : Message
	local self = setmetatable({}, Message)

	for key, value in data do
		self[key] = value
	end
	
	if self.channel_id then
		self.channel = GetChannel(self.channel_id)
	end

	if self.author then
		self.author = GetUser(self.author)
	end

	local mentions = {}

	if data.mentions then
		for _, user in data.mentions do
			table.insert(mentions, GetUser(user))
		end
	end
	
	self.mentions = mentions

	if data.referenced_message then
		self.referenced_message = GetMessageInChannel(data.referenced_message.channel_id, data.referenced_message.id)
	end
	
	return self
end

function Message:Delete()
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_MESSAGE:format(self.channel_id, self.id)}`

	rateLimit(self.channel.guild_id)


	return Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
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
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji))}`

	rateLimit(self.channel.guild_id)
	

	return Network.Put(url, "", {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Message:RemoveReaction(emoji: string, userId: string?)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_USER_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji), userId or "@me")}`

	rateLimit(self.channel.guild_id)

	return Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Message:RemoveAllReactions()
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_ALL_REACTIONS:format(self.channel_id, self.id)}`

	rateLimit(self.channel.guild_id)

	return Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
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

	rateLimit(self.guild_id)

	return Network.Post(url, Network.JsonEncode({
		content = content,
		embeds = embeds,
		message_reference = reference 
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`,
		['Content-Type'] = "application/json"
	})
end

function Channel:Delete(message_id: string)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_MESSAGE:format(self.id, message_id)}`

	rateLimit(self.guild_id)

	return Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Channel:GetMessage(id: string) : Message
	rateLimit(self.guild_id)

	local msg = GetMessageInChannel(self.id, id)

	return msg
end

function Channel:Modify(data: DiscordTypes.ChannelData & {icon: string?}) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.MODIFY_CHANNEL:format(self.id)}`

	rateLimit(self.guild_id)

	local success, response = Network.Patch(url, Network.JsonEncode(data), {
		['Authorization'] = `Bot {Bot.TOKEN}`,
		['Content-Type'] = "application/json"
	})

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

	if (self :: User).bot then return false, {message = "Bots cannot DM bots!"} end

	local response = Network.Post(url, Network.JsonEncode({
		recipient_id = self.id
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`,
		['Content-Type'] = "application/json"
	})

	return Channel.new(Network.JsonDecode(response.body))
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

	rateLimit(self.guild.id)

	return Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Member:Ban(delete_message_seconds: number?)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_BAN:format(self.guild.id, self.user.id)}`

	rateLimit(self.guild.id)



	return Network.Put(url, Network.JsonEncode({
		delete_message_seconds = delete_message_seconds
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
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

	rateLimit(self.id)

	local response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Member.new(Network.JsonDecode(response.body), self)
end

function Guild:BulkBan(userIds: {string}, delete_message_seconds: number?)
	local url = `{Endpoints.BASE_URL}{Endpoints.BULK_GUILD_BAN:format(self.id)}`

	rateLimit(self.id)

	return Network.Post(url, Network.JsonEncode({
		user_ids = userIds,
		delete_message_seconds = delete_message_seconds
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Guild:CreateRole(name: string, permissions: string, color: number, hoist: boolean, icon: string?, unicode_emoji: string?, mentionable: boolean)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_ROLE:format(self.id)}`

	rateLimit(self.id)

	return Network.Post(url, Network.JsonEncode({
		name = name,
		permissions = permissions,
		color = color,
		hoist = hoist,
		icon = icon,
		unicode_emoji = unicode_emoji,
		mentionable = mentionable
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})
end

function Guild:GetRoles() : ({DiscordTypes.RoleData} | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLES:format(self.id)}`
	
	rateLimit(self.id)

	local response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Network.JsonDecode(response.body)
end

function Guild:GetRole(id: string) : (DiscordTypes.RoleData? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLE:format(self.id, id)}`

	rateLimit(self.id)

	local response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Network.JsonDecode(response.body)
end	

function Guild:DeleteRole(id: string) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.DELETE_GUILD_ROLE:format(self.id, id)}`

	rateLimit(self.id)

	local success, response = Network.Delete(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return success, response
end

function Guild:ModifyRole(id: string, data: {name: string?, permissions: string?, color: number?, hoist: boolean?, icon: string?, unicode_emoji: string?, mentionable: boolean?}) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.MODIFY_GUILD_ROLE:format(self.id, id)}`

	rateLimit(self.id)

	local success, response = Network.Patch(url, Network.JsonEncode(data), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return success, response
end

function Guild:MoveRole(id: string, position: number) : (boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_ROLES:format(self.id)}`

	rateLimit(self.id)

	local success, response = Network.Patch(url, Network.JsonEncode({
		id = id,
		position = position
	}), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return success, response
end

function Guild:GetVanityURL() : ({code: string, uses: number}? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.GET_GUILD_VANITY_URL:format(self.id)}`

	rateLimit(self.id)

	local response = Network.Get(url, {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Network.JsonDecode(response.body)
end

function Guild:CreateChannel(data: DiscordTypes.CreateGuildChannelData) : (Channel? | boolean, {any}?)
	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_CHANNEL:format(self.id)}`

	rateLimit(self.id)

	local response = Network.Post(url, Network.JsonEncode(data), {
		['Authorization'] = `Bot {Bot.TOKEN}`
	})

	return Channel.new(Network.JsonDecode(response.body))
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
	GetGuild = GetGuild,
	GetMember = GetMember
}