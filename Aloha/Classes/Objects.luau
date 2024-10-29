--[=[
	@class Objects
	Class to create Discord objects.
]=]

--[=[
	@class Message
	Message object wrapper.
]=]
local Message = {}
Message.__index = Message

--[=[
	@class User
	User object wrapper.
]=]
local User = {}
User.__index = User

--[=[
	@class Channel
	Channel object wrapper.
]=]
local Channel = {}
Channel.__index = Channel

--[=[
	@class Guild
	Guild object wrapper.
]=]
local Guild = {}
Guild.__index = Guild

--[=[
	@class Member
	Member object wrapper.
]=]
local Member = {}
Member.__index = Member

--[=[
	@class Interaction
	Interaction object wrapper.
]=]
local Interaction = {}
Interaction.__index = Interaction
-----------------------------

local DiscordTypes = require("../Lib/DiscordTypes")
local Bot = require("../Lib/Bot")
local Endpoints = require("../Lib/Endpoints")
local Network = require("../Lib/Network")
local task = require("@lune/task")

--[=[
	@within Objects
	@type Guild {}
	A guild object.
]=]
export type Guild = DiscordTypes.GuildData & {

} & typeof(Guild)

--[=[
	@within Objects
	@type User {}
	A user object.
]=]
export type User = DiscordTypes.UserData & {
} & typeof(User)

--[=[
	@within Objects
	@type Channel {guild: Guild}
	A channel object.
]=]
export type Channel = DiscordTypes.ChannelData & {
	guild: Guild
} & typeof(Channel)

--[=[
	@within Objects
	@type Interaction {id: DiscordTypes.snowflake, application_id: DiscordTypes.snowflake, type: number, data: (DiscordTypes.ApplicationCommandInteractionData | DiscordTypes.MessageComponentInteractionData)?, guild: Guild?, guild_id: DiscordTypes.snowflake?, channel: Channel?, channel_id: DiscordTypes.snowflake?, member: Member?, user: User?, token: string, version: number, message: Message, app_permissions: string, locale: string, guild_locale: string, entitlements: {DiscordTypes.EntitlementData}?, authorizing_integration_owners: {[number]: DiscordTypes.snowflake}, context: number}
	An interaction object.
]=]
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

--[=[
	@within Objects
	@type Message {channel: Channel, author: User, mentions: {User}, id: DiscordTypes.snowflake, channel_id: DiscordTypes.snowflake, content: string, timestamp: string, edited_timestamp: string?, tts: boolean, mention_everyone: boolean, mention_roles: {number}, mention_channels: {DiscordTypes.ChannelMentionData}, attachments: {DiscordTypes.AttachmentData}, embeds: {DiscordTypes.EmbedData}, reactions: {DiscordTypes.ReactionData}?, nonce: (number | string)?, pinned: boolean, webhook_id: DiscordTypes.snowflake?, type: number, activity: DiscordTypes.ActivityData?, application: DiscordTypes.ApplicationData?, application_id: DiscordTypes.snowflake?, flags: number?, message_reference: DiscordTypes.MessageReferenceData?, message_snapshots: {DiscordTypes.MessageSnapshotData}?, referenced_message: Message?, interaction_metadata: DiscordTypes.InteractionMetadataData?, interaction: DiscordTypes.InteractionData?, thread: DiscordTypes.ChannelData?, components: {DiscordTypes.ComponentData}?, sticker_items: {DiscordTypes.StickerItemData}?, stickers: {DiscordTypes.StickerData}?, position: number?, role_subscription_data: DiscordTypes.RoleSubscriptionData?, resolved: DiscordTypes.ResolvedData?, poll: DiscordTypes.PollData?, call: DiscordTypes.CallData?}
	A message object.
]=]
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

--[=[
	@within Objects
	@type Member {user: User?, nick: string?, avatar: string?, banner: string?, roles: {number}?, joined_at: string, premium_since: string?, deaf: boolean, mute: boolean, pending: boolean?, permissions: string?, communication_disabled_until: string?, avatar_decoration_data: DiscordTypes.AvatarDecorationData?}
	A member object.
]=]
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
--[=[
	@within Objects
	@param id string -- The channel ID
	@return Channel -- The channel object
	Gets a channel by ID.
]=]
local function GetChannel(id: string) : Channel
	local url = `{Endpoints.GET_CHANNEL:format(id)}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Channel.new(response)
end

--[=[
	@within Objects
	@param data DiscordTypes.UserData -- The user data
	@return User -- The user object
	Gets a user by ID.
]=]
local function GetUser(data: DiscordTypes.UserData) : User
	return User.new(data)
end

--[=[
	@within Objects
	@param data DiscordTypes.MessageData -- The message data
	@return Message -- The message object
	Gets a message by ID.
]=]
local function GetMessage(data: DiscordTypes.MessageData) : Message
	return Message.new(data)
end

--[=[
	@within Objects
	@param channelId string -- The channel ID
	@param messageId string -- The message ID
	@return Message? -- The message object if found
	Gets a message by ID in a channel.
]=]
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

--[=[
	@within Objects
	@param id string -- The guild ID
	@return Guild? -- The guild object if found
	Gets a guild by ID.
]=]
local function GetGuild(id: string) : Guild?
	if not id then return end

	local url = `{Endpoints.GET_GUILD:format(id)}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Guild.new(response)
