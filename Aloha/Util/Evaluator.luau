--- @ignore
local Evaluator = {}
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")
local Bot = require("../Lib/Bot")
local Misc = require("./Misc")

function Evaluator.Evaluate(code: string): string
    local ret = "Timed out while evaluating code."
    local success = false
    local currentThread = coroutine.running()

    local temp = Misc.CreateTempFile(code)
    
    task.spawn(function()
        process.spawn("stylua", { temp.Path }, { cwd = "." })
        
        local result = process.spawn("lune", { "run", temp.Path }, { cwd = "." })
        
        success = #result.stderr == 0
        ret = success and result.stdout or result.stderr:gsub('%[string ".-/.-"%]:(%d+):', function(n)
            return ("[eval]:%d:"):format(n)
        end)
        
        temp:Delete() 
        coroutine.resume(currentThread)  
    end)

    task.delay(1, function()
        local pid_process = process.spawn([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
        for pid in pid_process.stdout:gmatch("%d+") do
            if pid ~= tostring(Bot.PROCESS_ID) then
                process.spawn("taskkill", { "/F", "/T", "/PID", pid }, { shell = true })
            end
        end

        if coroutine.status(currentThread) == "suspended" then
            coroutine.resume(currentThread)
        end
    end)

    coroutine.yield()

    return ret, success
end

return Evaluator