Directory structure:
/
  - Patches are being applied via composer.json
/manual_patch
  - Can't apply these patches via composer.json
  - Developer will need to apply these patches manually
  - Command to apply patch: patch -p1 < [patch_location]
/old - Obsolete patches that are not needed for the site.
