-- based on SinisterRectuah's implementation in Discordia
-- https://github.com/SinisterRectus/Discordia/blob/master/libs/utils/Mutex.lua

local Mutex = {}
Mutex.__index = Mutex
Mutex.__len = function(self)
	return self.Length
end

local LinkedList = require("../Classes/LinkedList")
local Timer = require("../Classes/Timer")

type Timer = Timer.Timer

export type Mutex = {
	deck: {any},
	_active: boolean
}

setmetatable(Mutex, {__index = LinkedList})

function Mutex.new()
	local self = setmetatable(LinkedList.new(), Mutex)
	self._active = false
	return self
end

function Mutex:Lock(prepend: boolean)
	if not self._active then
		self._active = true
		return
	end	

	if prepend then
		return coroutine.yield(self:PushLeft(coroutine.running()))
	end

	return coroutine.yield(self:PushRight(coroutine.running()))
end

function Mutex:Unlock() : boolean?
	if #self > 0 then
		return assert(coroutine.resume(self:PopLeft()))
	end

	self._active = false

	return nil
end

function Mutex:UnlockAfter(delay: number) : Timer
	return Timer.new(delay * 1000, 1/1000, nil, self.Unlock)
end

return Mutex
