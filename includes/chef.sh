#!/bin/bash
if [ -z "$CHEF_SERVER" ]; then
  echo "No Chef server defined. Doing this the old fashioned way."
else
  # Check chef-dk is installed
  if [ -z "$(chef --version)" ]; then
    echo "install chef-dk first"
  else
    echo "Chef-dk is installed. Gud."
  fi

  echo "Using Chef server url $CHEF_SERVER."
  [ -s $DIR/includes/configs/chef/validator.pem ] || printf '%s' "$CHEF_VALIDATOR_KEY" > $DIR/includes/configs/chef/validator.pem
fi


# check for .chef directory or rely on chef?

# check for knife or rely on chef?

# Generate client.rb
