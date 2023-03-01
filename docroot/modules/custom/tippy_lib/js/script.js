/* eslint-disable */
/**
 * @file
 * Contains js for the tippy.js library.
 */

 (function ($, Drupal, drupalSettings) {

  'use strict';

  Drupal.behaviors.tippy_tooltip = {

    attach: function (context) {
      $(document).ready(function () {
        // Add tippy for the data attr
        tippy('[data-tippy-content]', {
          // for troubleshooting, uncomment the next two lines
          // trigger: 'click',
          // hideOnClick: false,
        });
      });

      $(document).ready(function () {
        // Replace title attribute with tippy
        tippy('[title]:not(iframe)', {
          content: function(reference) {
            const title = reference.getAttribute('title');
            reference.removeAttribute('title');
            return title;
          },
          // for troubleshooting, uncomment the next two lines
          // trigger: 'click',
          // hideOnClick: false,
          delay: 1000,
        })
      });

    }
  };

})(jQuery, Drupal, drupalSettings);
