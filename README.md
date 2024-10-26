# Aloha <img src="https://cdn.discordapp.com/attachments/1298813084844167219/1299610722954641489/image.png?ex=671dd44d&is=671c82cd&hm=6b6d5476c4ffe5d20da86760a90e2d3f94b818fb0e0eeca2b987e2442f974023&" alt="aloha_logo" height="50">
![](https://img.shields.io/badge/Version-0.3.0-orange) ![](https://img.shields.io/badge/License-GPLv3-blue)[](![]())
[![Support Server](https://img.shields.io/badge/Support_Server-5865F2?logo=discord&logoColor=white)](https://discord.gg/S3skPhG2VT)
 
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

