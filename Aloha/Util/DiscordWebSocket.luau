-- Net WebSocket wrapper
local DiscordWebSocket = {}
DiscordWebSocket.__index = DiscordWebSocket
local Event = require("./Event")
local Bot = require("../Lib/Bot")
local task = require("@lune/task")
local Client = require("../Lib/Client")
local Misc = require("./Misc")
local Network = require("../Lib/Network")

type NetSocket = Network.WebSocket
type Event = Event.Event

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}
export type DiscordWebSocket = {
	OnMessage: Event,
	OnClose: Event,
	Closed: boolean
} & typeof(DiscordWebSocket)

function DiscordWebSocket.new(url: string, token: string) : DiscordWebSocket
	local self = setmetatable({}, DiscordWebSocket)

	self._url = url
	self._socket = Network.WebSocket(url)
	self._last_payload = nil
	self.token = token

	self.Closed = false

	self.OnMessage = Event.new()
	self.OnClose = Event.new()

	local connect 
	connect = function()
		local retry = false
		local heartbeat_ack = true
		--local ZLIB_SUFFIX = "\0\0\255\255"
		--local buffer = ""
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
				--[[local payload
				
				buffer ..= message

				if #message < 4 or message:sub(-4) ~= ZLIB_SUFFIX then
					local s, d = pcall(function()
						return Network.JsonDecode(message)
					end)

					if s then
						payload = d
					else
						continue
					end
				end

				if not payload then
					local decompressed = serde.decompress("zlib", buffer)
					payload = Network.JsonDecode(decompressed)
				end

				buffer = ""]]

				local payload = Network.JsonDecode(message)
				
				if payload.op == 10 then					
					task.spawn(function()
						task.wait((payload.d.heartbeat_interval * math.random()) / 1000)
						if self._socket.closeCode then return end
						local heartbeat_payload = Bot.OP.HEARTBEAT(payload.s)
						self:Send(heartbeat_payload)
						print("[WebSocket] 💖 Initial heartbeat sent.", heartbeat_payload)
						while not self._socket.closeCode and not self.Closed do
							task.wait(payload.d.heartbeat_interval / 1000)
							if self._socket.closeCode then break end
							if not heartbeat_ack then
								print("[WebSocket] 💔 The dead walk among us. Reconnecting...", payload)

								self._socket.close()
								self._socket = Network.WebSocket(self._url)

								continue
							end

							heartbeat_ack = true
							heartbeat_payload = Bot.OP.HEARTBEAT(self._last_payload.s)
							print("[WebSocket] 💖 Heartbeat sent.", heartbeat_payload)
							self:Send(heartbeat_payload)
						end
					end)

					self:Send(Bot.OP.HELLO(self.token))

					continue
				end

				if payload.op == 7 then
					print("[WebSocket] 🔄 Reconnect signal received. Attempting to resume.", payload)
					retry = true
					self._socket.close()
					self._socket = Network.WebSocket(Bot.RESUME_URL)
					self._socket.send(Bot.OP.RESUME(self.token, self._last_payload.s))

					continue
				end

				if payload.op == 9 then
					print("[WebSocket] 🚫 Invalid session. Reconnecting.", payload)
					self._socket.close()
					self._socket = Network.WebSocket(self._url)
					
					break
				end

				if payload.op ~= 0 and payload.op ~= 11 then
					print("[WebSocket] ❓ Unknown opcode received.", payload)
				end
				
				if payload.op == 11 then
					print("[WebSocket] ❤️ Heartbeat received. Uptime: " .. Misc.FormatTime(os.time() - Bot.STARTED_AT))
					heartbeat_ack = true
				end
				
				if payload.op == 0 and payload.t then
					Client.Fire(payload.t, payload)
				end

				self._last_payload = payload
			end
		end

		self.Closed = true
		self.OnClose:Fire(self._socket.closeCode, Bot.CLOSE_REASONS[self._socket.closeCode] or "Unknown")

		self._socket = Network.WebSocket(self._url)

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


function DiscordWebSocket:Send(data: Payload) : ()
	print("[WebSocket] 📤 Sending payload.", Network.JsonEncode(data))
	self._socket.send(Network.JsonEncode(data))
end
return DiscordWebSocket