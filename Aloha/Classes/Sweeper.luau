--[=[
    @class Sweeper
    A utility class for managing cleanup of objects and resources. Fork of Janitor by howmanysmall.
]=]

local Bot = require("../Lib/Bot")
local task = require("@lune/task")

local Sweeper = {}
Sweeper.__index = Sweeper

export type Sweeper = typeof(Sweeper) & {
	RemoveNoClean: (index: any) -> (),
	GetAll: () -> {[any]: any},
}

--[=[
    @return Sweeper
    Creates a new Sweeper instance.
]=]
function Sweeper.new() : Sweeper
	local self = setmetatable({}, Sweeper)

	self.CurrentlyCleaning = false
	self.Cache = {}
	
	local proxy = setmetatable({}, {
		__index = function(_, key)
			if key == "Cache" then return end
	
			return self[key]
		end,

		__newindex = function(_, key, value)
			if key == "CurrentlyCleaning" then return end
			
			if self[key] and type(self[key]) == "function" then
				error(`Cannot override method {key}.`)
			end

			self[key] = value
		end
	})

	return proxy
end

--[=[
    @within Sweeper
    @param object T -- The object to add
    @param methodName boolean | string? -- The cleanup method name or true for function/thread
    @param index any? -- Optional custom index
    @return T -- Returns the added object
    Adds an object to be cleaned up later.
]=]
function Sweeper:Add<T>(object: T, methodName: (boolean | string)?, index: any?) : T
	self.Cache[index or Bot.GenerateGUID()] = {
		method = methodName,
		object = object
	}

	return object
end

--[=[
    @within Sweeper
    Cleans up all objects in the Sweeper.
]=]
function Sweeper:Sweep() : ()
	for index in self.Cache do
		self:Remove(index)
	end

	self.Cache = {}
end

--[=[
    @within Sweeper
    @return {[any]: any} -- Table of all cached objects
    Returns a frozen clone of the cache.
]=]
function Sweeper:GetAll() : {[any]: any}
	return table.freeze(table.clone(self.Cache))
end

--[=[
    @within Sweeper
    @param index any -- The index to remove
    Removes an object from the cache without cleaning it.
]=]
function Sweeper:RemoveNoClean(index: any) : ()
	self.Cache[index] = nil
end

--[=[
    @within Sweeper
    @param index any -- The index to remove
    Removes and cleans up an object from the cache.
]=]
function Sweeper:Remove(index: any) : ()
	local data = self.Cache[index]
	if not data then return end

	local method = data.method
	if not method then 
		method = "Disconnect"
	end

	if data.object[method] then
		data.object[method](data.object)

		return
	end

	if method == true then
		if typeof(data.object) == "function" then
			data.object()
		end

		if typeof(data.object) == "thread" then
			task.cancel(data.object)
		end
	end
end

return Sweeper