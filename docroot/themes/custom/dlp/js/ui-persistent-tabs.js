(function ($, Drupal) {
  Drupal.behaviors.datatables = {
    attach: function (context, settings) {

          // show active tab on reload
          if (location.hash !== '') $('.nav-pills li a[href="' + location.hash + '"]').tab('show');

          // remember the hash in the URL without jumping
          $('.nav-pills li a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
             if(history.pushState) {
                  history.pushState(null, null, '#'+$(e.target).attr('href').substr(1));
             } else {
                  location.hash = '#'+$(e.target).attr('href').substr(1);
             }
          });

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

        // Check to see if container Div is empty, if it's not execute code
        if ($('.publication-grid-table').length > 0){
          /* Filter list by keywords */
          var $rows = $('.publication-grid-table table tbody tr');
          $('#dataTable-search').keyup(function() {
            var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

            //do not filter columns with noFilter class
            $rows.show().filter(function() {
              var text = $(this).children('td').not('.noFilter').text().replace(/\s+/g, ' ').toLowerCase();
              return !~text.indexOf(val);
            }).hide();
          });
      }        

        }
      }
    })(jQuery, Drupal);
