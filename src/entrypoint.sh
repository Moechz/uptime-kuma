#!/bin/sh
# ===========================================================================
# Uptime Kuma entrypoint for a non-root container (TOS 7 requirement).
#
# The upstream entrypoint chowns /app/data and then starts the Node server; the
# chown fails inside a container that already runs as uid 1000. The server itself
# performs the database migrations, so this wrapper starts it directly.
# ===========================================================================
set -e
set -u

DATA=/app/data
mkdir -p "$DATA" 2>/dev/null || true

if ! ( : > "$DATA/.write-test" ) 2>/dev/null; then
  echo "uptime-kuma: $DATA is not writable by uid $(id -u)" >&2
  exit 1
fi
rm -f "$DATA/.write-test"

cd /app
exec node server/server.js
