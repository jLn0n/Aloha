-- Net WebSocket wrapper
local WebSocket = {}
WebSocket.__index = WebSocket
local net = require("@lune/net")
local Event = require("./Event")
local API = require("../Lib/API")
local task = require("@lune/task")
local Client = require("../Lib/Client")

type NetSocket = net.WebSocket
type Event = Event.Event

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}
export type WebSocket = {
	OnMessage: Event,
	OnClose: Event,
	Closed: boolean
} & typeof(WebSocket)

function WebSocket.new(url: string, token: string) : WebSocket | any
	local self = setmetatable({}, WebSocket)

	self._url = url
	self._socket = net.socket(url)
	self._last_payload = nil
	self.token = token

	self.Closed = false

	self.OnMessage = Event.new()
	self.OnClose = Event.new()

	local connect 
	connect = function()
		local retry = false
		while (not self._socket.closeCode) or retry do
			retry = false

			local success, message = xpcall(function()
				return self._socket.next()
			end, function(err)
				print("[WebSocket] Error retrieving next message: " .. err)
			end)

			if not success then
				retry = true
				continue
			end
			
			if message then
				self.OnMessage:Fire(message)
				local payload = net.jsonDecode(message)
				self._last_payload = payload
				
				if payload.op == 10 then					
					task.spawn(function()
						task.wait((payload.d.heartbeat_interval * math.random()) / 1000)
						if self._socket.closeCode then return end
						self:Send(API.OP.HEARTBEAT(self._last_payload.s))

						while not self._socket.closeCode do
							task.wait(payload.d.heartbeat_interval / 1000)
							if self._socket.closeCode then break end
							self:Send(API.OP.HEARTBEAT(self._last_payload.s))
						end
					end)

					self:Send(API.OP.HELLO(self.token))

					continue
				end

				if payload.op == 7 then
					retry = true
					self._socket.close()
					self._socket = net.socket(API.RESUME_URL)
					self._socket.send(API.OP.RESUME(self.token, self._last_payload.s))

					continue
				end

				if payload.op == 9 then
					retry = true
					self._socket.close()
					self._socket = net.socket(self._url)
					
					continue
				end
				
				if payload.t then
					Client.Fire(payload.t, payload)
				end
			end
		end

		self.Closed = true
		self.OnClose:Fire(self._socket.closeCode)

		self._socket = net.socket(self._url)

		connect()
	end

	task.spawn(connect)

	return setmetatable({}, {	
		__newindex = function(_, index, value)
			if index:sub(1,1):lower() == index:sub(1,1) then
				return
			end

			self[index] = value
		end,

		__index = function(_, index)
			print(index)
			if index:sub(1,1) == "_" then
				return
			end

			return self[index]
		end
	})
end


function WebSocket:Send(data: Payload) : ()
	self._socket.send(net.jsonEncode(data))
end
return WebSocket