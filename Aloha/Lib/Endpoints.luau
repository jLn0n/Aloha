--- @ignore
--- @class Endpoints
return {
	-- Base Bot URL
	BASE_URL = "https://discord.com/api/v10",

	-- Authentication
	OAUTH2_TOKEN = "/oauth2/token",
	OAUTH2_AUTHORIZE = "/oauth2/authorize",
	
	-- Users
	GET_CURRENT_USER = "/users/@me",
	GET_USER = "/users/%s",
	MODIFY_CURRENT_USER = "/users/@me",
	GET_USER_GUILDS = "/users/@me/guilds",
	LEAVE_GUILD = "/users/@me/guilds/%s",
	CREATE_DM = "/users/@me/channels",
	CREATE_GROUP_DM = "/users/@me/channels",

	-- Guilds
	CREATE_GUILD = "/guilds",
	GET_GUILD = "/guilds/%s",
	MODIFY_GUILD = "/guilds/%s",
	DELETE_GUILD = "/guilds/%s",
	GET_GUILD_CHANNELS = "/guilds/%s/channels",
	CREATE_GUILD_CHANNEL = "/guilds/%s/channels",
	GET_GUILD_MEMBERS = "/guilds/%s/members",
	GET_GUILD_MEMBER = "/guilds/%s/members/%s",
	ADD_GUILD_MEMBER = "/guilds/%s/members/%s",
	MODIFY_GUILD_MEMBER = "/guilds/%s/members/%s",
	REMOVE_GUILD_MEMBER = "/guilds/%s/members/%s",
	GET_GUILD_ROLES = "/guilds/%s/roles",
	GET_GUILD_ROLE = "/guilds/%s/roles/%s",
	CREATE_GUILD_ROLE = "/guilds/%s/roles",
	MODIFY_GUILD_ROLE = "/guilds/%s/roles/%s",
	DELETE_GUILD_ROLE = "/guilds/%s/roles/%s",
	GET_GUILD_BANS = "/guilds/%s/bans",
	GET_GUILD_BAN = "/guilds/%s/bans/%s",
	CREATE_GUILD_BAN = "/guilds/%s/bans/%s",
	REMOVE_GUILD_BAN = "/guilds/%s/bans/%s",
	GET_GUILD_INVITES = "/guilds/%s/invites",
	GET_GUILD_INTEGRATIONS = "/guilds/%s/integrations",
	GET_GUILD_VANITY_URL = "/guilds/%s/vanity-url",
	BULK_GUILD_BAN = "/guilds/%s/bulk-ban",
	GUILD_PRUNE = "/guilds/%s/prune",

	-- Channels
	GET_CHANNEL = "/channels/%s",
	MODIFY_CHANNEL = "/channels/%s",
	DELETE_CHANNEL = "/channels/%s",
	GET_CHANNEL_MESSAGES = "/channels/%s/messages",
	GET_CHANNEL_MESSAGE = "/channels/%s/messages/%s",
	CREATE_MESSAGE = "/channels/%s/messages",
	CROSSPOST_MESSAGE = "/channels/%s/messages/%s/crosspost",
	DELETE_MESSAGE = "/channels/%s/messages/%s",
	BULK_DELETE_MESSAGES = "/channels/%s/messages/bulk-delete",
	EDIT_MESSAGE = "/channels/%s/messages/%s",
	GET_CHANNEL_INVITES = "/channels/%s/invites",
	CREATE_CHANNEL_INVITE = "/channels/%s/invites",
	DELETE_CHANNEL_PERMISSION = "/channels/%s/permissions/%s",
	FOLLOW_NEWS_CHANNEL = "/channels/%s/followers",
	TRIGGER_TYPING_INDICATOR = "/channels/%s/typing",
	GET_PINNED_MESSAGES = "/channels/%s/pins",
	PIN_MESSAGE = "/channels/%s/pins/%s",
	UNPIN_MESSAGE = "/channels/%s/pins/%s",
	GROUP_DM_ADD_RECIPIENT = "/channels/%s/recipients/%s",
	GROUP_DM_REMOVE_RECIPIENT = "/channels/%s/recipients/%s",

	-- Messages
	CREATE_REACTION = "/channels/%s/messages/%s/reactions/%s/@me",
	DELETE_USER_REACTION = "/channels/%s/messages/%s/reactions/%s/%s",
	GET_REACTIONS = "/channels/%s/messages/%s/reactions/%s",
	DELETE_ALL_REACTIONS = "/channels/%s/messages/%s/reactions",
	DELETE_ALL_REACTIONS_FOR_EMOJI = "/channels/%s/messages/%s/reactions/%s",

	-- Webhooks
	CREATE_WEBHOOK = "/channels/%s/webhooks",
	GET_CHANNEL_WEBHOOKS = "/channels/%s/webhooks",
	GET_GUILD_WEBHOOKS = "/guilds/%s/webhooks",
	GET_WEBHOOK = "/webhooks/%s",
	GET_WEBHOOK_WITH_TOKEN = "/webhooks/%s/%s",
	MODIFY_WEBHOOK = "/webhooks/%s",
	MODIFY_WEBHOOK_WITH_TOKEN = "/webhooks/%s/%s",
	DELETE_WEBHOOK = "/webhooks/%s",
	DELETE_WEBHOOK_WITH_TOKEN = "/webhooks/%s/%s",
	EXECUTE_WEBHOOK = "/webhooks/%s/%s",
	EXECUTE_SLACK_COMPATIBLE_WEBHOOK = "/webhooks/%s/%s/slack",
	EXECUTE_GITHUB_COMPATIBLE_WEBHOOK = "/webhooks/%s/%s/github",
	GET_WEBHOOK_MESSAGE = "/webhooks/%s/%s/messages/%s",
	EDIT_WEBHOOK_MESSAGE = "/webhooks/%s/%s/messages/%s",
	DELETE_WEBHOOK_MESSAGE = "/webhooks/%s/%s/messages/%s",

	-- Interactions
	CREATE_INTERACTION_RESPONSE = "/interactions/%s/%s/callback",
	GET_ORIGINAL_INTERACTION_RESPONSE = "/webhooks/%s/%s/messages/@original",
	EDIT_ORIGINAL_INTERACTION_RESPONSE = "/webhooks/%s/%s/messages/@original",
	DELETE_ORIGINAL_INTERACTION_RESPONSE = "/webhooks/%s/%s/messages/@original",

	-- Application Commands
	CREATE_GLOBAL_APPLICATION_COMMAND = "/applications/%s/commands",
	GET_GLOBAL_APPLICATION_COMMANDS = "/applications/%s/commands",
	GET_GLOBAL_APPLICATION_COMMAND = "/applications/%s/commands/%s",
	EDIT_GLOBAL_APPLICATION_COMMAND = "/applications/%s/commands/%s",
	DELETE_GLOBAL_APPLICATION_COMMAND = "/applications/%s/commands/%s",
	BULK_OVERWRITE_GLOBAL_APPLICATION_COMMANDS = "/applications/%s/commands",

	-- Guild Application Commands
	CREATE_GUILD_APPLICATION_COMMAND = "/applications/%s/guilds/%s/commands",
	GET_GUILD_APPLICATION_COMMANDS = "/applications/%s/guilds/%s/commands",
	GET_GUILD_APPLICATION_COMMAND = "/applications/%s/guilds/%s/commands/%s",
	EDIT_GUILD_APPLICATION_COMMAND = "/applications/%s/guilds/%s/commands/%s",
	DELETE_GUILD_APPLICATION_COMMAND = "/applications/%s/guilds/%s/commands/%s",
	BULK_OVERWRITE_GUILD_APPLICATION_COMMANDS = "/applications/%s/guilds/%s/commands",

	-- Application Command Permissions
	GET_GUILD_APPLICATION_COMMAND_PERMISSIONS = "/applications/%s/guilds/%s/commands/permissions",
	GET_APPLICATION_COMMAND_PERMISSIONS = "/applications/%s/guilds/%s/commands/%s/permissions",
	EDIT_APPLICATION_COMMAND_PERMISSIONS = "/applications/%s/guilds/%s/commands/%s/permissions",

	-- Gateway
	GET_GATEWAY = "/gateway",
	GET_GATEWAY_BOT = "/gateway/bot",

	-- OAuth2
	GET_CURRENT_APPLICATION = "/oauth2/applications/@me",
}