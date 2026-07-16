ARG PI_VERSION=0.80.7

FROM node:24.18.0-trixie-slim

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    fd-find \
    ripgrep \
  && rm -rf /var/lib/apt/lists/*

# Install Pi Coding Agent
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@"$PI_VERSION"

WORKDIR /workspace

ENTRYPOINT ["pi"]
