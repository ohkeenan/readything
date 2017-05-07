#!/bin/bash

if [ -z "$1" ]
  then
    read -r -p "Enter the domain: " DOMAIN
  else
    DOMAIN="$1"
fi



KEY="Kverbr" # Pem key
SECURITYGROUP="sg-4395102a"
SUBNET="subnet-2fcc3354"
CLIENT=$(echo -n "$DOMAIN" | cut -d. -f1)
CLIENTMD5=$(echo -n "$CLIENT" | md5sum | cut -d ' ' -f1)
OUTPUT="$DIR/output/$CLIENT"
AJ="aj"
OUTPUTAJ="$OUTPUT/$AJ"
keepMe="$OUTPUT/credentials.txt"

mkdir -p $OUTPUTAJ

function randm() {
  echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
}

MYSQL_ROOT_PASSWORD=$(randm)
MYSQL_NEXTCLOUD_PASSWORD=$(randm)
NEXTCLOUD_ADMIN_PASSWORD=$(randm)

cat >> $keepMe <<- EOM
ReadyThing session for $CLIENT at $(date -u)

MySQL user 'root' password is $MYSQL_ROOT_PASSWORD
NextCloud user 'admin' password is $NEXTCLOUD_ADMIN_PASSWORD
-------------------------------------------------------------------
EOM
