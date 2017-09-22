# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.13.12 - 2015-03-23

* [FEATURE] New channel/video reports: `favorites_added`, `favorites_removed`.

## 0.13.11 - 2015-02-27

* [FEATURE] New channel reports: `subscribers_gained`, `subscribers_lost`.
* [FEATURE] New video reports: `subscribers_gained`, `subscribers_lost`.
* [FEATURE] New channel reports: `estimated_minutes_watched`, `average_view_duration`, `average_view_percentage`.

## 0.13.10 - 2015-02-17

* [FEATURE] New `video.upload_thumbnail` to upload the thumbnail for a video.

## 0.13.9 - 2015-02-16

* [ENHANCEMENT] Accept `force: true` in `authentication_url` to force approval prompt.

## 0.13.8 - 2015-01-15

* [FEATURE] AssetSearch resources available.
* [FEATURE] Access asset metadata (`effective` and `mine`) via the asset object.
* [ENHANCEMENT] Support `isManualClaim` parameter in claims#insert.

## 0.13.7 - 2014-10-27

* [FEATURE] New video reports: monetized playbacks.

## 0.13.6 - 2014-10-08

* [ENHANCEMENT] Accept `includes(:viewer_percentages)` in `.partnered_channels` to eager-load multiple viewer percentages at once.
* [ENHANCEMENT] Accept `where` in ViewerPercentages to collect data for multiple channels at once.
* [ENHANCEMENT] Accept `part` in the `where` clause of Channels, so statistics can be loaded at once.

## 0.13.5 - 2014-10-06

* [ENHANCEMENT] Add `advertising_options_set` and `ad_formats` to video

## 0.13.4 - 2014-10-01

* [ENHANCEMENT] Accept `policy` (with custom set of rules) in `content_owner.create_claim`

## 0.13.3 - 2014-10-01

* [BUGFIX] Rescue OpenSSL::SSL::SSLErrorWaitReadable raised by YouTube servers.

## 0.13.2 - 2014-10-01

* [FEATURE] Add `release!` to Ownership.

## 0.13.1 - 2014-09-18

* [BUGFIX] Make list videos by id work for exactly 50 ids.

## 0.13.0 - 2014-09-11

**How to upgrade**

If your code never calls the `create_playlist` on a Channel object, then you
are good to go.

If it does, then replace your calls to `channel.create_playlist` with
`account.create_playlist`, that is, call `create_playlist` on the channel’s
account instead.

* [ENHANCEMENT] Remove `create_playlist` from Channel (still exists on Account)
* [ENHANCEMENT] Accept `category_id` in `upload_video`.

## 0.12.2 - 2014-09-09

* [ENHANCEMENT] Accept `part` in the `where` clause of Videos, so statistics and content details can be eagerly loaded.

## 0.12.1 - 2014-09-04

* [ENHANCEMENT] Add `position` option to add_video (to specify where in a playlist to add a video)
* [FEATURE] Add `update` to PlaylistItem (to change the position of the item in the playlist)

## 0.12.0 - 2014-08-31

**How to upgrade**

If your code never calls the `delete` method directly on a Subscription
object (to delete subscriptions by id), then you are good to go.

If it does, then be aware that trying to delete an unknown subscription will
now raise a RequestError, and will not accept `ignore_errors` as an option:

    account = Yt::Account.new access_token: 'ya29...'
    subscription = Yt::Subscription.new id: '--unknown-id--', auth: account
    # old behavior
    subscription.delete ignore_errors: true # => false
    # new behavior
    subscription.delete # => raises Yt::Errors::RequestError "subscriptionNotFound"

Note that the `unsubscribe` and `unsubscribe!` methods of `Channel` have not
changed, so you can still try to unsubscribe from a channel and not raise an
error by using the `unsubscribe` method:

    account = Yt::Account.new access_token: 'ya29...'
    channel = Yt::Channel.new id: 'UC-CHANNEL-ID', auth: account
    channel.unsubscribe # => returns falsey if you were not subscribed
    channel.unsubscribe! # => raises Yt::Errors::RequestError if you were not subscribed

* [ENHANCEMENT] Replace `has_many :subscriptions` with `has_one :subscription` in Channel
* [FEATURE] Add `subscribed_channels` to Channel (list which channels the channel is subscribed to)
* [FEATURE] Add `subscribers` to Account (list which channels are subscribed to an account)

