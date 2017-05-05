#!/bin/bash

# Get directory
SCRIPT=$(readlink -f $0)
DIR=`dirname $SCRIPT`

# Include variables
. "$DIR/include/variables.sh"

# Include ajenti-imports
. "$DIR/include/ajenti-imports.sh"

# Include AWS scripts
. "$DIR/include/aws/s3-bucket.sh"

# Generate user data
. "$DIR/include/userdata.sh"

# Generate user policies
. "$DIR/include/userpolicy.sh"


# Create Role
aws iam create-role \
        --role-name nw-rt-$CLIENT \
        --assume-role-policy-document file://$OUTPUT/ec2-$CLIENT-trust.json

aws iam put-role-policy \
        --role-name nw-rt-$CLIENT \
        --policy-name nw-rt-s3-$CLIENT \
        --policy-document file://$OUTPUT/s3-$CLIENT.json

aws iam attach-role-policy \
        --policy-arn arn:aws:iam::729480203074:policy/nw-rt-s3-users \
        --role-name nw-rt-$CLIENT

aws iam create-instance-profile \
        --instance-profile-name nw-rt-ip-$CLIENT

aws iam add-role-to-instance-profile \
        --instance-profile-name nw-rt-ip-$CLIENT \
        --role-name nw-rt-$CLIENT

# have to give AWS a few seconds for policies and S3...
sleep 30s

# run run run!
aws ec2 run-instances \
        --image-id ami-0bd66a6f \
        --count 1 \
        --instance-type t2.micro \
        --key-name Kverbr \
        --security-group-ids sg-4395102a \
        --subnet-id subnet-2fcc3354 \
        --iam-instance-profile Name="nw-rt-ip-$CLIENT" \
        --user-data file://$OUTPUT/userdata.txt
