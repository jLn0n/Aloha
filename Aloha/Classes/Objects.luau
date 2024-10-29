--[=[
	@class Objects
	@description Class to create Discord objects.
]=]
local Message = {}
Message.__index = Message

--[=[
	@class User
	@description Class to create Discord users.
]=]
local User = {}
User.__index = User

--[=[
	@class Channel
	@description Class to create Discord channels.
]=]
local Channel = {}
Channel.__index = Channel

--[=[
	@class Guild
	@description Class to create Discord guilds.
]=]
local Guild = {}
Guild.__index = Guild

--[=[
	@class Member
	@description Class to create Discord members.
]=]
local Member = {}
Member.__index = Member

--[=[
	@class Interaction
	@description Class to create Discord interactions.
]=]
local Interaction = {}
Interaction.__index = Interaction
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

export type Interaction = {
	id: DiscordTypes.snowflake,
	application_id: DiscordTypes.snowflake,
	type: number,
	data: (DiscordTypes.ApplicationCommandInteractionData | DiscordTypes.MessageComponentInteractionData)?,
	guild: Guild?,
	guild_id: DiscordTypes.snowflake?,
	channel: Channel?,
	channel_id: DiscordTypes.snowflake?,
	member: Member?,
	user: User?,
	token: string,
	version: number,
	message: Message,
	app_permissions: string,
	locale: string,
	guild_locale: string,
	entitlements: {DiscordTypes.EntitlementData}?,
	authorizing_integration_owners: {[number]: DiscordTypes.snowflake},
	context: number,
} & typeof(Interaction)

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

export type Member = {
	user: User?,
	nick: string?,
	avatar: string?,
	banner: string?,
	roles: {number}?,
	joined_at: string,
	premium_since: string?,
	deaf: boolean,
	mute: boolean,
	pending: boolean?,
	permissions: string?,
	communication_disabled_until: string?,
	avatar_decoration_data: DiscordTypes.AvatarDecorationData?
} & typeof(Member)
-- Functions -----------------
local function GetChannel(id: string) : Channel
	local url = `{Endpoints.GET_CHANNEL:format(id)}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Channel.new(response)
end

local function GetUser(data: DiscordTypes.UserData) : User
	return User.new(data)
end

local function GetMessage(data: DiscordTypes.MessageData) : Message
	return Message.new(data)
end

local function GetMessageInChannel(channelId: string, messageId: string) : Message?
	local url = `{Endpoints.GET_CHANNEL_MESSAGE:format(channelId, messageId)}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	if success then
		return Message.new(response)
	end

	return nil
end

local function GetGuild(id: string) : Guild?
	if not id then return end

	local url = `{Endpoints.GET_GUILD:format(id)}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Guild.new(response)
end
local function GetMember(userId: string, guildId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_MEMBER:format(guildId, userId)}`

	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Member.new(response, guildId)
end
------------------------------ Interaction
function Interaction.new(data: DiscordTypes.InteractionData) : Interaction
	local self = setmetatable({}, Interaction)

	for key, value in data do
		self[key] = value
	end

	if self.member then
		self.member = Member.new(self.member, self.guild_id)
	end

	if self.channel_id then
		self.channel = GetChannel(self.channel_id)
	end

	if self.guild_id then
		self.guild = GetGuild(self.guild_id)
	end

	return self
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
	local url = `{Endpoints.DELETE_MESSAGE:format(self.channel_id, self.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

function Message:Reply(content: string, embeds: {DiscordTypes.EmbedData}?)
	return self.channel:Send(content, embeds, {
		type = 0,
		message_id = self.id,
		channel_id = self.channel_id,
		guild_id = self.channel.guild_id
	})
end

function Message:AddReaction(emoji: string)
	local url = `{Endpoints.CREATE_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji))}`

	return Network.Request({
		method = "PUT",
		endpoint = url,
		body = ""
	})
end

function Message:RemoveReaction(emoji: string, userId: string?)
	local url = `{Endpoints.DELETE_USER_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji), userId or "@me")}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

