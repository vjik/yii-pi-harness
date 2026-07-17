ARG PHP_IMAGE_VERSION=8.5.8-cli-trixie
ARG COMPOSER_IMAGE_VERSION=2.10.2
ARG NODE_IMAGE_VERSION=24.18.0-trixie
ARG PI_VERSION=0.80.10

FROM node:${NODE_IMAGE_VERSION} AS node
FROM composer:${COMPOSER_IMAGE_VERSION} AS composer
FROM php:${PHP_IMAGE_VERSION}

ARG PI_VERSION

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    unzip \
    fd-find \
    ripgrep \
  && rm -rf /var/lib/apt/lists/* \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Custom PHP configuration
COPY php/php.ini "$PHP_INI_DIR/conf.d/php.ini"

# Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Node.js
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Install Pi Coding Agent
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@"$PI_VERSION"

# Pi config directory
ENV PI_CODING_AGENT_DIR=/pi

# Disable all Pi startup network operations (update checks, package update checks, and install/update telemetry).
ENV PI_OFFLINE=1

# Pi system prompt
COPY pi/SYSTEM.md /pi/SYSTEM.md

ENV LC_ALL=C.UTF-8

WORKDIR /workspace

CMD ["pi"]
