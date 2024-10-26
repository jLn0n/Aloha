-- Net WebSocket wrapper
local WebSocket = {}
WebSocket.__index = WebSocket
local net = require("@lune/net")
local Event = require("./Event")
local API = require("../Lib/API")
local task = require("@lune/task")
local Client = require("../Lib/Client")
local Misc = require("./Misc")
local serde = require("@lune/serde")

type NetSocket = net.WebSocket
type Event = Event.Event

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}
export type WebSocket = {
	OnMessage: Event,
	OnClose: Event,
	Closed: boolean
} & typeof(WebSocket)

function WebSocket.new(url: string, token: string) : WebSocket
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
		local heartbeat_ack = true
		local ZLIB_SUFFIX = "\0\0\255\255"
		local buffer = ""
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
				self.Closed = false
				self.OnMessage:Fire(message)
				local payload
				
				buffer ..= message

				if #message < 4 or message:sub(-4) ~= ZLIB_SUFFIX then
					local s, d = pcall(function()
						return net.jsonDecode(message)
					end)

					if s then
						payload = d
					else
						continue
					end
				end

				if not payload then
					local decompressed = serde.decompress("zlib", buffer)
					payload = net.jsonDecode(decompressed)
				end

				buffer = ""
				
				if payload.op == 10 then					
					task.spawn(function()
						task.wait((payload.d.heartbeat_interval * math.random()) / 1000)
						if self._socket.closeCode then return end
						local heartbeat_payload = API.OP.HEARTBEAT(payload.s)
						self:Send(heartbeat_payload)
						print("[WebSocket] 💖 Initial heartbeat sent.", heartbeat_payload)
						while not self._socket.closeCode and not self.Closed do
							task.wait(payload.d.heartbeat_interval / 1000)
							if self._socket.closeCode then break end
							if not heartbeat_ack then
								print("[WebSocket] 💔 The dead walk among us. Reconnecting...", payload)

								self._socket.close()
								self._socket = net.socket(self._url)

								continue
							end

							heartbeat_ack = true
							heartbeat_payload = API.OP.HEARTBEAT(self._last_payload.s)
							print("[WebSocket] 💖 Heartbeat sent.", heartbeat_payload)
							self:Send(heartbeat_payload)
						end
					end)

					self:Send(API.OP.HELLO(self.token))

					continue
				end

				if payload.op == 7 then
					print("[WebSocket] 🔄 Reconnect signal received. Attempting to resume.", payload)
					retry = true
					self._socket.close()
					self._socket = net.socket(API.RESUME_URL)
					self._socket.send(API.OP.RESUME(self.token, self._last_payload.s))

					continue
				end

				if payload.op == 9 then
					print("[WebSocket] 🚫 Invalid session. Reconnecting.", payload)
					self._socket.close()
					self._socket = net.socket(self._url)
					
					break
				end

				if payload.op ~= 0 and payload.op ~= 11 then
					print("[WebSocket] ❓ Unknown opcode received.", payload)
				end
				
				if payload.op == 11 then
					print("[WebSocket] ❤️ Heartbeat received. Uptime: " .. Misc.FormatTime(os.time() - API.STARTED_AT))
					heartbeat_ack = true
				end
				
				if payload.op == 0 and payload.t then
					Client.Fire(payload.t, payload)
				end

				self._last_payload = payload
			end
		end

		self.Closed = true
		self.OnClose:Fire(self._socket.closeCode, API.CLOSE_REASONS[self._socket.closeCode] or "Unknown")

		self._socket = net.socket(self._url)

		connect()
	end

	task.spawn(connect)

	local proxy = setmetatable({}, {	
		__newindex = function(_, index, value)
			if index:sub(1,1):lower() == index:sub(1,1) then
				return
			end

			self[index] = value
		end,

		__index = function(_, index)
			if index:sub(1,1) == "_" then
				return
			end

			return self[index]
		end
	})

	return proxy
end


function WebSocket:Send(data: Payload) : ()
	print("[WebSocket] 📤 Sending payload.", net.jsonEncode(data))
	self._socket.send(net.jsonEncode(data))
end
return WebSocket