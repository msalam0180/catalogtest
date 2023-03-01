Feature: WYSIWYG Editor
Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      | BEHAT Status B |

  @api @javascript
  Scenario: Selecting Existing Media Type of Image From Media Library With Medium Display and Aligning Left
    Given I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I fill in "Name" with "Logo"
      And I press the "Apply filters" button
      And I wait for ajax to finish
      And I click Table
      And I check "Edgar Logo" on the files selector
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Left"
      And I select "embed_medium" from "Display"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the "div" element with the "class" attribute set to "align-left media media--type-image media--view-mode-embed-medium" in the "forum_content" region

  @api @javascript
  Scenario: Selecting Existing Media Type of Image From Media Library With Thumbnail Display and Aligning Right
    Given I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I fill in "Name" with "Logo"
      And I press the "Apply filters" button
      And I wait for ajax to finish
      And I click Table
      And I check "Edgar Logo" on the files selector
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Right"
      And I select "embed_thumbnail" from "Display"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the "div" element with the "class" attribute set to "align-right media media--type-image media--view-mode-embed-thumbnail" in the "forum_content" region

  @api @javascript
  Scenario: Selecting From Existing Media Type of File From The Media Library and Aligning left
     Given I create "media" of type "files":
      | KEY   | name              | field_media_file |
      | Behat | Behat File Upload | behat-file.pdf   |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
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
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the "div" element with the "class" attribute set to "align-left media media--type-files media--view-mode-embed-default" in the "forum_content" region
      And I should see the link "behat-file.pdf"

  @api @javascript
  Scenario: Selecting From Existing Media Type of File From The Media Library and Aligning Right
     Given I create "media" of type "files":
      | KEY   | name              | field_media_file |
      | Behat | Behat File Upload | behat-file.pdf   |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
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
      And I select the radio button "Right"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the "div" element with the "class" attribute set to "align-right media media--type-files media--view-mode-embed-default" in the "forum_content" region
      And I should see the link "behat-file.pdf"

  @api @javascript
  Scenario: Uploading New Media Type of File From Media Library and Aligning Center
    Given I am logged in as a user with the "Administrator" roles
    When I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I click on the element with css selector "#media-library-wrapper > ul > li.media-library-menu-files"
      And I attach the file "behat-file.pdf" to "Add file"
      And I wait for ajax to finish
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button.button.button--primary.js-form-submit.form-submit.ui-button.ui-corner-all.ui-widget"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Center"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the link "behat-file.pdf"

  @api @javascript
  Scenario: Uploading New Media Type of Image From Media Library Default Display And Align Center
    Given I am logged in as a user with the "Administrator" roles
    When I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Insert from Media Library"
      And I attach the file "behat-HomePage.png" to "Add file"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "alt text"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button.button.button--primary.js-form-submit.form-submit.ui-button.ui-corner-all.ui-widget"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.media-library-widget-modal.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I click on the edit media button within "edit-body-0-value"
      And I select the radio button "Center"
      And I select "embed_default" from "Display"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the "img" element with the "src" attribute set to "/behat-HomePage" in the "forum_content" region

  @api @javascript
  Scenario: Inserting Hyperlink To Words In WYSIWYG Editor
    Given I create "media" of type "files":
      | KEY   | name              | field_media_file |
      | Behat | Behat File Upload | behat-file.pdf   |
    When I am logged in as a user with the "Administrator" roles
      And I am on "/node/add/application"
      And I fill in "Title" with "DSITE-6748-behat"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the hyperlink description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select text "hyperlink" in WYSIWYG selector "edit-body-0-value"
      And I press "Link"
      And I fill in "URL" with "/media/7375"
      And I click "Save" on the modal "Add Link"
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "DSITE-6748-behat"
      And I should see the link "hyperlink"
