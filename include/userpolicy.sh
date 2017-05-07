#!/bin/bash

# Generate client trust json
cat > $OUTPUT/ec2-$CLIENT-trust.json <<- EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Generate S3 policy
cat > $OUTPUT/s3-$CLIENT.json <<- EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::nw-rt"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "users/$CLIENTSEC/*"
                    ]
                }
            }
        },
        {
            "Sid": "AllowAllS3ActionsInUserFolder",
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::nw-rt/users/$CLIENTSEC/*"
            ]
        }
    ]
}
EOF
