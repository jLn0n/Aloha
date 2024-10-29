--[=[
    @class Enum
    Enums used throughout the library
]=]

--[=[
    @interface APPLICATION_COMMAND_OPTION_TYPE
    @within Enum
    @field SUB_COMMAND number -- Subcommand option type
    @field SUB_COMMAND_GROUP number -- Subcommand group option type 
    @field STRING number -- String option type
    @field INTEGER number -- Integer option type
    @field BOOLEAN number -- Boolean option type
    @field USER number -- User option type
    @field CHANNEL number -- Channel option type
    @field ROLE number -- Role option type
    @field MENTIONABLE number -- Mentionable option type
    @field NUMBER number -- Number option type
    @field ATTACHMENT number -- Attachment option type
]=]

--[=[
    @interface CHANNEL_TYPE
    @within Enum
    @field GUILD_TEXT number -- Text channel
    @field DM number -- DM channel
    @field GUILD_VOICE number -- Voice channel
    @field GROUP_DM number -- Group DM channel
    @field GUILD_CATEGORY number -- Category channel
    @field GUILD_ANNOUNCEMENT number -- Announcement channel
    @field ANNOUNCEMENT_THREAD number -- Announcement thread
    @field PUBLIC_THREAD number -- Public thread
    @field PRIVATE_THREAD number -- Private thread
    @field GUILD_STAGE_VOICE number -- Stage voice channel
    @field GUILD_DIRECTORY number -- Directory channel
    @field GUILD_FORUM number -- Forum channel
    @field GUILD_MEDIA number -- Media channel
]=]

--[=[
    @interface INTERACTION_TYPE
    @within Enum
    @field PING number -- Ping interaction
    @field APPLICATION_COMMAND number -- Application command interaction
    @field MESSAGE_COMPONENT number -- Message component interaction
    @field APPLICATION_COMMAND_AUTOCOMPLETE number -- Application command autocomplete interaction
    @field MODAL_SUBMIT number -- Modal submit interaction
]=]

--[=[
    @interface INTERACTION_CALLBACK_TYPE
    @within Enum
    @field PONG number -- Pong response
    @field CHANNEL_MESSAGE_WITH_SOURCE number -- Channel message with source
    @field DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE number -- Deferred channel message with source
    @field DEFERRED_UPDATE_MESSAGE number -- Deferred message update
    @field UPDATE_MESSAGE number -- Message update
    @field APPLICATION_COMMAND_AUTOCOMPLETE_RESULT number -- Autocomplete result
    @field MODAL number -- Modal response
    @field PREMIUM_REQUIRED number -- Premium required response
    @field LAUNCH_ACTIVITY number -- Launch activity response
]=]

--[=[
    @interface INTERACTION_CONTEXT_TYPE
    @within Enum
    @field GUILD number -- Guild context
    @field BOT_DM number -- Bot DM context
    @field PRIVATE_CHANNEL number -- Private channel context
]=]

--[=[
    @interface APPLICATION_INTEGRATION_TYPE
    @within Enum
    @field GUILD_INSTALL number -- Guild installation
    @field USER_INSTALL number -- User installation
]=]

--[=[
    @interface APPLICATION_COMMAND_TYPE
    @within Enum
    @field CHAT_INPUT number -- Chat input command
    @field USER number -- User command
    @field MESSAGE number -- Message command
    @field PRIMARY_ENTRY_POINT number -- Primary entry point command
]=]

--[=[
    @interface APPLICATION_COMMAND_HANDLER
    @within Enum
    @field APP_HANDLER number -- App handler
    @field DISCORD_LAUNCH_ACTIVITY number -- Discord launch activity
]=]

