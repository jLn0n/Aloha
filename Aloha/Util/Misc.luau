--[=[
    @class Misc
    Utility functions for various operations
]=]
local Misc = {}
local Bot = require("../Lib/Bot")
local fs = require("@lune/fs")
local DiscordTypes = require("../Lib/DiscordTypes")
local Network = require("../Lib/Network")

--[=[
    @function FetchThumbnailPNG
    @within Misc
    @param decal string -- Decal to fetch the thumbnail for
    @return string | nil -- URL of the thumbnail or nil if an error occurred
]=]
Misc.FetchThumbnailPNG = function(decal: string): (string | nil)
	local success, result = pcall(function()
		local assetId = decal:match("rbxassetid://(%d+)") or decal:match("https?://.+/asset/?id=(%d+)")
		if not assetId then
			error("Invalid asset ID format.")
		end
		local url = "https://thumbnails.roproxy.com/v1/assets?assetIds="..assetId.."&returnPolicy=PlaceHolder&size=512x512&format=Png&isCircular=false"
		local success, response = Network.Get(url)

		local data = Network.JsonDecode(response.body)
		return data.data[1].imageUrl
	end)

	if success then
		return result
	else
		warn("An error occurred: " .. result)
		return nil
	end
end

--[=[
    @function AddLineNumbers
    @within Misc
    @param input string -- Input string to add line numbers to
    @return string -- String with line numbers added
]=]
Misc.AddLineNumbers = function(input: string): string
	local output_string = ""
	local line_number = 1

	for line in input:gmatch("([^\n]*)\n?") do
		if line ~= "" then
			output_string = output_string .. string.format("%d  %s\n", line_number, line)
			line_number = line_number + 1
		end
	end

	return output_string
end

--[=[
    @function ToSnowflake
    @within Misc
    @param input string -- String to convert to snowflake
    @return DiscordTypes.snowflake -- Discord snowflake ID
]=]
Misc.ToSnowflake = function(input: string): DiscordTypes.snowflake
    assert(type(input) == "string" and #input >= 17 and #input <= 20 and input:match("^%d+$"), "Invalid snowflake")

    return input :: DiscordTypes.snowflake
end

--[=[
    @function FormatTime
    @within Misc
    @param seconds number -- Number of seconds to format
    @return string -- Formatted time string (e.g. "1d2h3m4s")
]=]
Misc.FormatTime = function(seconds: number): string
    local days = math.floor(seconds / 86400)
    seconds %= 86400
    local hours = math.floor(seconds / 3600)
    seconds %= 3600
    local minutes = math.floor(seconds / 60)
    seconds %= 60

    seconds = math.floor(seconds * 1000) / 1000

    local result = ""
    if days > 0 then 
        result ..= days .. "d" 
    end
    if hours > 0 then 
        result ..= hours .. "h" 
    end
    if minutes > 0 then 
        result ..= minutes .. "m" 
    end
    if seconds > 0 or #result == 0 then
        result ..= seconds .. "s"
    end

    return result
end

--[=[
    @function CreateTempFile
    @within Misc
    @param content string -- Content to write to temporary file
    @return {Path: string, Delete: () -> ()} -- Table containing file path and delete function
]=]
function Misc.CreateTempFile(content: string): {Path: string, Delete: () -> () }
	local tag = Bot.GenerateGUID(false)
	local path = `./Aloha/temp/{tag}.lua`
	fs.writeFile(path, content)
	return {
		Path = path,
		Delete = function(_)
			fs.removeFile(path)
		end
	}, tag
end

--[=[
    @function Beautify
    @within Misc
    @param code string -- Code string to beautify
    @return string -- Beautified code string with proper indentation
]=]
function Misc.Beautify(code: string): string
	local beautified_code = ""
    local indent_level = 0

	local function add_indent(level)
        return string.rep("\t", level)
    end

    code = code:gsub(";", ";\n") 
    code = code:gsub("%s*([{}])%s*", "%1\n") 
    code = code:gsub("(%s*%f[%a](if|for|while|function|do|repeat|else|elseif|then|until)%f[%A])", "\n%1\n") 
    code = code:gsub("%s*do%s*", " do\n") 
    code = code:gsub("%s*end%s*", "\nend\n") 
    code = code:gsub("\n+", "\n") 

    for line in code:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$")

        if line:match("^end") or line:match("^elseif") or line:match("^else") then
            indent_level = indent_level - 1
        end

        beautified_code = beautified_code .. add_indent(indent_level) .. line .. "\n"

        if line:match("%s*%f[%a](do|then|function|repeat)%f[%A]") then
            indent_level = indent_level + 1
        elseif line:match("%s*%f[%a]end%f[%A]") or line:match("%s*%f[%a]until%f[%A]") then
            indent_level = indent_level > 0 and indent_level - 1 or 0
        end
    end

    return beautified_code
end

return Misc