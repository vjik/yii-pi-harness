ARG PHP_IMAGE_VERSION=8.5.8-cli-trixie
ARG NODE_IMAGE_VERSION=24.18.0-trixie
ARG PI_VERSION=0.80.7

FROM node:${NODE_IMAGE_VERSION} AS node
FROM php:${PHP_IMAGE_VERSION}

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    fd-find \
    ripgrep \
  && rm -rf /var/lib/apt/lists/*

# Node.js
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Install Pi Coding Agent
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@"$PI_VERSION"

# Pi config directory
ENV PI_CODING_AGENT_DIR=/pi

# Pi session storage
ENV PI_CODING_AGENT_SESSION_DIR=/pi-sessions

WORKDIR /workspace

ENTRYPOINT ["pi"]
