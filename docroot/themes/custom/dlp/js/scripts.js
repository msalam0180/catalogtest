(function ($, Drupal) {

	Drupal.behaviors.responsiveBoxes = {
		attach: function (context, settings) {
			equalheight = function (container) {
				var currentTallest = 0,
					currentRowStart = 0,
					rowDivs = new Array(),
					$el,
					topPosition = 0;
				$(container).each(function () {
					$el = $(this);
					$($el).height('auto')
					topPostion = $el.position().top;
					if (currentRowStart != topPostion) {
						for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
							rowDivs[currentDiv].height(currentTallest);
						}
						rowDivs.length = 0; // empty the array
						currentRowStart = topPostion;
						currentTallest = $el.height();
						rowDivs.push($el);
					} else {
						rowDivs.push($el);
						currentTallest = (currentTallest < $el.height()) ? ($el.height()) : (currentTallest);
					}
					for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
						rowDivs[currentDiv].height(currentTallest);
					}
				});
			}

			$(window).on('load', function () {
				equalheight('.datasets-callout-row .well');
				equalheight('.well-group .well');
			});

			$(window).resize(function () {
				equalheight('.datasets-callout-row .well');
				equalheight('.well-group .well');
			});
		}
	}

	Drupal.behaviors.chunk = {
		attach: function (context, settings) {
			$.fn.chunk = function (size) {
				var arr = [];
				for (var i = 0; i < this.length; i += size) {
					arr.push(this.slice(i, i + size));
				}
				return this.pushStack(arr, "chunk", size);
			}
		}
	}

	Drupal.behaviors.unpublished_references = {
		attach: function (context, settings) {
			$('.node-published-false, .item-published-false').once().each(function () {
				$(this).addClass('has-unpublished-tag').append('<span class="unpublished-tag">Unpublished</span>');
			});
		}
	}


	Drupal.behaviors.overlabel = {
		attach: function (context, settings) {
			function overlabel(wrapper, field) {
				// hide a label when it is focued on or when it has a value
				// Instructions - style and place the label first, add @extend .sr-only; to the label
				var $field = $(wrapper).find('[id^="' + field + '"]');
				var $label = $(wrapper).find('[for^="' + field + '"]');
				if ($field.val() == '') {
					$label.addClass('make-sr-only-visible');
				}

				$field.on('focus', function () {
					$label.removeClass('make-sr-only-visible');
				}).on('blur', function () {
					if ($field.val() == '') {
						$label.addClass('make-sr-only-visible');
					}
				});
			}
			//global search in the header
			overlabel('.block-views-exposed-filter-blocksearch-results-page-2', 'edit-term');
			overlabel('.block-views-exposed-filter-blocksearch-results-page-3', 'edit-term');
		}
	}

	Drupal.behaviors.emptySidebar = {
		attach: function (context, settings) {
			$('.media-md-wrapper').each(function () {
				if ($.trim($(this).text()).length == 0) {
					if ($(this).children().length == 0) {
						$(this).text('');
						$(this).remove(); // remove empty paragraphs
					}
				}
			});

			$('.article-side').each(function () {
				if ($.trim($(this).text()).length == 0) {
					if ($(this).children().length == 0) {
						$(this).text('');
						$(this).remove(); // remove empty paragraphs
					}
				}
			});
		}
	}

	Drupal.behaviors.fixDatasetFacets = {
		attach: function (context, settings) {
			$(document).ajaxSuccess(function(event, xhr, settings) {
				$(".block-facet-blockfilter-by-data-category").addClass("form-item").appendTo("form#views-exposed-form-dataset-search-block-1");
			});
		}
	}

	Drupal.behaviors.fixGlossary = {
		attach: function (context, settings) {

			unique = function (selector) {
				var uniques = {};
				$(selector).each(function () {
					var thisItem = $(this).text();
					if (!(thisItem in uniques)) {
						uniques[thisItem] = "";
					}
					else {
						$(this).remove();
					}
					if (thisItem === "09") {
						var link = $(this).find("a");
						if (typeof link !== "undefined") {
							link.text("0-9");
						}
					}
					if (thisItem === "All") {
						var link = $(this).find("a");
						if (typeof link !== "undefined") {
							var href = link.attr("href");
							if (typeof href !== "undefined") {
								link.attr("href", href.split("?")[0]);
							}
						}
					}
				});
			}
			unique("#block-glossary-top li.facet-item.glossaryaz");
			unique("#block-glossary-bottom li.facet-item.glossaryaz");
		}
	}

	Drupal.behaviors.search_api_autocomplete = {
		attach: function (context, settings) {
			$(context).ready(function () {
				// Find autocomplete search box
				$(".ui-autocomplete-input[data-search-api-autocomplete-search]").autocomplete({
					select: function (event, ui) {
						// If button "tab" is pressed move to next focus item (e.g. Search button)
						if (event.keyCode != 9) {
							// If item url found then redirect users to URL of the type-ahead item (contrib functionality)
							if (ui.item.url) {
								location.href = ui.item.url;
								return false;
							}
						}
					}
				});
			});
		}
	}

	Drupal.behaviors.componentCategoryAggregation = {
		attach: function(context, settings) {
			$(context).ready(function() {

				// On each parent term
				$(".block-component-categories [data-parent]").once().each(function(){

					var parentTax = $( this ).data('group-tax');
					$items = $("[data-child][data-group-tax='" + parentTax + "']");

					var parentTotal = 0;
					// Find all items that are parents that match the parent term
					$.each($items, function(n, e)
					{
						var childNodeCount = $( this ).data('child-nodes');
						parentTotal = parentTotal + childNodeCount;
						$( this ).parent().remove();
					});

					// put that value into class total-component-nodes
					$(this).find('.total-component-nodes').text(parentTotal + " Items");

				});
			});
		}
	}

	Drupal.behaviors.componentCategoryHideSubCat = {
		attach: function(context, settings) {
			$(context).ready(function() {
				var pageTitle = $(".path-taxonomy h1").text().trim();
				var headingGroup = $(".view-group-heading").first().text().trim();

				if (pageTitle == headingGroup){
					$(".view-group-heading").hide();
					$(".view-group .summary").hide();
				}

			});
		}
	}

	Drupal.behaviors.facetResetLabel = {
		attach: function(context, settings) {
			$(context).ready(function() {
				var $facetResetWrapper = $(".facets-reset");
				var facetResetID = "facets-reset-id";
				$facetResetWrapper.find('.facets-checkbox').attr('id', facetResetID);
				$facetResetWrapper.find('label').attr('for', facetResetID);
			});
		}
	}


	Drupal.behaviors.moveOnMobile = {
		attach: function (context, settings) {

			moveElement = function (container, locationInDOM, appendOrPre) {
				if (appendOrPre === "pre"){
					$(locationInDOM).prepend($(container));
				}else{
					$(locationInDOM).append($(container));
				}
			}

			moveElementOnMobile = function (container, mobileLocation, modileAppendOrPre, screenLocation, screenAppendOrPre) {
				var x = window.matchMedia("(max-width: 1199px)")

				if (x.matches) {
					//mobile
					//if in screenLocation, then Move
					if( $( screenLocation + " " + container ).length ){
						moveElement(container, mobileLocation, modileAppendOrPre);
					}

				} else {
					//screen
					//if in mobileLocation, then Move
					if( $( mobileLocation  + " " + container ).length ){
						moveElement(container, screenLocation, screenAppendOrPre);
					}
				}
			}

			$(window).on('load', function () {
				moveElementOnMobile('.node-logo', '.mainSection', 'pre', '.sideSection', 'pre');
			});

			$(window).resize(function () {
				moveElementOnMobile('.node-logo', '.mainSection', 'pre', '.sideSection', 'pre');
			});
		}
	}

	Drupal.behaviors.contactAjaxButtonOverride = {
		attach: function(context, settings) {
			if (context.id == "contact_ajax_contact_message_feedback_form"){
				$(document).ajaxSuccess(function(event, xhr, settings) {
					if (event.target.id = "contact_ajax_contact_message_feedback_form") {
						if (xhr && xhr.responseJSON) {
							//unfortunately hacky because even errors return ajaxSuccess
							if (xhr.responseText.indexOf("Error message") < 0) {
								$("#drupal-modal--dialog .feedbackmodal .modal-footer .form-submit").hide();
							}	
						}									
					}
				});
		 	}
		}
	}

	Drupal.behaviors.fluidDialog = {
		attach: function(context, settings) {
			/*!
			* Custom script to make jquery-ui dialog responsive.
			* used the following as a starting point
			* http://stackoverflow.com/a/16471891/413538
			*/

			function fluidDialog() {
				var $visible = $(".ui-dialog:visible");
				// Each open dialog
				$visible.each(function () {
					var $this = $(this);
					var dialog = $this.find(".ui-dialog-content").data("ui-dialog");
					var wWidth = $(window).width();
					if (dialog.options.width == null || dialog.options.width == 'auto'){
						dialog.options.width = "600";
					}
					console.log(dialog.options.width);

					// Check window width against dialog width.
					if (wWidth < (parseInt(dialog.options.width, 10) + 50)) {
						// Keep dialog from filling entire screen
						$this.css("max-width", "90%");
						$this.css("width", "auto");
					} else {
						// Fix width bug.
						$this.css("max-width", dialog.options.width + "px");
					}
					// Reposition dialog.
					dialog.option("position", dialog.options.position);
				});
			}

			// Resize dialog on window resize.
				$(window).resize(function () {
					fluidDialog();
				});

			// Resize dialog if opened in a viewport smaller than dialog width.
				$(document).on("dialogopen", ".ui-dialog", function () {
					console.log('open');
					fluidDialog();
				});

		}
	}

	  //make log message required if moderation state is rejected
		Drupal.behaviors.rejectedLog = {
			attach: function (context) {
				if ($("#edit-new-state").length > 0 ) {
					$('#edit-new-state').once().change(function () {
						if ($("#edit-new-state").val() == "rejected") {
							$("#edit-revision-log").attr({
								'required': 'required',
								'aria-required': true
							});
							$(".form-item-revision-log label").once().addClass("js-required-form form-required");
							$(".main").prepend("<span id='revision-required' class='required-help'>*Fields marked with an asterisk(*) are required.</span>");
						} else {
							$("#edit-revision-log").removeAttr("required").removeAttr("aria-required");
							$(".form-item-revision-log label").removeClass("js-required-form form-required");
							$("#revision-required").remove();
						}
					});        
				}
			}
		}


})(jQuery, Drupal);
