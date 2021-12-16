#!/usr/bin/env sh

#import environment variable
export $(cat .env | xargs)

docker-compose \
-f stage1-docker-compose.yml \
run --rm  \
certbot certonly \
--webroot \
--webroot-path /var/www/certbot/ \
--register-unsafely-without-email \
--agree-tos \
--staging \
-d $LETSENCRYPT_DOMAIN

sudo chown --recursive $USER ./certbot
