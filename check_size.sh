#!/bin/bash

SIZE=$(du -sk $FILE --exclude=DEBIAN | cut -f1) 
sed -i "/^Version:/a Installed-Size: $SIZE" $PATH/DEBIAN/control
