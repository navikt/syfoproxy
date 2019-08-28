#!/usr/bin/env bash

source /var/run/secrets/nais.io/vault/credentials.env
envsubst < /tmp/default.conf.template > /etc/nginx/conf.d/default.conf '$SERVICE_GATEWAY_URL $SERVICE_GATEWAY_KEY $ALLOW_ORIGIN'

exec nginx -g 'daemon off;'
