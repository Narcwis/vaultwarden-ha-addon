# =============================================================================
# Vaultwarden Home Assistant Add-on Dockerfile
# =============================================================================
# Multi-stage build:
#   1. Pull vaultwarden/server at the specified BUILD_VERSION
#   2. Layer the binary onto the Home Assistant base image (BUILD_FROM)
# =============================================================================

ARG BUILD_VERSION
ARG BUILD_FROM

# Stage 1 — Fetch vaultwarden binary and web vault from the official image
FROM vaultwarden/server:${BUILD_VERSION} AS vaultwarden_src

# Stage 2 — Final HA-compatible image
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

# Install runtime dependencies
RUN \
    apk add --no-cache \
        curl \
        sqlite-libs

# Copy vaultwarden binary and web vault from the source image
COPY --from=vaultwarden_src /vaultwarden /usr/local/bin/vaultwarden
COPY --from=vaultwarden_src /web-vault /web-vault

# Create the vaultwarden user (uid/gid 1000 to match default HA expectations)
RUN \
    addgroup -g 1000 vaultwarden && \
    adduser -u 1000 -G vaultwarden -h /data -s /sbin/nologin -D vaultwarden

# Copy root filesystem overlay (s6 service definition)
COPY rootfs /

# Working directory and data volume
WORKDIR /data
VOLUME ["/data"]

# Expose ports
EXPOSE 80
EXPOSE 3012

# Labels required by Home Assistant
LABEL \
    io.hass.name="Vaultwarden" \
    io.hass.description="Lightweight Bitwarden-compatible password manager" \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH:-amd64}"

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:80/alive || exit 1
