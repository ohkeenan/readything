#!/bin/bash
cp -R $DIR/includes/configs/* $OUTPUTCFG/
#cp -R $DIR/includes/chef/* $OUTPUTCFG/

# change ohkeenan.com to new domain
find $OUTPUTCFG -type f -exec sed -i "s/ohkeenan.com/$DOMAIN/g" {} \;
find $OUTPUTCFG -type f -exec sed -i "s/ohkeenan/$CLIENT/g" {} \;

mv $OUTPUTCFG/chef_client.rb $OUTPUTCFG/client.rb

# Create tar.bz2 for configs
tar cjf $OUTPUT/configs.tar.bz2 -C $OUTPUT $CFG
echo "Created archive for importing setup configs"
