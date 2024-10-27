local Timer = {}
Timer.__index = Timer
local task = require("@lune/task")

export type Timer = typeof(Timer)

function Timer.new(time: number, interval: number, interval_callback: (totalTime: number) -> ()?, end_callback: () -> ()?) : Timer
	local self = setmetatable({}, Timer)

	self._interval = interval
	self._started = os.time()
	self._closed = false
	self._interval_callback = interval_callback
	self._end_callback = end_callback

	self._end_called = false

	self._task = task.spawn(function()
		while self._started + time > os.time() and not self._closed do
			task.wait(self._interval)
			if not self._interval_callback then continue end
			self._interval_callback(os.time() - self._started)
		end

		if not self._end_called and self._end_callback then
			self._end_callback()
		end
	end)

	return self
end

function Timer:Stop()
	self._closed = true

	if coroutine.status(self._task) == "running" then
		task.cancel(self._task)
	end

	self._end_called = true

	if not self._end_callback then return end
	self._end_callback()
end

return Timer