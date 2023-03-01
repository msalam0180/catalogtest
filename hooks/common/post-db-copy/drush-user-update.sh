#!/bin/sh
#
# Cloud Hook: drush-user-update
#
# Run drush uublk and urol in all non-prod environments.

# Map the script inputs to convenient names.
site=$1
target_env=$2
db_name="$3"
source_env="$4"
drush_alias=$site'.'$target_env

# List of drush command based on site.
drush_catalog="drush10 @$drush_alias"

# List of users based on site.
user_catalog="buenaventurac@sec.gov, abramov@sec.gov, lindingerri@sec.gov, tunpaiboolp@sec.gov, tsegayea@sec.gov, saraviama@sec.gov, khanshah@sec.gov, ahamedmo@sec.gov, rodriguezn@sec.gov, fematha@sec.gov, garciaro@sec.gov, bhimanin@sec.gov, nguyenphu@sec.gov, alammo@sec.gov, pettigrewa@sec.gov, michona@sec.gov, zamarronal@sec.gov, ybarras@sec.gov"

# Execute commands if environment is NOT prod.
if [ $target_env != "prod" ]; then
  case $db_name in
    "datacatalog01")
      $drush_catalog uublk "$user_catalog"
      $drush_catalog urol administrator "$user_catalog"
    ;;
  esac
else
  echo "Did not execute any drush commands."
fi
