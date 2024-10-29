--- @ignore
--- @class DefaultCommands.Uptime
local Enum = require("../Lib/Enum")
local DiscordTypes = require("../Lib/DiscordTypes")
local Misc = require("../Util/Misc")
local Bot = require("../Lib/Bot")
local Embed = require("../Classes/Embed")
local Color3 = require("../Classes/Color3")

return {
	Data = {
		name = "uptime",
		description = "shows the uptime of Aloha.",
		type = Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT
	},

	Response = function(data: DiscordTypes.ApplicationCommandInteractionData)
		return {
			type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
			data = {
				embeds = {
					Embed.new().setColor(Color3.new(252/255, 152/255, 3/255))
					.setDescription(`Aloha has been online for {Misc.FormatTime(os.time() - Bot.STARTED_AT)}`).finish()
				},
				flags = Enum.MESSAGE_FLAGS.EPHEMERAL
			}
		}
		
	end
}