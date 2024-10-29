--[=[
    @class DiscordTypes
    Type definitions for Discord API objects and payloads
]=]

--[=[
    @type snowflake string
    @within DiscordTypes
    Discord's snowflake ID format
]=]
export type snowflake = string

--[=[
    @type UserData {id: snowflake, username: string, discriminator: string, global_name: string?, avatar: string?, bot: boolean?, system: boolean?, mfa_enabled: boolean?, banner: string?, accent_color: number?, locale: string?, verified: boolean?, email: string?, flags: number?, premium_type: number?, public_flags: number?, avatar_decoration_data: AvatarDecorationData?}
    @within DiscordTypes
    Discord user object data
]=]
export type UserData = {
	id: snowflake,
	username: string,
	discriminator: string,
	global_name: string?,
	avatar: string?,
	bot: boolean?,
	system: boolean?,
	mfa_enabled: boolean?,
	banner: string?,
	accent_color: number?,
	locale: string?,
	verified: boolean?,
	email: string?,
	flags: number?,
	premium_type: number?,
	public_flags: number?,
	avatar_decoration_data: AvatarDecorationData?
}

--[=[
    @type CreateGuildChannelData {name: string, type: number, topic: string?, bitrate: number?, user_limit: number?, rate_limit_per_user: number?, permission_overwrites: {PermissionOverwriteData}?, parent_id: snowflake?, nsfw: boolean?, rtc_region: string?, video_quality_mode: number?, default_auto_archive_duration: number?, default_reaction_emoji: {ReactionData}?, available_tags: {ForumTagData}?, default_sort_order: number?, default_forum_layout: number?, default_thread_rate_limit_per_user: number?}
    @within DiscordTypes
    Data for creating a new guild channel
]=]
export type CreateGuildChannelData = {
	name: string,
	type: number,
	topic: string?,
	bitrate: number?,
	user_limit: number?,
	rate_limit_per_user: number?,
	permission_overwrites: {PermissionOverwriteData}?,
	parent_id: snowflake?,
	nsfw: boolean?,
	rtc_region: string?,
	video_quality_mode: number?,
	default_auto_archive_duration: number?,
	default_reaction_emoji: {ReactionData}?,
	available_tags: {ForumTagData}?,
	default_sort_order: number?,
	default_forum_layout: number?,
	default_thread_rate_limit_per_user: number?
}

--[=[
    @type AvatarDecorationData {asset: string, sku_id: number}
    @within DiscordTypes
    Avatar decoration data
]=]
export type AvatarDecorationData = {
	asset: string,
	sku_id: number
}

--[=[
    @type PermissionOverwriteData {id: snowflake, type: number, allow: string, deny: string}
    @within DiscordTypes
    Permission overwrite data for channels
]=]
export type PermissionOverwriteData = {
	id: snowflake,
	type: number,
	allow: string,
	deny: string
}

--[=[
    @type ThreadMetadataData {archived: boolean, auto_archive_duration: number, archive_timestamp: string, locked: boolean, invitable: boolean?, create_timestamp: string?}
    @within DiscordTypes
    Thread metadata
]=]
export type ThreadMetadataData = {
	archived: boolean,
	auto_archive_duration: number,
	archive_timestamp: string,
	locked: boolean,
	invitable: boolean?,
	create_timestamp: string?
}

--[=[
    @type ForumTagData {id: snowflake, name: string, moderated: boolean, emoji_id: snowflake?, emoji_name: string?}
    @within DiscordTypes
    Forum channel tag data
]=]
export type ForumTagData = {
	id: snowflake,
	name: string,
	moderated: boolean,
	emoji_id: snowflake?,
	emoji_name: string?
}

