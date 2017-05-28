#!/bin/bash

# Generate vault json
cat > $OUTPUT/vault.json <<- EOF
{
  "sql_root": "$MYSQL_ROOT_PASSWORD",
  "sql_nextcloud": "$MYSQL_NEXTCLOUD_PASSWORD",
  "cloud_admin": "$NEXTCLOUD_ADMIN_PASSWORD",
  "domain": "$DOMAIN",
  "buckets": "$BUCKET"
}
EOF
