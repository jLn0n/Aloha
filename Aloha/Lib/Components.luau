--[=[
@class Components
Module for handling Discord components.
]=]
local Components = {}
local DiscordTypes = require("./DiscordTypes")
local Objects = require("../Classes/Objects")
local Event = require("../Classes/Event")
local Enum = require("./Enum")
local Network = require("./Network")

type InteractionEvent = Event.Event<(Objects.Interaction, number?)>

local eventCallbacks = {}

for _, componentType in Enum.COMPONENT do
	eventCallbacks[componentType] = {
		event = Event.new()
	}
end

--[=[
@function GetInteractionSignal
@within Components
@param componentType number -- The type of component to get the signal for
@return Event<(Objects.Interaction, number?)> -- The event for the component type
]=]
function Components.GetInteractionSignal(componentType: number) : InteractionEvent
	return eventCallbacks[componentType].event
end

--[=[
@function HandleInteraction
@within Components
@param int DiscordTypes.InteractionData -- The interaction data
@param shard_id number? -- The shard ID
]=]
function Components.HandleInteraction(int: DiscordTypes.InteractionData, shard_id: number?)
	local interaction = Objects.Interaction.new(int)

	local componentData = interaction.data :: DiscordTypes.MessageComponentInteractionData

	eventCallbacks[componentData.component_type].event:Fire(interaction, shard_id)
end

return Components