--[=[
    @type ChannelData {id: snowflake, type: number, guild_id: snowflake?, position: number?, permission_overwrites: {PermissionOverwriteData}?, name: string?, topic: string?, nsfw: boolean?, last_message_id: snowflake?, bitrate: number?, user_limit: number?, rate_limit_per_user: number?, recipients: {UserData}?, icon: string?, owner_id: snowflake?, application_id: snowflake?, managed: boolean?, parent_id: snowflake?, last_pin_timestamp: string?, rtc_region: string?, video_quality_mode: number?, message_count: number?, thread_metadata: ThreadMetadataData?, member: ThreadMemberData?, default_auto_archive_duration: number?, permissions: string?, flags: number?, total_message_sent: number?, available_tags: {ForumTagData}?, applied_tags: {number}?, default_reaction_emoji: {ReactionData}?, default_thread_rate_limit_per_user: number?, default_sort_order: number?, default_forum_layout: number?}
    @within DiscordTypes
    Channel data
]=]
export type ChannelData = {
	id: snowflake,
	type: number,
	guild_id: snowflake?,
	position: number?,
	permission_overwrites: {PermissionOverwriteData}?,
	name: string?,
	topic: string?,
	nsfw: boolean?,
	last_message_id: snowflake?,
	bitrate: number?,
	user_limit: number?,
	rate_limit_per_user: number?,
	recipients: {UserData}?,
	icon: string?,
	owner_id: snowflake?,
	application_id: snowflake?,
	managed: boolean?,
	parent_id: snowflake?,
	last_pin_timestamp: string?,
	rtc_region: string?,
	video_quality_mode: number?,
	message_count: number?,
	thread_metadata: ThreadMetadataData?,
	member: ThreadMemberData?,
	default_auto_archive_duration: number?,
	permissions: string?,
	flags: number?,
	total_message_sent: number?,
	available_tags: {ForumTagData}?,
	applied_tags: {number}?,
	default_reaction_emoji: {ReactionData}?,
	default_thread_rate_limit_per_user: number?,
	default_sort_order: number?,
	default_forum_layout: number?
}

--[=[
    @type ChannelMentionData {id: snowflake, guild_id: snowflake, type: number, name: string}
    @within DiscordTypes
    Channel mention data
]=]
export type ChannelMentionData = {
	id: snowflake,
	guild_id: snowflake,
	type: number,
	name: string
}

--[=[
    @type AttachmentData {id: snowflake, filename: string, title: string?, description: string?, content_type: string?, size: number, url: string, proxy_url: string, height: number?, width: number?, ephemeral: boolean?, duration_secs: number?, waveform: string?, flags: number?}
    @within DiscordTypes
    Attachment data
]=]
export type AttachmentData = {
	id: snowflake,
	filename: string,
	title: string?,
	description: string?,
	content_type: string?,
	size: number,
	url: string,
	proxy_url: string,
	height: number?,
	width: number?,
	ephemeral: boolean?,
	duration_secs: number?,
	waveform: string?,
	flags: number?
}

--[=[
    @type EmbedFooterData {text: string, icon_url: string?, proxy_icon_url: string?}
    @within DiscordTypes
    Embed footer data
]=]
export type EmbedFooterData = {
	text: string,
	icon_url: string?,
	proxy_icon_url: string?
}

--[=[
    @type EmbedImageData {url: string, proxy_url: string?, height: number?, width: number?}
    @within DiscordTypes
    Embed image data
]=]
export type EmbedImageData = {
	url: string,
	proxy_url: string?,
	height: number?,
	width: number?
}

--[=[
    @type EmbedProviderData {url: string?, name: string?}
    @within DiscordTypes
    Embed provider data
]=]
export type EmbedProviderData = {
	url: string?,
	name: string?
}

--[=[
    @type EmbedAuthorData {name: string, url: string?, icon_url: string?, proxy_icon_url: string?}
    @within DiscordTypes
    Embed author data
]=]
export type EmbedAuthorData = {
	name: string,
	url: string?,
	icon_url: string?,
	proxy_icon_url: string?
}

--[=[
    @type EmbedFieldData {name: string, value: string, inline: boolean?}
    @within DiscordTypes
    Embed field data
]=]
export type EmbedFieldData = {
	name: string,
	value: string,
	inline: boolean?
}

