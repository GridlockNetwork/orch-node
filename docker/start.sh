#!/bin/sh
if [ -f /app/.env ]; then
  echo "Using custom env file"
  cp /app/.env /tmp/runtime.env
else
  echo "Using default fallback env"
  cp /app/default.env /tmp/runtime.env
fi

# Export all variables
set -a
. /tmp/runtime.env
set +a

# Run the application
exec node dist/index.js 