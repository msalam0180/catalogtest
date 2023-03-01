#!/bin/sh
echo "Begin CSS compiling"
echo "Adding Acquia as a remote repository"
git remote add acquia datacatalog01@svn-29892.prod.hosting.acquia.com:datacatalog01.git
echo "Checking out $CI_BUILD_REF_NAME"
git clean -fd;
git checkout $CI_BUILD_REF_NAME -f;
git reset --hard
echo "Pulling latest from Gitlab master"
git pull origin $CI_BUILD_REF_NAME -f;
echo "Pulling latest from Acquia master"
git pull acquia $CI_BUILD_REF_NAME;
echo "Compiling the SASS"
cd docroot/themes/custom/dlp
npm install
gulp sass
cd ../../../..
echo "Committing the compiled CSS."
git add -A
git commit -m "Compiling sass files."
echo "Pushing latest to Acquia master"
git push --force acquia $CI_BUILD_REF_NAME;

