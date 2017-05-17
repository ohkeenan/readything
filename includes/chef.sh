#!/bin/bash

# Check chef-dk is installed
if [[ -z "$(chef --version)" ]]; then
  echo "install chef-dk first"
else
  echo "Chef-dk is installed. Gud."
fi

# check for .chef directory or rely on chef?

# check for knife or rely on chef?

# Generate client.rb
