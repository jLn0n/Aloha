---
sidebar_position: 1
---

#  Aloha

The base for the entire library, and the engine that makes it all run.

## Properties
- None

## Methods

### `Aloha.Run(token: string, intents: number?)`

This is what gets your bot running. The first argument is required, and is your bot token, formatted **without** the `Bot ` prefix. It adds it for you!

Takes an optional second parameter for **[intents](https://discord.com/developers/docs/events/gateway#gateway-intents)**. Aloha provides you with some base intents to use in the **Enum** module:
| Enum             | Description                                       |
|------------------|---------------------------------------------------|
| INTENTS.ALL      | Includes all intents, with privileged intents.    |
| INTENTS.NONE     | Includes no intents.                              |
| INTENTS.DEFAULT  | Includes all intents WITHOUT privileged intents.  |
 ```luau
Aloha.Run(BOT_TOKEN_STRING, Enum.INTENTS.ALL)
-- Let's get this ball rolling!
```
***
### `Aloha.RegisterDefaultCommands(options: DefaultCommandOptions?) : {Command}`
Aloha comes with a few built-in application commands to make your life easier. This function will register all of them for you and allow them to be used on your bot. **Note: None of these commands require privileged intents.**

Takes an optional dictionary of options, and returns an array of all the commands registered.
| Option     | Description                                      |
|------------|--------------------------------------------------|
| rateLimit  | Sets the bot's command rate limit, calculated per individual user. |
```luau
Aloha.RegisterDefaultCommands({rateLimit = 5})
```
***
### `Aloha.RegisterCommandsIn(directory: string)`
This will allow you to register commands in a given directory. An example of command formatting is shown below.

```luau
Aloha.RegisterCommandsIn("./Commands")
```

#### Command format example:
```luau
return {
	Data = {
		name = "uptime",
		description = "shows the uptime of Aloha.",
		type = Enum.APPLICATION_COMMAND_TYPE.CHAT_INPUT
	},

	Response = function(data: DiscordTypes.ApplicationCommandInteractionData)
		return {
			type = Enum.INTERACTION_CALLBACK_TYPE.CHANNEL_MESSAGE_WITH_SOURCE,
			data = {
				embeds = {
					Embed.new().setColor(Color3.new(252/255, 152/255, 3/255))
					.setDescription(`Aloha has been online for {Misc.FormatTime(os.time() - Bot.STARTED_AT)}`).finish()
				},
				flags = Enum.MESSAGE_FLAGS.EPHEMERAL
			}
		}
		
	end
}
```
***
### `Aloha.ClearTemp()`
Clears the `/temp` folder. This is automatically called in `Run`, but if for whatever reason you need to do it on runtime, you can!

