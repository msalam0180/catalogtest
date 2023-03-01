#!/bin/sh
echo "Running PHPUnit Tests"
chmod a+x vendor/bin/phpunit 
chmod a+x vendor/phpunit/phpunit/phpunit
vendor/bin/phpunit 

echo "Running PHP CodeSniffer on docroot/modules/custom/"
phpcs --standard=phpcs_ruleset.xml -s --warning-severity=0 docroot/modules/custom  

cd docroot/

echo "Running eslint on all custom module files."
eslint modules/custom/**/*.js

echo "Running eslint on all JS theme files."
eslint themes/custom/dlp/js/shared.js

