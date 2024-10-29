--- @ignore
local Debug = {}
local Objects = require("../Classes/Objects")

Debug.AllowedUsers = {}

function Debug.AddUser(user: Objects.User | string)
	if type(user) == "string" then
		table.insert(Debug.AllowedUsers, user)
		return
	end

	if user.id then
		table.insert(Debug.AllowedUsers, user.id)
	end
end


return Debug