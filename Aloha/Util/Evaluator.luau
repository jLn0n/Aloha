local Evaluator = {}

function Evaluator.Evaluate(code: string) : string
	local load = loadstring(code)

	return load()
end

return Evaluator