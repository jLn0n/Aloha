local Event = require("../Util/Event")

local Objects = require("../Classes/Objects")
local Commands = require("./Commands")
local Enum = require("./Enum")
local Client = {}

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
			return Objects.GetMessage(payload.d, true)
		end,

		aliases = {"message_delete", "MessageDelete"},

		event = Event.new()
	},

	["READY"] = {
		callback = function(_payload: Payload)
			print("Bot is ready.")
		end,

		aliases = {"ready", "Ready"},

		event = Event.new()
	}
}

function Client.On(event: string, callback: (...any) -> ()) : Event.Connection
	return eventCallbacks[event].event:Connect(callback)
end

function Client.Fire(event: string, payload: Payload)
	if payload.t == "INTERACTION_CREATE" then
		
		if payload.d.type == Enum.INTERACTION_TYPE.APPLICATION_COMMAND then
			Commands.HandleInteraction(payload.d)
		end

		return
	end

	local callbackInfo = eventCallbacks[event]

	if not callbackInfo then
		for _, info in eventCallbacks do
			if table.find(info.aliases, event) then
				callbackInfo = info

				break
			end
		end

		if not callbackInfo then
			print(`Callback for {event} not found.`)
			return
		end
	end

	print(`Firing {event} event.`)
	callbackInfo.event:Fire(callbackInfo.callback(payload))
end

return Client