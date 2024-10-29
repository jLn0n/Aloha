--[=[
	@class Network
	@description Library to handle network requests.
]=]
local Network = {}
local net = require("@lune/net")
local Bot = require("./Bot")
local Endpoints = require("./Endpoints")
local task = require("@lune/task")
local Mutex = require("../Util/Mutex")
type Response = net.FetchResponse

export type ServeRequest = net.ServeRequest
export type ServeResponse = net.ServeResponse	
export type ServeHandle = net.ServeHandle
export type WebSocket = {
	Close: () -> (),
	Next: () -> (any),
	Send: (data: string) -> ()
}

-- just straight up rippped this from Discordia lol

local majorRoutes = {guilds = true, channels = true, webhooks = true}
local payloadRequired = {PUT = true, PATCH = true, POST = true}

local function sub(path)
	return not majorRoutes[path] and path .. '/:id'
end

local function route(method, endpoint)
	if endpoint:find('reactions') then
		endpoint = endpoint:match('.*/reactions')
	end

	endpoint = endpoint:gsub('(%a+)/%d+', sub)

	if method == 'DELETE' then
		local i, j = endpoint:find('/channels/%d+/messages')
		if i == 1 and j == #endpoint then
			endpoint = method .. endpoint
		end
	end

	return endpoint
end

local mutexes = setmetatable({}, {
	__index = function(self, k)
		self[k] = Mutex.new()
		return self[k]
	end
})

local function generateBoundary(files, boundary)
	boundary = boundary or tostring(math.random(0, 9))
	for _, v in ipairs(files) do
		if v[2]:find(boundary, 1, true) then
			return generateBoundary(files, boundary .. math.random(0, 9))
		end
	end
	return boundary
end

function Network.AttachFiles(body: string, files: {[any]: any}) : (string, string)
	local boundary = generateBoundary(files)
	local ret = {
		'--' .. boundary,
		'Content-Disposition:form-data;name="payload_json"',
		'Content-Type:application/json\r\n',
		body,
	}
	for i, v in ipairs(files) do
		table.insert(ret, '--' .. boundary)
		table.insert(ret, string.format('Content-Disposition:form-data;name="file%i";filename=%q', i, v[1]))
		table.insert(ret, 'Content-Type:application/octet-stream\r\n')
		table.insert(ret, v[2])
	end
	table.insert(ret, '--' .. boundary .. '--')
	return table.concat(ret, '\r\n'), boundary
end

function Network.Request(data: {method: string, endpoint: string, body: {[string]: any?}?, files: {[any]: any}?}, shard_id: number?) : (boolean, Response)
	local _, current = coroutine.running()

	if current then
		return error("Network requests must be made from a non-main thread.")
	end

	if shard_id then
		if Bot.IsRateLimited(shard_id)[shard_id] then
			print(`[Shard {shard_id}] Rate limited, deferring to the next cycle.`)
			task.wait(1)
		end
	end
	
	local url = Endpoints.BASE_URL .. data.endpoint

	local headers = {
		['Authorization'] = `Bot {Bot.TOKEN}`,
		['User-Agent'] = `Aloha/{Bot.ALOHA_VERSION}`
	}

	local body = data.body

	if payloadRequired[data.method] then
		body = data.body and Network.JsonEncode(data.body) or '{}'
		if data.files and next(data.files) then
			local boundary
			body, boundary = Network.AttachFiles(body, data.files)
			headers['Content-Type'] = `multipart/form-data;boundary={boundary}`
		else
			headers['Content-Type'] = "application/json"
		end
		headers['Content-Length'] = tostring(#body)
	end

	local mutex = mutexes[route(data.method, data.endpoint)]
	local response, delay = Network.Commit(data.method, url, headers, body, 0)
	mutex:UnlockAfter(delay)

	-- this is gross im sorry
	return not not response, response
end

function Network.Commit(method: string, url: string, headers: {[any]: any}, body: string?, retries: number) : ({[any]: any}, number)
	local delay = 250
	
	local success, response = pcall(function()
		return net.request({
			url = url,
			method = method,
			body = body,
			headers = headers
		})
	end)

	if not success then
		return response, delay
	end

	for i, v in ipairs(response) do
		response[v[1]:lower()] = v[2]
		response[i] = nil
	end

	if response['x-ratelimit-remaining'] == '0' then
		delay = math.max(1000 * response['x-ratelimit-reset-after'], delay)
	end

	local data = response['content-type'] == 'application/json' and net.jsonDecode(response.body) or response.body

	if response.statusCode < 300 then
		if type(data) == "string" then
			data = net.jsonDecode(data)
		end
		return data, delay
	end

	if type(data) ~= 'table' then
		return data, delay
	end

	local retry
	if response.statusCode == 502 then
		delay = delay + math.random(2000)
		retry = retries < 3
	elseif response.statusCode == 429 then
		delay = 1000 * data['retry-after']
		retry = retries < 3
	end

	if retry and delay then
		task.wait(delay / 1000)
		return Network.Commit(method, url, headers, body, retries + 1)
	end

	return response, delay
end

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