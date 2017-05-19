#!/bin/bash

# Functions first
randm() {
  echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
}

customCfg() {
  echo "Using custom configuration file $CONFIG"
  source "$DIR/$CONFIG"
}
defaultCfg() {
  echo "Using default configuration file default.cfg"
  source "$DIR/default.cfg"
}

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-c CONFIG]...
Create EC2 instance

    -h          display this help and exit
    -c config   use specific config file located in directory with readything.sh
    -v          verbose mode. Can be used multiple times for increased
                verbosity. (does nothing yet)
EOF
}

# Initialize our own variables
VERBOSE=0
OPTIND=1

# Get arguments/options
while getopts hvc: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        v)  VERBOSE=$((VERBOSE+1))
            ;;
        c)  CONFIG="$OPTARG"
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

[ -z "$CONFIG" ] && defaultCfg || customCfg

if [[ -z "$DOMAIN" || -z "$KEY" || -z "$SGROUP" || -z "$SUBNET" || -z "$BUCKET" ]];
  then
    echo -en "\e[31m*** ERROR: "
    [ -z "$DOMAIN" ] && echo -n "Domain, "
    [ -z "$KEY" ] && echo -n "Key, "
    [ -z "$SGROUP" ] && echo -n "Security Group, "
    [ -z "$SUBNET" ] && echo -n "Subnet, "
    [ -z "$BUCKET" ] && echo -n "Bucket, "
    echo -e "required! ***\e[0m\n"
    show_help
    exit 1
fi

CLIENT=$(echo -n "$DOMAIN" | cut -d. -f1)
CLIENTSEC=$(echo -n "$CLIENT" | md5sum | cut -d ' ' -f1)
OUTPUT="$DIR/output/$CLIENT"
CFG="rt"
OUTPUTCFG="$OUTPUT/$CFG"
keepMe="$OUTPUT/credentials.txt"
mkdir -p $OUTPUTCFG

MYSQL_ROOT_PASSWORD=$(randm)
MYSQL_NEXTCLOUD_PASSWORD=$(randm)
NEXTCLOUD_ADMIN_PASSWORD=$(randm)