end

--[=[
	@within Objects
	@param userId string -- The user ID
	@param guildId string -- The guild ID
	@return (Member? | boolean, {any}?) -- The member object if found
	Gets a member by ID in a guild.
]=]
local function GetMember(userId: string, guildId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_MEMBER:format(guildId, userId)}`

	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Member.new(response, guildId)
end
------------------------------ Interaction
--[=[
	@within Objects
	@param data DiscordTypes.InteractionData -- The interaction data
	@return Interaction -- The interaction object
	Creates a new interaction object.
]=]
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
--[=[
	@within Objects
	@param data DiscordTypes.MessageData -- The message data
	@return Message -- The message object
	Creates a new message object.
]=]
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

--[=[
	@within Message
	@return boolean -- Whether the message was deleted
	Deletes the message.
]=]
function Message:Delete()
	local url = `{Endpoints.DELETE_MESSAGE:format(self.channel_id, self.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

--[=[
	@within Message
	@param content string -- The message content
	@param embeds {DiscordTypes.EmbedData}? -- Optional embeds to send
	@return boolean -- Whether the message was sent
	Replies to the message.
]=]
function Message:Reply(content: string, embeds: {DiscordTypes.EmbedData}?)
	return self.channel:Send(content, embeds, {
		type = 0,
		message_id = self.id,
		channel_id = self.channel_id,
		guild_id = self.channel.guild_id
	})
end

--[=[
	@within Message
	@param emoji string -- The emoji to add
	@return boolean -- Whether the reaction was added
	Adds a reaction to the message.
]=]
function Message:AddReaction(emoji: string)
	local url = `{Endpoints.CREATE_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji))}`

	return Network.Request({
		method = "PUT",
		endpoint = url,
		body = ""
	})
end

--[=[
	@within Message
	@param emoji string -- The emoji to remove
	@param userId string? -- Optional user ID to remove reaction from
	@return boolean -- Whether the reaction was removed
	Removes a reaction from the message.
]=]
function Message:RemoveReaction(emoji: string, userId: string?)
	local url = `{Endpoints.DELETE_USER_REACTION:format(self.channel_id, self.id, Network.UrlEncode(emoji), userId or "@me")}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

--[=[
	@within Message
	@return boolean -- Whether all reactions were removed
	Removes all reactions from the message.
]=]
function Message:RemoveAllReactions()
	local url = `{Endpoints.DELETE_ALL_REACTIONS:format(self.channel_id, self.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end
------------------------------ Channel
--[=[
	@within Objects
	@param data DiscordTypes.ChannelData -- The channel data
	@return Channel -- The channel object
	Creates a new channel object.
]=]
function Channel.new(data: DiscordTypes.ChannelData) : Channel
	local self = setmetatable({}, Channel)

	for key, value in data do
		self[key] = value
	end

	self.guild = GetGuild(self.guild_id)

	return self
end

--[=[
	@within Channel
	@param content string -- The message content
	@param embeds {DiscordTypes.EmbedData}? -- Optional embeds to send
	@param reference DiscordTypes.MessageReferenceData? -- Optional message reference data
	@return boolean -- Whether the message was sent
	Sends a message to the channel.
]=]
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

--[=[
	@within Channel
	@param message_id string -- The message ID to delete
	@return boolean -- Whether the message was deleted
	Deletes a message in the channel.
]=]
function Channel:Delete(message_id: string)
	local url = `{Endpoints.DELETE_MESSAGE:format(self.id, message_id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

--[=[
	@within Channel
	@param id string -- The message ID
	@return Message -- The message object
	Gets a message in the channel.
]=]
function Channel:GetMessage(id: string) : Message
	local msg = GetMessageInChannel(self.id, id)

	return msg
end

--[=[
	@within Channel
	@param data DiscordTypes.ChannelData & {icon: string?} -- The channel data to modify
	@return (boolean, {any}?) -- Whether the channel was modified and any response data
	Modifies the channel.
]=]
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
--[=[
	@within Objects
	@param data DiscordTypes.UserData -- The user data
	@return User -- The user object
	Creates a new user object.
]=]
function User.new(data: DiscordTypes.UserData) : User
	local self = setmetatable({}, User)

	for key, value in data do
		self[key] = value
	end

	return self
end

--[=[
	@within User
	@return (Channel? | boolean, {any}?) -- The DM channel if created
	Creates or gets a DM channel with the user.
]=]
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

--[=[
	@within Objects
	@param data DiscordTypes.MemberData -- The member data
	@param guild Guild? | string? -- The guild object or ID
	@return Member -- The member object
	Creates a new member object.
]=]
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

--[=[
	@within Member
	@return boolean -- Whether the member was kicked
	Kicks the member from the guild.
]=]
function Member:Kick()
	local url = `{Endpoints.REMOVE_GUILD_MEMBER:format(self.guild.id, self.user.id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

--[=[
	@within Member
	@param delete_message_seconds number? -- Optional number of seconds of messages to delete
	@return boolean -- Whether the member was banned
	Bans the member from the guild.
]=]
function Member:Ban(delete_message_seconds: number?)
	local url = `{Endpoints.CREATE_GUILD_BAN:format(self.guild.id, self.user.id)}`

	return Network.Request({
		method = "PUT",
		endpoint = url,
		body = {delete_message_seconds = delete_message_seconds}
	})
end
------------------------------ Guild
--[=[
	@within Objects
	@param data DiscordTypes.GuildData -- The guild data
	@return Guild -- The guild object
	Creates a new guild object.
]=]
function Guild.new(data: DiscordTypes.GuildData) : Guild
	local self = setmetatable({}, Guild)

	for key, value in data do
		self[key] = value
	end

	return self
end

--[=[
	@within Guild
	@param id string -- The channel ID
	@return Channel -- The channel object
	Gets a channel in the guild.
]=]
function Guild:GetChannel(id: string) : Channel
	return GetChannel(id)
end

--[=[
	@within Guild
	@param userId string -- The user ID
	@return (Member? | boolean, {any}?) -- The member object if found
	Gets a member in the guild.
]=]
function Guild:GetMember(userId: string) : (Member? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_MEMBER:format(self.id, userId)}`

	local response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return Member.new(response, self)
end

--[=[
	@within Guild
	@param userIds {string} -- Array of user IDs to ban
	@param delete_message_seconds number? -- Optional number of seconds of messages to delete
	@return boolean -- Whether the users were banned
	Bulk bans users from the guild.
]=]
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

--[=[
	@within Guild
	@param name string -- The role name
	@param permissions string -- The role permissions
	@param color number -- The role color
	@param hoist boolean -- Whether the role should be displayed separately
	@param icon string? -- Optional role icon
	@param unicode_emoji string? -- Optional role unicode emoji
	@param mentionable boolean -- Whether the role should be mentionable
	@return (boolean, {any}?) -- Whether the role was created and the response data
	Creates a new role in the guild.
]=]
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

--[=[
	@within Guild
	@return ({DiscordTypes.RoleData} | boolean, {any}?) -- Array of roles if successful
	Gets all roles in the guild.
]=]
function Guild:GetRoles() : ({DiscordTypes.RoleData} | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_ROLES:format(self.id)}`
	
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end

--[=[
	@within Guild
	@param id string -- The role ID
	@return (DiscordTypes.RoleData? | boolean, {any}?) -- The role data if found
	Gets a role in the guild.
]=]
function Guild:GetRole(id: string) : (DiscordTypes.RoleData? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end	
--[=[
	@within Guild
	@param id string -- The role ID to delete
	@return (boolean, {any}?) -- Success status and response data
	Deletes a role from the guild.
]=]
function Guild:DeleteRole(id: string) : (boolean, {any}?)
	local url = `{Endpoints.DELETE_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "DELETE",
		endpoint = url
	})

	return success, response
end

--[=[
	@within Guild
	@param id string -- The role ID to modify
	@param data {name: string?, permissions: string?, color: number?, hoist: boolean?, icon: string?, unicode_emoji: string?, mentionable: boolean?} -- The data to modify
	@return (boolean, {any}?) -- Success status and response data
	Modifies a role in the guild.
]=]
function Guild:ModifyRole(id: string, data: {name: string?, permissions: string?, color: number?, hoist: boolean?, icon: string?, unicode_emoji: string?, mentionable: boolean?}) : (boolean, {any}?)
	local url = `{Endpoints.MODIFY_GUILD_ROLE:format(self.id, id)}`

	local success, response = Network.Request({
		method = "PATCH",
		endpoint = url,
		body = data
	})

	return success, response
end

--[=[
	@within Guild
	@param id string -- The role ID to move
	@param position number -- The new position
	@return (boolean, {any}?) -- Success status and response data
	Changes a role's position in the guild's role hierarchy.
]=]
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

--[=[
	@within Guild
	@return ({code: string, uses: number}? | boolean, {any}?) -- The vanity URL data if successful
	Gets the guild's vanity URL if it has one.
]=]
function Guild:GetVanityURL() : ({code: string, uses: number}? | boolean, {any}?)
	local url = `{Endpoints.GET_GUILD_VANITY_URL:format(self.id)}`

	local response = Network.Request({
		method = "GET",
		endpoint = url
	})

	return response
end

--[=[
	@within Guild
	@param data DiscordTypes.CreateGuildChannelData -- The channel creation data
	@return (Channel? | boolean, {any}?) -- The created channel if successful
	Creates a new channel in the guild.
]=]
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