function Message:RemoveAllReactions()
	local url = `{Endpoints.DELETE_ALL_REACTIONS:format(self.channel_id, self.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
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
	local url = `{Endpoints.CREATE_MESSAGE:format(self.id)}`

	return Network.Request({
		method = "POST",
		endpoint = url,
		body = {
			content = content,
			embeds = embeds,
			message_reference = reference 
		}
	})
end

function Channel:Delete(message_id: string)
	local url = `{Endpoints.DELETE_MESSAGE:format(self.id, message_id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

function Channel:GetMessage(id: string) : Message
	local msg = GetMessageInChannel(self.id, id)

	return msg
end

function Channel:Modify(data: DiscordTypes.ChannelData & {icon: string?}) : (boolean, {any}?)
	local url = `{Endpoints.MODIFY_CHANNEL:format(self.id)}`

	local body = data :: {[string]: any}
	return Network.Request({
		method = "PATCH",
		endpoint = url,
		body = body
	})
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
	local url = `{Endpoints.CREATE_DM}`

	if (self :: User).bot then return false, {message = "Bots cannot DM bots!"} end

	local response = Network.Request({
		method = "POST",
		endpoint = url,
		body = {recipient_id = self.id}
	})

	return Channel.new(response)
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
	local url = `{Endpoints.REMOVE_GUILD_MEMBER:format(self.guild.id, self.user.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

function Member:Ban(delete_message_seconds: number?)
	local url = `{Endpoints.CREATE_GUILD_BAN:format(self.guild.id, self.user.id)}`

	return Network.Request({
		method = "PUT",
		endpoint = url,
		body = {delete_message_seconds = delete_message_seconds}
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
	local url = `{Endpoints.GET_GUILD_MEMBER:format(self.id, userId)}`

	local response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Member.new(response, self)
end

function Guild:BulkBan(userIds: {string}, delete_message_seconds: number?)
	local url = `{Endpoints.BULK_GUILD_BAN:format(self.id)}`

	return Network.Request({
		method = "POST",
		endpoint = url,
		body = {
			user_ids = userIds,
			delete_message_seconds = delete_message_seconds
		}
	})
end

function Guild:CreateRole(name: string, permissions: string, color: number, hoist: boolean, icon: string?, unicode_emoji: string?, mentionable: boolean)
	local url = `{Endpoints.CREATE_GUILD_ROLE:format(self.id)}`

	local success, response = Network.Request({
		method = "POST",
		endpoint = url,
		body = {
			name = name,
			permissions = permissions,
			color = color,
			hoist = hoist,
			icon = icon,
			unicode_emoji = unicode_emoji,
			mentionable = mentionable
		}
	})

	return success, response
end

function Guild:GetRoles() : ({DiscordTypes.RoleData} | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_ROLES:format(self.id)}`
	
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end

function Guild:GetRole(id: string) : (DiscordTypes.RoleData? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end	

function Guild:DeleteRole(id: string) : (boolean, {any}?)
	local url = `{Endpoints.DELETE_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "DELETE",
		endpoint = url
	})

	return success, response
end

function Guild:ModifyRole(id: string, data: {name: string?, permissions: string?, color: number?, hoist: boolean?, icon: string?, unicode_emoji: string?, mentionable: boolean?}) : (boolean, {any}?)
	local url = `{Endpoints.MODIFY_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "PATCH",
		endpoint = url,
		body = data
	})

	return success, response
end

function Guild:MoveRole(id: string, position: number) : (boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_ROLES:format(self.id)}`

	return Network.Request({
		method = "PATCH",
		endpoint = url,
		body = {
			id = id,
			position = position
		}
	})
end

function Guild:GetVanityURL() : ({code: string, uses: number}? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_VANITY_URL:format(self.id)}`

	local response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end

function Guild:CreateChannel(data: DiscordTypes.CreateGuildChannelData) : (Channel? | boolean, {any}?)
	local url = `{Endpoints.CREATE_GUILD_CHANNEL:format(self.id)}`

	local body = data :: {[string]: any}
	local response = Network.Request({
		method = "POST",
		endpoint = url,
		body = body
	})

	return Channel.new(response)
end
------------------------------
return {
	Message = Message,
	User = User,
	Channel = Channel,
	Guild = Guild,
	Member = Member,
	Interaction = Interaction,

	GetChannel = GetChannel,
	GetUser = GetUser,
	GetMessage = GetMessage,
	GetGuild = GetGuild,
	GetMember = GetMember
}