#!/usr/bin/env sh
set -eu

envsubst '${LETSENCRYPT_DOMAIN}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"

