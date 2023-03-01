import { Given, When, Then } from 'cucumber';
import { helper } from './classes/helper';

/**
 * Statements:
 * I take current window screenshot and add text :arg3 to filename
 * I take current window screenshot and :arg1(hide|remove) :arg2 and add text :arg3 to filename
 * Variables:
 * arg1 (optional) = hide|remove
 * arg2 (optional) = element(s) selector
 * arg3 = additional text to filename
 */
When(/^I take current window screenshot(?: and (hide|remove) (?:"|')([^("|')]*)(?:"|'))?(?: and add text (?:"|')([^("|')]*)(?:"|') to filename)$/,
  function (arg1, arg2, arg3) {
    // File/Folder structure full/[hide|remove]/url-size.jpg
    var file_name = 'current-window/';
    if (arg1 != null && arg2 != null) {
      file_name += helper.hideOrRemove(arg1, arg2);
    }
    file_name += helper.generateFileNameOnUrl(arg3);
    // Check a screen
    var result = browser.checkScreen(file_name, { /* some options*/ });
    helper.checkTheResult(result);
  });
