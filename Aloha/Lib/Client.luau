local Event = require("../Util/Event")
local WebsocketEvents = require("./WebsocketEvents")

local Objects = require("../Classes/Objects")
local Commands = require("./Commands")
local Enum = require("./Enum")
local Client = {}

local DiscordTypes = require("./DiscordTypes")
type Payload = DiscordTypes.Payload

local eventCallbacks = {
	["MessageCreate"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		event = Event.new()
	},

	["MessageUpdate"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d)
		end,

		event = Event.new()
	},

	["MessageDelete"] = {
		callback = function(payload: Payload)
			return Objects.GetMessage(payload.d, true)
		end,

		event = Event.new()
	},

	["Ready"] = {
		callback = function(_payload: Payload)
			print("Bot is ready.")
		end,

		event = Event.new()
	}
}

function Client.On(event: string, callback: (...any) -> ()) : Event.Connection
	return eventCallbacks[event].event:Connect(callback)
end

function Client.Fire(event: string, payload: Payload)
	if payload.t == "INTERACTION_CREATE" then
		
		print(payload.d.type, Enum.INTERACTION_TYPE.APPLICATION_COMMAND)
		if payload.d.type == Enum.INTERACTION_TYPE.APPLICATION_COMMAND then
			Commands.HandleInteraction(payload.d)
		end

		return
	end
	
	if not WebsocketEvents[event] then
		print(`Event {event} not found.`)
		return
	end

	local callbackInfo = eventCallbacks[WebsocketEvents[event]]

	if not callbackInfo then
		print(`Callback for {WebsocketEvents[event]} not found.`)
		return
	end

	print(`Firing {WebsocketEvents[event]} event.`)
	callbackInfo.event:Fire(callbackInfo.callback(payload))
end

return Client