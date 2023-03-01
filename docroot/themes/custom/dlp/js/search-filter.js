+function ($) {
'use strict';

  $(document).ready(function() {

    $('.path-search .search-page-form ol li').each(function(){
        if($(this).is(":contains('Datadictionary DatasetName')")){
            $(this).hide();
        }
    });

  });

}(jQuery);
