#!/bin/sh
echo "Building sec.gov"
echo "Adding Acquia remote"
git remote rm acquia
git remote add acquia datacatalog01@svn-29892.prod.hosting.acquia.com:datacatalog01.git
echo "Checking out master"
git clean -fd;
git checkout master -f;
git reset --hard
echo "Pulling latest from Gitlab master"
git pull origin master -f;
echo "Pulling latest from Acquia master"
git pull acquia master;
#echo "Pushing latest to Gitlab master"
#git push origin master;
echo "Pushing latest to Acquia master"
git push acquia master;
echo "git fetch acquia --tags"
git fetch acquia --tags
echo "git push origin --tags"
git push origin --tags
echo "Executing Drush commands"

#drush @datacatalog01.dev updb -y
#drush @datacatalog01.dev entup -y
#drush @datacatalog01.dev cr
#drush @datacatalog01.dev fra -y
