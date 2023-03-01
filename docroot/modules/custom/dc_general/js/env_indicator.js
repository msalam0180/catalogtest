(function ($, Drupal) {
  "use strict";

  Drupal.behaviors.EnvIndicator = {
    attach: function (context, settings) {
      $(context).ready(function () {
        // Adding a div wrapper for the environment indicator wrapper
        $('#environment-indicator', context).once('addEnvironmentWrapper').each(function () {
          $('#environment-indicator').wrapInner('<div class="env-indicator-text"></div>');
          $('#environment-indicator div.env-indicator-text', context).css({
            'background-color': settings.environmentIndicator.bgColor,
            'color': settings.environmentIndicator.fgColor
          });
        });

        // Position fixed for mobile view
        if ($('body').hasClass('toolbar-vertical') && !$('body').hasClass('toolbar-fixed')) {
          var env_pos = $('#environment-indicator').offset().top;
          $(window).scroll(function (e) {
            var env_indicator = $('#environment-indicator div.env-indicator-text');
            if ($(this).scrollTop() > env_pos) {
              env_indicator.css({ 'position': 'fixed', 'top': '0px' });
            } else {
              env_indicator.css({ 'position': 'sticky', 'top': 'auto' });
            }
          });
        }

        // If not Prod or Local then set new env_name based on host
        if (settings.environmentIndicator.name == 'Acquia Lower') {
          // Setting new env name based on host
          var new_env_name = $(location).attr('host').split('.')[0];
          $('#environment-indicator div.env-indicator-text')[0].childNodes[0].nodeValue = new_env_name;
        }
      });
    }
  }
}(jQuery, Drupal));
