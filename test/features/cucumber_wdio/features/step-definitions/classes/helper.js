// Add any class import
class Helper {

  /**
   * Function hide or remove selector(s) from the current page.
   * @param {string} arg2 get (hide|remove)
   * @param {string} arg3 get selector(s)
   *
   * @returns {string} Returns file_name to help with file/folder structure.
   */
  hideOrRemove(arg2, arg3) {
    var arg3_split = arg3.split(',');
    helper.waitTimeOut(2);
    arg3_split.forEach(function (selector) {
      browser.execute((arg_1, arg_2) => {
        var cssStyle = (arg_2 == 'hide') ? 'visibility:hidden' : 'display:none';
        document.querySelector(arg_1.trim()).setAttribute('style', cssStyle);
      }, selector, arg2);
    });
    // helper.waitTimeOut(1);
    return arg2 + '/';
  }

  /**
   * Triggers wait time on browser before continuing with tests
   * @param {integer} arg1 Enter how many seconds to wait
   */
  waitTimeOut(arg1) {
    arg1 = arg1 * 1000;
    browser.executeAsync((arg1, done) => {
      setTimeout(done, arg1);
    }, arg1);
  }

  /**
   * Generates file_name based on url and text.
   * @param {string} arg2 additional file name text
   *
   * @returns {string} Returns file_name to help with file/folder structure.
   */
  generateFileNameOnUrl(arg2) {
    var arg1 = browser.getUrl();
    var file_name = '';
    // Gets an relative URL path
    arg1 = arg1.replace(/^.*\/\/[^\/]+/, '');
    // If home page add meaningful filename
    arg1 = (arg1 == '/') ? '/homepage' : arg1;
    // Replace special characters with _ and substring the filename
    file_name += arg1.replace(/[^A-Za-z0-9]+/gi, '_').substring(1, 201);
    file_name += (arg2 != null) ? '-' + arg2 : '';
    return file_name;
  }

  checkTheResult(arg1) {
    var diffDir = arg1.folders['diff'];
    // Adding Screenshot Diff screenshot
    if (diffDir != null) {
      if (typeof TimelineReporter !== 'undefined') {
        TimelineReporter.addContext({
          title: 'Dynamic link',
          value: '<a href="' + diffDir + '">Link to an image</a>',
          // value: '<img src="'+diffDir+'"/>',
          // value: '<img src="'+diffDir+'"> </img>',
        });
      }
    }
    expect(arg1.misMatchPercentage).toEqual(0);
  }
}

export const helper = new Helper();

/**
  To run javascript/jQuery do following:
  browser.execute(() => {
    // Vanilla JS
    document.querySelector(arg_1.trim()).setAttribute("style", cssStyle);
    // jQuery
    jQuery("").css("visibility","hidden");
    });
  });
 */
