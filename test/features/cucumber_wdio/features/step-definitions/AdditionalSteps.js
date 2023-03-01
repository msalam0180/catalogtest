import { Given, When, Then } from 'cucumber';
import { helper } from './classes/helper';

/**
 * Statements:
 * I visit :arg1
 * Variables:
 * arg1 = URL
 */
Given(/^I visit "([^"]*)"$/,
  function (arg1) {
    if (arg1 == 'homepage') {
      arg1 = '/';
    }
    browser.url(arg1);
    // var mainMenu_visible = $('#block-secgov-main-menu').isExisting();
    // If main menu doesn't exist login
    // if (!mainMenu_visible) {
    //   browser.url('/user/login');
    //   $('#edit-name').setValue('enduser');
    //   $('#edit-pass').setValue('PW123!');
    //   // helper.waitTimeOut(1);
    //   $('#edit-actions #edit-submit').click();
    //   browser.url(arg1);
    // }
  });

/**
 * Statements:
 * I wait for :arg1 seconds
 * Variables:
 * arg1 = seconds
 */
Then(/^I wait for "(\d*)" seconds$/,
  function (arg1) {
    // browser.setTimeout({ 'script': 60000 });
    helper.waitTimeOut(arg1);
  });

/**
 * Statements:
 * I set my screensize to :arg1
 * Variables:
 * arg1 = size of the screen
 */
Then(/^I set my screensize to (mobile|tablet|desktop)$/,
  function (arg1) {
    if (arg1 == 'mobile') {
      browser.setWindowSize(300, 750);
    } else if (arg1 == 'tablet') {
      browser.setWindowSize(750, 850);
    } else if (arg1 == 'desktop') {
      browser.setWindowSize(1450, 1050);
    } else {

    }
  });

/**
* Statements:
* I scroll to :arg1
* Variables:
* arg1 = element to scroll to
*/
When(/^I scroll to "([^"]*)"$/,
  function (arg1) {
    const elem = $(arg1);
    // scroll to specific element
    elem.scrollIntoView();
  });

/**
 * Statements:
 * I hover on :arg1
 * Variables:
 * arg1 = element
*/
When(/^I hover on "([^"]*)"?$/,
  function (arg1) {
    helper.waitTimeOut(1);
    $(arg1).moveTo();
  });

/**
* Statements:
* I click on :arg1
* Variables:
* arg1 = element
*/
When(/^I click on "([^"]*)"?$/,
  function (arg1) {
    helper.waitTimeOut(1);
    $(arg1).click();
  });

/**
* Statements:
* I hide :arg1
* Variables:
* arg1 = element to hide
*/
When(/^I hide "([^"]*)"$/,
  function (arg1) {
    helper.hideOrRemove('hide', arg1);
  });

/**
* Statements:
* I remove :arg1
* Variables:
* arg1 = element to remove
*/
When(/^I remove "([^"]*)"$/,
  function (arg1) {
    helper.hideOrRemove('remove', arg1);
  });

/**
* Statements:
* I type :arg1 in :arg2
* Variables:
* arg1 = enter text
* arg1 = selector
*/
When(/^I type "([^"]*)" in "([^"]*)"$/,
  function (arg1, arg2) {
    $(arg2).clearValue();
    $(arg2).addValue(arg1);
  });
