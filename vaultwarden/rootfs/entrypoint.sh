#!/bin/sh
# =============================================================================
# Vaultwarden entrypoint wrapper for HA add-on
# =============================================================================
# The HA supervisor passes addon options as env vars. This wrapper applies
# custom transformations before exec'ing the vaultwarden binary.
# =============================================================================

# If the admin panel is explicitly disabled, strip the token
if [ "${DISABLE_ADMIN_PANEL}" = "true" ]; then
    unset ADMIN_TOKEN
fi

exec /vaultwarden
