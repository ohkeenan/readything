#!/bin/bash

cat > $OUTPUT/userdata.txt <<- EOF

#!/bin/bash

# Update Instance
yum update -y

# Chef Stuff
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.0.118
mkdir /etc/chef

aws s3api get-object --bucket $BUCKET --region $BUCKETREGION --key users/$CLIENTSEC/config/configs.tar.bz2 /home/ec2-user/configs.tar.bz2
tar xjf /home/ec2-user/configs.tar.bz2 -C /home/ec2-user/
mv /home/ec2-user/$CFG/chef/* /etc/chef/
chef-client

EOF
