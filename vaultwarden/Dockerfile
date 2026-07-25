# =============================================================================
# Vaultwarden Home Assistant Add-on Dockerfile
# =============================================================================
# Builds on top of the official vaultwarden/server image directly (no s6).
# The HA supervisor passes addon options as environment variables natively.
# A lightweight entrypoint wrapper applies any custom transformations.
# =============================================================================

# renovate: datasource=docker depName=vaultwarden/server versioning=docker
ARG VAULTWARDEN_VERSION="1.37.0"
FROM vaultwarden/server:${VAULTWARDEN_VERSION}

# Copy entrypoint wrapper
COPY rootfs/ /

ARG VAULTWARDEN_VERSION
WORKDIR /data
VOLUME ["/data"]
ENV DATA_FOLDER=/data \
    WEB_VAULT_FOLDER=/web-vault

EXPOSE 80

LABEL \
    io.hass.name="Vaultwarden" \
    io.hass.description="Lightweight Bitwarden-compatible password manager" \
    io.hass.version="${VAULTWARDEN_VERSION}" \
    io.hass.type="addon"

HEALTHCHECK --interval=60s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:80/alive || exit 1

ENTRYPOINT ["/entrypoint.sh"]