--[=[
    @type EmbedData {title: string?, type: string?, description: string?, url: string?, timestamp: string?, color: number?, footer: EmbedFooterData?, image: EmbedImageData?, thumbnail: EmbedImageData?, video: EmbedImageData?, provider: EmbedProviderData?, author: EmbedAuthorData?, fields: {EmbedFieldData}?}
    @within DiscordTypes
    Embed data
]=]
export type EmbedData = {
	title: string?,
	type: string?,
	description: string?,
	url: string?,
	timestamp: string?,
	color: number?,
	footer: EmbedFooterData?,
	image: EmbedImageData?,
	thumbnail: EmbedImageData?,
	video: EmbedImageData?,
	provider: EmbedProviderData?,
	author: EmbedAuthorData?,
	fields: {EmbedFieldData}?
}

--[=[
    @type RoleTagsData {bot_id: snowflake?, integration_id: snowflake?, premium_subscriber: boolean?, subscription_listing_id: snowflake?, available_for_purchase: boolean?, guild_connections: boolean?}
    @within DiscordTypes
    Role tags data
]=]
export type RoleTagsData = {
	bot_id: snowflake?,
	integration_id: snowflake?,
	premium_subscriber: boolean?,
	subscription_listing_id: snowflake?,
	available_for_purchase: boolean?,
	guild_connections: boolean?
}

--[=[
    @type RoleData {id: snowflake, name: string, color: number, hoist: boolean, icon: string?, unicode_emoji: string?, position: number, permissions: string, managed: boolean, mentionable: boolean, tags: RoleTagsData?, flags: number}
    @within DiscordTypes
    Role data
]=]
export type RoleData = {
	id: snowflake,
	name: string,
	color: number,
	hoist: boolean,
	icon: string?,
	unicode_emoji: string?,
	position: number,
	permissions: string,
	managed: boolean,
	mentionable: boolean,
	tags: RoleTagsData?,
	flags: number
}

--[=[
    @type ReactionCountDetailsData {burst: number, normal: number}
    @within DiscordTypes
    Reaction count details
]=]
export type ReactionCountDetailsData = {
	burst: number,
	normal: number
}

--[=[
    @type EmojiData {id: snowflake, name: string, roles: {number}?, user: UserData?, require_colons: boolean?, managed: boolean?, animated: boolean?, available: boolean?}
    @within DiscordTypes
    Emoji data
]=]
export type EmojiData = {
	id: snowflake,
	name: string,
	roles: {number}?,
	user: UserData?,
	require_colons: boolean?,
	managed: boolean?,
	animated: boolean?,
	available: boolean?
}

--[=[
    @type ReactionData {count: number, count_details: ReactionCountDetailsData, me: boolean, me_burst: boolean, emoji: EmojiData, burst_colors: {number}}
    @within DiscordTypes
    Reaction data
]=]
export type ReactionData = {
	count: number,
	count_details: ReactionCountDetailsData,
	me: boolean,
	me_burst: boolean,
	emoji: EmojiData,
	burst_colors: {number}
}

--[=[
    @type ActivityData {type: number, party_id: snowflake?}
    @within DiscordTypes
    Activity data
]=]
export type ActivityData = {
	type: number,
	party_id: snowflake?
}

--[=[
    @type TeamMemberData {user: UserData, membership_state: number, role: string, team_id: snowflake}
    @within DiscordTypes
    Team member data
]=]
export type TeamMemberData = {
	user: UserData,
	membership_state: number,
	role: string,
	team_id: snowflake
}

--[=[
    @type TeamData {icon: string?, id: snowflake, members: {TeamMemberData}, name: string, owner_user_id: snowflake}
    @within DiscordTypes
    Team data
]=]
export type TeamData = {
	icon: string?,
	id: snowflake,
	members: {TeamMemberData},
	name: string,
	owner_user_id: snowflake
}

