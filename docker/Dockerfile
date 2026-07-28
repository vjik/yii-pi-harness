ARG PHP_IMAGE_VERSION=8.5.8-cli-trixie
ARG COMPOSER_IMAGE_VERSION=2.10.2
ARG NODE_IMAGE_VERSION=24.18.0-trixie
ARG PI_VERSION=0.82.1
ARG CLAUDE_CODE_VERSION=2.1.212
ARG ZIZMOR_VERSION=1.28.0
ARG GITHUB_LOOKUP_NEXT_ID_VERSION=1.0.1
ARG GH_VERSION=2.96.0

FROM node:${NODE_IMAGE_VERSION} AS node
FROM composer:${COMPOSER_IMAGE_VERSION} AS composer
FROM php:${PHP_IMAGE_VERSION} AS base

ARG ZIZMOR_VERSION
ARG GITHUB_LOOKUP_NEXT_ID_VERSION
ARG GH_VERSION

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    fd-find \
    ripgrep \
    python3-pip \
    yamllint \
  && rm -rf /var/lib/apt/lists/* \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Custom PHP configuration
COPY php/php.ini "$PHP_INI_DIR/conf.d/php.ini"

# Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Zizmor
RUN pip install zizmor=="$ZIZMOR_VERSION" --no-cache-dir --break-system-packages

# GitHub Lookup Next ID
RUN curl -fsSL "https://raw.githubusercontent.com/vjik/github-lookup-next-id/${GITHUB_LOOKUP_NEXT_ID_VERSION}/github-lookup-next-id" -o /usr/local/bin/github-lookup-next-id \
  && chmod +x /usr/local/bin/github-lookup-next-id

# Node.js
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# GitHub CLI
RUN curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_$(dpkg --print-architecture).deb" -o /tmp/gh.deb \
  && dpkg -i /tmp/gh.deb \
  && rm /tmp/gh.deb

# Knowledge base & Skills
COPY kb/ /kb
COPY skills/ /skills
RUN curl -fsSL "https://raw.githubusercontent.com/cli/cli/v${GH_VERSION}/skills/gh/SKILL.md" -o /skills/gh/SKILL.md

# Entrypoint
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV LC_ALL=C.UTF-8
WORKDIR /workspace
ENTRYPOINT ["entrypoint.sh"]


# =============================================================================
# Pi Coding Agent
# =============================================================================
FROM base AS pi

ARG PI_VERSION

# Install Pi Coding Agent
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@"$PI_VERSION"

# Pi config directory
ENV PI_CODING_AGENT_DIR=/pi

# Disable all Pi startup network operations (update checks, package update checks, and install/update telemetry).
ENV PI_OFFLINE=1

# Pi defaults
COPY agents/pi /opt/pi
RUN chmod +x /opt/pi/prepare.sh

CMD ["pi"]


# =============================================================================
# Claude Code
# =============================================================================
FROM base AS claude-code

ARG CLAUDE_CODE_VERSION

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code@"$CLAUDE_CODE_VERSION"

# Claude Code config directory
ENV CLAUDE_CONFIG_DIR=/claude-code

# The image pins the Claude Code version; disable background auto-update checks
ENV DISABLE_AUTOUPDATER=1

# Claude Code defaults
COPY agents/claude-code /opt/claude-code
RUN chmod +x /opt/claude-code/prepare.sh

CMD ["claude"]
