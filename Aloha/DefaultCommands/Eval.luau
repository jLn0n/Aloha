local Enum = require("../Lib/Enum")
local DiscordTypes = require("../Lib/DiscordTypes")
local Evaluator = require("../Util/Evaluator")
local Misc = require("../Util/Misc")
local API = require("../Lib/API")
local fs = require("@lune/fs")
local process = require("@lune/process")

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

		local output = Evaluator.Evaluate(code)

		local input = code:sub(1, 100) .. (#code > 100 and "..." or "")

		local temp_file = Misc.CreateTempFile(input)
		process.spawn("stylua", {temp_file.Path}, {cwd = "."})
		local beautified_code = fs.readFile(temp_file.Path)
		temp_file:Delete()

		return {
			type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
			data = {
				embeds = {
					{
						title = "Luau Evaluator",
						fields = {
							{
								name = "Input",
								value = "```lua\n" .. Misc.AddLineNumbers(beautified_code) .. "\n```"
							},
							{
								name = "Output",
								value = "```\n" .. Misc.AddLineNumbers(output) .. "\n```"
							}
						}
					}
				}
			}
		}
	
	end
}