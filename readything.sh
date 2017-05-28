#!/bin/bash

# Get directory
SCRIPT=$(readlink -f $0)
DIR=`dirname $SCRIPT`

# includes variables
. "$DIR/includes/variables.sh"

# Chef
. "$DIR/includes/chef.sh"

# includes imports
. "$DIR/includes/imports.sh"

# includes AWS scripts
. "$DIR/includes/aws/s3-bucket.sh"

# Generate user data
. "$DIR/includes/userdata.sh"

# Generate user policies
. "$DIR/includes/aws/iam-userpolicy.sh"

# Generate the vault.json
. "$DIR/includes/vaultdata.sh"


# Create Role
# Check if Role Already Exists
if [ -z "$(aws iam get-role --role-name $BUCKET-$CLIENT | grep RoleId)" ]; then
  echo -ne "Role does not exist."
  aws iam create-role \
          --role-name $BUCKET-$CLIENT \
          --assume-role-policy-document file://$OUTPUT/ec2-$CLIENT-trust.json
  echo -en "\e[32mCreated $BUCKET-$CLIENT\e[0m"
else
  echo "Role $BUCKET-$CLIENT exists. Skipping...."
fi

# Check if Policy Already Exists
if [ -z "$(aws iam get-role-policy --role-name $BUCKET-$CLIENT --policy-name $BUCKET-s3-$CLIENT |grep ListBucket)" ]; then
  echo "Policy does not exist. Creating $BUCKET-s3-$CLIENT"
  aws iam put-role-policy \
          --role-name $BUCKET-$CLIENT \
          --policy-name $BUCKET-s3-$CLIENT \
          --policy-document file://$OUTPUT/s3-$CLIENT.json
else
  echo "Policy $BUCKET-s3-$CLIENT exists. Skipping..."
fi

# Check if policy is attached already
if [ -z "$(aws iam list-attached-role-policies --role-name $BUCKET-$CLIENT | grep $BUCKET-s3-users)" ]; then
  # Todo: Create policy if doesn't exist
  echo "Policy is not attached to role. Attaching."
  aws iam attach-role-policy \
          --policy-arn arn:aws:iam::729480203074:policy/$BUCKET-s3-users \
          --role-name $BUCKET-$CLIENT
else
  echo "Policy is already attached. Skipping..."
fi

# Check if Instance Profile Already Exists
if [ -z "$(aws iam get-instance-profile --instance-profile-name $BUCKET-ip-$CLIENT)" ]; then
  echo "Instance profile does not exist. Creating."
  aws iam create-instance-profile \
          --instance-profile-name $BUCKET-ip-$CLIENT
else
  echo "Instance profile already exists. Skipping..."
fi

if [ -z "$(aws iam list-instance-profiles-for-role --role-name $BUCKET-$CLIENT|grep $BUCKET-ip-$CLIENT)" ]; then
  echo "Role is not attached to instance profile. Attaching."
  aws iam add-role-to-instance-profile \
          --instance-profile-name $BUCKET-ip-$CLIENT \
          --role-name $BUCKET-$CLIENT
else
  echo "Role is already attached to instance profile. Skipping..."
fi

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
        --iam-instance-profile Name="$BUCKET-ip-$CLIENT" \
        --user-data file://$OUTPUT/userdata.txt

cat >> $keepMe <<- EOF
ReadyThing session for $CLIENT at $(date -u) completed.

MySQL user 'root' password is $MYSQL_ROOT_PASSWORD
NextCloud user 'admin' password is $NEXTCLOUD_ADMIN_PASSWORD
-------------------------------------------------------------------
EOF

# sleep for now - check with chef server later
echo "sleeping while instance is brought up and connected to chef server"
sleep 60s

knife vault create credentials $CLIENT -A "$CHEF_ADMINS,$CLIENT" -J $OUTPUT/vault.json

echo -e "\e[32mReadyThing completed. Session data is located at $keepMe\e[0m"
