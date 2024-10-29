local Event = require("../Classes/Event")

local Objects = require("../Classes/Objects")
local Commands = require("./Commands")
local Enum = require("./Enum")
local Bot = require("./Bot")
local Client = {}

Client.User = nil

local DiscordTypes = require("./DiscordTypes")
type Payload = DiscordTypes.Payload

local eventCallbacks = {
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

	["READY"] = {
		callback = function(payload: Payload)
			Bot.RESUME_URL = payload.d.resume_gateway_url
			Bot.SESSION_ID = payload.d.session_id
		end,

		aliases = {"ready", "Ready"},

		event = Event.new()
	}
}

function Client.On(event: string, callback: (...any) -> ()) : Event.Connection?
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

function Client.Fire(event: string, payload: Payload, shard_id: number?)
	if payload.t == "INTERACTION_CREATE" then
		if payload.d.type == Enum.INTERACTION_TYPE.APPLICATION_COMMAND then
			Commands.HandleInteraction(payload.d, shard_id)
		end

		return
	end

	if not eventCallbacks[event] then
		return
	end

	local callbackInfo = eventCallbacks[event]

	callbackInfo.event:Fire(callbackInfo.callback(payload, shard_id))
end



return Client