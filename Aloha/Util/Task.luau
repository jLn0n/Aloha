local Task = {}
local Event = require("../Classes/Event")
local task = require("@lune/task")

function Task.Cancel(thread: thread)
	task.cancel(thread)
end

function Task.Delay<T...>(duration: number, functionOrThread: ((T...) -> ...any) | thread, ...: T...) : thread
	print("[Task] Delaying for ", duration, " seconds")
	return task.delay(duration, functionOrThread, ...)
end

function Task.Spawn<T...>(functionOrThread: ((T...) -> ...any) | thread, ...: T...) : thread
	return task.spawn(functionOrThread, ...)
end

function Task.Wait(duration: number?) : number
	return task.wait(duration)
end

function Task.Defer<T...>(functionOrThread: ((T...) -> ...any) | thread, ...: T...) : thread
	return task.defer(functionOrThread, ...)
end


return Task