#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${SKIP_DB_MIGRATE:-}" ]]; then
	echo "Skipping migrations (SKIP_DB_MIGRATE=1)"
	exec "$@"
fi

echo "Running database migrations..."
bundle exec rails db:migrate
exec "$@"
