local Enum = require("../Lib/Enum")
local DiscordTypes = require("../Lib/DiscordTypes")
local Evaluator = require("../Util/Evaluator")

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

		return {
			type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
			data = {
				embeds = {
					{
						title = "Luau Evaluator",
						fields = {
							{
								name = "Input",
								value = "```lua\n" .. input .. "\n```"
							},
							{
								name = "Output",
								value = "```\n" .. output .. "\n```"
							}
						}
					}
				}
			}
		}
	
	end
}