--[=[
    @type WelcomeScreenChannelData {channel_id: snowflake, description: string, emoji_id: snowflake?, emoji_name: string?}
    @within DiscordTypes
    Welcome screen channel data
]=]
export type WelcomeScreenChannelData = {
	channel_id: snowflake,
	description: string,
	emoji_id: snowflake?,
	emoji_name: string?
}

--[=[
    @type WelcomeScreenData {description: string?, welcome_channels: {WelcomeScreenChannelData}?}
    @within DiscordTypes
    Welcome screen data
]=]
export type WelcomeScreenData = {
	description: string?,
	welcome_channels: {WelcomeScreenChannelData}?
}

--[=[
    @type GuildData {id: snowflake, name: string, icon: string?, icon_hash: string?, splash: string?, discovery_splash: string?, owner: boolean, owner_id: snowflake, permissions: string?, region: string?, afk_channel_id: snowflake?, afk_timeout: number, widget_enabled: boolean?, widget_channel_id: snowflake?, verification_level: number, default_message_notifications: number, explicit_content_filter: number, roles: {RoleData}?, emojis: {EmojiData}?, features: {string}, mfa_level: number, application_id: snowflake?, system_channel_id: snowflake?, system_channel_flags: number, rules_channel_id: snowflake?, max_presences: number?, max_members: number?, vanity_url_code: string?, description: string?, banner: string?, premium_tier: number, premium_subscription_count: number?, preferred_locale: string, public_updates_channel_id: snowflake?, max_video_channel_users: number?, max_stage_video_channel_users: number?, approximate_member_count: number?, approximate_presence_count: number?, welcome_screen: WelcomeScreenData?, nsfw_level: number, stickers: {StickerData}?, premium_progress_bar_enabled: boolean, safety_alerts_channel_id: snowflake?}
    @within DiscordTypes
    Guild data
]=]
export type GuildData = {
	id: snowflake,
	name: string,
	icon: string?,
	icon_hash: string?,
	splash: string?,
	discovery_splash: string?,
	owner: boolean,
	owner_id: snowflake,
	permissions: string?,
	region: string?,
	afk_channel_id: snowflake?,
	afk_timeout: number,
	widget_enabled: boolean?,
	widget_channel_id: snowflake?,
	verification_level: number,
	default_message_notifications: number,
	explicit_content_filter: number,
	roles: {RoleData}?,
	emojis: {EmojiData}?,
	features: {string},
	mfa_level: number,
	application_id: snowflake?,
	system_channel_id: snowflake?,
	system_channel_flags: number,
	rules_channel_id: snowflake?,
	max_presences: number?,
	max_members: number?,
	vanity_url_code: string?,
	description: string?,
	banner: string?,
	premium_tier: number,
	premium_subscription_count: number?,
	preferred_locale: string,
	public_updates_channel_id: snowflake?,
	max_video_channel_users: number?,
	max_stage_video_channel_users: number?,
	approximate_member_count: number?,
	approximate_presence_count: number?,
	welcome_screen: WelcomeScreenData?,
	nsfw_level: number,
	stickers: {StickerData}?,
	premium_progress_bar_enabled: boolean,
	safety_alerts_channel_id: snowflake?
}

--[=[
    @type InstallParamsData {scopes: {string}, permissions: string}
    @within DiscordTypes
    Install params data
]=]
export type InstallParamsData = {
	scopes: {string},
	permissions: string
}