--[=[
    @interface MESSAGE_FLAGS
    @within Enum
    @field CROSSPOST number -- Message is crossposted
    @field IS_CROSSPOST number -- Message is a crosspost
    @field SUPPRESS_EMBEDS number -- Message embeds are suppressed
    @field SOURCE_MESSAGE_DELETED number -- Source message was deleted
    @field URGENT number -- Message is urgent
    @field HAS_THREAD number -- Message has a thread
    @field EPHEMERAL number -- Message is ephemeral
    @field LOADING number -- Message is loading
    @field FAILED_TO_MENTION_SOME_ROLES_IN_THREAD number -- Failed to mention some roles in thread
    @field SUPPRESS_NOTIFICATIONS number -- Notifications are suppressed
    @field IS_VOICE_MESSAGE number -- Message is a voice message
]=]

--[=[
    @interface INTENTS
    @within Enum
    @field DEFAULT number -- Default intents
    @field NONE number -- No intents
    @field ALL number -- All intents
]=]

return {
	APPLICATION_COMMAND_OPTION_TYPE = {
		SUB_COMMAND = 1,
		SUB_COMMAND_GROUP = 2,
		STRING = 3,
		INTEGER = 4,
		BOOLEAN = 5,
		USER = 6,
		CHANNEL = 7,
		ROLE = 8,
		MENTIONABLE = 9,
		NUMBER = 10,
		ATTACHMENT = 1
	},

	CHANNEL_TYPE = {
		GUILD_TEXT = 0,
		DM = 1,
		GUILD_VOICE = 2,
		GROUP_DM = 3,
		GUILD_CATEGORY = 4,
		GUILD_ANNOUNCEMENT = 5,
		ANNOUNCEMENT_THREAD = 10,
		PUBLIC_THREAD = 11,
		PRIVATE_THREAD = 12,
		GUILD_STAGE_VOICE = 13,
		GUILD_DIRECTORY = 14,
		GUILD_FORUM = 15,
		GUILD_MEDIA = 16
	},

	INTERACTION_TYPE = {
		PING = 1,
		APPLICATION_COMMAND = 2,
		MESSAGE_COMPONENT = 3,
		APPLICATION_COMMAND_AUTOCOMPLETE = 4,
		MODAL_SUBMIT = 5
	},

	INTERACTION_CALLBACK_TYPE = {
		PONG = 1,
		CHANNEL_MESSAGE_WITH_SOURCE = 4,
		DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE = 5,
		DEFERRED_UPDATE_MESSAGE = 6,
		UPDATE_MESSAGE = 7,
		APPLICATION_COMMAND_AUTOCOMPLETE_RESULT = 8,
		MODAL = 9,
		PREMIUM_REQUIRED = 10,
		LAUNCH_ACTIVITY = 12
	},

	INTERACTION_CONTEXT_TYPE = {
		GUILD = 0,
		BOT_DM = 1,
		PRIVATE_CHANNEL = 2
	},

	APPLICATION_INTEGRATION_TYPE = {
		GUILD_INSTALL = 0,
		USER_INSTALL = 1
	},

	APPLICATION_COMMAND_TYPE = {
		CHAT_INPUT = 1,
		USER = 2,
		MESSAGE = 3,
		PRIMARY_ENTRY_POINT = 4
	},

	APPLICATION_COMMAND_HANDLER = {
		APP_HANDLER = 1,
		DISCORD_LAUNCH_ACTIVITY = 2
	},

	MESSAGE_FLAGS = {
		CROSSPOST = bit32.lshift(1, 0),
		IS_CROSSPOST = bit32.lshift(1, 1),
		SUPPRESS_EMBEDS = bit32.lshift(1, 2),
		SOURCE_MESSAGE_DELETED = bit32.lshift(1, 3),
		URGENT = bit32.lshift(1, 4),
		HAS_THREAD = bit32.lshift(1, 5),
		EPHEMERAL = bit32.lshift(1, 6),
		LOADING = bit32.lshift(1, 7),
		FAILED_TO_MENTION_SOME_ROLES_IN_THREAD = bit32.lshift(1, 8),
		SUPPRESS_NOTIFICATIONS = bit32.lshift(1, 12),
		IS_VOICE_MESSAGE = bit32.lshift(1, 13)
	},

	INTENTS = {
		DEFAULT = 53575421,
		NONE = 0,
		ALL = 53608447
	}
}
