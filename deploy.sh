!/bin/sh
echo "Deploying code from dev to stage (test) environment"

drush @datacatalog01.dev ac-code-deploy test
sleep 60
drush @datacatalog01.test fra -y
drush @datacatalog01.test entup -y