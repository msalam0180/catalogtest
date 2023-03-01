#!/bin/sh
echo "git remote set-url origin git@jira.jiratracker.com:sec/datacatalog.git"
git remote set-url origin git@jira.jiratracker.com:sec/datacatalog.git
echo "Adding Acquia as a remote repository"
git remote add acquia datacatalog01@svn-29892.prod.hosting.acquia.com:datacatalog01.git
echo "git checkout $CI_BUILD_REF_NAME;"
git checkout $CI_BUILD_REF_NAME;
echo "git pull origin $CI_BUILD_REF_NAME;"
git pull origin $CI_BUILD_REF_NAME;
echo "git pull acquia $CI_BUILD_REF_NAME;"
git pull acquia $CI_BUILD_REF_NAME;
echo "git push -u acquia $CI_BUILD_REF_NAME;"
git push -u acquia $CI_BUILD_REF_NAME;
git push acquia $CI_BUILD_REF_NAME;
echo "git fetch acquia --tags"
git fetch acquia --tags
echo "git push origin --tags"
git push origin --tags

echo "****************************"
