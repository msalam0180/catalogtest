#!/bin/sh
echo "Deleting previous behat-* test files"
cd ~/sec/datacatalog/docroot/sites/default/files
find . -name '\behat-*.*' -type f -delete

cd ~/sec/datacatalog/test
export BEHAT_PARAMS='{"extensions": {"Behat\\MinkExtension": {"base_url": "http://datacatalog.jiratracker.com"},"Drupal\\DrupalExtension": {"drupal": {"drupal_root": "/home/gitlab-runner/sec/datacatalog/docroot"}}}}'
echo "Checking for behat installation"
if [ -e bin/behat ]
then
    echo "Behat found, running tests"
    bin/behat
else
    echo "Behat not found, running composer install"
    composer install
    echo "Running Behat tests"
    bin/behat
fi