# Changelog — Vaultwarden Add-on

## [1.6] — 2026-07-25

- Fixed web vault path — explicitly set `WEB_VAULT_FOLDER=/web-vault` in Dockerfile

## [1.5] — 2026-07-25

- Removed s6-overlay — switched to single-stage build from official vaultwarden/server image
- Addon options now passed as environment variables directly by HA supervisor
- Added `entrypoint.sh` wrapper for `disable_admin_panel` transformation
- Removed unused `map: config:rw` and `map: ssl` mounts

## [1.4] — 2026-07-25

- Addon version 1.4 (bundles Vaultwarden 1.37.0)
- Added `admin_token` to addon options with empty default
- Added `disable_admin_panel` option to toggle admin dashboard visibility

## [1.37.0] — 2025-07-24

- Updated Vaultwarden to v1.37.0
- Added configurable `port` option for internal web port
- Added configurable `notifications_port` option for WebSocket notifications
- Added `admin_token` option for admin panel access
- Exposed port 3012/tcp for WebSocket notifications
