--[=[
    @class Timer
    A utility class for managing timed callbacks.
]=]
local Timer = {}
Timer.__index = Timer

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
    self._thread = coroutine.create(function()
        self:Run(time)
    end)

    coroutine.resume(self._thread) 
    return self
end

--[=[
    @private
    The main run loop for the timer.
]=]
function Timer:Run(time: number)
    local startTime = os.time()
    while os.time() - startTime < time and not self._closed do
        local elapsed = os.time() - startTime
        self:Yield(self._interval)

        if self._interval_callback and not self._closed then
            self._interval_callback(elapsed)
        end
    end

    if self._end_callback and not self._closed then
        self._end_callback()
    end
end

--[=[
    @private
]=]
function Timer:Yield(duration: number)
    local start = os.clock()
    while os.clock() - start < duration do
        coroutine.yield()
    end
end

--[=[
    @within Timer
    Stops the timer and cancels any pending callbacks.
]=]
function Timer:Stop()
    self._closed = true
    if coroutine.status(self._thread) == "suspended" then
        coroutine.resume(self._thread) 
    end
end

return Timer