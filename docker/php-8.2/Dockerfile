# hadolint ignore=DL3006
FROM php-builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PHP_VERSION=8.2.32
ARG CURL_CONNECT_TIMEOUT=7
ENV PHP_DIR=/opt/php/8.2

WORKDIR /usr/src
RUN curl -fsSL --connect-timeout ${CURL_CONNECT_TIMEOUT} https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz | tar -xJ
WORKDIR /usr/src/php-${PHP_VERSION}

RUN ./configure \
    --prefix=${PHP_DIR} \
    --with-config-file-path=${PHP_DIR}/config \
    --with-config-file-scan-dir=${PHP_DIR}/config/conf.d \
    --with-openssl \
    --with-curl \
    --with-zlib \
    --with-zip \
    --enable-mbstring \
    --enable-intl \
    --enable-bcmath \
    --enable-sockets \
    --enable-pcntl \
    --with-sodium \
    --with-pdo-sqlite \
    --enable-sqlite3 \
    && make -j"$(nproc)" \
    && make install \
    && mkdir -p ${PHP_DIR}/config/conf.d \
    && cp php.ini-development ${PHP_DIR}/config/php.ini

COPY docker/php-8.2/php.ini ${PHP_DIR}/config/conf.d/php.ini
