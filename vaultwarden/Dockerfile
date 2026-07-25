# =============================================================================
# Vaultwarden Home Assistant Add-on Dockerfile
# =============================================================================
# Multi-stage build:
#   1. Pull vaultwarden/server at the specified BUILD_VERSION
#   2. Layer onto the HA base image with optimal cache layering
#
# Cache strategy:
#   - Stable layers (apk, user, rootfs) go FIRST so they never need
#     rebuilding when vaultwarden version changes
#   - Vaultwarden binary/web-vault copy + labels are LAST — only these
#     layers invalidate on version bumps
#   - Same-version restarts are fully cached → instant start
# =============================================================================

ARG BUILD_VERSION
ARG BUILD_FROM

# Stage 1 — Fetch vaultwarden binary and web vault from the official image
# renovate: datasource=docker depName=vaultwarden/server versioning=docker
ARG VAULTWARDEN_VERSION="1.37.0"
FROM vaultwarden/server:${VAULTWARDEN_VERSION} AS vaultwarden_src

# Stage 2 — Final HA-compatible image
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

# ── STABLE LAYERS (cached across version bumps) ──────────────────────────

# Install runtime dependencies
RUN \
    apk add --no-cache \
        curl \
        sqlite-libs

# Create the vaultwarden user (uid/gid 1000)
RUN \
    addgroup -g 1000 vaultwarden && \
    adduser -u 1000 -G vaultwarden -h /data -s /sbin/nologin -D vaultwarden

# Copy root filesystem overlay (s6 service definition)
COPY rootfs /

# Working directory and data volume
WORKDIR /data
VOLUME ["/data"]

EXPOSE 80

# ── VAULTWARDEN LAYERS (invalidate only on version changes) ─────────────

# Copy vaultwarden binary and web vault from source image
COPY --from=vaultwarden_src /vaultwarden /usr/local/bin/vaultwarden
COPY --from=vaultwarden_src /web-vault /web-vault

# Labels required by Home Assistant
LABEL \
    io.hass.name="Vaultwarden" \
    io.hass.description="Lightweight Bitwarden-compatible password manager" \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH:-amd64}" \
    io.hass.vaultwarden_version="${VAULTWARDEN_VERSION}"

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:80/alive || exit 1
