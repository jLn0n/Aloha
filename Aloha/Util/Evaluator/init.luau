local Evaluator = {}
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")
local API = require("../../Lib/API")

function Evaluator.Evaluate(code: string): string
	local ret = ""
	local finished = false
	local currentThread = coroutine.running()

	code = ([[ 
	require = function(req) error("require is disabled.") end
	%s
	]]):format(code)

	task.spawn(function()
		local tag = API.GenerateGUID(false)
		fs.writeFile(`./Aloha/temp/{tag}.luau`, code)  
		ret = process.spawn("lune", {"run", `./Aloha/temp/{tag}.luau`}, {
			cwd = ".",
		})

		ret = #ret.stderr > 0 and ret.stderr or ret.stdout
		fs.removeFile(`./Aloha/temp/{tag}.luau`)

		finished = true
		coroutine.resume(currentThread)
	end)


	task.delay(1, function()
		local pid_process = process.spawn([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
		for pid in pid_process.stdout:gmatch("%d+") do
			if pid == API.PROCESS_ID then
				continue
			end

			process.spawn("taskkill", {"/F", "/T", "/PID", pid}, { shell = true })
		end
	end)

	if not finished then
		task.delay(2, function()
			coroutine.resume(currentThread)
		end)
		coroutine.yield(currentThread)
	end

	return ret
end

return Evaluator