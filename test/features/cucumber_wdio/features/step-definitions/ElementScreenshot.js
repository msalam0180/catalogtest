import { Given, When, Then } from 'cucumber';
import { helper } from './classes/helper';

/**
 * Statements:
 * I take screenshot of element :arg1
 * I take screenshot of element :arg1 on URL :arg2
 * I take screenshot of element :arg1 on URL :arg2 and :arg3(hide|remove) :arg4
 * Variables:
 * arg1 = element
 * arg2 (optional) = URL
 * arg3 (optional) = hide|remove
 * arg4 (optional) = element(s) selector
 */
When(/^I take screenshot of element (?:"|')([^("|')]*)(?:"|')(?: on URL (?:"|')([^("|')]*)(?:"|'))?(?: and (hide|remove) (?:"|')([^("|')]*)(?:"|'))?$/,
  function (arg1, arg2, arg3, arg4) {
    // File/Folder structure full/[hide|remove]/url-size.jpg
    var file_name = 'element/';
    if (arg2 != null) {
      browser.url(arg2);
      if (arg3 != null && arg4 != null) {
        file_name += helper.hideOrRemove(arg3, arg4);
      }
    }
    file_name += helper.generateFileNameOnUrl();
    file_name += '-' + arg1.replace(/[^A-Za-z0-9]+/gi, '').substring(0, 30);
    var result = browser.checkElement($(arg1), file_name, { rawMisMatchPercentage: true, /* some options*/ });
    helper.checkTheResult(result);
  });
