local Evaluator = {}
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")
local Bot = require("../Lib/Bot")
local Misc = require("./Misc")

function Evaluator.Evaluate(code: string): string
    local ret = ""
    local success = false
    local currentThread = coroutine.running()

    -- Code injection with safe require and environment restrictions
    code = ([[ 
    task = require("@lune/task")
    require = function(req) error("require is disabled.") end
    getfenv = function() error("getfenv is disabled.") end
    setfenv = function() error("setfenv is disabled.") end

    %s
    ]]):format(code)

    local temp = Misc.CreateTempFile(code)
    
    -- Spawn lune task with a coroutine-safe approach
    task.spawn(function()
        process.spawn("stylua", { temp.Path }, { cwd = "." })
        
        local result = process.spawn("lune", { "run", temp.Path }, { cwd = "." })
        
        success = #result.stderr == 0
        ret = success and result.stdout or result.stderr:gsub('%[string ".-/.-"%]:(%d+):', function(n)
            return ("[eval]:%d:"):format(n - 5)
        end)
        
        temp:Delete()  -- Only delete the temp file after execution
        coroutine.resume(currentThread)  -- Resume coroutine once `lune` completes
    end)

    -- Safety measure to kill potential rogue processes
    task.delay(1, function()
        local pid_process = process.spawn([[wmic process where "name='lune.exe'" get processid]], {}, { shell = true })
        for pid in pid_process.stdout:gmatch("%d+") do
            if pid ~= tostring(Bot.PROCESS_ID) then
                process.spawn("taskkill", { "/F", "/T", "/PID", pid }, { shell = true })
            end
        end

        -- Only resume if coroutine hasn’t already been resumed
        if coroutine.status(currentThread) == "suspended" then
            coroutine.resume(currentThread)
        end
    end)

    -- Yield to allow coroutine to handle task spawning
    coroutine.yield()

    return ret, success
end

return Evaluator