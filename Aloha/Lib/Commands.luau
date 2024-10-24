local Commands = {}
local net = require("@lune/net")
local Endpoints = require("./Endpoints")
local Cache = require("./Cache")
local Enum = require("./Enum")
local DiscordTypes = require("./DiscordTypes")
local Event = require("../Util/Event")
local API = require("./API")

export type GlobalCommand = {
	name: string,
	name_localizations: { [string]: string }?,
	description: string?,
	description_localizations: { [string]: string }?,
	options: {DiscordTypes.CommandOptionData}?,
	default_member_permissions: string?,
	integration_types: {number}?,
	contexts: {number}?,
	type: number,
	nsfw: boolean?
}

export type GuildCommand = {
	name: string,
	name_localizations: { [string]: string }?,
	description: string?,
	description_localizations: { [string]: string }?,
	options: DiscordTypes.CommandOptionData?,
	default_member_permissions: string?,
	default_permission: boolean?,
	type: number,
	nsfw: boolean?
}

Commands.Cache = {}

local Command = {}
Command.__index = Command

type Command = DiscordTypes.ApplicationCommandData & typeof(Command) & {Executed: Event.Event, Response: {type: number, data: DiscordTypes.InteractionCallbackData}?}

function Command.new(data: DiscordTypes.ApplicationCommandData) : Command
	local self = setmetatable({}, Command)

	for key, value in data do
		self[key] = value
	end

	self.Response = nil

	self.Executed = Event.new()

	return self
end

function Command:SetResponse(type: number, data: DiscordTypes.InteractionCallbackData)
	self.Response = {type = type, data = data}
end



function Commands.RegisterGlobal(data: GlobalCommand) : (Command, string)
	local returnStr = "SUCCESS"
	if data.type == Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT and not data.description then
		returnStr = "CHAT_INPUT_COMMAND_DESCRIPTION_REQUIRED"
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GLOBAL_APPLICATION_COMMAND:format(Cache.Client.id)}`

	local response = net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode(data),
		headers = {
			["Authorization"] = `Bot {API.TOKEN}`,
			["Content-Type"] = "application/json"
		}
	})

	local command = Command.new(net.jsonDecode(response.body))

	Commands.Cache[command.id] = command

	return command, returnStr
end

function Commands.RegisterGuild(data: GuildCommand, guild_id: string) : (Command, string)
	local returnStr = "SUCCESS"
	if data.type == Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT and not data.description then
		returnStr = "CHAT_INPUT_COMMAND_DESCRIPTION_REQUIRED"
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_APPLICATION_COMMAND:format(Cache.Client.id, guild_id)}`

	local response = net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode(data),
		headers = {
			["Authorization"] = `Bot {API.TOKEN}`,
			["Content-Type"] = "application/json"
		}
	})

	local command = Command.new(net.jsonDecode(response.body))

	Commands.Cache[command.id] = command

	return command, returnStr
end

function Commands.HandleInteraction(interaction: DiscordTypes.InteractionData)
	local applicationData = interaction.data :: DiscordTypes.ApplicationCommandInteractionData

	local command = Commands.Cache[applicationData.id]
	print(Commands.Cache, applicationData.id)
	if not command then return end
	command.Executed:Fire(applicationData.options)

	print(command.Response)
	if not command.Response then return end

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_INTERACTION_RESPONSE:format(interaction.id, interaction.token)}`
	
	net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode({
			type = command.Response.type,
			data = command.Response.data
		}),
		headers = {
			["Authorization"] = `BOT {API.TOKEN}`,
			["Content-Type"] = "application/json"
		}
	})
end

return Commands