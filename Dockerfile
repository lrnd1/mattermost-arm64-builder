# Mattermost ARM64 Docker Image
# Based on official approach, adapted for arm64

FROM alpine:3.21 AS builder

ARG MATTERMOST_VERSION

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tar

WORKDIR /mattermost

# Download the official arm64 release tarball
RUN curl -fsSL "https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-${MATTERMOST_VERSION}-linux-arm64.tar.gz" \
    | tar -xz --strip-components=1

# Final runtime image
FROM alpine:3.21

RUN apk add --no-cache \
    ca-certificates \
    mailcap \
    tzdata \
    && addgroup -g 2000 mattermost \
    && adduser -u 2000 -G mattermost -D mattermost

COPY --from=builder /mattermost /mattermost

WORKDIR /mattermost

USER mattermost

EXPOSE 8065

ENTRYPOINT ["/mattermost/bin/mattermost"]
