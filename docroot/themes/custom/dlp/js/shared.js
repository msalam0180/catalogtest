// prettier-ignore
(function ($, Drupal) {
  Drupal.behaviors.datatables = {
    attach(context, settings) {
      // Initialize accordion for FAQ Views output
      $('.view-applications-faqs .views-field views-field-title').click(() => {
        $('.views-field-field-faq-answer').collapse({
          toggle: false
        });
      });
    }
  };
})(jQuery, Drupal);
