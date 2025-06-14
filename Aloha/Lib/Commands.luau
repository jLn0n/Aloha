--[=[
    @class Commands
    Handles Discord application command registration and interaction responses.
]=]
local Commands = {}
local net = require("@lune/net")
local Endpoints = require("./Endpoints")
local Enum = require("./Enum")
local DiscordTypes = require("./DiscordTypes")
local Event = require("../Classes/Event")
local Bot = require("./Bot")
local Task = require("../Util/Task")
local Objects = require("../Classes/Objects")
local Network = require("./Network")
local Snowflake = require("../Classes/Snowflake")
--[=[
    @type GlobalCommand {name: string, name_localizations: {[string]: string}?, description: string?, description_localizations: {[string]: string}?, options: {CommandOptionData}?, default_member_permissions: string?, integration_types: {number}?, contexts: {number}?, type: number, nsfw: boolean?}
    @within Commands
    Data for registering a global application command.
]=]
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

--[=[
    @type GuildCommand {name: string, name_localizations: {[string]: string}?, description: string?, description_localizations: {[string]: string}?, options: CommandOptionData?, default_member_permissions: string?, default_permission: boolean?, type: number, nsfw: boolean?}
    @within Commands
    Data for registering a guild-specific application command.
]=]
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

--[=[
    @prop Cache {[string]: Command}
    @within Commands
    Cache of registered commands indexed by ID.
]=]
Commands.Cache = {}

--[=[
    @prop RateLimit {[string]: boolean}
    @within Commands
    Rate limit tracking for command usage.
]=]
Commands.RateLimit = {}

--[=[
    @class Command
    Represents a Discord application command.
]=]
local Command = {}
Command.__index = Command

type ExecutedEvent = Event.Event<DiscordTypes.ApplicationCommandInteractionDataOptionData>

--[=[
    @type Command ApplicationCommandData & {Executed: Event, Response: {type: number, data: InteractionCallbackData}?}
    @within Commands
    A Discord application command instance.
]=]
export type Command = DiscordTypes.ApplicationCommandData & typeof(Command) & {Executed: ExecutedEvent, Response: {type: number, data: DiscordTypes.InteractionCallbackData}?}

--[=[
    @function new
    @within Command
    @param data ApplicationCommandData -- The command data from Discord
    @return Command -- A new Command instance
]=]
function Command.new(data: DiscordTypes.ApplicationCommandData) : Command?
	local self = setmetatable({}, Command)

	if typeof(data) ~= "table" then
		return
	end

	for key, value in data do
		self[key] = value
	end

	if self.id then
		self.id = Snowflake.new(self.id)
	end

	self.Response = nil

	self.Executed = Event.new()

	return self
end
--[=[
    @method SetResponse
    @within Command
    @param callback (ApplicationCommandInteractionData) -> {type: number, data: InteractionCallbackData} -- The response callback function
    Sets the response handler for when the command is executed.
]=]
function Command:SetResponse(callback: (DiscordTypes.ApplicationCommandInteractionData) -> {type: number, data: DiscordTypes.InteractionCallbackData})
	self.Response = callback
end

function Commands.Delete(id: string)
	Network.Request({
		endpoint = Endpoints.DELETE_GLOBAL_APPLICATION_COMMAND:format(Bot.Client.id, id),
		method = "DELETE",
	})
end

--[=[
    @function Clear
    @within Commands
    Clears the command cache and removes all registered commands.
]=]
function Commands.Clear()
	Commands.Cache = {}

	local s, r = Network.Request({
		endpoint = Endpoints.GET_GLOBAL_APPLICATION_COMMANDS:format(Bot.Client.id),
		method = "GET",
	})

	if s then
		for _, command in r.body or {} do
			Network.Request({
				endpoint = Endpoints.DELETE_GLOBAL_APPLICATION_COMMAND:format(Bot.Client.id, command.id),
				method = "DELETE",
			})
		end
	end
end

--[=[
    @function RegisterGlobal
    @within Commands
    @param data GlobalCommand -- The command data to register
    @return Command, string -- The registered command and status message
    Registers a global application command.
]=]
function Commands.RegisterGlobal(data: GlobalCommand) : (Command?, string)
	local returnStr = "SUCCESS"
	if data.type == Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT and not data.description then
		returnStr = "CHAT_INPUT_COMMAND_DESCRIPTION_REQUIRED"
	end
	
	local url = `{Endpoints.CREATE_GLOBAL_APPLICATION_COMMAND:format(Bot.Client.id.id)}`

	
	local success, response = Network.Request({
		endpoint = url,
		method = "POST",
		body = data,
	})

	if not success then
		return nil, returnStr
	end

	if response.code then
		return nil, response.code
	end

	local command = Command.new(response)

	if not command then 
		returnStr = "FAILED_TO_CREATE_COMMAND"
		return nil, returnStr 
	end

	Commands.Cache[command.id.id] = command

	return command, returnStr
end

--[=[
    @function RegisterGuild
    @within Commands
    @param data GuildCommand -- The command data to register
    @param guild_id string -- The ID of the guild to register the command in
    @return Command, string -- The registered command and status message
    Registers a guild-specific application command.
]=]
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

	Commands.Cache[command.id.id] = command

	return command, returnStr
end

--[=[
	@function HandleInteraction
	@within Commands
	@param int InteractionData -- The interaction data from Discord
	@param shard_id number? -- Optional shard ID
	@return Network.Response? -- The response from the interaction, if successful
	Handles an incoming command interaction. Returns nothing if the command is ratelimited.
]=]
function Commands.HandleInteraction(int: DiscordTypes.InteractionData, shard_id: number?) : Network.Response?

	local interaction = Objects.Interaction.new(int)
	local applicationData = interaction.data :: DiscordTypes.ApplicationCommandInteractionData
	
	if applicationData.target_id and Commands.RateLimit[applicationData.target_id] then
		return
	elseif interaction.member and interaction.member.user and interaction.member.user.id and Commands.RateLimit[interaction.member.user.id] then
		return
	end

	local command = Commands.Cache[applicationData.id]

	if not command then
		return
	end
	command.Executed:Fire(applicationData.options)

	if not command.Response then return end

	local endpoint = `{Endpoints.CREATE_INTERACTION_RESPONSE:format(interaction.id, interaction.token)}`

	local success, response = Network.Request({
		endpoint = endpoint,
		method = "POST",
		body = command.Response(interaction),
	})


	if not success then
		return response
	end

	if applicationData.target_id and Bot.RATE_LIMIT > 0 then
		Commands.RateLimit[applicationData.target_id] = true
		Task.Delay(Bot.RATE_LIMIT, function()
			Commands.RateLimit[applicationData.target_id] = nil
		end)
	elseif interaction.member and interaction.member.user and interaction.member.user.id then
		if Bot.RATE_LIMIT <= 0 then return end
		Commands.RateLimit[interaction.member.user.id] = true
		Task.Delay(Bot.RATE_LIMIT, function()
			Commands.RateLimit[interaction.member.user.id] = nil
		end)
	end

	return response
end

return Commands