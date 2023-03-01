#!/bin/bash

source ~/.profile
export $(grep -v "^#" ~/.snow.env.${AH_SITE_ENVIRONMENT} | xargs)
export SNOW_API_TOKEN=$(curl -k -X POST -d "grant_type=password&client_id=${SNOW_CLIENT_ID}&client_secret=${SNOW_CLIENT_SECRET}&username=${SNOW_USERNAME}&password=${SNOW_PASSWORD}" https://${SNOW_INSTANCE}/oauth_token.do | jq -r '.access_token')
cd /var/www/html/${AH_SITE_GROUP}.${AH_SITE_ENVIRONMENT}/docroot/sites/default/files/migration
curl -o asl.json -k -H 'Accept: application/json' -H "Authorization: Bearer ${SNOW_API_TOKEN}" https://${SNOW_INSTANCE}/api/now/table/cmdb_software_product_model?sysparm_query=u_approved_software=true&sysparm_display_value=true&sysparm_suppress_pagination_header=true
