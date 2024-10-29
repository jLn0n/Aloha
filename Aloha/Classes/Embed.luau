--[=[
	@class Embed
	Class to create Discord embeds.
]=]
local Embed = {}
local Color3 = require("Color3")
type Color3 = Color3.Color3

local DiscordTypes = require("../Lib/DiscordTypes")

export type Embed = {
	setTitle: (title: string) -> Embed,
	setDescription: (description: string) -> Embed,
	setUrl: (url: string) -> Embed,
	setTimestamp: () -> Embed,
	setColor: (color: Color3) -> Embed,
	setFooter: (text: string, icon_url: string?) -> Embed,
	setImage: (url: string) -> Embed,
	setThumbnail: (url: string) -> Embed,
	setVideo: (url: string) -> Embed,
	setProvider: (name: string, url: string?) -> Embed,
	setAuthor: (name: string, icon_url: string?, url: string?) -> Embed,
	setFields: (fields: { { name: string, value: string, inline: boolean? } }) -> Embed,
	addField: (name: string, value: string, inline: boolean?) -> Embed,
	finish: () -> DiscordTypes.EmbedData,
}

--[=[
	@function new
	@within Embed
	Creates a new Embed.
	@return Embed
]=]
function Embed.new(): Embed
	local newEmbed = {}
	newEmbed._structure = {}

	--[=[
	@function setTitle
	Sets the title of the embed.
	@within Embed
	@param title string
	@return Embed
]=]
	newEmbed.setTitle = function(title: string)
		newEmbed._structure.title = title

		return newEmbed
	end

	--[=[
	@function setDescription
	Sets the description of the embed.
	@within Embed
	@param description string
	@return Embed
	]=]
	newEmbed.setDescription = function(description: string)
		newEmbed._structure.description = description

		return newEmbed
	end

	--[=[
	@function setUrl
	Sets the URL of the embed.
	@within Embed
	@param url string
	@return Embed
	]=]
	newEmbed.setUrl = function(url: string)
		newEmbed._structure.url = url

		return newEmbed
	end

	--[=[
	@function setTimestamp
	Sets the timestamp of the embed.
	@within Embed
	@param time string?
	@return Embed
	]=]
	newEmbed.setTimestamp = function(time: string?)
		local now = time or os.time()
		local tz_offset_sec = os.difftime(now, os.time(os.date("!*t", now)))
		local tz_offset = string.format("%+.2d:%.2d", math.floor(tz_offset_sec / 3600), math.abs(tz_offset_sec % 3600) / 60)
	
		newEmbed._structure.timestamp = os.date("!%Y-%m-%dT%H:%M:%S") .. tz_offset

		return newEmbed
	end

	--[=[
	@function setColor
	Sets the color of the embed.
	@within Embed
	@param color Color3
	@return Embed
	]=]
	newEmbed.setColor = function(color: Color3)
		newEmbed._structure.color = color:ToInt()

		return newEmbed
	end

	--[=[
	@function setFooter
	Sets the footer of the embed.
	@within Embed
	@param text string
	@param icon_url string?
	@param proxy_icon_url string?
	@return Embed
	]=]
	newEmbed.setFooter = function(text: string, icon_url: string?, proxy_icon_url: string?)
		newEmbed._structure.footer = {
			text = text,
			icon_url = icon_url,
			proxy_icon_url = proxy_icon_url
		}

		return newEmbed
	end

	--[=[
	@function setImage
	Sets the image of the embed.
	@within Embed
	@param url string
	@param height number?
	@param width number?
	@param proxy_url string?
	@return Embed
	]=]
	newEmbed.setImage = function(url: string, height: number?, width: number?, proxy_url: string?)
		newEmbed._structure.image = {
			url = url,
			height = height,
			width = width,
			proxy_url = proxy_url
		}

		return newEmbed
	end

	--[=[
	@function setThumbnail
	Sets the thumbnail of the embed.
	@within Embed
	@param url string
	@param height number?
	@param width number?
	@param proxy_url string?
	@return Embed
	]=]
	newEmbed.setThumbnail = function(url: string, height: number?, width: number?, proxy_url: string?)
		newEmbed._structure.thumbnail = {
			url = url,
			height = height,
			width = width,
			proxy_url = proxy_url
		}

		return newEmbed
	end

	--[=[
	@function setVideo
	Sets the video of the embed.
	@within Embed
	@param url string
	@param height number?
	@param width number?
	@param proxy_url string?
	@return Embed
	]=]
	newEmbed.setVideo = function(url: string, height: number?, width: number?, proxy_url: string?)
		newEmbed._structure.video = {
			url = url,
			height = height,
			width = width,
			proxy_url = proxy_url
		}

		return newEmbed
	end

	--[=[
	@function setProvider
	Sets the provider of the embed.
	@within Embed
	@param name string?
	@param url string?
	@return Embed
	]=]
	newEmbed.setProvider = function(name: string?, url: string?)
		newEmbed._structure.provider = {
			name = name,
			url = url
		}

		return newEmbed
	end

	--[=[
	@function setAuthor
	Sets the author of the embed.
	@within Embed
	@param name string
	@param icon_url string?
	@param url string?
	@param proxy_icon_url string?
	@return Embed
	]=]
	newEmbed.setAuthor = function(name: string, icon_url: string?, url: string?, proxy_icon_url: string?)
		newEmbed._structure.author = {
			name = name,
			icon_url = icon_url,
			url = url,
			proxy_icon_url = proxy_icon_url
		}

		return newEmbed
	end

	--[=[
	@function setFields
	Sets the fields of the embed.
	@within Embed
	@param fields { { name: string, value: string, inline: boolean? } }
	@return Embed
	]=]
	newEmbed.setFields = function(fields: { { name: string, value: string, inline: boolean? } })
		newEmbed._structure.fields = fields

		return newEmbed
	end

	--[=[
	@function addField
	@within Embed
	@param name string
	@param value string
	@param inline boolean?
	@return Embed
	Adds a field to the embed.
	]=]
	newEmbed.addField = function(name: string, value: string, inline: boolean?)
		if not newEmbed._structure.fields then
			newEmbed._structure.fields = {}
		end

		table.insert(newEmbed._structure.fields, {
			name = name,
			value = value,
			inline = inline
		})

		return newEmbed
	end

	--[=[
	@function finish
	Finishes the embed and returns the embed data as a structured table.
	@within Embed
	@return DiscordTypes.EmbedData
	]=]
	newEmbed.finish = function() : DiscordTypes.EmbedData
		return newEmbed._structure
	end

	return newEmbed
end

return Embed