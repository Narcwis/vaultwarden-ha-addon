# Vaultwarden Home Assistant Add-on

[![GitHub Release](https://img.shields.io/github/v/release/Narcwis/vaultwarden-ha-addon)](https://github.com/Narcwis/vaultwarden-ha-addon/releases)
[![HA Add-on](https://img.shields.io/badge/Home%20Assistant-Add--on-blue)](https://github.com/Narcwis/vaultwarden-ha-addon)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen)](https://github.com/Narcwis/vaultwarden-ha-addon)

Vaultwarden (unofficial Bitwarden compatible server) as a Home Assistant add-on.

This repository provides an easy way to run [Vaultwarden](https://github.com/dani-garcia/vaultwarden) — a lightweight, self-hosted password manager compatible with Bitwarden clients — directly on your Home Assistant system.

## About

Vaultwarden is a lightweight implementation of the Bitwarden server API written in Rust. It is ideal for self-hosted deployment where running the official resource-heavy Bitwarden server is undesirable.

This add-on:
- Pulls the official [vaultwarden/server](https://hub.docker.com/r/vaultwarden/server) Docker image
- Runs on the Home Assistant supervisor
- Supports all architectures (amd64, aarch64, armv7, armhf, i386)
- Automatically stays up-to-date via Renovate bot

## Installation

1. Add this repository to your Home Assistant instance:

   [![Add repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FNarcwis%2Fvaultwarden-ha-addon)

   Or manually go to **Settings → Add-ons → Add-on Store → ⋮ → Repositories** and add:
   ```
   https://github.com/Narcwis/vaultwarden-ha-addon
   ```

2. Find the **Vaultwarden** add-on in the store and click **Install**.

3. Configure the add-on options to your preference.

4. Start the add-on and navigate to `http://homeassistant.local:80` (or your HA IP).

## Configuration

| Version | |
|---------|-|
| Addon | 1.4 |
| Vaultwarden | 1.37.0 |

| Option | Default | Description |
|--------|---------|-------------|
| `signups_allowed` | `false` | Allow new user registration |
| `domain` | (optional) | Set the domain for Vaultwarden (e.g., `https://vault.example.com`) |
| `admin_token` | (optional) | Token for the admin panel at `/admin` |
| `disable_admin_panel` | `false` | Disable the admin dashboard |

## Development

### Repository Structure

```
vaultwarden-ha-addon/
├── vaultwarden/          # Add-on definition
│   ├── config.yaml       # Add-on configuration
│   ├── Dockerfile        # Multi-stage Docker build
│   ├── rootfs/           # Root filesystem overlay
│   └── CHANGELOG.md      # Per-add-on changelog
├── .github/
│   ├── renovate.json5    # Renovate bot config
│   └── workflows/
│       └── renovate.yml  # Scheduled Renovate workflow
├── repository.yaml       # HA repository manifest
├── LICENSE
└── README.md
```

### How Updates Work

This repository uses [Renovate](https://docs.renovatebot.com/) to automatically keep the add-on version in sync with the official [vaultwarden/server](https://hub.docker.com/r/vaultwarden/server) Docker image tags.

When a new Vaultwarden version is released (e.g., `v1.34.0`), Renovate creates a PR that:
- Updates the `version` field in `vaultwarden/config.yaml`
- Updates `BUILD_VERSION` in `vaultwarden/Dockerfile`

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Vaultwarden itself is Copyright &copy; Daniel Garcia and contributors, licensed under AGPL-3.0.
