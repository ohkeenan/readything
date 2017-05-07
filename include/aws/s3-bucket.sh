#!/bin/bash

# Create bucket folders
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/vmail/
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/data/

# Transfer ajenti configs to le bucket
aws s3api put-object \
  --bucket nw-rt \
  --key users/$CLIENTSEC/config/ajenti.tar.bz2 \
  --body $OUTPUT/ajenti.tar.bz2
