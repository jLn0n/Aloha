--[=[
    @class Debug
    Handles debug functionality and user permissions for debugging
]=]
local Debug = {}
local Objects = require("../Classes/Objects")

--[=[
    @prop AllowedUsers {string}
    @within Debug
    List of user IDs that are allowed to use debug functionality
]=]
Debug.AllowedUsers = {}

--[=[
    @function AddUser
    @within Debug
    @param user Objects.User | string -- The user or user ID to add to allowed users
    Adds a user to the list of users allowed to use debug functionality
]=]
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