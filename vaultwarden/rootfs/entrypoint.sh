#!/bin/sh
# =============================================================================
# Vaultwarden entrypoint wrapper for HA add-on
# =============================================================================
# Reads addon options from /data/options.json (written by the supervisor),
# applies custom transformations, then exec's vaultwarden.
# =============================================================================

OPTIONS_FILE="/data/options.json"

if [ -f "${OPTIONS_FILE}" ]; then
    # Extract string values (e.g. "admin_token": "abc")
    get_str() {
        grep -o "\"$1\":[ ]*\"[^\"]*\"" "${OPTIONS_FILE}" | \
            sed "s/.*: *\"//; s/\"$//"
    }

    # Extract boolean values (e.g. "signups_allowed": false)
    get_bool() {
        grep -o "\"$1\":[ ]*\(true\|false\)" "${OPTIONS_FILE}" | \
            sed "s/.*: *//"
    }

    SIGNUPS_ALLOWED=$(get_bool signups_allowed)
    DOMAIN=$(get_str domain)
    ADMIN_TOKEN=$(get_str admin_token)
    DISABLE_ADMIN=$(get_bool disable_admin_panel)

    [ -n "${SIGNUPS_ALLOWED}" ] && export SIGNUPS_ALLOWED="${SIGNUPS_ALLOWED}"
    [ -n "${DOMAIN}" ] && export DOMAIN="${DOMAIN}"

    if [ -n "${ADMIN_TOKEN}" ] && [ "${DISABLE_ADMIN}" != "true" ]; then
        export ADMIN_TOKEN="${ADMIN_TOKEN}"
    fi
fi

exec /vaultwarden
