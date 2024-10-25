local Enum = require("../Lib/Enum")
local DiscordTypes = require("../Lib/DiscordTypes")
local Evaluator = require("../Util/Evaluator")
local Misc = require("../Util/Misc")
local API = require("../Lib/API")
local fs = require("@lune/fs")
local process = require("@lune/process")
local Embed = require("../Classes/Embed")
local task = require("@lune/task")
local Color3 = require("../Classes/Color3")

return {
	Data = {
		name = "eval",
		description = "evaluates Luau code.",
		type = Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT,
		options = {
			{
				name = "code",
				description = "The code to evaluate.",
				type = Enum.APPLICATION_COMMAND_OPTION_TYPE.STRING,
				required = true
			}
		}
	},

	Response = function(data: DiscordTypes.ApplicationCommandInteractionData)
		local options = data.options
		if not options then 
			return {
				type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
				data = {
					content = "Error evaluating code."
				}
			}
		end
		local code = options[1].value

		local start = os.clock()
		local output, success = Evaluator.Evaluate(code)
		local timeTaken = (os.clock() - start) * 1000
		timeTaken = math.floor(timeTaken * 10 + 0.5) / 10

		local embedColor = success and Color3.new(107/255, 245/255, 76/255) or Color3.new(230/255, 32/255, 32/255)

		local input = code:sub(1, 100) .. (#code > 100 and "..." or "")
		
		local lines = {}
		local isLong = false
		local extraCount = 0
		output = output:sub(1, 100)
		for line in output:gmatch("[^\r\n]+") do
			if isLong then 
				extraCount += 1 
				continue 
			end

			table.insert(lines, line)
			if #lines >= 20 then
				isLong = true
				extraCount = 1
			end
		end
		output = table.concat(lines, "\n")
		if isLong then 
			output ..= "...(" .. extraCount .." lines)" 
		end

		local temp_file = Misc.CreateTempFile(input)
		process.spawn("./stylua", {temp_file.Path}, {cwd = "."})
		local beautified_code = fs.readFile(temp_file.Path)
		temp_file:Delete()
			
		return {
			type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
			data = {
				embeds = {
					Embed.new().setTitle("Luau Evaluator").setColor(embedColor).setFields({
						{
							name = "Input",
							value = "```lua\n" .. Misc.AddLineNumbers(beautified_code) .. "\n```"
						},
						{
							name = "Output",
							value = "```\n" .. output .. "\n```"
						}
					}).setFooter(`Evaluated in: {timeTaken}ms`).finish()
				}
			}
		}
	
	end
}