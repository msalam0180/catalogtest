Feature: Create Data Insight For WDIO
  As a content creator, I can create a Data Insight so that when users visit an insight page, user can see the following,
  -- A logically organized template in the Data Catalog.
  -- A checklist to check that my content is following SEC standards
  -- Content that is accessible and fits with the site's standards

  Background:

    Given users:
      | name     | mail              | pass | roles            |
      | approver | approver@test.com |      | Content Approver |
      | auth     | auth@test.com     | auth |                  |
      And "data_insight_type" terms:
      | name             |
      | BEHAT Category   |
      | Test Category    |
      | Educational1     |
      | Capital Markets1 |
      And "tags" terms:
      | name      |
      | insight22 |
      | something |
      And "roles" terms:
      | name        |
      | BEHAT Role3 |
      And "forums" terms:
      | name     |
      | Datasets |
      And "contact" content:
      | field_first_name | field_last_name | field_email         | field_division_office | moderation_state |
      | BEHAT            | Contact         | email@email.com     | DERA                  | published        |
      | Editorial        | Contact         | editorial@email.com | DERA                  | published        |
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And  "article" content:
      | title         | body | field_category | moderation_state |
      | BEHAT Article | test | FAQ            | published        |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |

  @ui @api @javascript @wdio
  Scenario: Create Data Insight For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "statistics" content:
      | title          | body             | moderation_state |
      | BEHAT Reports1 | This is the body | published        |
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "Test Behat Data Insight"
      And I press "Add new Author"
      And I wait for ajax to finish
      And I fill in "John" for "First Name"
      And I fill in "Behat" for "Last Name"
      And I fill in "test@behat.com" for "Email"
      And I select "EEO" from "Division/Office"
      And I press "Create Author"
      And I wait for ajax to finish
      And I fill in "field_published_date[0][value][date]" with "11/29/2019"
      And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
      And I type "BEHAT Key Message One" in the "Key Message" WYSIWYG editor number "0"
      And I type "BEHAT Visualization One" in the "Visualization" WYSIWYG editor number "0"
      And I wait 1 seconds
      And I press "Add Visualizations"
      And I wait 1 seconds
      And I type "BEHAT Key Message Two" in the "Key Message" WYSIWYG editor number "1"
      And I type "BEHAT Visualization Two" in the "Visualization" WYSIWYG editor number "1"
      And I wait 1 seconds
      And I press "Add Visualizations"
      And I wait 1 seconds
      And I type "BEHAT Key Message Three" in the "Key Message" WYSIWYG editor number "2"
      And I type "BEHAT Visualization Three" in the "Visualization" WYSIWYG editor number "2"
      And I fill in "URL" with "http://test.com"
      And I type "BEHAT FootNotes" in the "Footnotes" WYSIWYG editor
      And I select the first autocomplete option for "Test Category" on the "Data Insight Categories" field
      And I select the first autocomplete option for "insight22" on the "Tags" field
      And I fill in "BEHAT Insights" for "Search Keywords"
      And I scroll to the top
      And I wait 2 seconds
      And I click "Contacts"
      And I wait for ajax to finish
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Add existing Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 2 seconds
      And I fill in "edit-name" with "BEHAT"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I click "Related Content"
      And I select the first autocomplete option for "BEHAT dataset1" on the "Related Datasets" field
      And I select the first autocomplete option for "BEHAT Reports1" on the "Related Reports & Statistics" field
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "field_documents[form][inline_entity_form][field_document_category]"
      And I fill in "Description" with "Test"
      And I press "Create Document"
      And I wait 1 seconds
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I wait 2 seconds
      And I fill in "Title" with "BEHAT Article"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT Article" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I take a screenshot using "datainsight.feature" file with "@datainsight_all" tag
      And I take a screenshot using "datainsight.feature" file with "@datainsight_link_report" tag

  @api @javascript
  Scenario: Add Related Data Insights to Data Insight WDIO
    Given "data_insight" content:
      | title                   | field_summary | body             | moderation_state | field_reviewer |
      | Behat Insight Main      | behat short   | This is the body | published        | approver       |
      | Behat Related Insight 1 | behat short   | This is the body | published        | approver       |
      | Behat Related Insight 2 | behat short   | This is the body | published        | approver       |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/data-insights/behat-insight-main/edit"
      And I fill in "field_published_date[0][value][date]" with "11/29/2030"
      And I click "Related Content"
      And I select the first autocomplete option for "Behat Related Insight 1" on the "Related Data Insights" field in the "insight_related_insights" region
      And I press "Add another item" in the "insight_related_insights" region
      And I select the first autocomplete option for "Behat Related Insight 2" on the "Related Data Insights (value 2)" field in the "insight_related_insights" region
      And I press "Save"
    Then I take a screenshot using "datainsight.feature" file with "@datainsight_2insights" tag
