--[=[
    @class Mutex
    A mutex (mutual exclusion) implementation for coroutine synchronization. Based on SinisterRectus's implementation in Discordia.
]=]

local task = require("@lune/task")

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

--[=[
    @function new
    @within Mutex
    @return Mutex -- A new mutex instance
    Creates a new mutex instance
]=]
function Mutex.new()
	local self = setmetatable(LinkedList.new(), Mutex)
	self._active = false
	return self
end

--[=[
    @method Lock
    @within Mutex
    @param prepend boolean -- Whether to prepend the coroutine to the wait queue
    Locks the mutex. If already locked, yields the current coroutine until unlocked.
]=]
function Mutex:Lock(prepend: boolean)
	if not self._active then
		self._active = true
		return
	end
	
	if prepend then
		self:PushLeft(coroutine.running())
	else
		self:PushRight(coroutine.running())
	end

	while self._active do
		task.wait()
	end
end

--[=[
    @method Unlock	
    @within Mutex
    @return boolean? -- Returns true if a coroutine was resumed, nil otherwise
    Unlocks the mutex and resumes the next waiting coroutine if any
]=]
function Mutex:Unlock() : boolean?
	if #self > 0 then
		return assert(coroutine.resume(self:PopLeft()))
	end

	self._active = false

	return nil
end

--[=[
    @method UnlockAfter
    @within Mutex
    @param delay number -- Delay in seconds before unlocking
    @return Timer -- Timer instance that will unlock the mutex after the delay
    Creates a timer that unlocks the mutex after the specified delay
]=]
function Mutex:UnlockAfter(delay: number) : Timer
	return Timer.new(delay * 1000, 1/1000, nil, self.Unlock)
end

return Mutex
