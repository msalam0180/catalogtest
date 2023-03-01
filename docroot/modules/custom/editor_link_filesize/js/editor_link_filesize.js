
(function (Drupal, $) {

  'use strict';

  Drupal.behaviors.editor_link_filesize = {
    attach: function (context, settings) {

      $("a[data-entity-type]='media'").once('[data-filesize]').each(function(){
        var $filesize = $(this).attr("data-filesize");
        $(this).append( '<span class="file-size">(' + $filesize + ')</span>');
      });
      
    }
  };

}(Drupal, jQuery));
