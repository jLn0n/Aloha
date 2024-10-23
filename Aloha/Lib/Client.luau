local Event = require("../Util/Event")
local WebsocketEvents = require("./WebsocketEvents")

local Message = require("../Classes/Message")

local Client = {}

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}

local eventCallbacks = {
	["messageCreate"] = {
		callback = function(payload: Payload)
			return Message.new(payload.d)
		end,

		event = Event.new()
	},

	["messageUpdate"] = {
		callback = function(payload: Payload)
			return Message.new(payload.d)
		end,

		event = Event.new()
	},

	["messageDelete"] = {
		callback = function(payload: Payload)
			return Message.new(payload.d)
		end,

		event = Event.new()
	},

	["ready"] = {
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