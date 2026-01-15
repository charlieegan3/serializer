# serializer

serializer collects links from Hacker news & others and lists them in
**sequential** order, some might even say it *serializes* them. It also
collects a few other sources, not all of which are voting based, e.g. Ars
Technica.

## Requirements
- Ruby `3.4.7`
- Rails `~> 7.2`
- PostgreSQL
- Node.js (for asset compilation)

## Running (Docker)
```sh
docker build -t serializer:latest .
docker run --rm -p 3000:3000 \
	-e RAILS_ENV=production \
	-e SECRET_KEY_BASE=changeme \
	-e DATABASE_URL=postgres://db \
	serializer:latest
```

For development without Docker, use a Ruby `3.4.7` environment, run `bundle install`, set `DATABASE_URL`, and start with `bundle exec rails server`.
