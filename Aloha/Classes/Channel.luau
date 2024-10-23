local Channel = {}
Channel.__index = Channel

export type Channel = {

}

function Channel.new(data: {[string]: any})
	local self = setmetatable({}, Channel)


	return self
end
return Channel