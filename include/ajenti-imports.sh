#!/bin/bash
cp -R $DIR/include/ajenti/* $OUTPUTAJ/

# change example.com to new domain
find $OUTPUTAJ -type f -exec sed -i "s/example.com/$DOMAIN/g" {} \;
find $OUTPUTAJ -type f -exec sed -i "s/example/$CLIENT/g" {} \;

# Create tar.bz2 for Ajenti configs
tar cjf $OUTPUT/ajenti.tar.bz2 -C $OUTPUT $AJ
echo "Created archive for importing setup configs"
