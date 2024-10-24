-- Janitor fork to work with my library. Thank you to howmanysmall for the original Janitor.
local API = require("../Lib/API")
local task = require("@lune/task")

local Sweeper = {}
Sweeper.__index = Sweeper

export type Sweeper = typeof(Sweeper) & {
	RemoveNoClean: (index: any) -> (),
	GetAll: () -> {[any]: any},
}

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

function Sweeper:Add<T>(object: T, methodName: (boolean | string)?, index: any?) : T
	self.Cache[index or API.GenerateGUID()] = {
		method = methodName,
		object = object
	}

	return object
end

function Sweeper:Sweep() : ()
	for index in self.Cache do
		self:Remove(index)
	end

	self.Cache = {}
end

function Sweeper:GetAll() : {[any]: any}
	return table.freeze(table.clone(self.Cache))
end

function Sweeper:RemoveNoClean(index: any) : ()
	self.Cache[index] = nil
end

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