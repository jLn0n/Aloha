local LinkedList = require("../Classes/LinkedList")

local Cache = {
	Channels = {},
	Guilds = {},

	Users = LinkedList.new(),
	Members = LinkedList.new(),
	Messages = LinkedList.new()
}

return Cache