--[=[
    @type ApplicationData {id: snowflake, name: string, icon: string?, description: string, rpc_origins: {string}?, bot_public: boolean, bot_require_code_grant: boolean, bot: UserData?, terms_of_service_url: string?, privacy_policy_url: string?, owner: UserData?, verify_key: string?, team: TeamData?, guild_id: snowflake?, guild: GuildData?, primary_sku_id: number?, slug: string?, cover_image: string?, flags: number?, approximate_guild_count: number?, approximate_user_install_count: number?, redirect_uris: {string}?, interactions_endpoint_url: string?, role_connections_verification_url: string?, tags: {string}?, install_params: InstallParamsData?, integration_types_config: {GUILD_INSTALL: number, USER_INSTALL: number}, custom_install_url: string?}
    @within DiscordTypes
    Application data
]=]
export type ApplicationData = {
	id: snowflake,
	name: string,
	icon: string?,
	description: string,
	rpc_origins: {string}?,
	bot_public: boolean,
	bot_require_code_grant: boolean,
	bot: UserData?,
	terms_of_service_url: string?,
	privacy_policy_url: string?,
	owner: UserData?,
	verify_key: string?,
	team: TeamData?,
	guild_id: snowflake?,
	guild: GuildData?,
	primary_sku_id: number?,
	slug: string?,
	cover_image: string?,
	flags: number?,
	approximate_guild_count: number?,
	approximate_user_install_count: number?,
	redirect_uris: {string}?,
	interactions_endpoint_url: string?,
	role_connections_verification_url: string?,
	tags: {string}?,
	install_params: InstallParamsData?,
	integration_types_config: {GUILD_INSTALL: number, USER_INSTALL: number},
	custom_install_url: string?
}

--[=[
    @type CommandOptionChoiceData {name: string, name_localizations: {[string]: string}?, value: (string | number)}
    @within DiscordTypes
    Command option choice data
]=]
export type CommandOptionChoiceData = {
	name: string,
	name_localizations: { [string]: string }?,
	value: (string | number)
}

--[=[
    @type CommandOptionData {type: number, name: string, name_localizations: {[string]: string}?, description: string, description_localizations: {[string]: string}?, required: boolean?, choices: {CommandOptionChoiceData}?, options: {CommandOptionData}?, channel_types: {number}?, min_value: number?, max_value: number?, min_length: number?, max_length: number?, autocomplete: boolean?}
    @within DiscordTypes
    Command option data
]=]
export type CommandOptionData = {
	type: number,
	name: string,
	name_localizations: { [string]: string }?,
	description: string,
	description_localizations: { [string]: string }?,
	required: boolean?,
	choices: {CommandOptionChoiceData}?,
	options: {CommandOptionData}?,
	channel_types: {number}?,
	min_value: number?,
	max_value: number?,
	min_length: number?,
	max_length: number?,
	autocomplete: boolean?
}

--[=[
    @type MessageReferenceData {type: number?, message_id: snowflake?, guild_id: snowflake?, channel_id: snowflake?, fail_if_not_exists: boolean?}
    @within DiscordTypes
    Message reference data
]=]
export type MessageReferenceData = {
	type: number?,
	message_id: snowflake?,
	guild_id: snowflake?,
	channel_id: snowflake?,
	fail_if_not_exists: boolean?
}

--[=[
    @type MessageSnapshotData {message: MessageData}
    @within DiscordTypes
    Message snapshot data
]=]
export type MessageSnapshotData = {
	message: MessageData
}

--[=[
    @type ApplicationCommandData {id: snowflake, type: number, application_id: snowflake, guild_id: snowflake?, name: string, name_localizations: {[string]: string}?, description: string, description_localizations: {[string]: string}?, options: {CommandOptionData}?, default_member_permissions: string?, dm_permission: boolean?, default_permission: boolean?, nsfw: boolean?, integration_type: number?, contexts: {number}?, version: snowflake, handler: number}
    @within DiscordTypes
    Application command data
]=]
export type ApplicationCommandData = {
	id: snowflake,
	type: number,
	application_id: snowflake,
	guild_id: snowflake?,
	name: string,
	name_localizations: { [string]: string }?,
	description: string,
	description_localizations: { [string]: string }?,
	options: {CommandOptionData}?,
	default_member_permissions: string?,
	dm_permission: boolean?,
	default_permission: boolean?,
	nsfw: boolean?,
	integration_type: number?,
	contexts: {number}?,
	version: snowflake,
	handler: number
}

