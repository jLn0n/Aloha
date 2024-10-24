local Misc = {}
local API = require("../Lib/API")
local fs = require("@lune/fs")
Misc.AddLineNumbers = function(input: string): string
	local output_string = ""
	local line_number = 1

	for line in input:gmatch("([^\n]*)\n?") do
		if line ~= "" then
			output_string = output_string .. string.format("%d    %s\n", line_number, line)
			line_number = line_number + 1
		end
	end

	return output_string
end

function Misc.CreateTempFile(content: string): {Path: string, Delete: () -> () }
	local tag = API.GenerateGUID(false)
	local path = `./Aloha/temp/{tag}.lua`
	fs.writeFile(path, content)
	return {
		Path = path,
		Delete = function(_)
			fs.removeFile(path)
		end
	}
end

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