#!/bin/bash

set -ex

PORT_WSS="${PORT_WSS:=8002}"
export TRACE="${TRACE}"

# account for php needs to acccess the pipe for communication with docker
chown www-data:www-data /var/run/docker.sock

if [[ "$MODE" == "self-signed" ]]; then 

  CERT="/etc/ssl/certs/ssl-cert-snakeoil.pem"
  KEY="/etc/ssl/private/ssl-cert-snakeoil.key" 

  openssl req -new -x509 -days 256 -nodes -newkey rsa:4096 -out $CERT -keyout $KEY  -subj '/CN='"${HOST}"'/O='"${HOST}"'/C=US/OU=dockerphp'

  ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/.
else
  ln -s /etc/apache2/sites-available/default-nossl.conf /etc/apache2/sites-enabled/.
fi
rm -f /etc/apache2/sites-enabled/000-default.conf

export APP_ROOT=/var/www/html
php /var/www/wss-src/wssrv.php "${PORT_WSS}" &
WSS_PID=$!

trap "trap - SIGTERM; kill -9 ${WSS_PID}; apachectl -k stop || true; kill -9 0; exit 0" SIGINT SIGTERM EXIT


apache2-foreground