--[=[
    @type MessageComponentInteractionData {custom_id: string, component_type: number, values: {(string | number | boolean)}?, resolved: ResolvedData?}
    @within DiscordTypes
    Message component interaction data
]=]
export type MessageComponentInteractionData = {
	custom_id: string,
	component_type: number,
	values: {(string | number | boolean)}?,
	resolved: ResolvedData?
}

--[=[
    @type EntitlementData {id: snowflake, sku_id: snowflake, plan: {id: snowflake, price: number}}
    @within DiscordTypes
    Entitlement data
]=]
export type EntitlementData = {
	id: snowflake,
	sku_id: snowflake,
	plan: {
		id: snowflake,
		price: number
	}
}

--[=[
    @type InteractionData {id: snowflake, application_id: snowflake, type: number, data: (ApplicationCommandInteractionData | MessageComponentInteractionData)?, guild: GuildData?, guild_id: snowflake?, channel: ChannelData?, channel_id: snowflake?, member: MemberData?, user: UserData?, token: string, version: number, message: MessageData, app_permissions: string, locale: string, guild_locale: string, entitlements: {EntitlementData}?, authorizing_integration_owners: {[number]: snowflake}, context: number}
    @within DiscordTypes
    Interaction data
]=]
export type InteractionData = {
	id: snowflake,
	application_id: snowflake,
	type: number,
	data: (ApplicationCommandInteractionData | MessageComponentInteractionData)?,
	guild: GuildData?,
	guild_id: snowflake?,
	channel: ChannelData?,
	channel_id: snowflake?,
	member: MemberData?,
	user: UserData?,
	token: string,
	version: number,
	message: MessageData,
	app_permissions: string,
	locale: string,
	guild_locale: string,
	entitlements: {EntitlementData}?,
	authorizing_integration_owners: {[number]: snowflake},
	context: number,
}

--[=[
    @type InteractionCallbackData {tts: boolean?, content: string?, embeds: {EmbedData}?, allowed_mentions: {string}?, flags: number?, components: {ComponentData}?, attachments: {AttachmentData}?, poll: PollData?}
    @within DiscordTypes
    Interaction callback data
]=]
export type InteractionCallbackData = {
	tts: boolean?,
	content: string?,
	embeds: {EmbedData}?,
	allowed_mentions: {string}?,
	flags: number?,
	components: {ComponentData}?,
	attachments: {AttachmentData}?,
	poll: PollData?
}

--[=[
    @type ApplicationCommandInteractionDataOptionData {name: string, type: number, value: (string | number | boolean)?, options: {ApplicationCommandInteractionDataOptionData}?, focused: boolean?}
    @within DiscordTypes
    Application command interaction data option
]=]
export type ApplicationCommandInteractionDataOptionData = {
	name: string,
	type: number,
	value: (string | number | boolean)?,
	options: {ApplicationCommandInteractionDataOptionData}?,
	focused: boolean?
}

--[=[
    @type ApplicationCommandInteractionData {id: snowflake, name: string, type: number, resolved: ResolvedData?, options: {ApplicationCommandInteractionDataOptionData}?, guild_id: snowflake?, target_id: snowflake?}
    @within DiscordTypes
    Application command interaction data
]=]
export type ApplicationCommandInteractionData = {
	id: snowflake,
	name: string,
	type: number,
	resolved: ResolvedData?,
	options: {ApplicationCommandInteractionDataOptionData}?,
	guild_id: snowflake?,
	target_id: snowflake?
}

--[=[
    @type InteractionMetadataData {id: snowflake, type: number, user: UserData, authorizing_integration_owners: {[number]: snowflake}, original_response_message_id: snowflake?, interacted_message_id: snowflake?, triggering_interaction_metadata: {}}
    @within DiscordTypes
    Interaction metadata
]=]
export type InteractionMetadataData = {
	id: snowflake,
	type: number,
	user: UserData,
	authorizing_integration_owners: {[number]: snowflake},
	original_response_message_id: snowflake?,
	interacted_message_id: snowflake?,
	triggering_interaction_metadata: {}
}

