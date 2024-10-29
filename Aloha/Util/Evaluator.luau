--[=[
	@class Evaluator
	Utility class for evaluating Luau code in a sandboxed environment
]=]
local Evaluator = {}
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")
local Bot = require("../Lib/Bot")
local Misc = require("./Misc")

--[=[
	@function Evaluate
	@within Evaluator
	@param code string -- The Luau code to evaluate
	@return string, boolean -- Returns the evaluation result and success status
	Evaluates the given Luau code in a sandboxed environment with a timeout
]=]
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

function Evaluator.EvaluateBF(code: string): string
	local maxInstructions = 50000
	local maxMemory = 3000

	local memory = {}
	for i = 1, maxMemory do 
		memory[i] = 0 
	end   
	local pointer = 1
	local codePointer = 1
	local instructionCount = 0
	local outputBuffer = buffer.create(1024)
	local outputOffset = 0

	local loopStack = {}
	local jumpTable = {}
	for i = 1, #code do
		if code:sub(i, i) == "[" then
			table.insert(loopStack, i)
		elseif code:sub(i, i) == "]" then
			local start = table.remove(loopStack)
			if not start then
				return "Unmatched ']' at position " .. i, false
			end
			jumpTable[start] = i
			jumpTable[i] = start
		end
	end
	if #loopStack > 0 then
		return "Unmatched '[' at position " .. loopStack[1], false
	end

	while codePointer <= #code and instructionCount < maxInstructions do
		local command = code:sub(codePointer, codePointer)
		if command == ">" then
			pointer = pointer + 1
			if pointer > maxMemory then return "Memory pointer out of bounds.", false end
		elseif command == "<" then
			pointer = pointer - 1
			if pointer < 1 then 
				return "Memory pointer out of bounds.", false
			end
		elseif command == "+" then
			memory[pointer] = (memory[pointer] + 1) % 256
		elseif command == "-" then
			memory[pointer] = (memory[pointer] - 1) % 256
		elseif command == "." then
			buffer.writestring(outputBuffer, outputOffset, string.char(memory[pointer]))
			outputOffset += 1
		elseif command == "," then
			
			memory[pointer] = 0
		elseif command == "[" then
			if memory[pointer] == 0 then
				codePointer = jumpTable[codePointer] or codePointer
			end
		elseif command == "]" then
			if memory[pointer] ~= 0 then
				codePointer = jumpTable[codePointer] or codePointer
			end
		end
		codePointer = codePointer + 1
		instructionCount = instructionCount + 1
	end

	if instructionCount >= maxInstructions then
		return "Exceeded maximum instruction count.", false
	end

	return buffer.tostring(outputBuffer), true
end

return Evaluator