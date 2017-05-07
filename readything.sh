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
# Check if Role Already Exists
if [ -z "$(aws iam get-role --role-name nw-rt-$CLIENT | grep RoleId)" ]; then
  echo "Role does not exist. Creating nw-rt-$CLIENT"
  aws iam create-role \
          --role-name nw-rt-$CLIENT \
          --assume-role-policy-document file://$OUTPUT/ec2-$CLIENT-trust.json
else
  echo "Role nw-rt-$CLIENT exists. Not creating."
fi

# Check if Policy Already Exists
if [ -z "$(aws iam get-role-policy --role-name nw-rt-$CLIENT --policy-name nw-rt-s3-$CLIENT |grep ListBucket)" ]; then
  echo "Policy does not exist. Creating nw-rt-s3-$CLIENT"
  aws iam put-role-policy \
          --role-name nw-rt-$CLIENT \
          --policy-name nw-rt-s3-$CLIENT \
          --policy-document file://$OUTPUT/s3-$CLIENT.json
else
  echo "Policy nw-rt-s3-$CLIENT exists. Not creating."
fi

aws iam attach-role-policy \
        --policy-arn arn:aws:iam::729480203074:policy/nw-rt-s3-users \
        --role-name nw-rt-$CLIENT

aws iam create-instance-profile \
        --instance-profile-name nw-rt-ip-$CLIENT

aws iam add-role-to-instance-profile \
        --instance-profile-name nw-rt-ip-$CLIENT \
        --role-name nw-rt-$CLIENT

# have to give AWS a few seconds for policies/S3
echo "sleeping..."
sleep 20s

# run run run!
aws ec2 run-instances \
        --image-id ami-0bd66a6f \
        --count 1 \
        --instance-type t2.micro \
        --key-name $KEY \
        --security-group-ids $SGROUP \
        --subnet-id $SUBNET \
        --iam-instance-profile Name="nw-rt-ip-$CLIENT" \
        --user-data file://$OUTPUT/userdata.txt

cat >> $keepMe <<- EOF
ReadyThing session for $CLIENT at $(date -u) completed.

MySQL user 'root' password is $MYSQL_ROOT_PASSWORD
NextCloud user 'admin' password is $NEXTCLOUD_ADMIN_PASSWORD
-------------------------------------------------------------------
EOF

echo -e "\e[32mReadyThing completed. Session data is located at $keepMe\e[0m"
