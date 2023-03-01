Feature: Create, Edit And Delete Reports And Statistics
  As a content creator, I can create a Report or Statistic:
  --using a logically organized template in the Data Catalog.
  --using a checklist to check that my content is following SEC standards
  --with content that is accessible and fits with the site's standards

  Background:

    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "statistics" terms:
      | name          |
      | BEHAT Reports |
      | Test Category |
      And "tags" terms:
      | name        |
      | report22    |
      | myReportTag |
      And "roles" terms:
      | name        | parent      |
      | BEHAT Role  |             |
      | BEHAT Role3 |             |
      And "contact" content:
      | field_first_name | field_last_name | field_email         | field_division_office | moderation_state |
      | BEHAT            | Contact         | email@email.com     | DERA                  | published        |
      | Editorial        | Contact         | editorial@email.com | DERA                  | published        |
      | Reporter         | One             | reporter@email.com  |                       | published        |
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And  "article" content:
      | title         | body | field_category | moderation_state |
      | BEHAT Article | test | FAQ            | published        |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |

  @api @javascript
  Scenario Outline: Authorized Users Can Create Reports And Statistics
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/statistics"
      And I fill in "Title" with "Test Behat Reports And Statistics"
      And I fill in "Short Description" with "Behat Short"
      And I type "BEHAT Data Description for Reports" in the "Description" WYSIWYG editor
      And I should see the text "Only 300 characters will appear as a summary and 600 in search results."
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "Mike" for "First Name"
      And I fill in "Author" for "Last Name"
      And I fill in "test@behat.com" for "Email"
      And I select "EEO" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Add existing Author"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "author"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Author" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I fill in "edit-field-published-date-0-value-date" with "11/29/2019"
      And I type "BEHAT Visualization One" in the "Visualization" WYSIWYG editor number "0"
      And I type "BEHAT Visualization Text One" in the "Visualization Text" WYSIWYG editor number "0"
      And I wait 1 seconds
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Visualization Two" in the "Visualization" WYSIWYG editor number "1"
      And I type "BEHAT Visualization Text Two" in the "Visualization Text" WYSIWYG editor number "1"
      And I wait 1 seconds
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Visualization Three" in the "Visualization" WYSIWYG editor number "2"
      And I type "BEHAT Visualization Text Three" in the "Visualization Text" WYSIWYG editor number "2"
      And I wait 1 seconds
      And I fill in "URL" with "http://test.com"
      And I fill in "Link text" with "GitLab"
      And I type "BEHAT FootNotes" in the "Footnotes" WYSIWYG editor
      And I select "REPORTS" from "Category"
      And I select the autocomplete option for "report22" on the "Tags" field
      And I fill in "ReportTerms" for "Search Keywords"
      And I scroll to the top
      And I click "Related Content"
      And I select the first autocomplete option for "BEHAT dataset1" on the "Related Datasets" field
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "BEHAT"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I scroll to the top
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "<DocumentName>"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "field_documents[form][0][field_document_category]"
      And I fill in "Description" with "Test" in the "add_document" region
      And I press "Create Document"
      And I wait for ajax to finish
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
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Test Behat Reports And Statistics"
      And I should see the text "Author"
      And I should see the link "Mike Author"
      And I should see the text "Date Posted"
      And I should see the text "11/29/2019"
      And I should see the text "BEHAT Data Description for Reports"
      And I should see the text "BEHAT Visualization One"
      And I should see the text "BEHAT Visualization Text One"
      And I should see the text "BEHAT Visualization Two"
      And I should see the text "BEHAT Visualization Text Two"
      And I should see the text "BEHAT Visualization Three"
      And I should see the text "BEHAT Visualization Text Three"
      And I should see the text "GitLab Link"
      And I should see the link "GitLab"
      And I should see the text "Footnotes"
      And I should see the text "BEHAT FootNotes"
      And I should see the link "BEHAT Reports"
      And I should see the link "Test Category"
      And I should see the text "BEHAT Role3"
      And I should see the link "BEHAT Contact"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I should see the text "Related Documents"
      And I should see the link "<DocumentName>"
      And I should see the text "Document Category"
      And I should see the text "Data Dictionary"
      And I should see the text "Related Articles"
      And I should see the link "BEHAT Article"
      And I should see the link "report22"
    When I click "<DocumentName>"
    Then the link should open in a new tab
      And I close the current window

      Examples:
       | role             | DocumentName        |
       | Content Approver | Uploaded Document1  |
       | sitebuilder      | Uploaded Document2  |
       | administrator    | Uploaded Document3  |
       | Content Creator  | Uploaded Document4  |

  @api @javascript
  Scenario: Reports And Statistics Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "statistics" content:
      | title            | BEHAT Reports |
      | body             | Description   |
      | moderation_state | published     |
      And I wait 3 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Reports and Statistics BEHAT Reports"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit Reports And Statistics
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "statistics" content:
      | title                 | BEHAT Reports            |
      | field_summary         | behat short              |
      | field_author          | BEHAT Contact            |
      | body                  | This is the body         |
      | field_repository_link | Gitlab - http://test.com |
      | field_reviewer        | approver                 |
      | moderation_state      | published                |
    Then I should see the heading "BEHAT Reports"
      And I should see the text "Author"
      And I should see the link "BEHAT Contact"
      And I should see the text "This is the body"
    When I am on "/reports-statistics/behat-reports/edit"
      And I fill in "Title" with "BEHAT Reports Edited"
      And I type "This is Edited body  " in the "Description" WYSIWYG editor
      And I publish it
    Then I should see the heading "BEHAT Reports Edited"
      And I should see the text "This is Edited body"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete Reports And Statistics
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "statistics" content:
      | title                 | BEHAT Reports            |
      | field_author          | BEHAT Contact            |
      | body                  | This is the body         |
      | field_contact         | Editorial Contact        |
      | field_repository_link | Gitlab - http://test.com |
      | field_reviewer        | approver                 |
      | moderation_state      | published                |
    Then I should see the heading "BEHAT Reports"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Reports" row
      And I click "Delete" in the "node_action" region
      And  I press the "Delete" button
    Then I should see "The Reports and Statistics BEHAT Reports has been deleted."
      And I am on "/reports-statistics/behat-reports"
      And I should see "The requested page could not be found."

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api
  Scenario: Search Reports And Statistics
    Given I am logged in as a user with the "authenticated user" role
      And "statistics" content:
      | title          | field_author      | body             | field_data_search_index | field_tags  | moderation_state |
      | BEHAT Reports1 | BEHAT Contact     | This is the body | myReportTerm            |             | published        |
      | BEHAT Reports2 | BEHAT Contact     | This is the body | myReportTerm            |             | published        |
      | BEHAT Reports3 | Reporter One      | This is the body |                         |             | published        |
      | BEHAT Reports4 | Editorial Contact | This is the body |                         | myReportTag | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "myReportTerm" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I wait 1 seconds
    Then I should see the link "BEHAT Reports1" in the "results_view" region
      And I should see the link "BEHAT Reports2" in the "results_view" region
      And I should not see the link "BEHAT Reports3" in the "results_view" region
      And I should not see the link "BEHAT Reports4" in the "results_view" region
    When I fill in "Search" with "myReportTag" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I wait 1 seconds
    Then I should see the link "BEHAT Reports4" in the "results_view" region
      And I should not see the link "BEHAT Reports1" in the "results_view" region
      And I should not see the link "BEHAT Reports2" in the "results_view" region
      And I should not see the link "BEHAT Reports3" in the "results_view" region
    When I fill in "Search" with "reporter" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I wait 1 seconds
    Then I should see the link "BEHAT Reports3" in the "results_view" region
      And I should not see the link "BEHAT Reports1" in the "results_view" region
      And I should not see the link "BEHAT Reports2" in the "results_view" region
      And I should not see the link "BEHAT Reports4" in the "results_view" region
    When I fill in "Search" with "Editorial" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I wait 1 seconds
    Then I should see the link "BEHAT Reports4" in the "results_view" region
      And I should not see the link "BEHAT Reports1" in the "results_view" region
      And I should not see the link "BEHAT Reports2" in the "results_view" region
      And I should not see the link "BEHAT Reports3" in the "results_view" region

  @api @javascript
  Scenario: Create Reports And Statistics With Existing Author
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/statistics"
      And I fill in "Title" with "Test Reports And Statistics Behat"
      And I fill in "Short Description" with "Behat short"
      And I type "Behat reports Description" in the "Description" WYSIWYG editor
      And I press "Add existing Author"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "BEHAT"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Test Reports And Statistics Behat"
      And I should see the link "BEHAT Contact"
      And I should see the text "(DERA)"
      And I should see the text "Behat reports Description"

  @api @javascript
  Scenario: Site Users Can View Reports And Statistics Page
    Given I am logged in as a user with the "authenticated user" role
      And "statistics" content:
      | title         | field_author  | body             | field_repository_link    | field_footnotes    | field_associated_datasets | field_documents   | field_articles | field_data_search_index | field_r_and_s_category | field_published_date | moderation_state |
      | BEHAT Reports | BEHAT Contact | This is the body | Gitlab - http://test.com | This is Foot Notes | BEHAT dataset1            | Behat File Upload | BEHAT Article  | index                   | Test Category          | 2019-11-13           | published        |
    When I am on "/reports-statistics/behat-reports"
    Then I should see the heading "BEHAT Reports"
      And I should see the link "BEHAT Contact"
      And I should see "Date Posted"
      And I should see "11/13/2019"
      And I should see the text "This is the body"
      And I should see the text "Gitlab Link"
      And I should see the link "Gitlab"
      And I should see the text "Footnotes"
      And I should see the text "This is Foot Notes"
      And I should see the text "Category"
      And I should see the link "Test Category"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I should see the text "Related Documents"
      And I should see the link "Behat File Upload"
      And I should see the text "Related Articles"
      And I should see the link "BEHAT Article"
      And I click "Test Category"
      And I should see the link "BEHAT Reports"

  @api @javascript
  Scenario Outline: Validate Start A New Discussion For Reports & Statistics
    Given "statistics" content:
      | title                          | field_summary | Body                      | field_r_and_s_category | moderation_state |
      | Testing di-2979 for report     | Short Report  | Testing report di-2979    | REPORTS                | published        |
      | Testing di-2979 for statistics | Short Stat    | Testing statistic di-2979 | Statistics             | published        |
    When I am logged in as a user with the "<role>" role
      And I visit "<visit>"
      And I click "<click>"
    Then I should see the text "<click>"
      And I should see the link "Start a New Discussion"
      And I should see the text "Rules of the Road govern all discussions"
      And I should see the link "Rules of the Road"
      And the hyperlink "Rules of the Road" should match the Drupal url "https://theexchange.sec.gov/media/1156/download"
    When I click "Start a New Discussion"
    And I wait 2 seconds
    Then the link should open in a new tab
      And I should see the text "Create Discussion"
      And I fill in "Title" with "Ticket 2979"
      And I select "Datasets" from "Category"
      And I wait 1 seconds
      And I type "Testing for di-2979" in the "Body" WYSIWYG editor
      And I scroll to the bottom
      And I press the "Post Discussion" button
      And I should see the text "Ticket 2979"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content/discussions"
    Then I click "Edit" in the "Ticket 2979" row
      And I scroll to the bottom
      And I select "published" from "Change to"
      And I press the "Post Discussion" button
    When I am logged in as a user with the "<role>" role
      And I visit "<visit>"
    Then I click "<click>"
      And I should see the text "Related Discussions"
      And I should see the link "Ticket 2979"
      And I close the current window

      Examples:
       | role               | visit       | click                          |
       | authenticated user | /reports    | Testing di-2979 for report     |
       | Content Creator    | /statistics | Testing di-2979 for statistics |
       | Content Approver   | /reports    | Testing di-2979 for report     |

  @api @javascript
  Scenario Outline: Validate Start A New Discussion For Reports & Statistics include Forum Moderator field
    Given "statistics" content:
      | title                          | field_summary | Body                      | field_r_and_s_category | moderation_state |
      | Testing di-2979 for report     | behat short   | Testing report di-2979    | REPORTS                | published        |
      | Testing di-2979 for statistics | Short stat    | Testing statistic di-2979 | Statistics             | published        |
      And users:
      | name     | mail              | roles            |
      | Test     | approver@test.com | Forum Moderator  |
    When I am logged in as a user with the "<role>" role
      And I visit "<visit>"
      And I click "<click>"
      And I wait for ajax to finish
    Then I should see the text "<click>"
      And I should see the link "Start a New Discussion"
      And I should see the text "Rules of the Road govern all discussions"
      And I should see the link "Rules of the Road"
      And the hyperlink "Rules of the Road" should match the Drupal url "https://theexchange.sec.gov/media/1156/download"
    When I click "Start a New Discussion"
    And I wait 2 seconds
    Then the link should open in a new tab
      And I should see the text "Create Discussion"
      And I fill in "Title" with "Ticket 2979"
      And I select "Datasets" from "Category"
      And I wait 1 seconds
      And I type "Testing for di-2979" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "Test" on the "Forum Moderator" field
      And I scroll to the bottom
      And I press the "Post Discussion" button
      And I should see the text "Ticket 2979"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content/discussions"
    Then I click "Edit" in the "Ticket 2979" row
      And I scroll to the bottom
      And I select "published" from "Change to"
      And I press the "Post Discussion" button
    When I am logged in as a user with the "<role>" role
      And I visit "<visit>"
    Then I click "<click>"
      And I should see the text "Related Discussions"
      And I should see the link "Ticket 2979"
      And I close the current window

      Examples:
      | role               | visit       | click                          |
      | sitebuilder        | /statistics | Testing di-2979 for statistics |
      | Forum Moderator    | /statistics | Testing di-2979 for statistics |
      | administrator      | /reports    | Testing di-2979 for report     |

  @api
  Scenario: Verify Reports And Statistics Insight Help Text, Label, And Required Fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/statistics"
    Then I should see the text "Title"
      And I should see the text "Short Description"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Description"
      And I should see the text "Author"
      And I should see the text "Date Posted"
      And I should see the text "Only 300 characters will appear as a summary and 600 in search results."
      And I should see the text "Visualization"
      And I should see the text "GITLAB LINK"
      And I should see the text "Footnotes"
      And I should see the text "RELATED DOCUMENTS"
      And I should see the text "category"
      And I should see the text "GITLAB LINK"
      And I should see the text "Related Datasets"
      And I should see the text "Related Data Insights"
      And I should see the text "Related Documents"
      And I should see the text "Related Articles"
      And I should see the text "Contacts"
      And I should see the text "Search Keywords"
      And I should see the text "Tags"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
      And I should see the text "Reviewer"
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
    When I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Description field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api @javascript
    Scenario: Add Data Insight To Reports And Statistics
      Given "data_insight" content:
        | title          | body             | moderation_state |
        | BEHAt Insight1 | This is the body | published        |
        | BEHAt Insight2 | This is the body | published        |
      And I am logged in as a user with the "Content Approver" role
      When I am on "/node/add/statistics"
      And I fill in "Title" with "Test Behat Reports And Statistics"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Data Description for Reports" in the "Description" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I scroll to the top
      And I click "Related Content"
      And I select the first autocomplete option for "BEHAt Insight1" on the "Related Data Insights" field
      And I click on the element with css selector "#edit-field-related-data-insights-add-more"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAt Insight2" on the "Related Data Insights (value 2)" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "Test Behat Reports And Statistics"
      And I should see the text "Reports and Statistics"
      And I should see the text "Related Data Insights"
      And I should see the link "BEHAt Insight1"
      And I should see the link "BEHAt Insight2"
      And I scroll to the bottom
    When I click "BEHAt Insight1"
    Then I should see the heading "BEHAt Insight1"
      And I wait 1 seconds
      And I should see "Data Insights"
      And I should see the text "Related Reports & Statistics"
      And I scroll to the bottom
      And I should see the link "Test Behat Reports And Statistics"
    When I click "Test Behat Reports And Statistics"
      And I should see the link "BEHAt Insight1"
      And I should see the link "BEHAt Insight2"
    When I am on "/reports-statistics/test-behat-reports-and-statistics/edit"
      And I click "Related Content"
      And I fill in "Related Data Insights (value 2)" with ""
      And I press "Save"
    Then I should see the heading "Test Behat Reports And Statistics"
      And I should see the link "BEHAt Insight1"
      And I should not see the link "BEHAt Insight2"
