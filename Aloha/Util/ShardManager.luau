local ShardManager = {}
local DiscordWebSocket = require("DiscordWebSocket")
local DiscordTypes = require("../Lib/DiscordTypes")
ShardManager.Shards = {}
ShardManager.ShardCount = 0

function ShardManager.InitializeShards(gateway_url: string, token: string, shards: number)
	for shard_id = 0, shards - 1 do
		ShardManager.Shards[shard_id] = DiscordWebSocket.new(gateway_url, `Bot {token}`, shard_id, shards)
	end

	ShardManager.ShardCount = shards

	return ShardManager.Shards
end

function ShardManager.GetShard(guild_id: DiscordTypes.snowflake)
	local id = tonumber(guild_id)
	if not id then return end

	local shard_id = bit32.rshift(id, 22) % ShardManager.ShardCount

	return ShardManager.Shards[shard_id]
end

return ShardManager