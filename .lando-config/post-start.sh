#! /bin/bash

# Get the lando logger
. /helpers/log.sh

cd /app/docroot/themes/custom/dlp
npm install && npm run compile && lando_green "*****Catalog theme build complete.*****"
