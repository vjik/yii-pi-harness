#!/bin/sh
set -eu

PUID="${PUID:-0}"
PGID="${PGID:-0}"
if [ "$PUID" = 0 ] && [ "$PGID" = 0 ]; then
  exec "$@"
fi

chown -R "$PUID:$PGID" "$PI_CODING_AGENT_SESSION_DIR"

export HOME=/tmp/user-home
exec setpriv --reuid="$PUID" --regid="$PGID" --clear-groups "$@"
