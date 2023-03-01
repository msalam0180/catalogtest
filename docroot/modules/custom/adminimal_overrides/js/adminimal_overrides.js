/* eslint-disable */
/**
 * @file
 * Contains js alteration to the adminimal theme.
 */

(function ($, Drupal, drupalSettings) {

  'use strict';


  /**
   * Check/Uncheck all checkboxes.
   */
  Drupal.behaviors.selectAll = {
    attach: function (context, settings) {
      $("#edit-field-perm-division-office").prepend($('<input type="checkbox" class="form-checkbox shield-select-all"/><label class="option shield-select-all-label"> Select / Deselect all </label>'));
      $(".shield-select-all").on('click', function () {
        let $isChecked = (!$(this).attr('checked'));
        $(this).parent().find('.form-type-checkbox input[type=checkbox]').attr('checked', $isChecked);
        $(this).attr('checked', $isChecked)
      })
    }
  };


  // Add help text to Media Name field.
  Drupal.behaviors.mediaNameHelp = {
    attach: function (context, settings) {
      if ($('body.path-media form.media-form .field--name-name').length > 0) {
        $(".field--name-name .js-form-item").once().append("<div class='description'>Please name the document with the type of document that it is, for example: \"User Guide: A Guide to Using My Dataset\"</div>");
      }
    }
  };


  // Adds a tabindex to iframe in modal popups created by entity browser so it is tab-able
  Drupal.behaviors.entityBrowserModalIframeAlter = {
    attach: function (context) {
      $(window).on({
        'dialog:aftercreate': function (event, dialog, $element, settings) {
          $('.entity-browser-modal-iframe').attr("tabindex", "0");
        }
      });
    }
  };

  // Adds tab focus handling for ajax inline-entity forms
  Drupal.behaviors.focusInlineEntityForms = {
    attach: function (context) {
      $(".field--widget-inline-entity-form-complex .button.js-form-submit").on("mousedown", function () {
        var fieldwrapper = $(this).closest(".field--widget-inline-entity-form-complex");
        $(document).ajaxComplete(function () {
          waitForEl(".ief-form input:not([type='hidden'])", fieldwrapper, function () {
            var firstInput = fieldwrapper.find(".ief-form input:not([type='hidden'])")[0];
            // If inline-entity form input found then focus on the first element
            if (typeof firstInput !== "undefined") {
              firstInput.focus();
              $(document).off('ajaxComplete');
              return;
            }
          });
        });
      });
    }
  }


  var waitForEl = function (selector, context, callback, maxTimes) {
    if (maxTimes === undefined) {
      maxTimes = 150;
    }
    if ($(selector, context).length) {
      callback();
    } else {
      if (maxTimes === false || maxTimes > 0) {
        maxTimes != false && maxTimes--;
        setTimeout(function () {
          waitForEl(selector, context, callback, maxTimes);
        }, 100);
      }
    }
  };


  // Add tab focus for paragraphs
  Drupal.behaviors.focusParagraphs = {
    attach: function (context) {
      $(".field--type-entity-reference-revisions .field-add-more-submit").on("mousedown", function () {
        var fieldwrapper = $(this).closest(".field--widget-entity-reference-paragraphs");
        $(document).ajaxComplete(function () {
          waitForEl(".ajax-new-content .paragraphs-dropbutton-wrapper input.js-form-submit", fieldwrapper, function () {
            var firstInput = fieldwrapper.find(".ajax-new-content .paragraphs-dropbutton-wrapper input:first")[0];
            //focus on the first element
            if (typeof firstInput !== "undefined") {
              firstInput.focus();
              $(document).off('ajaxComplete');
              return;
            }
          });
        });
      });
    }
  }

  // Add tab focus for entity reference fields
  Drupal.behaviors.focusAutocompleteEntityReferences = {
    attach: function (context) {
      $(".field--widget-entity-reference-autocomplete .field-add-more-submit").on("mousedown", function () {
        var fieldwrapper = $(this).closest(".field--widget-entity-reference-autocomplete");
        $(document).ajaxComplete(function () {
          waitForEl(".ajax-new-content .ui-autocomplete-input", fieldwrapper, function () {
            var firstInput = fieldwrapper.find(".ajax-new-content input:first")[0];
            //focus on the first element
            if (typeof firstInput !== "undefined") {
              firstInput.focus();
              $(document).off('ajaxComplete');
              return;
            }
          });
        });
      });
    }
  }
  // Add tab focus for cshs fields
  Drupal.behaviors.focusCshsEntityReferences = {
    attach: function (context) {
      $(".field--widget-cshs .field-add-more-submit").on("mousedown", function () {
        var fieldwrapper = $(this).closest(".field--widget-cshs");
        $(document).ajaxComplete(function () {

          waitForEl(".ajax-new-content .select-wrapper :input", fieldwrapper, function () {
            var firstInput = fieldwrapper.find(".ajax-new-content .select-wrapper :input:first")[0];
            //focus on the first element
            if (typeof firstInput !== "undefined") {
              firstInput.focus();
              $(document).off('ajaxComplete');
              return;
            }
          });
        });
      });
    }
  }

  // Replace help text on link fields
  Drupal.behaviors.replaceLinkHelpText = {
    attach: function (context) {
      $('.field--type-link .description li').each(function () {
        var text = $(this).text()
          .replace('enter an internal path', 'enter a path internal to the catalog')
          .replace('or an external URL', 'or a URL external to the catalog')
          .replace('Enter <front> to link to the front page. Enter <nolink> to display link text only.', '');
        $(this).text(text);
      });
    }
  }

  // Adds ToolTips next to the label for tall fields so a user can see it quickly OSSS-8845
  Drupal.behaviors.helptext = {
    attach: function (context) {
      // Textarea (WYSIWYG) widgets
      $(
        ".field--widget-text-textarea-with-summary .description, .field--widget-text-textarea .description"
      ).each(function (index) {
        // Find Field Wrppaing element
        var $field = $(this).closest(".form-wrapper")
        //Check if it already has a help text popup
        if (!$field.find(".helper-popup").length) {
          //Add help popup
          var $label = $field.find("label")
          $label.addClass("has-helper-popup")
          $(document.createElement('div'))
            .html(
              "<span class='visually-hidden'>" + $(this).html() + "</span>"
            )
            .attr({
              class: 'helper-popup',
              'data-tippy-content': $(this).text(),
              'tabindex': '0'
            })
            .insertAfter($label)
        }
      })

      // Textarea widgets
      $(".form-type-textarea .description").each(function (index) {
        // Find Field Wrppaing element
        var $field = $(this).closest(".form-item")
        //Check if it already has a help text popup
        if (!$field.find(".helper-popup").length) {
          //Add help popup
          var $label = $field.find("label")
          $label.addClass("has-helper-popup")
          $(document.createElement('div'))
            .html(
              "<span class='visually-hidden'>" + $(this).html() + "</span>"
            )
            .attr({
              class: 'helper-popup',
              'data-tippy-content': $(this).text(),
              'tabindex': '0'
            })
            .insertAfter($label)
        }
      })

      //drag and drop tables for multiple items
      $(".field-multiple-table")
        .next(".description")
        .each(function (index) {
          var $field = $(this).closest(".form-wrapper")
          if (!$field.find(".helper-popup").length) {
            var $label = $field.find(".field-label .label")
            $label.addClass("has-helper-popup")
            $(document.createElement('div'))
              .html(
                "<span class='visually-hidden'>" + $(this).html() + "</span>"
              )
              .attr({
                class: 'helper-popup',
                'data-tippy-content': $(this).text(),
                'tabindex': '0'
              })
              .insertAfter($label)
          }
        })
    },
  };


  Drupal.behaviors.customCKEditorConfig = {
    attach: function (context, settings) {
      if (typeof CKEDITOR !== "undefined") {

        CKEDITOR.on( 'dialogDefinition', function( ev ) {
          var dialogName = ev.data.name;
          var dialogDefinition = ev.data.definition;
      
          if ( dialogName == 'table' || dialogName == 'tableProperties') {
              var info = dialogDefinition.getContents( 'info' );
      
              info.get( 'txtWidth' )[ 'default' ] = '100%';       // Set default width to 100%
              info.remove('txtCellSpace');
              info.remove('txtCellPad');
              info.remove('txtBorder');
              info.remove('txtHeight');
              info.remove('cmbAlign');

              dialogDefinition.removeContents('tableStyles');
    
              dialogDefinition.addContents( {
                  id: 'tableStyles',
                  label: 'Styles',
                  accessKey: 'A',
                  width: "336",
                  elements: [
                    {
                      type: 'checkbox',
                      id: 'styledTable',
                      label: 'Styled Table',
                      setup: function(a) {
                        this.setValue(a.hasClass( "table" ));
                        
                        var dialog = this.getDialog()
                        if(a.hasClass( "table" )){
                          dialog.getContentElement('tableStyles','tableBordered' ).enable();
                          dialog.getContentElement('tableStyles','tableCondensed' ).enable();
                          dialog.getContentElement('tableStyles','helpText' ).enable();
                        } else {
                          dialog.getContentElement('tableStyles','tableBordered' ).setValue(false);
                          dialog.getContentElement('tableStyles','tableBordered' ).disable();
                          dialog.getContentElement('tableStyles','tableCondensed' ).setValue(false);
                          dialog.getContentElement('tableStyles','tableCondensed' ).disable();
                          dialog.getContentElement('tableStyles','helpText' ).disable();
                        }
                      },
                      onClick: function(a) {
                        var dialog = this.getDialog();
                        if(this.getValue()){
                          dialog.getContentElement('tableStyles','tableBordered' ).enable();
                          dialog.getContentElement('tableStyles','tableCondensed' ).enable();
                          dialog.getContentElement('tableStyles','helpText' ).enable();
                        } else {
                          dialog.getContentElement('tableStyles','tableBordered' ).setValue(false);
                          dialog.getContentElement('tableStyles','tableBordered' ).disable();
                          dialog.getContentElement('tableStyles','tableCondensed' ).setValue(false);
                          dialog.getContentElement('tableStyles','tableCondensed' ).disable();
                          dialog.getContentElement('tableStyles','helpText' ).disable();
                        }
                      },
                      commit: function(a, d) {
                        this.getValue() ? d.addClass("table") : d.removeClass("table");
                      }
                    },
                    {
                    type: 'html',
                    id: 'helpText',
                    html: 'Add additional styles'
                    },
                    {
                      type: 'checkbox',
                      id: 'tableCondensed',
                      label: "Condensed",
                      'default': '',
                      setup: function(a) {
                        this.setValue(a.hasClass( "table-condensed" ))
                      },
                      commit: function(a, d) {
                        this.getValue() ? d.addClass("table-condensed") : d.removeClass("table-condensed");
                      }
                    },
                    {
                      type: 'checkbox',
                      id: 'tableBordered',
                      label: "Bordered",
                      'default': '',
                      setup: function(a) {
                        this.setValue(a.hasClass( "table-bordered" ))
                      },
                      commit: function(a, d) {
                        this.getValue() ? d.addClass("table-bordered") : d.removeClass("table-bordered");
                      }
                    },
                    {
                      type: 'html',
                      id: 'helpText2',
                      html: '<p>If there are already attributes and classes in the source, <br>using the checkboxes above will not remove that original formatting. <br>You will need to clean up classes/attributes previously in the source.</p>'
                      },
                  ]
              });
          }
        });
      }
    }
  }

  // Adds synced text to synced fields
  Drupal.behaviors.syncedField = {
    attach: function (context) {
      $(".syncField label").once().append("<span class='syncLabel'>Synced</span>");
      $(".syncField table h4").once().append("<span class='syncLabel'>Synced</span>");
      $(".syncField.field--type-entity-reference-revisions strong[data-drupal-selector^='edit-field-']").once().append("<span class='syncLabel'>Synced</span>");
    },
  };

  //make log message required if moderation state is rejected
  Drupal.behaviors.rejectedLog = {
    attach: function (context) {
      if ($("#edit-moderation-state-0-state").length > 0 ) {
        $('#edit-moderation-state-0-state').change(function () {
          if ($("#edit-moderation-state-0-state").val() == "rejected") {
            $("#edit-revision-log-0-value").attr({
              'required': 'required',
              'aria-required': true
            });
            $(".form-item-revision-log-0-value label").addClass("js-required-form form-required")
          } else {
            $("#edit-revision-log-0-value").removeAttr("required").removeAttr("aria-required");
            $(".form-item-revision-log-0-value label").removeClass("js-required-form form-required");
          }
        });        
      }
    }
  }

  //add aria labels for node revision table radios
  if ($("#edit-node-revisions-table").length > 0) {
    Drupal.behaviors.revisionRadioLabels = {
      attach: function (context) {
        $(".block-help").once().append("<p>When using a keyboard, <span id='radiobuttonInfo'>press the up and down arrow keys to choose a different revision.</span></p>");
        $("input[name='radios_left']").each(function(){ $(this).attr("aria-label","left comparison").attr("aria-describedby","radiobuttonInfo")});
        $("input[name='radios_right']").each(function(){ $(this).attr("aria-label","right comparison").attr("aria-describedby","radiobuttonInfo")});
      }
    }
  }
  
})(jQuery, Drupal, drupalSettings);
