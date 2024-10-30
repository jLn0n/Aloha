# Aloha
![](https://img.shields.io/badge/Version-0.4.0-orange) ![](https://img.shields.io/badge/License-GPLv3-blue)[](![]())
[![Support Server](https://img.shields.io/badge/Support_Server-5865F2?logo=discord&logoColor=white)](https://discord.gg/S3skPhG2VT)
[![Documentation](https://img.shields.io/badge/Documentation-02B1E9?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8dGl0bGU+TW9vbndhdmU8L3RpdGxlPgogIDxwYXRoIGQ9Ik0xMy43MzkgMTQwLjMzMWMuMjguNDkyLjQ2NSAxLjAwOC44NTEgMS40MzguODczLjk3MyAyLjE3MyAxLjAzMyAzLjI2NC4zOTcuOTg5IDIuMzc1IDMuNTg4IDIuOTgzIDUuODk5IDIuNTQ3LjUzNC0uMSAxLjkxOS0uMyAyLjEzMi0uODYyLTEuNDgzIDAtMy4xMDYuMTctNC4zNjMtLjgxOS0yLjE0Ny0xLjY4OS0uNzE1LTQuNiAxLjM4OC01LjQ3Ny0uMTM4LS40MjYtMS4xNTgtLjM5OC0xLjUzNy0uMzk2LTEuNzYyLjAwNy0yLjk0OCAxLjEwOC0zLjY2OCAyLjYyNy0uNjc1LTEuNzQ4LS4zNTQtMy4yOCAxLjE0LTQuNDg4LjM5Ny0uMzIxLjg0My0uNTM5IDEuMjg5LS43OC4xMTgtLjA2NC4zNDItLjE5Ni4xOC0uMzQxLS4xNjUtLjE0OC0uNTE2LS4xNy0uNzI1LS4yMjJhMTIuMjcyIDEyLjI3MiAwIDAgMC0yLjA4Mi0uMzJjLS44MTktLjA1OC0xLjYyNC0uMDQ0LTIuNDMuMTQ3LTMuMDcuNzI5LTQuMjc2IDMuNTg5LTUuNjM2IDYuMTAzLS41NjcgMS4wNS0xLjA1MSAyLjEyNi0xLjk5OCAyLjkwMi0xLjE1MS45NDQtMi42NzYgMS4xOC00LjExNSAxLS4zNjktLjA0Ni0uNzMtLjEyOC0xLjA5LS4yMTUtLjA4NC0uMDItLjMyNC0uMS0uMzUxLjA0My0uMDQ0LjIzNC43MzEuNDcuODk2LjU0MSAxLjA0NC40NDUgMi4xLjY4OSAzLjIyMi44MjEgMy4wNTkuMzYxIDYuNTMtMS44NTcgNy43MzQtNC42NDZ6IiBzdHlsZT0iZmlsbDojZmZmZmZmO2ZpbGwtb3BhY2l0eToxO3N0cm9rZTpub25lO3N0cm9rZS13aWR0aDouMDQ5NTc0MyIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTEuODg1IC0xMjcuMzEpIi8+Cjwvc3ZnPg==)](https://thegalaxydev.github.io/Aloha/)

 Aloha is a Discord API library written in Luau using [Lune](https://github.com/lune-org/lune). This is an attempt to make a more up-to-date form of Discordia for people who want to make Discord bots in Luau.


## Current Features:
- Event connection system that allows you to listen in on Discord events with ease.
```lua
local Aloha = require("Aloha")
local Client = Aloha.Lib.Client

Client.On("MESSAGE_CREATE", function(message)
	print(message.content) -- Messages are automatically parsed into a Lua table, and abstracted to make accessing the channel, guild, etc, easier!

	message:Reply("Hello!")
end)
```
- A fully fledged type file for all of Discord's objects, so you don't have to check the docs!
- Enums for all those pesky numbers and constants from Discord.
- A secure and efficient WebSocket connection that automatically reconnects on failure.
- A built-in Luau evaluator for your convenience, sandboxed and safe for anyone to use!
- A janitor clone for cleaning up your connections.
- Built-in rate limiting.
- Shard management that scales with your bot.


## Getting started:
Running Aloha is incredibly simple. Simply call the `Run` function with your bot token and it will handle the rest.
```lua
local Aloha = require("Aloha")
local Enum = Aloha.Lib.Enum
-- DO NOT SHARE YOUR BOT TOKEN WITH ANYONE!
Aloha.Run("YOUR_BOT_TOKEN", Enum.INTENTS.DEFAULT) -- Run takes an optional second argument for intents.
```
Then run the file with `lune run <your_bot_file>.luau` and you're good to go!

