(function ($, Drupal) {
  "use strict";

  Drupal.behaviors.DcGeneral = {
    attach: function (context, settings) {
      $('.chart-js-link').once('ToggleJSLinks').on('click', function() {
        $(this).siblings('.chart-js-links-wrapper').toggleClass('hidden');
      });

      $('.chart-js-link').once('ToggleJSLinksKeyboard').on('keypress', function(e) {
        if(e.which == 13) {
          $(this).siblings('.chart-js-links-wrapper').toggleClass('hidden');
        }
      });
    }
  }
}(jQuery, Drupal));
