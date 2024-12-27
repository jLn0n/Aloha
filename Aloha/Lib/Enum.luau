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
    @interface PERMISSIONS
    @within Enum
    @field CREATE_INSTANT_INVITE number -- Create instant invite
    @field KICK_MEMBERS number -- Kick members
    @field BAN_MEMBERS number -- Ban members
    @field ADMINISTRATOR number -- Administrator
    @field MANAGE_CHANNELS number -- Manage channels
    @field MANAGE_GUILD number -- Manage guild
    @field ADD_REACTIONS number -- Add reactions
    @field VIEW_AUDIT_LOG number -- View audit log
    @field PRIORITY_SPEAKER number -- Priority speaker
    @field STREAM number -- Stream
    @field VIEW_CHANNEL number -- View channel
    @field SEND_MESSAGES number -- Send messages
    @field SEND_TTS_MESSAGES number -- Send TTS messages
    @field MANAGE_MESSAGES number -- Manage messages
    @field EMBED_LINKS number -- Embed links
    @field ATTACH_FILES number -- Attach files
    @field READ_MESSAGE_HISTORY number -- Read message history
    @field MENTION_EVERYONE number -- Mention everyone
    @field USE_EXTERNAL_EMOJIS number -- Use external emojis
    @field VIEW_GUILD_INSIGHTS number -- View guild insights
    @field CONNECT number -- Connect
    @field SPEAK number -- Speak
    @field MUTE_MEMBERS number -- Mute members
    @field DEAFEN_MEMBERS number -- Deafen members
    @field MOVE_MEMBERS number -- Move members
    @field USE_VAD number -- Use voice activity detection
    @field CHANGE_NICKNAME number -- Change nickname
    @field MANAGE_NICKNAMES number -- Manage nicknames
    @field MANAGE_ROLES number -- Manage roles
    @field MANAGE_WEBHOOKS number -- Manage webhooks
    @field MANAGE_EMOJIS_AND_STICKERS number -- Manage emojis and stickers
    @field USE_APPLICATION_COMMANDS number -- Use application commands
    @field REQUEST_TO_SPEAK number -- Request to speak
    @field MANAGE_EVENTS number -- Manage events
    @field MANAGE_THREADS number -- Manage threads
    @field CREATE_PUBLIC_THREADS number -- Create public threads
    @field CREATE_PRIVATE_THREADS number -- Create private threads
    @field USE_EXTERNAL_STICKERS number -- Use external stickers
    @field SEND_MESSAGES_IN_THREADS number -- Send messages in threads
    @field USE_EMBEDDED_ACTIVITIES number -- Use embedded activities
    @field MODERATE_MEMBERS number -- Moderate members
]=]

--[=[
    @interface INTENTS
    @within Enum
    @field DEFAULT number -- Default intents
    @field NONE number -- No intents
    @field ALL number -- All intents
]=]

