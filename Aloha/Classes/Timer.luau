--[=[
    @class Timer
    A utility class for managing timed callbacks.
]=]
local Timer = {}
Timer.__index = Timer
local task = require("@lune/task")

export type Timer = typeof(Timer)

--[=[
    @param time number -- The total time to run in seconds
    @param interval number -- The interval between callbacks in seconds
    @param interval_callback ((totalTime: number) -> ())? -- Optional callback that runs each interval with total elapsed time
    @param end_callback (() -> ())? -- Optional callback that runs when timer completes
    @return Timer -- The new Timer instance
    Creates a new Timer that runs for the specified duration.
]=]
function Timer.new(time: number, interval: number, interval_callback: (totalTime: number) -> ()?, end_callback: () -> ()?) : Timer
	local self = setmetatable({}, Timer)

	self._interval = interval
	self._started = os.time()
	self._closed = false
	self._interval_callback = interval_callback
	self._end_callback = end_callback

	self._task = task.spawn(function()
		while self._started + time > os.time() and not self._closed do
			task.wait(self._interval)
			if not self._interval_callback then continue end
			self._interval_callback(os.time() - self._started)
		end

		if self._end_callback then
			self._end_callback()
		end
	end)

	return self
end

--[=[
    @within Timer
    Stops the timer and cancels any pending callbacks.
]=]
function Timer:Stop()
	self._closed = true

	if coroutine.status(self._task) == "suspended" then
		task.cancel(self._task)
	end
end

return Timer