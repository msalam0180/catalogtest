(function ($, Drupal) {

  Drupal.behaviors.datatables = {
    attach: function (context, settings) {

      //$('.path-dataset-grid .view-dataset-grid-homepage table').DataTable();

      // Custom search/filter for Content Types

      // Check to see if container Div is empty, if it's not execute code
      if ($('.dataset-grid-table').length > 0){
    		/* Filter list by keywords */
    		var $rows = $('.dataset-grid-table table tbody tr');
    		$('#dataTable-search').keyup(function() {
    			var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

    			//do not filter columns with noFilter class
    			$rows.show().filter(function() {
    				var text = $(this).children('td').not('.noFilter').text().replace(/\s+/g, ' ').toLowerCase();
    				return !~text.indexOf(val);
    			}).hide();
    		});
    }

    // Provide sorting capabilities via jquery.tablesorter plugin
    $(".view-dataset-grid-homepage table").tablesorter();


    // Check to see if container Div is empty, if it's not execute code
    if ($('.view-publication-grid-homepage').length > 0){
      /* Filter list by keywords */
      var $rows = $('.view-publication-grid-homepage table tbody tr');
      $('#dataTable-search').keyup(function() {
        var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

        //do not filter columns with noFilter class
        $rows.show().filter(function() {
          var text = $(this).children('td').not('.noFilter').text().replace(/\s+/g, ' ').toLowerCase();
          return !~text.indexOf(val);
        }).hide();
      });
  }

  // Provide sorting capabilities via jquery.tablesorter plugin
  $(".view-publication-grid-homepage table").tablesorter();

  }

}

})(jQuery, Drupal);
