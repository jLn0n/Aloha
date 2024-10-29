--- @ignore
local Commands = {}
local net = require("@lune/net")
local Endpoints = require("Endpoints")
local Enum = require("Enum")
local DiscordTypes = require("DiscordTypes")
local Event = require("../Classes/Event")
local Bot = require("Bot")
local task = require("@lune/task")
local Objects = require("../Classes/Objects")

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
Commands.RateLimit = {}

local Command = {}
Command.__index = Command


export type Command = DiscordTypes.ApplicationCommandData & typeof(Command) & {Executed: Event.Event, Response: {type: number, data: DiscordTypes.InteractionCallbackData}?}

function Command.new(data: DiscordTypes.ApplicationCommandData) : Command
	local self = setmetatable({}, Command)

	for key, value in data do
		self[key] = value
	end

	self.Response = nil

	self.Executed = Event.new()

	return self
end

function Command:SetResponse(callback: (DiscordTypes.ApplicationCommandInteractionData) -> {type: number, data: DiscordTypes.InteractionCallbackData})
	self.Response = callback
end



function Commands.RegisterGlobal(data: GlobalCommand) : (Command, string)
	local returnStr = "SUCCESS"
	if data.type == Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT and not data.description then
		returnStr = "CHAT_INPUT_COMMAND_DESCRIPTION_REQUIRED"
	end

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GLOBAL_APPLICATION_COMMAND:format(Bot.Client.id)}`

	local response = net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode(data),
		headers = {
			["Authorization"] = `Bot {Bot.TOKEN}`,
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

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_GUILD_APPLICATION_COMMAND:format(Bot.Client.id, guild_id)}`

	local response = net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode(data),
		headers = {
			["Authorization"] = `Bot {Bot.TOKEN}`,
			["Content-Type"] = "application/json"
		}
	})

	local command = Command.new(net.jsonDecode(response.body))

	Commands.Cache[command.id] = command

	return command, returnStr
end

function Commands.HandleInteraction(int: DiscordTypes.InteractionData, shard_id: number?)
	local interaction = Objects.Interaction.new(int)

	local applicationData = interaction.data :: DiscordTypes.ApplicationCommandInteractionData
	

	if applicationData.target_id and Commands.RateLimit[applicationData.target_id] then
		return
	elseif interaction.member and interaction.member.user and interaction.member.user.id and Commands.RateLimit[interaction.member.user.id] then
		return
	end

	local command = Commands.Cache[applicationData.id]
	if not command then return end
	command.Executed:Fire(applicationData.options)

	if not command.Response then return end

	local url = `{Endpoints.BASE_URL}{Endpoints.CREATE_INTERACTION_RESPONSE:format(interaction.id, interaction.token)}`
	
	net.request({
		url = url,
		method = "POST",
		body = net.jsonEncode(command.Response(interaction)),
		headers = {
			["Authorization"] = `BOT {Bot.TOKEN}`,
			["Content-Type"] = "application/json"
		}
	})

	if applicationData.target_id and Bot.RATE_LIMIT > 0 then
		Commands.RateLimit[applicationData.target_id] = true
		task.delay(Bot.RATE_LIMIT, function()
			Commands.RateLimit[applicationData.target_id] = nil
		end)
	elseif interaction.member and interaction.member.user and interaction.member.user.id then
		if Bot.RATE_LIMIT <= 0 then return end
		Commands.RateLimit[interaction.member.user.id] = true
		task.delay(Bot.RATE_LIMIT, function()
			Commands.RateLimit[interaction.member.user.id] = nil
		end)
	end
end

return Commands