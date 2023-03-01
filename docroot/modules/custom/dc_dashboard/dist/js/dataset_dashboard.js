(function ($, Drupal) {
  "use strict";

  Drupal.behaviors.metadataDasboard = {
    attach: function (context, settings) {

      $(document).once('columnOnFocus').on('click', '.dataset-column.off-focus', function () {
        $(this).addClass('on-focus edited');
        $(this).removeClass('off-focus');
        $(this).parent().addClass('edited');
        let column_value = $(this).html();
        let data_type = $(this).attr('data-type');

        if (data_type == 'string' || data_type == 'integer' || data_type == 'float' || data_type == 'email') {
          let $input = $('<input>').attr({
            type: 'text',
            value: column_value,
            class: 'form-text',
            maxlength: '255',
            style: 'width: 100%;'
          });
          $(this).html($input);
          $input.focus();
        }
        else if (data_type == 'list_string') {
          let field = $(this).attr('data-field');
          let stamp_mark = Date.now();
          let data_select_options = $.parseJSON($(this).attr('data-select-options'));
          let $input = $('<select>').attr({
            class: 'form-select',
            style: 'width: 100%;',
            id: 'list_string_' + field + stamp_mark
          });
          let $column = $(this);
          $.each(data_select_options, function (key, value) {
            $input.append(
              $('<option>').attr({
                value: key,
                selected: key === $($column).attr('data-selected-value')
              }).html(value)
              );
            });
          $(this).html($input);
          $input.focus();

          $input.change(function() {
            console.log($column);
            $column.attr('data-selected-value', $(this).val());
          });
        }
        else if (data_type == 'entity_reference') {
          let nid = $(this).parent().attr('data-nid');
          let field = $(this).attr('data-field');
          let stamp_mark = Date.now();
          let $input = $('<input>').attr({
            type: 'text',
            value: column_value,
            class: 'form-text',
            maxlength: '255',
            style: 'width: 100%;',
            id: 'entity_ref_' + field + stamp_mark
          });
          $(this).html($input);
          $input.focus();

          $input.autocomplete({
            source: function( request, response ) {
              $.ajax({
                url: "/ajax/dataset-dashboard-get-field-data",
                dataType: "json",
                method: "POST",
                data: {
                  nid: nid,
                  field: field,
                  query: request.term
                },
                success: function( data ) {
                  response( data );
                }
              });
            },
            minLength: 1,
            select: function( event, ui ) {
              $input.val(ui.item.value);
            }
          });
        }
      });

      $(document).once('columnOffFocus').on('blur', '.dataset-column', function () {
        $(this).removeClass('on-focus');
        $(this).addClass('off-focus');
        let data_type = $(this).attr('data-type');
        if (data_type == 'string' || data_type == 'integer' || data_type == 'float' || data_type == 'email') {
          let input_value = $(this).find('input').val();
          $(this).html(input_value);
        }
        else if (data_type == 'list_string') {
          let selected_text = $(this).find('select').find(':selected').text();
          $(this).html(selected_text);
        }
        else if (data_type == 'entity_reference') {
          let input_value = $(this).find('input').val();
          $(this).html(input_value);
        }
      });

      $('button.dataset-dashboard-save-button').on('click', function () {
        let result = [];
        $('tr.edited').each(function () {
          let row = {};
          row['nid'] = $(this).attr('data-nid');
          $(this).find('td.edited').each(function () {
            if ($(this).attr('data-type') == 'list_string') {
              row[$(this).attr('data-field')] = $(this).attr('data-selected-value');
            } else {
              row[$(this).attr('data-field')] = $(this).html();
            }
          });
          result.push(row);
        });

        let save_state = $('.dataset-dashboard-save-state').val();
        let request_data = {save_state: save_state, results: result};

        $.post("/ajax/dataset-dashboard-save", JSON.stringify(request_data))
          .done(function (data) {
            location.href = location.href;
          });
      });

      $('.dataset-dashboard-save-state').on('change', function() {
        $('.dataset-dashboard-save-state').val($(this).val());
      });

    }
  }
}(jQuery, Drupal));
