#!/bin/bash

# Create bucket folders
aws s3api put-object --bucket nw-rt --key users/$CLIENTMD5/
aws s3api put-object --bucket nw-rt --key users/$CLIENTMD5/vmail/
aws s3api put-object --bucket nw-rt --key users/$CLIENTMD5/data/

# Transfer ajenti configs to le bucket
aws s3api put-object \
  --bucket nw-rt \
  --key users/$CLIENTMD5/config/ajenti.tar.bz2 \
  --body $OUTPUT/ajenti.tar.bz2