## 0.11.6 - 2014-08-28

* [BUGFIX] Make Resource.new(url: url).title hit the right endpoint

## 0.11.5 - 2014-08-27

* [BUGFIX] Make videos.where(id: 'MESycYJytkU').first.id return 'MESycYJytkU'

## 0.11.4 - 2014-08-27

* [ENHANCEMENT] Add Video search even by id, chart or rating
* [FEATURE] Add `ActiveSupport::Notification` to inspect HTTP requests

## 0.11.3 - 2014-08-21

* [FEATURE] Add `update` method to Asset model

## 0.11.2 - 2014-08-20

* [FEATURE] Add AdvertisingOptionsSet with `update` to change the advertising settings of a video
* [FEATURE] Add `content_owner.create_claim` and `claim.delete`
* [FEATURE] Add `update` method to Ownership to change owners of an asset
* [FEATURE] Add `asset.ownership` to list the owners of an asset
* [FEATURE] Add `content_owner.create_asset` and Asset model

## 0.11.1 - 2014-08-17

* [ENHANCEMENT] Add Video search even without a parent account or channel

For instance, to search for the most viewed video on the whole YouTube, run:

    videos = Yt::Collections::Videos.new
    videos.where(order: 'viewCount').first.title #=>  "PSY - GANGNAM STYLE"

## 0.11.0 - 2014-08-17

**How to upgrade**

When a request to YouTube fails, Yt used to print out a verbose error message,
including the response body and the request that caused the error (in curl
format). This output could include sensitive data (such as the authentication
token). For security reasons, Yt will not print it out anymore by default.

If this is acceptable, then you are good to go.
If you want the old behavior, set the `log_level` of Yt to `:debug`:

    Yt.configure do |config|
      config.log_level = :debug
    end

* [ENHANCEMENT] Add `log_level` to Yt.configuration

## 0.10.5 - 2014-08-17

* [ENHANCEMENT] Use PATCH rather than PUT to partially update a MatchPolicy

## 0.10.4 - 2014-08-15

* [BUGFIX] List tags of videos retrieved with channel.videos and account.videos

## 0.10.3 - 2014-08-12

* [FEATURE] Add methods to insert and delete ContentID references
* [FEATURE] Add `.match_reference_id` to Claim model

## 0.10.2 - 2014-08-11

* [FEATURE] Add `MatchPolicy` class with `.update` to change the policy used by an asset

## 0.10.1 - 2014-08-11

* [BUGFIX] Make Yt work on Ruby 1.9.3 / ActiveSupport 3.0 again (was broken by 0.10.0)

## 0.10.0 - 2014-08-11

**How to upgrade**

If your code never calls the `size` method to count how many items a list of
results has (e.g., how many videos an account has), then you are good to go.

If it does, then be aware that `size` will now return try to the number of
items as specified in the "totalResults" field of the first page of the YouTube
response, rather than loading *all* the pages (possibly thousands) and counting
exactly how many items are returned.

If this is acceptable, then you are good to go.
If you want the old behavior, replace `size` with `count`:

    account = Yt::Account.new access_token: 'ya29...'
    # old behavior
    account.videos.size # => retrieved *all* the pages of the account’s videos
    # new behavior
    account.videos.size # => retrieves only the first page, returning the totalResults counter
    account.videos.count # => retrieves *all* the pages of the account’s videos

* [ENHANCEMENT] Calling `size` on a collection does not load all the pages of the collection
* [ENHANCEMENT] Alias `policy.time_updated` to more coherent `policy.updated_at`

## 0.9.8 - 2014-08-11

* [FEATURE] Add `.content_owner` and `.linked_at` to channels managed by a CMS content owner

## 0.9.7 - 2014-08-02

* [BUGFIX] Correctly parse videos’ duration for videos longer than 24 hours

## 0.9.6 - 2014-08-02

* [ENHANCEMENT] Accept angle brackets characters in videos’ and playlists’ metadata

## 0.9.5 - 2014-08-02

* [FEATURE] Allow status attributes of a video to be updated

`video.update` now accepts three new attributes: `privacy_status`,
`public_stats_viewable` and `publish_at`.

