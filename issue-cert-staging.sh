#!/usr/bin/env sh

#import environment variable
export $(cat .env | xargs)

docker run -it --rm \
-v $PWD/docker-volumes/etc/letsencrypt:/etc/letsencrypt \
-v $PWD/docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
-v $PWD/docker/letsencrypt-docker-nginx/src/letsencrypt/letsencrypt-site:/data/letsencrypt \
-v "$PWD/docker-volumes/var/log/letsencrypt:/var/log/letsencrypt" \
certbot/certbot \
certonly --webroot \
--register-unsafely-without-email --agree-tos \
--webroot-path=/data/letsencrypt \
--staging \
-d $LETSENCRYPT_DOMAIN

