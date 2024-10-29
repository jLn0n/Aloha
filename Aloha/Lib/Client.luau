--[=[
	@class Client
	The main Discord client class that handles events and interactions.
]=]

local Event = require("../Classes/Event")

local Objects = require("../Classes/Objects")
local Commands = require("./Commands")
local Enum = require("./Enum")
local Bot = require("./Bot")
local Client = {}

--[=[
	@prop User any
	@within Client
	The bot's user object.
]=]
Client.User = nil

local DiscordTypes = require("./DiscordTypes")
type Payload = DiscordTypes.Payload

--[=[
	@private
	@type EventCallbacks {[string]: {callback: (Payload, number?) -> any, aliases: {string}, event: Event}}
	@within Client
	Table of event callbacks and their associated data.
]=]
local eventCallbacks = {	
	["READY"] = {
		callback = function(payload: Payload, shard_id: number)
			Bot.Shards[shard_id].ResumeURL = payload.d.resume_gateway_url
			Bot.Shards[shard_id].SessionID = payload.d.session_id
		end,

		aliases = {"ready", "Ready"},

		event = Event.new()
	},

	-- MESSAGE EVENTS
	["MESSAGE_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		aliases = {"message_create", "MessageCreate"},

		event = Event.new()
	},

	["MESSAGE_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		aliases = {"message_update", "MessageUpdate"},

		event = Event.new()
	},

	["MESSAGE_DELETE"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		aliases = {"message_delete", "MessageDelete"},

		event = Event.new()
	},

	["MESSAGE_REACTION_ADD"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"message_reaction_add", "MessageReactionAdd"},

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"message_reaction_remove", "MessageReactionRemove"},

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE_ALL"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"message_reaction_remove_all", "MessageReactionRemoveAll"},

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE_EMOJI"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"message_reaction_remove_emoji", "MessageReactionRemoveEmoji"},

		event = Event.new()
	},

	-- CHANNEL EVENTS
	["CHANNEL_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetChannel(payload.d.id)
		end,

		aliases = {"channel_create", "ChannelCreate"},

		event = Event.new()
	},

	["CHANNEL_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetChannel(payload.d.id)
		end,

		aliases = {"channel_update", "ChannelUpdate"},

		event = Event.new()
	},

	["CHANNEL_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"channel_delete", "ChannelDelete"},

		event = Event.new()
	},

	["CHANNEL_PINS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"channel_pins_update", "ChannelPinsUpdate"},

		event = Event.new()
	},

	-- GUILD EVENTS
	["GUILD_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetGuild(payload.d.id)
		end,

		aliases = {"guild_create", "GuildCreate"},

		event = Event.new()
	},

	["GUILD_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetGuild(payload.d.id)
		end,

		aliases = {"guild_update", "GuildUpdate"},

		event = Event.new()
	},

	["GUILD_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_delete", "GuildDelete"},

		event = Event.new()
	},

	["GUILD_ROLE_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_role_create", "GuildRoleCreate"},

		event = Event.new()
	},

	["GUILD_ROLE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_role_update", "GuildRoleUpdate"},

		event = Event.new()
	},

	["GUILD_ROLE_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_role_delete", "GuildRoleDelete"},

		event = Event.new()
	},

	["GUILD_MEMBER_ADD"] = {
		callback = function(payload: Payload)
			return Objects.GetMember(payload.d.user.id, payload.d.guild_id)
		end,

		aliases = {"guild_member_add", "GuildMemberAdd"},

		event = Event.new()
	},

	["GUILD_MEMBER_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMember(payload.d.user.id, payload.d.guild_id)
		end,

		aliases = {"guild_member_update", "GuildMemberUpdate"},

		event = Event.new()
	},

	["GUILD_MEMBER_REMOVE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_member_remove", "GuildMemberRemove"},

		event = Event.new()
	},

	["USER_UPDATE"] = {
		callback = function(payload: Payload)
			return Bot.Client
		end,

		aliases = {"user_update", "UserUpdate"},

		event = Event.new()
	},

	-- MISC

	["PRESENCE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"presence_update", "PresenceUpdate"},

		event = Event.new()
	},

	["VOICE_STATE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"voice_state_update", "VoiceStateUpdate"},

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_scheduled_event_create", "GuildScheduledEventCreate"},	

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_scheduled_event_update", "GuildScheduledEventUpdate"},	

		event = Event.new()
	},	

	["GUILD_SCHEDULED_EVENT_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_scheduled_event_delete", "GuildScheduledEventDelete"},	

		event = Event.new()
	},

	-- THREAD EVENTS

	["THREAD_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_create", "ThreadCreate"},

		event = Event.new()
	},

	["THREAD_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_update", "ThreadUpdate"},

		event = Event.new()
	},

	["THREAD_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_delete", "ThreadDelete"},

		event = Event.new()
	},

	["THREAD_LIST_SYNC"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_list_sync", "ThreadListSync"},

		event = Event.new()
	},

	["THREAD_MEMBER_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_member_update", "ThreadMemberUpdate"},

		event = Event.new()
	},

	["THREAD_MEMBERS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"thread_members_update", "ThreadMembersUpdate"},

		event = Event.new()
	},

	["INTERACTION_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"interaction_create", "InteractionCreate"},

		event = Event.new()
	},

	["GUILD_INTEGRATIONS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"guild_integrations_update", "GuildIntegrationsUpdate"},	

		event = Event.new()
	},

	["APPLICATION_COMMAND_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"application_command_create", "ApplicationCommandCreate"},

		event = Event.new()
	},

	["APPLICATION_COMMAND_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"application_command_update", "ApplicationCommandUpdate"},

		event = Event.new()
	},

	["APPLICATION_COMMAND_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"application_command_delete", "ApplicationCommandDelete"},

		event = Event.new()
	},

	["WEBHOOKS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"webhooks_update", "WebhooksUpdate"},

		event = Event.new()
	},

	["INVITE_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"invite_delete", "InviteDelete"},

		event = Event.new()
	},

	["TYPING_START"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		aliases = {"typing_start", "TypingStart"},

		event = Event.new()
	},
}

