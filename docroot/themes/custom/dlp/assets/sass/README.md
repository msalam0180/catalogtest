
# Compile SASS on windows
###########################################################################
Note: DO NOT edit any files in the CSS directory. Those files are compiled.
###########################################################################

## Dependencies
### Install Node
Node can be installed using the installer found here ->  https://nodejs.org/en

### Install Gulp CLI
1. In the node command prompt: Install Gulp CLI on your machine globally *
	`npm install --global gulp-cli`
2. Check Gulp CLI version. It should be at least 2.2.0 or higher. But not anything above full version 2.
	`gulp -v`

*If upgrading from old version of Gulp, uninstall the old version first `npm uninstall gulp -g`

### Install Additional Dependencies
1. In the node command prompt: Navigate to the theme directory*:
	`cd  [PATH]\docroot\themes\custom\[theme]`
2. Download dependencies:
	`npm install`
	
*If upgrading from old version of Gulp, in the theme directory, delete your node modules directory first

## Compile SASS

### Compile Once

1. In the node command prompt: Navigate to the theme directory:
	`cd  [PATH]\docroot\themes\custom\[theme]`
2. Compile using the following command:
	`gulp sass`

### Watch Files for Changes

1. In the node command prompt: Navigate to the theme directory:
	`cd  [PATH]\docroot\themes\custom\[theme]`
2. Compile using the following command
	`gulp watch`

To stop watching, either close the termal that is watching the files or `ctrl + c`
