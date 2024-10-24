local Evaluator = {}
local luau = require("@lune/luau")

function Evaluator.Evaluate(code: string) : string

	local output = ""

	local environment = setmetatable({
		print = function(...)
			local args = {...}
			for i = 1, select('#', ...) do
			  args[i] = tostring(args[i])
			end
		
			output ..= table.concat(args, '\t') .. '\n'
		  end,
	}, {
		__index = _G
	})

	local eval,err = luau.load(code, {environment = environment})

	if eval then
		local _, ret = pcall(eval)
		if ret ~= nil then
			output = tostring(ret) .. '\n' .. output
		end
	else
		output = err
	end

	return output
end

return Evaluator