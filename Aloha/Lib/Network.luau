local Network = {}
local net = require("@lune/net")

export type ServeRequest = net.ServeRequest
export type ServeResponse = net.ServeResponse	
export type ServeHandle = net.ServeHandle
export type WebSocket = {
	Close: () -> (),
	Next: () -> (any),
	Send: (data: string) -> ()
}

function Network.Get(url: string, headers: {[string]: string}) : (boolean, string)
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "GET",
			headers = headers
		})
	end)

	return success, response
end

function Network.Post(url: string, body: string, headers: {[string]: string}) : (boolean, string)
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "POST",
			body = body,
			headers = headers
		})
	end)

	return success, response
end

function Network.Delete(url: string, headers: {[string]: string}) : (boolean, string)
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "DELETE",
			headers = headers
		})
	end)

	return success, response
end

function Network.Patch(url: string, body: string, headers: {[string]: string}) : (boolean, string)
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PATCH",
			body = body,
			headers = headers
		})
	end)

	return success, response
end

function Network.Put(url: string, body: string, headers: {[string]: string}) : (boolean, string)
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = "PUT",
			body = body,
			headers = headers
		})
	end)

	return success, response
end

function Network.WebSocket(url: string) : WebSocket
	local newSocket = net.socket(url)


	return {
		Close = newSocket.close,
		Next = newSocket.next,
		Send = newSocket.send,
		getCloseCode = function() return newSocket.closeCode end
	}
end

function Network.Server(port: number, callback: (request: ServeRequest) -> ServeResponse) : ServeHandle
	return net.serve(port, callback)
end	

function Network.JsonEncode(data: any) : string
	return net.jsonEncode(data)
end

function Network.JsonDecode(data: string) : {[any]: any}
	return net.jsonDecode(data)
end

function Network.UrlEncode(data: string) : string
	return net.urlEncode(data)
end

function Network.UrlDecode(data: string) : string
	return net.urlDecode(data)
end

return Network