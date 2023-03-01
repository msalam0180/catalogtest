# Tippy.js Library

Tippy.js is the complete tooltip, popover, dropdown, and menu solution for the web, powered by Popper.

## Instructions

1. Install this module
2. Add a reference to your theme or module (see Included Libraries below)

## Included Libraries
- Base library only - Add a reference to your theme or module `tippy_lib/base_lib`
- Some Basic Configuration - Add a reference to your theme or module `tippy_lib/base_config`
  - Add attribute `data-tippy-content="This is the tooltip"` to any item that you want to have a tooltip
  - Most elements that have a title attr, will instead use tippy

### Documentation

  - [Tippy.js](https://atomiks.github.io/tippyjs/)
  - [Source Copied From CDN](https://unpkg.com/browse/tippy.js@6.3.1/)

## Update Instructions

1. Navigate to the latest version of the cdn
2. Download the dist/tippy.css and replace the current tippy.css file
3. Download the dist/tippy.umd.min.js file and replace the current js file
4. Update the readme to point to the new URL for the CDN
5. Update the tippy_lib.libraries.yml to reference the new licence
6. Update the tippy_lib.libraries.yml to reference the new version

## Adding additional functionality

1. Navigate to the latest version of the cdn
2. Download the additional files needed and put them in the css and/or js directories
3. Create new libraries in the tippy_lib.libraries.yml files.
4. Update the readme "Included Libraries"
