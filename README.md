# Aloha
![](https://img.shields.io/badge/version-0.3.0-orange) ![](https://img.shields.io/badge/license-GPLv3-blue)
<img src="https://cdn.discordapp.com/attachments/1298468918951936010/1299273719482548244/image.png?ex=671c9a72&is=671b48f2&hm=ce3a6397c3f9bc3c5e987dde618611e70d49de9e2655a48d260f95ec73bd85ac&" alt="aloha_logo" style="float: right; margin-left: 10px;" height="150">
 
 Aloha is a Discord API written in Luau using [Lune](https://github.com/lune-org/lune). This is an attempt to make a more up-to-date form of Discordia for people who want to make Discord bots in Luau.


## Current Features:
- Event connection system that allows you to listen in on Discord events with ease.
```lua
local Aloha = require("Aloha")
local Client = require("Client")

Client.On("MESSAGE_CREATE", function(message)
	print(message.content) -- Messages are automatically parsed into a Lua table, and abstracted to make accessing the channel, guild, etc, easier!

	message:Reply("Hello!")
end)
```
- A fully fledged type file for all of Discord's objects, so you don't have to check the docs!
- Enums for all those pesky numbers and constants from Discord.
- A secure WebSocket connection that automatically reconnects on failure.
- A built-in Luau evaluator for your convenience, sandboxed and safe for anyone to use!
- A janitor clone for cleaning up your connections.


## Getting started:
Running Aloha is incredibly simple. Simply call the `Run` function with your bot token and it will handle the rest.
```lua
local Aloha = require("Aloha")
local Enum = require("Enum")
-- DO NOT SHARE YOUR BOT TOKEN WITH ANYONE!
Aloha.Run("YOUR_BOT_TOKEN", Enum.INTENTS.DEFAULT) -- Run takes an optional second argument for intents.
```
Then run the file with `lune run <your_bot_file>.luau` and you're good to go!- - -

