#!/usr/bin/env bash
die() { echo "$*" 1>&2 ; exit 1; }

echo -e "Deploying caddy to production!"

[ -z "$(git status --porcelain)" ] || die "There are uncommitted changes"

docker --context arm compose --file compose.prod.yml pull || die "Failed to pull new image"
docker --context arm compose --file compose.prod.yml up -d || die "Failed to bring compose up"

docker --context arm cp ./Caddyfile caddy:/etc/caddy/Caddyfile || die "Failed to copy Caddyfile to container"
docker --context arm exec -d caddy sh -c "caddy reload -c /etc/caddy/Caddyfile" || die "Failed to reload caddy config"