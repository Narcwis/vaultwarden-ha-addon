#!/bin/sh
# =============================================================================
# Vaultwarden entrypoint wrapper for HA add-on
# =============================================================================
# Reads addon options from /data/options.json (written by the supervisor),
# applies custom transformations, then exec's vaultwarden.
# =============================================================================

OPTIONS_FILE="/data/options.json"

if [ -f "${OPTIONS_FILE}" ]; then
    SIGNUPS_ALLOWED=$(jq -r ".signups_allowed // false" "${OPTIONS_FILE}")
    DOMAIN=$(jq -r ".domain // empty" "${OPTIONS_FILE}")
    ADMIN_TOKEN=$(jq -r ".admin_token // empty" "${OPTIONS_FILE}")
    DISABLE_ADMIN=$(jq -r ".disable_admin_panel // false" "${OPTIONS_FILE}")

    export SIGNUPS_ALLOWED="${SIGNUPS_ALLOWED}"

    if [ -n "${DOMAIN}" ]; then
        export DOMAIN="${DOMAIN}"
    fi

    if [ -n "${ADMIN_TOKEN}" ] && [ "${DISABLE_ADMIN}" != "true" ]; then
        export ADMIN_TOKEN="${ADMIN_TOKEN}"
    fi
fi

exec /vaultwarden
