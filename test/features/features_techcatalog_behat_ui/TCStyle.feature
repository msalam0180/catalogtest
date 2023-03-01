Feature: Create Styles on Pages
  As a Content Creator, I want to be able to create basic page and add styles
  So that visitors to Catalog can see visually stunning pages

  Background:
    Given users:
      | name     | mail              | pass | roles            |
      | auth     | auth@test.com     | auth |                  |
      | approver | approver@test.com |      | Content Approver |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |

  @ui @api @javascript @wdio
  Scenario: Adding Auto-Styling Table
    Given "application" content:
      | title              | body         | field_summary | field_division_office_multi | field_owner | moderation_state | field_app_status |
      | Wdio Application 1 | description1 | summary1      | division1                   | division2   | published        | BEHAT Status A   |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/wdio-application-1/edit"
      And I press "Source" in the "Detailed Description" WYSIWYG Toolbar
      And I wait 2 seconds
      And I type '<table class="table table-condensed table-bordered" style="width: 100%;"><thead><tr><th scope="col">column header 1</th><th scope="col">column header 2</th><th scope="col">column header 3</th></tr></thead><tbody><tr><td>r1c1</td><td>r1c2</td><td>r1c3</td></tr><tr><td>r2c1</td><td>WHEN I create a table in the Detailed Description or Body field THEN the table is automatically styled</td><td>r2c3</td></tr><tr><td>r3c1</td><td>r3c2</td><td>AND no editing of the source is required</td></tr></tbody></table><p>&nbsp;</p>' in css selector ".cke_source"
      And I wait 2 seconds
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
    Then I take a screenshot using "global.feature" file with "@styled_table" tag

 @api @javascript @wdio
  Scenario: WebIO for WYSIWYG image media library
    Given I create "media" of type "image":
      | name              | field_media_image    | field_caption                   |
      | Edgar Logo        | behat-edgar-logo.png | Behat Edgar Caption             |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat-image"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I fill in "Name" with "Logo"
      And I press the "Apply filters" button
      And I wait for ajax to finish
      And I click Table
      And I check "Edgar Logo" on the files selector
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I wait for ajax to finish
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Left"
      And I select "embed_medium" from "Display"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@WYSIWYGmedialibrary_image" tag

  @api @javascript @wdio
  Scenario: WebIO for WYSIWYG file media library
     Given I create "media" of type "files":
      | KEY   | name              | field_media_file |
      | Behat | Behat File Upload | behat-file.pdf   |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat-file"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I click on the element with css selector "#media-library-wrapper > ul > li.media-library-menu-files"
      And I fill in "Name" with "Behat"
      And I press "Apply filters"
      And I click Table
      And I check "Behat File Upload" on the files selector
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Left"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@WYSIWYGmedialibrary_file" tag