--[=[
    @type ComponentData {[number]: {type: number, components: {[number]: {type: number, label: string, style: number, custom_id: snowflake}}}}
    @within DiscordTypes
    Component data
]=]
export type ComponentData = {[number]: {type: number, components: {[number]: {type: number, label: string, style: number, custom_id: snowflake}}}}

--[=[
    @type StickerItemData {id: snowflake, name: string, format_type: number}
    @within DiscordTypes
    Sticker item data
]=]
export type StickerItemData = {
	id: snowflake,
	name: string,
	format_type: number
}

--[=[
    @type StickerData {id: snowflake, pack_id: snowflake?, name: string, description: string?, tags: string, type: number, format_type: number, available: boolean?, guild_id: snowflake?, user: UserData?, sort_value: number?}
    @within DiscordTypes
    Sticker data
]=]
export type StickerData = {
	id: snowflake,
	pack_id: snowflake?,
	name: string,
	description: string?,
	tags: string,
	type: number,
	format_type: number,
	available: boolean?,
	guild_id: snowflake?,
	user: UserData?,
	sort_value: number?
}

--[=[
    @type StickerPackData {id: snowflake, stickers: {StickerData}, name: string, sku_id: number, cover_sticker_id: snowflake?, description: string, banner_asset_id: snowflake?}
    @within DiscordTypes
    Sticker pack data
]=]
export type StickerPackData = {
	id: snowflake,
	stickers: {StickerData},
	name: string,
	sku_id: number,
	cover_sticker_id: snowflake?,
	description: string,
	banner_asset_id: snowflake?
}

--[=[
    @type ThreadMemberData {id: snowflake?, user_id: snowflake?, join_timestamp: string, flags: number, member: MemberData?}
    @within DiscordTypes
    Thread member data
]=]
export type ThreadMemberData = {
	id: snowflake?,
	user_id: snowflake?,
	join_timestamp: string,
	flags: number,
	member: MemberData?
}

--[=[
    @type MemberData {user: UserData?, nick: string?, avatar: string?, banner: string?, roles: {number}?, joined_at: string, premium_since: string?, deaf: boolean, mute: boolean, pending: boolean?, permissions: string?, communication_disabled_until: string?, avatar_decoration_data: AvatarDecorationData?}
    @within DiscordTypes
    Member data
]=]
export type MemberData = {
	user: UserData?,
	nick: string?,
	avatar: string?,
	banner: string?,
	roles: {number}?,
	joined_at: string,
	premium_since: string?,
	deaf: boolean,
	mute: boolean,
	pending: boolean?,
	permissions: string?,
	communication_disabled_until: string?,
	avatar_decoration_data: AvatarDecorationData?
}

--[=[
    @type RoleSubscriptionData {role_subscription_listing_id: snowflake, tier_name: string, total_months_subscribed: number, is_renewing: boolean}
    @within DiscordTypes
    Data for a role subscription
]=]
export type RoleSubscriptionData = {
	role_subscription_listing_id: snowflake,
	tier_name: string,
	total_months_subscribed: number,
	is_renewing: boolean
}

--[=[
    @type PollMediaData {text: string?, emoji: EmojiData?}
    @within DiscordTypes
    Media data for a poll
]=]
export type PollMediaData = {text: string?, emoji: EmojiData?}

--[=[
    @type PollAnswerData {answer_id: snowflake, poll_media: PollMediaData}
    @within DiscordTypes
    Data for a poll answer
]=]
export type PollAnswerData = {
	answer_id: snowflake,
	poll_media: PollMediaData
}

--[=[
    @type PollAnswerCountData {id: snowflake, count: number, me_voted: boolean}
    @within DiscordTypes
    Count data for a poll answer
]=]
export type PollAnswerCountData = {
	id: snowflake,
	count: number,
	me_voted: boolean
}

