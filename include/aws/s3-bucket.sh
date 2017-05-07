#!/bin/bash

# Create bucket folders
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/ >/dev/null
echo "Created bucket key users/$CLIENTSEC/"
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/vmail/ >/dev/null
echo "Created bucket key users/$CLIENTSEC/vmail/ for mailboxes"
aws s3api put-object --bucket nw-rt --key users/$CLIENTSEC/data/ >/dev/null
echo "Created bucket key users/$CLIENTSEC/data/ for NextCloud"

# Transfer ajenti configs to le bucket
aws s3api put-object \
  --bucket nw-rt \
  --key users/$CLIENTSEC/config/ajenti.tar.bz2 \
  --body $OUTPUT/ajenti.tar.bz2 >/dev/null
  echo "Uploaded archive to S3 /users/$CLIENTSEC/config/ajenti.tar.bz2"
