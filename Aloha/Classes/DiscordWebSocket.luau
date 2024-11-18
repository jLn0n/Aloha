--[=[
	@class DiscordWebSocket
	Class to spawn sharded websockets for Discord.
]=]
local DiscordWebSocket = {}
DiscordWebSocket.__index = DiscordWebSocket
local Event = require("./Event")
local Bot = require("../Lib/Bot")
local task = require("@lune/task")
local Client = require("../Lib/Client")
local Misc = require("../Util/Misc")
local Timer = require("./Timer")
local Network = require("../Lib/Network")

type NetSocket = Network.WebSocket

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}
export type DiscordWebSocket = {
	OnMessage: Event.Event<string>,
	OnClose: Event.Event<number, string>,
	Closed: boolean
} & typeof(DiscordWebSocket)

--[=[
	Creates a new DiscordWebSocket.
	@within DiscordWebSocket
	@param url string
	@param token string
	@param shard_id number
	@param shards number
	@return DiscordWebSocket
]=]
function DiscordWebSocket.new(url: string, token: string, shard_id: number, shards: number) : DiscordWebSocket
	local self = setmetatable({}, DiscordWebSocket)

	self._url = url
	self._socket = Network.WebSocket(url)
	self._last_payload = nil
	self.token = token
	self.shard_id = shard_id
	self.shards = shards

	self.Closed = false

	self.OnMessage = Event.new()
	self.OnClose = Event.new()

	Bot.Shards[shard_id] = {Socket = self, ResumeURL = "", SessionID = ""}

	local connect 
	connect = function()
		local retry = false
		self.Closed = false
		local heartbeat_ack = true

		while (not self._socket.getCloseCode() and not self.Closed) or retry do
			retry = false

			local success, message = xpcall(function()
				return self._socket.Next()
			end, function(err)
				print("[WebSocket] Error retrieving next message: " .. err)
				self._socket.Close(4000)
				self.Closed = true
				retry = true
			end)

			if not success then
				print("[WebSocket] Error retrieving next message: " .. message)
				task.wait()
				continue
			end
			
			if not message then 
				print("[WebSocket] No message received.")
				task.wait() 
				continue 
			end

			self.OnMessage:Fire(message)
		
			local payload = Network.JsonDecode(message)
			
			if payload.op == 10 then	
				local initial_delay = (payload.d.heartbeat_interval * math.random()) / 1000
				self._last_heartbeat_interval = payload.d.heartbeat_interval

				local function heartbeat_end_callback()
					if self._socket.getCloseCode() then
						print(`[Shard {self.shard_id}] 🔴 WebSocket closed.`)
						return
					end

					if not heartbeat_ack then
						-- close and reconnect
						print(`[Shard {self.shard_id}] 🧟 Heartbeat not acknowledged. Reconnecting...`)
						retry = true
						if not self._socket.getCloseCode() then
							self._socket.Close(4000)
						end

						task.wait(1)

						self._socket = Network.WebSocket(self._url)
						self.Closed = true

						return
					end

					local heartbeat_payload = Bot.OP.HEARTBEAT(self._last_payload.s)
					local success, err = pcall(function(...)  
						if self._socket.getCloseCode() then
							return
						end

						self:Send(heartbeat_payload)
					end)
					
					if not success or self._socket.getCloseCode() then
						print(`[Shard {self.shard_id}] 🔴 Heartbeat failed to send: {err}`)
						self._socket.Close(4000)
						self._socket = Network.WebSocket(self._url)
						self.Closed = true
						retry = true
						return
					end

					if self.heartbeat_task then
						if coroutine.status(self.heartbeat_task) == "suspended" then
							task.cancel(self.heartbeat_task)
						end
					end

					self.heartbeat_task = task.delay(payload.d.heartbeat_interval / 1000, heartbeat_end_callback)

					heartbeat_ack = false
				end

				task.delay(initial_delay, function()
					heartbeat_end_callback()
					print(`[Shard {self.shard_id}] 💖 Heartbeat started.`)
				end)

				self:Send(Bot.OP.IDENTIFY(self.token, self.shard_id, self.shards, initial_delay))
				print(`[Shard {self.shard_id}] 🔑 Identify sent.`)
			end

			if payload.op == 7 then
				print(`[Shard {self.shard_id}] 🔄 Reconnect signal received. Attempting to resume.`, payload)
				retry = true
				self._socket.Close(4000)
				self.Closed = true
				self._socket = Network.WebSocket(Bot.Shards[self.shard_id].ResumeURL)
				self:Send(Bot.OP.RESUME(self.token, self._last_payload.s, self.shard_id))
			end

			if payload.op == 9 then
				print(`[Shard {self.shard_id}] 🚫 Invalid session. Reconnecting.`, payload)
				self._socket.Close(4000)
				self._socket = Network.WebSocket(self._url)
				self.Closed = true
				break
			end

			if payload.op == 11 then
				print(`[Shard {self.shard_id}] 💜 Heartbeat received. Uptime: {Misc.FormatTime(os.time() - Bot.STARTED_AT)}`)
				heartbeat_ack = true
			end

			if payload.op == 0 and payload.t then
				Client.Fire(payload.t, payload, self.shard_id)
			end

			self._last_payload = payload

			task.wait()

			if retry or self._socket.getCloseCode() then
				print(`[Shard {self.shard_id}] 🔄 Reconnecting WebSocket.`)
				self.Closed = true
				self._socket.Close(4000)
				task.wait(1)
				self._socket = Network.WebSocket(self._url)
				heartbeat_ack = true
				self._last_payload = nil
			end
		end

		self.Closed = true
		print(`[Shard {self.shard_id}] 🔴 WebSocket closed.`, self._socket.getCloseCode())
		self._socket = Network.WebSocket(self._url)
		self.OnClose:Fire(self._socket.getCloseCode(), Bot.CLOSE_REASONS[self._socket.getCloseCode()] or "Unknown")
	end

	self.OnClose:Connect(function(code, reason)
		task.defer(connect)
	end)

	if self.heartbeat_task then
		task.cancel(self.heartbeat_task)
	end

	connect()

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

--[=[
	Sends a payload to Discord.
	@param data Payload
	@within DiscordWebSocket
]=]
function DiscordWebSocket:Send(data: Payload) : ()
	print("[WebSocket] Sending payload: ", data)
	self._socket.Send(Network.JsonEncode(data))
end
return DiscordWebSocket