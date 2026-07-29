# check=skip=InvalidDefaultArgInFrom

ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    xz-utils \
    build-essential \
    autoconf \
    pkg-config \
    libxml2-dev \
    libsqlite3-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libonig-dev \
    libicu-dev \
    libsodium-dev \
    libzip-dev \
  && rm -rf /var/lib/apt/lists/*
