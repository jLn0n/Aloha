export type snowflake = string & { __newtype: "snowflake" }

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

export type AvatarDecorationData = {
	asset: string,
	sku_id: number
}

export type PermissionOverwriteData = {
	id: snowflake,
	type: number,
	allow: string,
	deny: string
}

export type ThreadMetadataData = {
	archived: boolean,
	auto_archive_duration: number,
	archive_timestamp: string,
	locked: boolean,
	invitable: boolean?,
	create_timestamp: string?
}

export type ForumTagData = {
	id: snowflake,
	name: string,
	moderated: boolean,
	emoji_id: snowflake?,
	emoji_name: string?
}

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

export type ChannelMentionData = {
	id: snowflake,
	guild_id: snowflake,
	type: number,
	name: string
}

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

export type EmbedFooterData = {
	text: string,
	icon_url: string?,
	proxy_icon_url: string?
}

export type EmbedImageData = {
	url: string,
	proxy_url: string?,
	height: number?,
	width: number?
}


export type EmbedProviderData = {
	url: string?,
	name: string?
}

export type EmbedAuthorData = {
	name: string,
	url: string?,
	icon_url: string?,
	proxy_icon_url: string?
}

export type EmbedFieldData = {
	name: string,
	value: string,
	inline: boolean?
}

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

export type RoleTagsData = {
	bot_id: snowflake?,
	integration_id: snowflake?,
	premium_subscriber: boolean?,
	subscription_listing_id: snowflake?,
	available_for_purchase: boolean?,
	guild_connections: boolean?
}

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

export type ReactionCountDetailsData = {
	burst: number,
	normal: number
}

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


export type ReactionData = {
	count: number,
	count_details: ReactionCountDetailsData,
	me: boolean,
	me_burst: boolean,
	emoji: EmojiData,
	burst_colors: {number}
}

export type ActivityData = {
	type: number,
	party_id: snowflake?
}

export type TeamMemberData = {
	user: UserData,
	membership_state: number,
	role: string,
	team_id: snowflake
}

export type TeamData = {
	icon: string?,
	id: snowflake,
	members: {TeamMemberData},
	name: string,
	owner_user_id: snowflake
}

export type WelcomeScreenChannelData = {
	channel_id: snowflake,
	description: string,
	emoji_id: snowflake?,
	emoji_name: string?
}

export type WelcomeScreenData = {
	description: string?,
	welcome_channels: {WelcomeScreenChannelData}?
}

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

export type InstallParamsData = {
	scopes: {string},
	permissions: string
}

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

export type CommandOptionChoiceData = {
	name: string,
	name_localizations: { [string]: string }?,
	value: (string | number)
}

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

export type MessageReferenceData = {
	type: number?,
	message_id: snowflake?,
	guild_id: snowflake?,
	channel_id: snowflake?,
	fail_if_not_exists: boolean?
}

export type MessageSnapshotData = {
	message: MessageData
}

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

export type MessageComponentInteractionData = {
	custom_id: string,
	component_type: number,
	values: {(string | number | boolean)}?,
	resolved: ResolvedData?
}

export type EntitlementData = {
	id: snowflake,
	sku_id: snowflake,
	plan: {
		id: snowflake,
		price: number
	}
}

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

export type ApplicationCommandInteractionDataOptionData = {
	name: string,
	type: number,
	value: (string | number | boolean)?,
	options: {ApplicationCommandInteractionDataOptionData}?,
	focused: boolean?
}

export type ApplicationCommandInteractionData = {
	id: snowflake,
	name: string,
	type: number,
	resolved: ResolvedData?,
	options: {ApplicationCommandInteractionDataOptionData}?,
	guild_id: snowflake?,
	target_id: snowflake?
}

export type InteractionMetadataData = {
	id: snowflake,
	type: number,
	user: UserData,
	authorizing_integration_owners: {[number]: snowflake},
	original_response_message_id: snowflake?,
	interacted_message_id: snowflake?,
	triggering_interaction_metadata: {}
}

export type ComponentData = {[number]: {type: number, components: {[number]: {type: number, label: string, style: number, custom_id: snowflake}}}}

export type StickerItemData = {
	id: snowflake,
	name: string,
	format_type: number
}

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

export type StickerPackData = {
	id: snowflake,
	stickers: {StickerData},
	name: string,
	sku_id: number,
	cover_sticker_id: snowflake?,
	description: string,
	banner_asset_id: snowflake?
}

export type ThreadMemberData = {
	id: snowflake?,
	user_id: snowflake?,
	join_timestamp: string,
	flags: number,
	member: MemberData?
}

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

export type RoleSubscriptionData = {
	role_subscription_listing_id: snowflake,
	tier_name: string,
	total_months_subscribed: number,
	is_renewing: boolean
}

export type PollMediaData = {text: string?, emoji: EmojiData?}

export type PollAnswerData = {
	answer_id: snowflake,
	poll_media: PollMediaData
}

export type PollAnswerCountData = {
	id: snowflake,
	count: number,
	me_voted: boolean
}

export type PollResultData = {
	is_finalized: boolean,
	answer_counts: {PollAnswerCountData}
}

export type PollData = {
	question: PollMediaData,
	answers: {PollAnswerData},
	expiry: string?,
	allow_multiselect: boolean,
	layout_type: number,
	results: {PollResultData}

}

export type CallData = {
	participants: {number}?,
	ended_timestamp: string?
}

export type ResolvedData = {
	users: {UserData}?,
	members: {MemberData}?,
	roles: {RoleData}?,
	channels: {ChannelData}?,
	message: MessageData?,
	attachments: {AttachmentData}?
}

export type Payload = {op: number?, d: {[string]:any}, s: number?, t: string?}


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