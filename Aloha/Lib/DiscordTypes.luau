
export type UserData = {
	id: string,
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

export type AvatarDecorationData = {
	asset: string,
	sku_id: number
}

export type PermissionOverwriteData = {
	id: string,
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
	id: string,
	name: string,
	moderated: boolean,
	emoji_id: number?,
	emoji_name: string?
}

export type ChannelData = {
	id: string,
	type: number,
	guild_id: number?,
	position: number?,
	permission_overwrites: {PermissionOverwriteData}?,
	name: string?,
	topic: string?,
	nsfw: boolean?,
	last_message_id: number?,
	bitrate: number?,
	user_limit: number?,
	rate_limit_per_user: number?,
	recipients: {UserData}?,
	icon: string?,
	owner_id: number?,
	application_id: number?,
	managed: boolean?,
	parent_id: number?,
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
	id: string,
	guild_id: number,
	type: number,
	name: string
}

export type AttachmentData = {
	id: string,
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
	bot_id: number?,
	integration_id: number?,
	premium_subscriber: boolean?,
	subscription_listing_id: number?,
	available_for_purchase: boolean?,
	guild_connections: boolean?
}

export type RoleData = {
	id: string,
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
	id: string,
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
	party_id: string?
}

export type TeamMemberData = {
	user: UserData,
	membership_state: number,
	role: string,
	team_id: number
}

export type TeamData = {
	icon: string?,
	id: string,
	members: {TeamMemberData},
	name: string,
	owner_user_id: number
}

export type WelcomeScreenChannelData = {
	channel_id: number,
	description: string,
	emoji_id: number?,
	emoji_name: string?
}

export type WelcomeScreenData = {
	description: string?,
	welcome_channels: {WelcomeScreenChannelData}?
}

export type GuildData = {
	id: string,
	name: string,
	icon: string?,
	icon_hash: string?,
	splash: string?,
	discovery_splash: string?,
	owner: boolean,
	owner_id: number,
	permissions: string?,
	region: string?,
	afk_channel_id: number?,
	afk_timeout: number,
	widget_enabled: boolean?,
	widget_channel_id: number?,
	verification_level: number,
	default_message_notifications: number,
	explicit_content_filter: number,
	roles: {RoleData}?,
	emojis: {EmojiData}?,
	features: {string},
	mfa_level: number,
	application_id: number?,
	system_channel_id: number?,
	system_channel_flags: number,
	rules_channel_id: number?,
	max_presences: number?,
	max_members: number?,
	vanity_url_code: string?,
	description: string?,
	banner: string?,
	premium_tier: number,
	premium_subscription_count: number?,
	preferred_locale: string,
	public_updates_channel_id: number?,
	max_video_channel_users: number?,
	max_stage_video_channel_users: number?,
	approximate_member_count: number?,
	approximate_presence_count: number?,
	welcome_screen: WelcomeScreenData?,
	nsfw_level: number,
	stickers: {StickerData}?,
	premium_progress_bar_enabled: boolean,
	safety_alerts_channel_id: number?
}

export type InstallParamsData = {
	scopes: {string},
	permissions: string
}

export type ApplicationData = {
	id: string,
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
	guild_id: number?,
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

export type MessageReferenceData = {
	type: number?,
	message_id: number?,
	guild_id: number?,
	channel_id: number?,
	fail_if_not_exists: boolean?
}

export type MessageSnapshotData = {
	message: MessageData
}

export type InteractionData = {
	id: string,
	type: number,
	name: string,
	user: UserData,
	member: MemberData?,
}

export type InteractionMetadataData = {
	id: string,
	type: number,
	user: UserData,
	authorizing_integration_owners: {GUILD_INSTALL: number, USER_INSTALL: number},
	original_response_message_id: number?,
	interacted_message_id: number?,
	triggering_interaction_metadata: {}
}

export type ComponentData = {[number]: {type: number, components: {[number]: {type: number, label: string, style: number, custom_id: string}}}}

export type StickerItemData = {
	id: string,
	name: string,
	format_type: number
}

export type StickerData = {
	id: string,
	pack_id: number?,
	name: string,
	description: string?,
	tags: string,
	type: number,
	format_type: number,
	available: boolean?,
	guild_id: number?,
	user: UserData?,
	sort_value: number?
}

export type StickerPackData = {
	id: string,
	stickers: {StickerData},
	name: string,
	sku_id: number,
	cover_sticker_id: number?,
	description: string,
	banner_asset_id: number?
}

export type ThreadMemberData = {
	id: string?,
	user_id: number?,
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
	role_subscription_listing_id: number,
	tier_name: string,
	total_months_subscribed: number,
	is_renewing: boolean
}

export type PollMediaData = {text: string?, emoji: EmojiData?}

export type PollAnswerData = {
	answer_id: number,
	poll_media: PollMediaData
}

export type PollAnswerCountData = {
	id: string,
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

export type MessageData = {
	id: string,
	channel_id: number,
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
	webhook_id: number?,
	type: number,
	activity: ActivityData?,
	application: ApplicationData?,
	application_id: number?,
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