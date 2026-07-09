# Mattermost ARM64 Docker Image (Team Edition)
FROM alpine:3.21 AS builder

ARG MATTERMOST_VERSION

RUN apk add --no-cache ca-certificates curl tar

WORKDIR /mattermost

# Correct download URL for Team Edition arm64
RUN curl -fsSL "https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-team-${MATTERMOST_VERSION}-linux-arm64.tar.gz" \
    | tar -xz --strip-components=1

FROM alpine:3.21

RUN apk add --no-cache ca-certificates mailcap tzdata \
    && addgroup -g 2000 mattermost \
    && adduser -u 2000 -G mattermost -D mattermost

COPY --from=builder /mattermost /mattermost

WORKDIR /mattermost
USER mattermost

EXPOSE 8065
ENTRYPOINT ["/mattermost/bin/mattermost"]