--[=[
    @type PollResultData {is_finalized: boolean, answer_counts: {PollAnswerCountData}}
    @within DiscordTypes
    Results data for a poll
]=]
export type PollResultData = {
	is_finalized: boolean,
	answer_counts: {PollAnswerCountData}
}

--[=[
    @type PollData {question: PollMediaData, answers: {PollAnswerData}, expiry: string?, allow_multiselect: boolean, layout_type: number, results: {PollResultData}}
    @within DiscordTypes
    Data for a poll
]=]
export type PollData = {
	question: PollMediaData,
	answers: {PollAnswerData},
	expiry: string?,
	allow_multiselect: boolean,
	layout_type: number,
	results: {PollResultData}
}

--[=[
    @type CallData {participants: {number}?, ended_timestamp: string?}
    @within DiscordTypes
    Data for a voice call
]=]
export type CallData = {
	participants: {number}?,
	ended_timestamp: string?
}

--[=[
    @type ResolvedData {users: {UserData}?, members: {MemberData}?, roles: {RoleData}?, channels: {ChannelData}?, message: MessageData?, attachments: {AttachmentData}?}
    @within DiscordTypes
    Resolved data for interactions
]=]
export type ResolvedData = {
	users: {UserData}?,
	members: {MemberData}?,
	roles: {RoleData}?,
	channels: {ChannelData}?,
	message: MessageData?,
	attachments: {AttachmentData}?
}

--[=[
    @type Payload {op: number?, d: {[string]:any}, s: number?, t: string?}
    @within DiscordTypes
    Gateway payload data
]=]
export type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}

--[=[
    @type MessageData {id: snowflake, channel_id: snowflake, author: UserData, content: string, timestamp: string, edited_timestamp: string?, tts: boolean, mention_everyone: boolean, mentions: {UserData}, mention_roles: {number}, mention_channels: {ChannelMentionData}, attachments: {AttachmentData}, embeds: {EmbedData}, reactions: {ReactionData}?, nonce: (number | string)?, pinned: boolean, webhook_id: snowflake?, type: number, activity: ActivityData?, application: ApplicationData?, application_id: snowflake?, flags: number?, message_reference: MessageReferenceData?, message_snapshots: {MessageSnapshotData}?, referenced_message: MessageData?, interaction_metadata: InteractionMetadataData?, interaction: InteractionData?, thread: ChannelData?, components: {ComponentData}?, sticker_items: {StickerItemData}?, stickers: {StickerData}?, position: number?, role_subscription_data: RoleSubscriptionData?, resolved: ResolvedData?, poll: PollData?, call: CallData?}
    @within DiscordTypes
    Message data
]=]
export type MessageData = {
	id: snowflake,
	channel_id: snowflake,
	author: UserData,
	content: string,
	timestamp: string,
	edited_timestamp: string?,
	tts: boolean,
	mention_everyone: boolean,
	mentions: {UserData},
	mention_roles: {number},
	mention_channels: {ChannelMentionData},
	attachments: {AttachmentData},
	embeds: {EmbedData},
	reactions: {ReactionData}?,
	nonce: (number | string)?,
	pinned: boolean,
	webhook_id: snowflake?,
	type: number,
	activity: ActivityData?,
	application: ApplicationData?,
	application_id: snowflake?,
	flags: number?,
	message_reference: MessageReferenceData?,
	message_snapshots: {MessageSnapshotData}?,
	referenced_message: MessageData?,
	interaction_metadata: InteractionMetadataData?,
	interaction: InteractionData?,
	thread: ChannelData?,
	components: {ComponentData}?,
	sticker_items: {StickerItemData}?,
	stickers: {StickerData}?,
	position: number?,
	role_subscription_data: RoleSubscriptionData?,
	resolved: ResolvedData?,
	poll: PollData?,
	call: CallData?
}

return {}