local bit64 = require("../Classes/Bit64")

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

	COMPONENT = {
		ACTION_ROW = 1,
		BUTTON = 2,
		STRING_SELECT = 3,
		TEXT_INPUT = 4,
		USER_SELECT = 5,
		ROLE_SELECT = 6,
		MENTIONABLE_SELECT = 7,
		CHANNEL_SELECT = 8
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
		CROSSPOST = bit64.lshift(bit64.from_u32(1), 0),
		IS_CROSSPOST = bit64.lshift(bit64.from_u32(1), 1),
		SUPPRESS_EMBEDS = bit64.lshift(bit64.from_u32(1), 2),
		SOURCE_MESSAGE_DELETED = bit64.lshift(bit64.from_u32(1), 3),
		URGENT = bit64.lshift(bit64.from_u32(1), 4),
		HAS_THREAD = bit64.lshift(bit64.from_u32(1), 5),
		EPHEMERAL = bit64.lshift(bit64.from_u32(1), 6),
		LOADING = bit64.lshift(bit64.from_u32(1), 7),
		FAILED_TO_MENTION_SOME_ROLES_IN_THREAD = bit64.lshift(bit64.from_u32(1), 8),
		SUPPRESS_NOTIFICATIONS = bit64.lshift(bit64.from_u32(1), 12),
		IS_VOICE_MESSAGE = bit64.lshift(bit64.from_u32(1), 13)
	},

	PERMISSIONS = {
		CREATE_INSTANT_INVITE = bit64.lshift(bit64.from_u32(1), 0),
		KICK_MEMBERS = bit64.lshift(bit64.from_u32(1), 1),
		BAN_MEMBERS = bit64.lshift(bit64.from_u32(1), 2),
		ADMINISTRATOR = bit64.lshift(bit64.from_u32(1), 3),
		MANAGE_CHANNELS = bit64.lshift(bit64.from_u32(1), 4),
		MANAGE_GUILD = bit64.lshift(bit64.from_u32(1), 5),
		ADD_REACTIONS = bit64.lshift(bit64.from_u32(1), 6),
		VIEW_AUDIT_LOG = bit64.lshift(bit64.from_u32(1), 7),
		PRIORITY_SPEAKER = bit64.lshift(bit64.from_u32(1), 8),
		STREAM = bit64.lshift(bit64.from_u32(1), 9),
		VIEW_CHANNEL = bit64.lshift(bit64.from_u32(1), 10),
		SEND_MESSAGES = bit64.lshift(bit64.from_u32(1), 11),
		SEND_TTS_MESSAGES = bit64.lshift(bit64.from_u32(1), 12),
		MANAGE_MESSAGES = bit64.lshift(bit64.from_u32(1), 13),
		EMBED_LINKS = bit64.lshift(bit64.from_u32(1), 14),
		ATTACH_FILES = bit64.lshift(bit64.from_u32(1), 15),
		READ_MESSAGE_HISTORY = bit64.lshift(bit64.from_u32(1), 16),
		MENTION_EVERYONE = bit64.lshift(bit64.from_u32(1), 17),
		USE_EXTERNAL_EMOJIS = bit64.lshift(bit64.from_u32(1), 18),
		VIEW_GUILD_INSIGHTS = bit64.lshift(bit64.from_u32(1), 19),
		CONNECT = bit64.lshift(bit64.from_u32(1), 20),
		SPEAK = bit64.lshift(bit64.from_u32(1), 21),
		MUTE_MEMBERS = bit64.lshift(bit64.from_u32(1), 22),
		DEAFEN_MEMBERS = bit64.lshift(bit64.from_u32(1), 23),
		MOVE_MEMBERS = bit64.lshift(bit64.from_u32(1), 24),
		USE_VAD = bit64.lshift(bit64.from_u32(1), 25),
		CHANGE_NICKNAME = bit64.lshift(bit64.from_u32(1), 26),
		MANAGE_NICKNAMES = bit64.lshift(bit64.from_u32(1), 27),
		MANAGE_ROLES = bit64.lshift(bit64.from_u32(1), 28),
		MANAGE_WEBHOOKS = bit64.lshift(bit64.from_u32(1), 29),
		MANAGE_GUILD_EXPRESSIONS = bit64.lshift(bit64.from_u32(1), 30),
		USE_APPLICATION_COMMANDS = bit64.lshift(bit64.from_u32(1), 31),
		REQUEST_TO_SPEAK = bit64.lshift(bit64.from_u32(1), 32),
		MANAGE_EVENTS = bit64.lshift(bit64.from_u32(1), 33),
		MANAGE_THREADS = bit64.lshift(bit64.from_u32(1), 34),
		CREATE_PUBLIC_THREADS = bit64.lshift(bit64.from_u32(1), 35),
		CREATE_PRIVATE_THREADS = bit64.lshift(bit64.from_u32(1), 36),
		USE_EXTERNAL_STICKERS = bit64.lshift(bit64.from_u32(1), 37),
		SEND_MESSAGES_IN_THREADS = bit64.lshift(bit64.from_u32(1), 38),
		USE_EMBEDDED_ACTIVITIES = bit64.lshift(bit64.from_u32(1), 39),
		MODERATE_MEMBERS = bit64.lshift(bit64.from_u32(1), 40),
		VIEW_CREATOR_MONETIZATION_ANALYTICS = bit64.lshift(bit64.from_u32(1), 41),
		USE_SOUNDBOARD = bit64.lshift(bit64.from_u32(1), 42),
		CREATE_GUILD_EXPRESSIONS = bit64.lshift(bit64.from_u32(1), 43),
		CREATE_EVENTS = bit64.lshift(bit64.from_u32(1), 44),
		USE_EXTERNAL_SOUNDS = bit64.lshift(bit64.from_u32(1), 45),
		SEND_VOICE_MESSAGES = bit64.lshift(bit64.from_u32(1), 46),
		SEND_POLLS = bit64.lshift(bit64.from_u32(1), 49),
		USE_EXTERNAL_APPS = bit64.lshift(bit64.from_u32(1), 50),
	},

	INTENTS = {
		DEFAULT = 53575421,
		NONE = 0,
		ALL = 53608447
	}
}
