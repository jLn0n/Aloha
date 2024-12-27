--[=[
	@class Client
	The main Discord client class that handles events and interactions.
]=]

local Event = require("../Classes/Event")
local Endpoints = require("./Endpoints")
local Network = require("./Network")
local Objects = require("../Classes/Objects")
local Commands = require("./Commands")
local Enum = require("./Enum")
local Bot = require("./Bot")
local Components = require("./Components")
local Cache = require("../Util/Cache")
local Snowflake = require("../Classes/Snowflake")
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
	@type EventCallbacks {[string]: {callback: (Payload, number?) -> any, event: Event}}
	@within Client
	Table of event callbacks and their associated data.
]=]
local eventCallbacks = {
	["APPLICATION_COMMAND_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["APPLICATION_COMMAND_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["APPLICATION_COMMAND_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["AUTO_MODERATION_ACTION_EXECUTION"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["AUTO_MODERATION_RULE_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["AUTO_MODERATION_RULE_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["AUTO_MODERATION_RULE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["CHANNEL_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetChannel(Snowflake.new(payload.d.id))
		end,

		event = Event.new()
	},

	["CHANNEL_DELETE"] = {
		callback = function(payload: Payload)
			Cache.Channels[payload.d.id] = nil
			return payload.d
		end,

		event = Event.new()
	},

	["CHANNEL_PINS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["CHANNEL_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetChannel(Snowflake.new(payload.d.id))
		end,

		event = Event.new()
	},

	["GUILD_AUDIT_LOG_ENTRY_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetGuild(Snowflake.new(payload.d.id), payload.d)
		end,

		event = Event.new()
	},

	["GUILD_DELETE"] = {
		callback = function(payload: Payload)
			Cache.Guilds[payload.d.id] = nil
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_EMOJIS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_INTEGRATIONS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_MEMBER_ADD"] = {
		callback = function(payload: Payload)
			return Objects.GetMember(payload.d.user.id, payload.d.guild_id, payload.d)
		end,

		event = Event.new()
	},

	["GUILD_MEMBER_REMOVE"] = {
		callback = function(payload: Payload)
			for index, member in Cache.Members:iter() do
				if member.user_id == payload.d.user.id and member.guild_id == payload.d.guild_id then
					Cache.Members:RemoveIndex(index)
					break
				end
			end

			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_MEMBER_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMember(payload.d.user.id, payload.d.guild_id, payload.d)
		end,

		event = Event.new()
	},

	["GUILD_ROLE_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_ROLE_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_ROLE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_USER_ADD"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SCHEDULED_EVENT_USER_REMOVE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SOUNDBOARD_SOUND_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SOUNDBOARD_SOUND_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_SOUNDBOARD_SOUND_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_STICKERS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["GUILD_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetGuild(Snowflake.new(payload.d.id), payload.d)
		end,

		event = Event.new()
	},

	["INTEGRATION_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["INTEGRATION_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["INTEGRATION_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["INTERACTION_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["INVITE_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["INVITE_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_CREATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		event = Event.new()
	},

	["MESSAGE_DELETE"] = {
		callback = function(payload: Payload)
			for index, msg in Cache.Messages:iter() do
				if msg.id.id == payload.d.id then
					Cache.Messages:RemoveIndex(index)
					break
				end
			end

			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_DELETE_BULK"] = {
		callback = function(payload: Payload)
			local ids = payload.d.ids

			for _, id in ids do
				for index, msg in Cache.Messages:iter() do
					if msg.id.id == id then
						Cache.Messages:RemoveIndex(index)
						break
					end
				end
			end

			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_POLL_VOTE_ADD"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_POLL_VOTE_REMOVE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_REACTION_ADD"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE_ALL"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_REACTION_REMOVE_EMOJI"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["MESSAGE_UPDATE"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		event = Event.new()
	},

	["PRESENCE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["READY"] = {
		callback = function(payload: Payload, shard_id: number)
			Bot.Shards[shard_id].ResumeURL = payload.d.resume_gateway_url
			Bot.Shards[shard_id].SessionID = payload.d.session_id
		end,

		event = Event.new()
	},

	["THREAD_CREATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["THREAD_DELETE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["THREAD_LIST_SYNC"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["THREAD_MEMBER_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["THREAD_MEMBERS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["THREAD_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["TYPING_START"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["USER_UPDATE"] = {
		callback = function(payload: Payload)
			return Bot.Client
		end,

		event = Event.new()
	},

	["VOICE_CHANNEL_EFFECT_SEND"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["VOICE_STATE_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},

	["WEBHOOKS_UPDATE"] = {
		callback = function(payload: Payload)
			return payload.d
		end,

		event = Event.new()
	},
}

type EventString = "READY" | "MESSAGE_CREATE" | "MESSAGE_UPDATE" | "MESSAGE_DELETE" | "MESSAGE_REACTION_ADD" | "MESSAGE_REACTION_REMOVE" 
| "MESSAGE_REACTION_REMOVE_ALL" | "MESSAGE_REACTION_REMOVE_EMOJI" | "CHANNEL_CREATE" | "CHANNEL_UPDATE" | "CHANNEL_DELETE" | "CHANNEL_PINS_UPDATE" 
| "GUILD_CREATE" | "GUILD_UPDATE" | "GUILD_DELETE" | "GUILD_ROLE_CREATE" | "GUILD_ROLE_UPDATE" | "GUILD_ROLE_DELETE" | "GUILD_MEMBER_ADD" | "GUILD_MEMBER_UPDATE" 
| "GUILD_MEMBER_REMOVE" | "USER_UPDATE" | "PRESENCE_UPDATE" | "VOICE_STATE_UPDATE" | "GUILD_SCHEDULED_EVENT_CREATE" | "GUILD_SCHEDULED_EVENT_UPDATE" | "APPLICATION_COMMAND_DELETE" 
| "WEBHOOKS_UPDATE" | "INVITE_DELETE" | "TYPING_START" | "VOICE_CHANNEL_EFFECT_SEND" | "MESSAGE_DELETE_BULK" | "AUTO_MODERATION_RULE_CREATE" | "AUTO_MODERATION_RULE_UPDATE" 
| "AUTO_MODERATION_RULE_DELETE" | "AUTO_MODERATION_ACTION_EXECUTION" | "MESSAGE_POLL_VOTE_ADD" | "MESSAGE_POLL_VOTE_REMOVE" | "GUILD_AUDIT_LOG_ENTRY_CREATE" | "THREAD_CREATE" 
| "THREAD_UPDATE" | "THREAD_DELETE" | "THREAD_LIST_SYNC" | "THREAD_MEMBER_UPDATE"

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

	assert(callbackInfo, `No callback info found for event: {event}`)

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

		if payload.d.type == Enum.INTERACTION_TYPE.APPLICATION_COMMAND_AUTOCOMPLETE then
		end

		if payload.d.type == Enum.INTERACTION_TYPE.MESSAGE_COMPONENT then
			Components.HandleInteraction(payload.d, shard_id)
		end
	end

	local callbackInfo = eventCallbacks[event]

	if not callbackInfo then
		return
	end

	callbackInfo.event:Fire(callbackInfo.callback(payload, shard_id))
end

function Client.Modify(data: {username: string, avatar: string?, banner: string?})
	local url = `{Endpoints.MODIFY_CURRENT_USER}`
	local success, response = Network.Request({
		method = "PATCH",
		endpoint = url,
		body = data
	})

	if success then
		Client.User = Objects.User.new(response)
	end
end

function Client.GetGuilds(fetch: boolean?)
	if not fetch then return Cache.Guilds end

	local url = `{Endpoints.GET_USER_GUILDS}`
	local success, response = Network.Request({
		method = "GET",
		endpoint = url
	})

	if success then
		local t = {}

		for _, guild in response do
			t[guild.id] = Objects.GetGuild(guild.id, guild)
		end

		return t
	end

	return {}
end

function Client.LeaveGuild(guild_id: string)
	local url = `{Endpoints.LEAVE_GUILD:format(guild_id)}`
	local success, _ = Network.Request({
		method = "DELETE",
		endpoint = url
	})

	return success
end

function Client.CreateGuild(data: DiscordTypes.GuildData)
	local url = `{Endpoints.CREATE_GUILD}`
	local success, response = Network.Request({
		method = "POST",
		endpoint = url,
		body = data
	})

	if success then
		return Objects.GetGuild(response.id, response)
	end

	return nil
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@return Webhook -- The webhook object
	Gets a webhook.
]=]
function Client.GetWebhook(id: string)
	local url = `{Endpoints.GET_WEBHOOK:format(id)}`

	return Network.Request({
		method = "GET",
		endpoint = url
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@return Webhook -- The webhook object
	Gets a webhook with a token.
]=]
function Client.GetWebhookWithToken(id: string, token: string)
	local url = `{Endpoints.GET_WEBHOOK_WITH_TOKEN:format(id, token)}`

	return Network.Request({
		method = "GET",
		endpoint = url
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param data {name: string, avatar: string?} -- The webhook data
	@param reason string? -- Optional reason for the webhook modification in audit logs
	@return (boolean, {any}?) -- Whether the webhook was modified and any response data
	Modifies a webhook.
]=]
function Client.ModifyWebhook(id: string, data: {name: string, avatar: string?}, reason: string?)
	local url = `{Endpoints.MODIFY_WEBHOOK:format(id)}`

	local body = data :: {[string]: any}
	return Network.Request({
		method = "PATCH",
		endpoint = url,
		body = body,
		headers = {
			["X-Audit-Log-Reason"] = reason
		}
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param data {name: string, avatar: string?} -- The webhook data
	@param reason string? -- Optional reason for the webhook modification in audit logs
	@return (boolean, {any}?) -- Whether the webhook was modified and any response data
	Modifies a webhook with a token.
]=]
function Client.ModifyWebhookWithToken(id: string, token: string, data: {name: string, avatar: string?}, reason: string?)
	local url = `{Endpoints.MODIFY_WEBHOOK_WITH_TOKEN:format(id, token)}`

	local body = data :: {[string]: any}
	return Network.Request({
		method = "PATCH",
		endpoint = url,
		body = body,
		headers = {
			["X-Audit-Log-Reason"] = reason
		}
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param reason string? -- Optional reason for the webhook deletion in audit logs
	@return boolean -- Whether the webhook was deleted
	Deletes a webhook.
]=]
function Client.DeleteWebhook(id: string, reason: string?)
	local url = `{Endpoints.DELETE_WEBHOOK:format(id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url,
		headers = {
			["X-Audit-Log-Reason"] = reason
		}
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param reason string? -- Optional reason for the webhook deletion in audit logs
	@return boolean -- Whether the webhook was deleted
	Deletes a webhook with a token.
]=]
function Client.DeleteWebhookWithToken(id: string, token: string, reason: string?)
	local url = `{Endpoints.DELETE_WEBHOOK_WITH_TOKEN:format(id, token)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url,
		headers = {
			["X-Audit-Log-Reason"] = reason
		}
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param wait boolean? -- Whether to wait for the webhook to execute
	@param thread_id string? -- The thread ID
	@param data DiscordTypes.ExecuteWebhookData -- The webhook data
	@param files {string}? -- The files to send
	@return (boolean, {any}?) -- Whether the webhook was executed and any response data
	Executes a webhook.
]=]
function Client.ExecuteWebhook(id: string, token: string, wait: boolean?, thread_id: string?, data: DiscordTypes.ExecuteWebhookData, files: {string}?)
	local url = `{Endpoints.EXECUTE_WEBHOOK:format(id, token)}`

	local body = data :: {[string]: any}

	return Network.Request({
		method = "POST",
		endpoint = url,
		files = files,
		query = {
			wait = wait,
			thread_id = thread_id
		},
		body = body
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param message_id string -- The message ID
	@return (boolean, {any}?) -- Whether the message was fetched and any response data
	Gets a webhook message.
]=]
function Client.GetWebhookMessage(id: string, token: string, message_id: string)
	local url = `{Endpoints.GET_WEBHOOK_MESSAGE:format(id, token, message_id)}`

	return Network.Request({
		method = "GET",
		endpoint = url
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param message_id string -- The message ID
	@param data DiscordTypes.ExecuteWebhookData -- The webhook data
	@return (boolean, {any}?) -- Whether the message was edited and any response data
	Edits a webhook message.
]=]
function Client.EditWebhookMessage(id: string, token: string, message_id: string, data: DiscordTypes.ExecuteWebhookData)
	local url = `{Endpoints.EDIT_WEBHOOK_MESSAGE:format(id, token, message_id)}`

	local body = data :: {[string]: any}
	return Network.Request({
		method = "PATCH",
		endpoint = url,
		body = body
	})
end

--[=[
	@within Client
	@param id string -- The webhook ID
	@param token string -- The webhook token
	@param message_id string -- The message ID
	@return boolean -- Whether the message was deleted
	Deletes a webhook message.
]=]
function Client.DeleteWebhookMessage(id: string, token: string, message_id: string)
	local url = `{Endpoints.DELETE_WEBHOOK_MESSAGE:format(id, token, message_id)}`

	return Network.Request({
		method = "DELETE",
		endpoint = url
	})
end

return Client