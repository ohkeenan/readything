#!/bin/bash
cp -R $DIR/includes/configs/* $OUTPUTCFG/
#cp -R $DIR/includes/chef/* $OUTPUTCFG/

# change ohkeenan.com to new domain
find $OUTPUTCFG -type f -exec sed -i "s/ohkeenan.com/$DOMAIN/g" {} \;
find $OUTPUTCFG -type f -exec sed -i "s/ohkeenan/$CLIENT/g" {} \;
find $OUTPUTCFG -type f -exec sed -i "s|CHEF_SERVER|$CHEF_SERVER|g" {} \;
find $OUTPUTCFG -type f -exec sed -i "s/CHEFVALIDCLIENT/$CHEF_VALIDATOR_CLIENT_NAME/g" {} \;

# Create tar.bz2 for configs
tar cjf $OUTPUT/configs.tar.bz2 -C $OUTPUT $CFG
echo "Created archive for importing setup configs"
