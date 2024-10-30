--[=[
	@class Event
	Class to create events.
]=]
local task = require("@lune/task")

local Event = {}
Event.__index = Event
Event.__class = "Event"

export type Event<T...> = {
	Callbacks : {[(T...)->any]: any};
	Waiting : {thread};
	Connect : (Event<T...>, func : (T...)->any) -> Connection,
	Fire : (Event<T...>, T...) -> nil,
	Wait : (Event<T...>, number?) -> T...
}
export type Connection = {
	Connected : boolean,
	Disconnect: () -> nil
}

--[=[
	Creates a new Event.
	@within Event
	@return Event
]=]
function Event.new<T...>() : Event<T...>
	local self = setmetatable({}, Event)
	self.Callbacks = {}
	self.Waiting = {}

	return self
end

--[=[
	Connects a function to the event.
	@within Event
	@param func (any)->any
	@return Connection?
]=]
function Event:Connect<T...>(func: (T...)->any) : Connection?
	local connection = {}
	connection.Connected = true

	function connection.Disconnect(cself)
		self.Callbacks[func] = nil
		cself.Connected = false
	end
	
	self.Callbacks[func] = newproxy()

	return connection
end

--[=[
	Fires the event.
	@within Event
	@param ... any
]=]
function Event:Fire<T...>(...: T...)
	for func in pairs(self.Callbacks) do
		coroutine.wrap(func)(...)
	end

	for _, thread in pairs(self.Waiting) do
		table.remove(self.Waiting, thread)
		coroutine.resume(thread , ...)
	end
end

--[=[
	Waits for the event to fire.
	@within Event
	@param timeout number?
	@return any
]=]
function Event:Wait<T...>(timeout: number?) : T...
	local thread = coroutine.running()
	table.insert(self.Waiting, thread)

	if timeout then
		task.delay(timeout, function()
			if coroutine.status(thread) == "suspended" then
				table.remove(self.Waiting, thread)
				coroutine.resume(thread)
			end
		end)
	end

	return coroutine.yield()
end

return Event