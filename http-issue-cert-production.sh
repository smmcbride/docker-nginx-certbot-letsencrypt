#!/usr/bin/env sh

#import environment variable
export $(cat .env | xargs)

docker-compose \
-f http-docker-compose.yml \
run --rm  \
certbot certonly \
--webroot \
--webroot-path /var/www/certbot/ \
--email $LETSENCRYPT_EMAIL \
--no-eff-email \
--agree-tos \
-d $LETSENCRYPT_DOMAIN
