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

	task.spawn(function()
		while not self._socket.closeCode do
			local message = self._socket.next()
	
			if message then
				self.OnMessage:Fire(message)
				local payload = net.jsonDecode(message)
				self._last_payload = payload
				
				if payload.op == 10 then					
					task.spawn(function()
						task.wait((payload.d.heartbeat_interval * math.random()) / 1000)
						self:Send(API.OP.HEARTBEAT(self._last_payload.s))

						while not self._socket.closeCode do
							task.wait(payload.d.heartbeat_interval / 1000)
							self:Send(API.OP.HEARTBEAT(self._last_payload.s))
						end
					end)

					self:Send(API.OP.HELLO(self.token))

					continue
				end

				if payload.op == 7 then
					self._socket.close()

					print("Socket disconnected, reconnecting...")

					print("Creating new socket...")
					self._socket = net.socket(self._url)
					self:HandleMessage()

					return
				end

				if payload.op == 9 then
					print("Socket resumed.")
				end

				Client.Fire(payload.t, payload)
			end
		end

		self.Closed = true
		self.OnClose:Fire(self._socket.closeCode)
	end)

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