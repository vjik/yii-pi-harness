#!/bin/sh
set -eu

PUID="${PUID:-0}"
PGID="${PGID:-0}"
if [ "$PUID" = 0 ] && [ "$PGID" = 0 ]; then
  exec "$@"
fi

# Home directory
export HOME=/tmp/user-home

# Prepare GitHub CLI
export GH_CONFIG_DIR=/tmp/gh-config
mkdir -p "$GH_CONFIG_DIR"
if [ -f /pi/github-token ]; then
  gh auth login --with-token < /pi/github-token \
    || echo "entrypoint: gh auth login failed, continuing without gh authentication" >&2
fi
chown -R "$PUID:$PGID" "$GH_CONFIG_DIR"

# Prepare Pi
chown -R "$PUID:$PGID" "$PI_CODING_AGENT_SESSION_DIR"

# Run Pi
exec setpriv --reuid="$PUID" --regid="$PGID" --clear-groups "$@"
