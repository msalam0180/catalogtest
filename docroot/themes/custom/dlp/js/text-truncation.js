// Drupal.behaviors.basic = {
//   attach: function(context, settings) {
//     (function($) {

//       $( ".views-field-field-dataset-description" ).each(function() {
//         var title = $( this ).parents('tr').find('.views-field-title').text();
//         $(this).shorten();
//         $(this).find( $("a:contains('more')") ).attr('aria-label', 'Read More about ' + title);
//       });

//       $(".views-field-field-dataset-use ul, .views-field-field-dataset-category ul").shorten();

//     })(jQuery);
//   }
// };