type EventString = "READY" | "MESSAGE_CREATE" | "MESSAGE_UPDATE" | "MESSAGE_DELETE" | "MESSAGE_REACTION_ADD" | "MESSAGE_REACTION_REMOVE" | "MESSAGE_REACTION_REMOVE_ALL" | "MESSAGE_REACTION_REMOVE_EMOJI" | "CHANNEL_CREATE" | "CHANNEL_UPDATE" | "CHANNEL_DELETE" | "CHANNEL_PINS_UPDATE" | "GUILD_CREATE" | "GUILD_UPDATE" | "GUILD_DELETE" | "GUILD_ROLE_CREATE" | "GUILD_ROLE_UPDATE" | "GUILD_ROLE_DELETE" | "GUILD_MEMBER_ADD" | "GUILD_MEMBER_UPDATE" | "GUILD_MEMBER_REMOVE" | "USER_UPDATE" | "PRESENCE_UPDATE" | "VOICE_STATE_UPDATE" | "GUILD_SCHEDULED_EVENT_CREATE" | "GUILD_SCHEDULED_EVENT_UPDATE" | "APPLICATION_COMMAND_DELETE" | "WEBHOOKS_UPDATE" | "INVITE_DELETE" | "TYPING_START"

--[=[
	@function On
	@within Client
	@param event EventString -- The event to listen for
	@param callback function -- The callback function to run when the event fires
	@return Event.Connection? -- The event connection, if successful
	
	Registers an event handler for the specified Discord gateway event.
]=]
function Client.On(event: EventString, callback: (...any) -> any) : Event.Connection?
	local callbackInfo = eventCallbacks[event]

	if not callbackInfo then
		for _, info in eventCallbacks do
			if table.find(info.aliases, event) then
				callbackInfo = info

				break
			end
		end

		if not callbackInfo then 
			return
		end
	end


	return callbackInfo.event:Connect(callback)
end

--[=[
	@function Fire
	@within Client
	@param event string -- The event name to fire
	@param payload Payload -- The event payload
	@param shard_id number? -- Optional shard ID
	
	Fires a Discord gateway event internally.
]=]
function Client.Fire(event: string, payload: Payload, shard_id: number?)
	if payload.t == "INTERACTION_CREATE" then
		if payload.d.type == Enum.INTERACTION_TYPE.APPLICATION_COMMAND then
			Commands.HandleInteraction(payload.d, shard_id)
		end
	end

	local callbackInfo = eventCallbacks[event]

	if not callbackInfo then
		return
	end

	callbackInfo.event:Fire(callbackInfo.callback(payload, shard_id))
end



return Client