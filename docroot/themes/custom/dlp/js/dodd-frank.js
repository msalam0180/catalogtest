(function ($) {

// hide to avoid flash of unformatted section, will show once section is built
$(".reports-list").hide();

// sort order for sections in modal windows
var modal_sort_order = {
    'remaining': 4,
    'adopted': 1,
    'adopted_in_part': 2,
    'proposed': 3,
};


/* FUNCTIONS TO GET DATA FROM JSON OBJECTS ------------------------------- */

// returns an array of objects according to key and/or value
// works if either key or value is ''
function getObjects(obj, key, val) {
    var objects = [];
    for (var i in obj) {
      if (!obj.hasOwnProperty(i)) continue;
      if (typeof obj[i] == 'object') {
        objects = objects.concat(getObjects(obj[i], key, val));
      } else
      //if key matches and value matches or if key matches and value is not passed (eliminating the case where key matches but passed value does not)
      if (i == key && obj[i] == val || i == key && val == '') { //
        objects.push(obj);
      } else if (obj[i] == val && key == '') {
        //only add if the object is not already in the array
        if (objects.lastIndexOf(obj) == -1) {
          objects.push(obj);
        }
      }
    }
    return objects;
  }
  // use when a value is an array, looks to see if the value is in the array 
  // returns an array of objects

function getObjectsContains(obj, key, val) {
    var objects = [];
    for (var i in obj) {
      if (obj[i][key].indexOf(val) !== -1) {
        objects.push(obj[i]);
      } else {}
    }
    return objects;
  }
  //returns an array of values that match on a certain key

function getValues(obj, key) {
    var objects = [];
    for (var i in obj) {
      if (!obj.hasOwnProperty(i)) continue;
      if (typeof obj[i] == 'object') {
        objects = objects.concat(getValues(obj[i], key));
      } else if (i == key) {
        objects.push(obj[i]);
      }
    }
    return objects;
  }
  //returns an array of keys that match on a certain value

function getKeys(obj, val) {
    var objects = [];
    for (var i in obj) {
      if (!obj.hasOwnProperty(i)) continue;
      if (typeof obj[i] == 'object') {
        objects = objects.concat(getKeys(obj[i], val));
      } else if (obj[i] == val) {
        objects.push(i);
      }
    }
    return objects;
  }


/* LOAD AND USE DATA FROM .JSON FILES ------------------------------- */

// variables to hold json
var sectionData, accomplishData;

$(document).ready(function() {

// get the data 
$.when($.getJSON("../spotlight/dodd-frank/data/df-sections-key-11-10-2016.json", function(data) {
    sectionData = data;
}), $.getJSON("../spotlight/dodd-frank/data/df-accomplishments-key.json",
    function(data) {
        accomplishData = data;
    })).then(function() {
    
        // check if both json files loaded
        if (sectionData && accomplishData) {
           
        // print json objects to console
        // console.log(sectionData);
        // console.log(accomplishData);
            
        //get array of values for 'category'     
        var categories = _.uniq(_.pluck(sectionData, "category"))
        // console.log(categories);
            
        // Iterate through each category
        $.each(categories, function(index, category) {
            
          // create the matching div id
          var divId = category.toLowerCase().replace(/\ /g, '_').replace(/\-/g, '_');
          
          // create the matching modal id
          var modalId = divId + '_modal'
          
          // console.log('Data in the "' + category + '" category will go into #' + divId + ' and #' + modalId)
          
          // category title into modal header
          $('#' + modalId).find('.modal-header').prepend('<h4>' + category + '</h4>');
            
          // get the matching sections (Objects) for this category
          var matching_sections = getObjects(sectionData, 'category', category);
            
          // iterate through the list of sections (Objects)
          $.each(matching_sections, function(index, section) {
              
            // get the unique id for each section
            var li_id = section.section_id;
             
            // create modal footnote html if modal_footnote == "show"
            var modal_class = ''  
            var modal_html = ''
            if (section.modal_footnote == "show") {
                // console.log(section.section + ' will show footnote in modal');
                modal_class = ' modal-footnote'
                modal_html = '<span class="footnote">' + section.footnote + '</span>'
            } else {
            };
            
            // format status string to use as <li> class 
            var section_class = section.status.toLowerCase().replace(/\ /g, '_')
            
            // console.log(divId + ': ' + section.section + ' ' + section.description);
              
            // create a sort order by status then section number
            var sort_id = modal_sort_order[section_class]*1000000 + section.section_key
            
            // create <li> for the matching section with status as class
            // possible future update ... check if accomplishments exist, if so, add button regardless of status
            if (section.status == 'Remaining') {
                // 'Remaining' sections do not get a check mark or button
                $('#' + modalId).find('ul.section-list').append(
                      '<li id="' + li_id + '" class="' + section_class +
                      modal_class + '"><span class="status"><span class="status-sort">' +
                      sort_id + '</span>' +
                      section.status +
                      '</span><span class="section-num">Section ' +
                      section.section +
                      '</span><span class="section-description">' +
                      section.description + '</span>' +
                      modal_html + '</li>');
            } else {
                $('#' + modalId).find('ul.section-list').append(
                      '<li id="' + li_id + '" class="' +
                      section_class + modal_class + 
                      '"><span class="status"><span class="fa fa-check-circle fa-lg"></span><span class="status-sort">' +
                      sort_id + '</span>' +
                      section.status +
                      '</span><span class="section-num">Section ' +
                      section.section +
                      '</span><span class="section-description">' +
                      section.description +
                      '</span></a><a href="dodd-frank-section.shtml#' +
                      section.section_num.toString() +
                      '"><button class="btn-details">VIEW DETAILS</button></a>' +
                      modal_html + '</li>');
            };
              
          });  // end iterating through sections that match this category
          
          // sort the <li> in each modal by status, then by section number
          var lis = $('#' + modalId).find('ul.section-list').find('li');
          lis = lis.sort(function(a, b) {
              var num1 = parseInt($(a).find(".status-sort").text(), 10),
              num2 = parseInt($(b).find(".status-sort").text(), 10);
              if (num1 > num2) return 1;
              if (num1 < num2) return -1;
              return 0;
          });
        
          // update the modal with sorted list
          $('#' + modalId).find('ul.section-list').html(lis);
            
        });  // end iterating through this category
        

        // get reports (accomplishment Objects that have type == reports)
        var reports_accomplishments = getObjects(accomplishData, 'type', 'report');
            
        // create <li> for each
        $.each(reports_accomplishments, function(index, accomplishment) {
            // build links_html if links exist
            if (accomplishment.links_dict !== null) {
                var links_list = accomplishment.links_dict.split(',');
                var links_html = ''
                $.each(links_list, function(index, link) {
                    var link_split = link.split(':');
                    var link_type = link_split[2];
                    var link_href = 'http:' + link_split[1];
                    var key_split = link_href.split('.');
                    var file_type = key_split[key_split.length - 1];
                    var directories = link_href.split('/');
                    if (directories[4] == 'sro') {
                        var sro = directories[5].toUpperCase();
                        link_type = link_type + ' - ' + sro;
                    } else {}
                    if (file_type == 'pdf') {
                        link_type = link_type + ' (PDF)'
                    } else {}
                    links_html = links_html + '<a href="' + link_href +
                        //'">View the ' + link_type + '</a><br>'
                        '">' + link_type + '</a><br>'
                });
            } else {};
            var theDate = new Date(accomplishment.date_unix_millis + 21600000);
            var ap_style_dates = ['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May.',
                'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.'
            ];
            var dateString = ap_style_dates[theDate.getMonth()] + ' ' + theDate
                .getDate() + ', ' + (parseInt(theDate.getYear()) + 1900);
            
            if (accomplishment.display == 'hide') {
            // do nothing if set to hide
            } else {
            // added formatted reports data to list
            $('ul.reports-list').append('<li>' + accomplishment.text +
                '[&sect;' + accomplishment.section + ']<span class="link">' +
                links_html + '</span><span class="date_unix">' +
                accomplishment.date_unix_millis +
                '</span><span class="date-string">' + dateString +
                '</span></li>');
            };
            
        });  // end iterating through matching reports
        
        // sort the reports (reverse chrono)
        var lis = $('ul.reports-list').find('li');
        lis = lis.sort(function(a, b) {
            var num1 = parseInt($(a).find(".date_unix").text(), 10),
                num2 = parseInt($(b).find(".date_unix").text(), 10);
            // console.log(num1, num2);
            if (num1 > num2) return -1;
            if (num1 < num2) return 1;
            return 0;
        });
        
        // return the sorted list of reports
        $(".reports-list").html(lis);
        
        // hide the unused unix datestamp field
        $(".date_unix").hide();
            
        // show reports
        $(".reports-list").show();
            
        // DISPLAY MODAL ON CLICK 
        $('#rules-progress a, #rules-progress div').click(function(e) {
            if (e.target.localName != "sup") {
              var modal_id = $(this).attr('id') + '_modal';
              $('#' + modal_id).modal();
            }
            else { // Go to footnotes
              window.location.hash = $(e.target).data("target");
              return false;
            }
        });
            
        /* end if (sectionData && accomplishData) ------------------------- */

        /*
        // charData is an associative array used to store the various counts for each chart type.
        // The array is indexed by the HTML element id corresponding to the chart type. Each array
        // element points to another associative array containing counts for Adopted, Adopted in
        // Part, Proposed, and Remaining. The values for these counts are derived by calling _.where
        // to filter the sectionData collection based on the category and status attributes.
        */
      
        chartData = {};
        chartData["pfChart"] = {};
        chartData["ecChart"] = {};
        chartData["vrChart"] = {};
        chartData["absChart"] = {};
        chartData["sbsChart"] = {};
        chartData["craChart"] = {};
        chartData["caChart"] = {};
        chartData["sdChart"] = {};
        chartData["msaChart"] = {};
        chartData["oChart"] = {};
        
        chartData["pfChart"]["Adopted"] = _.where(sectionData, {
          category: "Private Funds",
          status: "Adopted"
        }).length;
        chartData["pfChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Private Funds",
          status: "Adopted in Part"
        }).length;
        chartData["pfChart"]["Proposed"] = _.where(sectionData, {
          category: "Private Funds",
          status: "Proposed"
        }).length;
        chartData["pfChart"]["Remaining"] = _.where(sectionData, {
          category: "Private Funds",
          status: "Remaining"
        }).length;
        
        chartData["vrChart"]["Adopted"] = _.where(sectionData, {
          category: "Volcker Rule",
          status: "Adopted"
        }).length;
        chartData["vrChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Volcker Rule",
          status: "Adopted in Part"
        }).length;
        chartData["vrChart"]["Proposed"] = _.where(sectionData, {
          category: "Volcker Rule",
          status: "Proposed"
        }).length;
        chartData["vrChart"]["Remaining"] = _.where(sectionData, {
          category: "Volcker Rule",
          status: "Remaining"
        }).length;
        
        chartData["sbsChart"]["Adopted"] = _.where(sectionData, {
          category: "Security-Based Swaps",
          status: "Adopted"
        }).length;
        chartData["sbsChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Security-Based Swaps",
          status: "Adopted in Part"
        }).length;
        chartData["sbsChart"]["Proposed"] = _.where(sectionData, {
          category: "Security-Based Swaps",
          status: "Proposed"
        }).length;
        chartData["sbsChart"]["Remaining"] = _.where(sectionData, {
          category: "Security-Based Swaps",
          status: "Remaining"
        }).length;
        
        chartData["caChart"]["Adopted"] = _.where(sectionData, {
          category: "Clearing Agencies",
          status: "Adopted"
        }).length;
        chartData["caChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Clearing Agencies",
          status: "Adopted in Part"
        }).length;
        chartData["caChart"]["Proposed"] = _.where(sectionData, {
          category: "Clearing Agencies",
          status: "Proposed"
        }).length;
        chartData["caChart"]["Remaining"] = _.where(sectionData, {
          category: "Clearing Agencies",
          status: "Remaining"
        }).length;
        
        chartData["msaChart"]["Adopted"] = _.where(sectionData, {
          category: "Municipal Securities Advisors",
          status: "Adopted"
        }).length;
        chartData["msaChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Municipal Securities Advisors",
          status: "Adopted in Part"
        }).length;
        chartData["msaChart"]["Proposed"] = _.where(sectionData, {
          category: "Municipal Securities Advisors",
          status: "Proposed"
        }).length;
        chartData["msaChart"]["Remaining"] = _.where(sectionData, {
          category: "Municipal Securities Advisors",
          status: "Remaining"
        }).length;
        
        chartData["ecChart"]["Adopted"] = _.where(sectionData, {
          category: "Executive Compensation",
          status: "Adopted"
        }).length;
        chartData["ecChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Executive Compensation",
          status: "Adopted in Part"
        }).length;
        chartData["ecChart"]["Proposed"] = _.where(sectionData, {
          category: "Executive Compensation",
          status: "Proposed"
        }).length;
        chartData["ecChart"]["Remaining"] = _.where(sectionData, {
          category: "Executive Compensation",
          status: "Remaining"
        }).length;
        
        chartData["absChart"]["Adopted"] = _.where(sectionData, {
          category: "Asset-backed Securities",
          status: "Adopted"
        }).length;
        chartData["absChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Asset-backed Securities",
          status: "Adopted in Part"
        }).length;
        chartData["absChart"]["Proposed"] = _.where(sectionData, {
          category: "Asset-backed Securities",
          status: "Proposed"
        }).length;
        chartData["absChart"]["Remaining"] = _.where(sectionData, {
          category: "Asset-backed Securities",
          status: "Remaining"
        }).length;
        
        chartData["craChart"]["Adopted"] = _.where(sectionData, {
          category: "Credit Rating Agencies",
          status: "Adopted"
        }).length;
        chartData["craChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Credit Rating Agencies",
          status: "Adopted in Part"
        }).length;
        chartData["craChart"]["Proposed"] = _.where(sectionData, {
          category: "Credit Rating Agencies",
          status: "Proposed"
        }).length;
        chartData["craChart"]["Remaining"] = _.where(sectionData, {
          category: "Credit Rating Agencies",
          status: "Remaining"
        }).length;
        
        chartData["sdChart"]["Adopted"] = _.where(sectionData, {
          category: "Specialized Disclosures",
          status: "Adopted"
        }).length;
        chartData["sdChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Specialized Disclosures",
          status: "Adopted in Part"
        }).length;
        chartData["sdChart"]["Proposed"] = _.where(sectionData, {
          category: "Specialized Disclosures",
          status: "Proposed"
        }).length;
        chartData["sdChart"]["Remaining"] = _.where(sectionData, {
          category: "Specialized Disclosures",
          status: "Remaining"
        }).length;
        
        chartData["oChart"]["Adopted"] = _.where(sectionData, {
          category: "Other",
          status: "Adopted"
        }).length;
        chartData["oChart"]["Adopted in Part"] = _.where(sectionData, {
          category: "Other",
          status: "Adopted in Part"
        }).length;
        chartData["oChart"]["Proposed"] = _.where(sectionData, {
          category: "Other",
          status: "Proposed"
        }).length;
        chartData["oChart"]["Remaining"] = _.where(sectionData, {
          category: "Other",
          status: "Remaining"
        }).length;
        
        var totalObjectsAdopted = _.filter(sectionData, function(obj) {
          return (obj.status == "Adopted" || obj.status == "Adopted in Part");
        });
        var totalObjectsProposed = _.where(sectionData, {
          status: "Proposed"
        }).length;
        var totalObjectsRemaining = _.where(sectionData, {
          status: "Remaining"
        }).length;

          // Dynamically set the counts for each rulemaking provision chart.

          $('#pf-adopted').text(chartData["pfChart"]["Adopted"] + chartData["pfChart"]["Adopted in Part"]);
          $('#pf-proposed').text(chartData["pfChart"]["Proposed"]);
          $('#pf-remaining').text(chartData["pfChart"]["Remaining"]);
          
          $('#vr-adopted').text(chartData["vrChart"]["Adopted"] + chartData["vrChart"]["Adopted in Part"]);
          $('#vr-proposed').text(chartData["vrChart"]["Proposed"]);
          $('#vr-remaining').text(chartData["vrChart"]["Remaining"]);
          
          $('#sbs-adopted').text(chartData["sbsChart"]["Adopted"] + chartData["sbsChart"]["Adopted in Part"]);
          $('#sbs-proposed').text(chartData["sbsChart"]["Proposed"]);
          $('#sbs-remaining').text(chartData["sbsChart"]["Remaining"]);
          
          $('#ca-adopted').text(chartData["caChart"]["Adopted"] + chartData["caChart"]["Adopted in Part"]);
          $('#ca-proposed').text(chartData["caChart"]["Proposed"]);
          $('#ca-remaining').text(chartData["caChart"]["Remaining"]);
          
          $('#msa-adopted').text(chartData["msaChart"]["Adopted"] + chartData["msaChart"]["Adopted in Part"]);
          $('#msa-proposed').text(chartData["msaChart"]["Proposed"]);
          $('#msa-remaining').text(chartData["msaChart"]["Remaining"]);
          
          $('#ec-adopted').text(chartData["ecChart"]["Adopted"] + chartData["ecChart"]["Adopted in Part"]);
          $('#ec-proposed').text(chartData["ecChart"]["Proposed"]);
          $('#ec-remaining').text(chartData["ecChart"]["Remaining"]);
          
          $('#abs-adopted').text(chartData["absChart"]["Adopted"] + chartData["absChart"]["Adopted in Part"]);
          $('#abs-proposed').text(chartData["absChart"]["Proposed"]);
          $('#abs-remaining').text(chartData["absChart"]["Remaining"]);
          
          $('#cra-adopted').text(chartData["craChart"]["Adopted"] + chartData["craChart"]["Adopted in Part"]);
          $('#cra-proposed').text(chartData["craChart"]["Proposed"]);
          $('#cra-remaining').text(chartData["craChart"]["Remaining"]);
          
          $('#sd-adopted').text(chartData["sdChart"]["Adopted"] + chartData["sdChart"]["Adopted in Part"]);
          $('#sd-proposed').text(chartData["sdChart"]["Proposed"]);
          $('#sd-remaining').text(chartData["sdChart"]["Remaining"]);
          
          $('#o-adopted').text(chartData["oChart"]["Adopted"] + chartData["oChart"]["Adopted in Part"]);
          $('#o-proposed').text(chartData["oChart"]["Proposed"]);
          $('#o-remaining').text(chartData["oChart"]["Remaining"]);
          
          $('#total-adopted').text(totalObjectsAdopted);
          $('#total-proposed').text(totalObjectsProposed);
          $('#total-remaining').text(totalObjectsRemaining);

          // Loop through the chartData collection to build the chart objects. The key
          // for the chartData elements corresponds to the HTML div id of the various
          // rulemaking provisions. Using Flot Chart library to dynamically generate the charts.  

          var chartAreaIndex = 0;
          for (var chrt in chartData) {
            var flotData = [
              {label: "Adopted", data: chartData[chrt]["Adopted"] + chartData[chrt]["Adopted in Part"]},
              {label: "Proposed", data: chartData[chrt]["Proposed"]},
              {label: "Remaining", data: chartData[chrt]["Remaining"]}
            ];

            //$.plot($("#rules-progress a:eq(" + chartAreaIndex + ") .graph"), flotData, {
            $.plot($("#rules-progress div.rule-section:eq(" + chartAreaIndex + ") .graph"), flotData, {
              series: {
                pie: {
                  show: true,
                  label: {
                    show: false
                  }
                }
              },
              legend: {
                show: false
              },
              colors: ["#56B14A", "#1B7FBF", "#949FB1"]
            });
            chartAreaIndex += 1;
          }

        } else {
            // json didn't load
            console.log('one or more of the json data files did not load')
        }
});

});
})(jQuery);