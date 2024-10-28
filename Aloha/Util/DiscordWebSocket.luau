-- Net WebSocket wrapper
local DiscordWebSocket = {}
DiscordWebSocket.__index = DiscordWebSocket
local Event = require("./Event")
local Bot = require("../Lib/Bot")
local task = require("@lune/task")
local Client = require("../Lib/Client")
local Misc = require("./Misc")
local Timer = require("./Timer")
local Network = require("../Lib/Network")

type NetSocket = Network.WebSocket
type Event = Event.Event

type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}
export type DiscordWebSocket = {
	OnMessage: Event,
	OnClose: Event,
	Closed: boolean
} & typeof(DiscordWebSocket)

function DiscordWebSocket.new(url: string, token: string, shard_id: number, shards: number) : DiscordWebSocket
	local self = setmetatable({}, DiscordWebSocket)

	self._url = url
	self._socket = Network.WebSocket(url)
	self._last_payload = nil
	self.token = token
	self.shard_id = shard_id
	self.shards = shards
	self._last_heartbeat_interval = 0
	self._heartbeat_timer = nil

	self.Closed = false

	self.OnMessage = Event.new()
	self.OnClose = Event.new()

	local connect 
	connect = function()
		local retry = false
		local heartbeat_ack = true

		while (not self._socket.getCloseCode()) or retry do
			retry = false

			local success, message = xpcall(function()
				return self._socket.Next()
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
			
				local payload = Network.JsonDecode(message)
				
				if payload.op == 10 then	
					local initial_delay = (payload.d.heartbeat_interval * math.random()) / 1000
					self._last_heartbeat_interval = payload.d.heartbeat_interval

					local function heartbeat_interval_callback()
						if self._socket.getCloseCode() then
							print(`[Shard {self.shard_id}] 🔴 WebSocket closed.`)
							self._heartbeat_timer:Stop()
						end
					end

					local function heartbeat_end_callback()
						if self._socket.getCloseCode() then
							print(`[Shard {self.shard_id}] 🔴 WebSocket closed.`)
							self._heartbeat_timer:Stop()
							return
						end

						local heartbeat_payload = Bot.OP.HEARTBEAT(self._last_payload.s)
						self:Send(heartbeat_payload)
						print(`[Shard {self.shard_id}] 💖 Heartbeat sent.`, heartbeat_payload)

						self._heartbeat_timer = Timer.new(payload.d.heartbeat_interval / 1000, 1, heartbeat_interval_callback, heartbeat_end_callback)
					end

					self._heartbeat_timer = Timer.new(initial_delay, 1, heartbeat_interval_callback, heartbeat_end_callback)


					self:Send(Bot.OP.IDENTIFY(self.token, self.shard_id, self.shards, initial_delay))

					continue
				end

				if payload.op == 7 then
					print(`[Shard {self.shard_id}] 🔄 Reconnect signal received. Attempting to resume.`, payload)
					retry = true
					self._socket.Close()
					self._socket = Network.WebSocket(Bot.RESUME_URL)
					self._socket.Send(Bot.OP.RESUME(self.token, self._last_payload.s, self.shard_id))
					continue
				end

				if payload.op == 9 then
					print(`[Shard {self.shard_id}] 🚫 Invalid session. Reconnecting.`, payload)
					self._socket.Close()
					self._socket = Network.WebSocket(self._url)
					break
				end

				if payload.op == 11 then
					print(`[Shard {self.shard_id}] 💜 Heartbeat received. Uptime: {Misc.FormatTime(os.time() - Bot.STARTED_AT)} (Next in: {Misc.FormatTime(self._last_heartbeat_interval / 1000)})`)
					heartbeat_ack = true
				end

				if payload.op == 0 and payload.t then
					Client.Fire(payload.t, payload)
				end

				self._last_payload = payload
			end
		end

		self.Closed = true
		self.OnClose:Fire(self._socket.getCloseCode(), Bot.CLOSE_REASONS[self._socket.getCloseCode()] or "Unknown")

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
	self._socket.Send(Network.JsonEncode(data))
end
return DiscordWebSocket