## 0.9.4 - 2014-08-02

* [FEATURE] Expose metadata for live-streaming videos

New method are now available for `Video` instance to check their live-streaming
details: `actual_start_time`, `actual_end_time`, `scheduled_start_time`,
`scheduled_end_time` and `concurrent_viewers`.

## 0.9.3 - 2014-07-30

* [BUGFIX] Don’t cache `.where` conditions on multiple calls

For instance, invoking `account.videos.where(q: 'x').count` followed by
`account.videos.count` used to return the same result, because the `where`
conditions of the first request were wrongly kept for the successive request.

* [FEATURE] Check if a ContentID claim is third-party with `claim.third_party?`
* [ENHANCEMENT] `update` methods accept both underscore and camel-case attributes

For instance, either of the following syntaxes can now be used:
`video.update categoryId: "22"` or `video.update category_id: "22"`.

## 0.9.2 - 2014-07-29

* [FEATURE] List ContentID policies with `content_owner.policies`

## 0.9.1 - 2014-07-28

* [FEATURE] List ContentID references with `content_owner.references`
* [ENHANCEMENT] `playlist.update` accepts both `privacyStatus` and `privacy_status`

For instance, either of the following syntaxes can now be used:
`playlist.update privacyStatus: "unlisted"` or
`playlist.update privacy_status: "unlisted"`.

## 0.9.0 - 2014-07-28

**How to upgrade**

If your code never declares instances of `Yt::Rating`, or never calls the
`update` method on them, then you are good to go.

If it does, then *simply replace `update` with `set`*:

    rating = Yt::Rating.new
    # old syntax
    rating.update :like
    # new syntax
    rating.set :like

* [ENHANCEMENT] `rating.set` replaces `rating.update` to rate a video

## 0.8.5 - 2014-07-28

* [FEATURE] Delete a video with `video.delete`

## 0.8.4 - 2014-07-24

* [BUGFIX] Correctly parse annotations with timestamp written as `t='0'`

## 0.8.3 - 2014-07-24

* [FEATURE] List content owners managed by an account with `account.content_owners`

## 0.8.2 - 2014-07-23

* [FEATURE] List ContentID claims administered by a content owner with `content_owner.claims`

## 0.8.1 - 2014-07-22

* [FEATURE] Include all the video-related status information in `video.status`

New method are now available for `Video` instance to check their status
information: `public?`, `uploaded?`, `rejected?`, `failed?`, `processed?`,
`deleted?`, `uses_unsupported_codec?`, `has_failed_conversion?`, `empty?`,
`invalid?`, `too_small?`, `aborted?`, `claimed?`, `infringes_copyright?`,
`duplicate?`, `inappropriate?`, `too_long?`, `belongs_to_closed_account?`,
`infringes_trademark?`, `violates_terms_of_use?`, `has_public_stats_viewable?`,
`belongs_to_suspended_account?`, `scheduled?`, `scheduled_at`, `embeddable?`
`licensed_as_creative_commons?` and `licensed_as_standard_youtube?`.

## 0.8.0 - 2014-07-19

**How to upgrade**

If your code never declares instances of `Yt::Channel`, or never calls the
`subscribe` method on them, then you are good to go.

If it does, then be aware that `subscribe` will not raise an error anymore if
a YouTube user tries to subscribe to her/his own YouTube channel. Instead,
`subscribe` will simply return `nil`.

If this is acceptable, then you are good to go.
If you want the old behavior, replace `subscribe` with `subscribe!`:

    account = Yt::Account.new access_token: 'ya29...'
    channel = account.channel
    # old behavior
    channel.subscribe # => raised an error
    # new behavior
    channel.subscribe # => nil
    channel.subscribe! # => raises an error

* [ENHANCEMENT] `channel.subscribe` does not raise error when trying to subscribe to one’s own channel

## 0.7 - 2014/06/18

