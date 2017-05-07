#!/bin/bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-k KEY] [-s SGROUP] [-n SUBNET] [-d DOMAIN]...
Create EC2 instance

    -h          display this help and exit
    -k KEY      keyfile (exclude .pem)
    -s SGROUP   security group id
    -n SUBNET   subnet id
    -d DOMAIN   domain (eg ohkeenan.com)
    -v          verbose mode. Can be used multiple times for increased
                verbosity. (does nothing yet)
EOF
}

# Initialize our own variables
VERBOSE=0
OPTIND=1

# Get arguments/options
while getopts hvk:s:n:d: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        v)  VERBOSE=$((VERBOSE+1))
            ;;
        k)  KEY="$OPTARG"
            ;;
        s)  SGROUP="$OPTARG"
            ;;
        n)  SUBNET="$OPTARG"
            ;;
        d)  DOMAIN="$OPTARG"
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

if [[ -z "$DOMAIN" || -z "$KEY" || -z "$SGROUP" || -z "$SUBNET" ]];
  then
    echo -e "\e[31mERROR: Domain, key, security group and subnet are all required!\e[0m\n"
    show_help
    exit 1
fi

CLIENT=$(echo -n "$DOMAIN" | cut -d. -f1)
CLIENTSEC=$(echo -n "$CLIENT" | md5sum | cut -d ' ' -f1)
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