* [breaking change] Rename DetailsSet to ContentDetail
* Add statistics_set to Video (views, likes, dislikes, favorites, comments)
* Add statistics_set to Channel (views, comments, videos, subscribers)
* More snippet methods for Video (channel_id, channel_title, category_id, live_broadcast_content)
* More snippet methods for Playlist (channel_id, channel_title)
* More snippet methods for PlaylistItem (channel_id, channel_title, playlist_id, video_id)
* More status methods for PlaylistItem (privacy_status, public?, private?, unlisted?)
* Add video.update to update title, description, tags and categoryId of a video
* Sort channel.videos by most recent first
* Extract Reports (earnings, views) into module with macro `has_report`
* New channel reports: comments, likes, dislikes, shares and impressions
* Allow both normal and partnered channels to retrieve reports about views, comments, likes, dislikes, shares
* Make reports available also on Video (not just Channel)
* New account.upload_video to upload a video (either local or remote).
* Make channel.videos access more than 500 videos per channel
* Add viewer percentage (age group, gender) to Channel and Video reports

## 0.6 - 2014/06/05

* [breaking change] Rename Channel#earning to Channel#earnings_on
* [breaking change] Account#videos shows *all* videos owned by account (public and private)
* Add the .status association to *every* type of resource (Channel, Video, Playlist)
* Allow account.videos to be chained with .where, such as in account.videos.where(q: 'query')
* Retry request once when YouTube times out
* Handle annotations with "never" as the timestamp, without text, singleton positions, of private videos
* New methods for Video: hd?, stereoscopic?, captioned?, licensed?

## 0.5 - 2014/05/16

* More complete custom exception Yt::Error, with code, body and curl
* Replace `:ignore_not_found` and `:ignore_duplicates` with `:ignore_errors`
* Allow resources to be initialized with a url, such as Yt::Resource.new url: 'youtube.com/fullscreen'
* Add `has_one :id` to resources, to retrieve the ID of resources initialized by URL
* Raise an error if some `has_one` associations are not found (id, snippet, details set, user info)
* Don't check for the right :scope if Account is initialized with credentials
* Move models in Yt::Models but still auto-include them in the main namespace
* New Authentication model to separate `access_token` and `refresh_token` from Account
* New types of Errors that render more verbose errors and the failing request in cURL syntax
* Separate Error class for 500 error, so they can be easily found in app logs
* New Earning collection to retrieve estimated earning for YouTube-partnered channels
* Rename error classes so they match the corresponding Net::HTTP errors (e.g. Unauthorized)
* Separate Error class for 403 Error
* Retry once YouTube earning queries that return error 400 "Invalid query. Query did not conform to the expectations"
* Update RSpec to 3.0 (only required in development/testing)
* New ContentOwner subclass of Account with access to partnered channels
* Automatically refresh the access token when it expires or becomes invalid
* Retry once YouTube earning queries that return error 503
* Wait 3 seconds and retry *every* request that returns 500, 503 or 400 with "Invalid query"
* New Views collection to retrieve view count for YouTube-partnered channels

## 0.4 - 2014/05/09

* Complete rewrite, using ActiveSupport and separating models and collections
* New methods to handle annotations, details sets
* Supports also ActiveSupport 3 and Ruby 1.9.3 (not just AS4 + Ruby 2)
* Fix parsing annotation and timestamps longer than 1 hour
* Fix delegating tags from resources to snippets
* Two options to add videos to a playlist: fail or not if a video is missing or its account terminated
* Allow to configure Yt credentials through environment variables
* When updating a playlist, only changes the specified attributes

## 0.3.0 - 2014/04/16

* New and improved methods to handle subscriptions, playlists, playlist items
* `find_or_create_playlist_by` does not yield a block anymore
* `account.subscribe_to!` raises error in case of duplicate subscription, but `account.subscribe_to` does not

## 0.2.1 - 2014/04/10

* `account.subscribe_to!` does not raise error in case of duplicate subscription
* Accountable objects can be initialized with the OAuth access token if there's no need to get a fresh one with a refresh token

## 0.2.0 - 2014/04/09

* Replaced `account.perform!` with `account.like!`, `account.subscribe_to!`
* Added `account.add_to!` to add a video to an account’s playlist
* Added `account.find_or_create_playlist_by` to find or create an account’s playlist

## 0.1.1 - 2014/04/09

* Added support for Ruby 2.0.0

## 0.1.0  - 2014/04/08

* Support for authenticated resources: Youtube accounts and Google accounts
* Support for public Youtube resources: channels and videos
* Available actions for authenticated Youtube accounts: like a video, subscribe to a channel