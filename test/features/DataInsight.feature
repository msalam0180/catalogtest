Feature: Create, Edit and Delete A Data Insight
  As a content creator, I can create a Data Insight so that when users visit an insight page, user can see the following,
  -- A logically organized template in the Data Catalog.
  -- A checklist to check that my content is following SEC standards
  -- Content that is accessible and fits with the site's standards

  Background:

    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
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

  @api @javascript
  Scenario Outline: Authorized Users Can Create Data Insight
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "Test Behat Data Insight"
      And I fill in "Short Description" with "behat short"
      And I press "Add existing Author"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "editorial"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Editorial" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I fill in "field_published_date[0][value][date]" with "11/29/2019"
      And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
      And I type "BEHAT Key Message One" in the "Key Message" WYSIWYG editor number "0"
      And I type "BEHAT Visualization One" in the "Visualization" WYSIWYG editor number "0"
      And I wait for ajax to finish
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Two" in the "Key Message" WYSIWYG editor number "1"
      And I type "BEHAT Visualization Two" in the "Visualization" WYSIWYG editor number "1"
      And I wait for ajax to finish
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Three" in the "Key Message" WYSIWYG editor number "2"
      And I type "BEHAT Visualization Three" in the "Visualization" WYSIWYG editor number "2"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Four" in the "Key Message" WYSIWYG editor number "3"
      And I type "BEHAT Visualization Four" in the "Visualization" WYSIWYG editor number "3"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Five" in the "Key Message" WYSIWYG editor number "4"
      And I type "BEHAT Visualization Five" in the "Visualization" WYSIWYG editor number "4"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Six" in the "Key Message" WYSIWYG editor number "5"
      And I type "BEHAT Visualization Six" in the "Visualization" WYSIWYG editor number "5"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Seven" in the "Key Message" WYSIWYG editor number "6"
      And I type "BEHAT Visualization Seven" in the "Visualization" WYSIWYG editor number "6"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Eight" in the "Key Message" WYSIWYG editor number "7"
      And I type "BEHAT Visualization Eight" in the "Visualization" WYSIWYG editor number "7"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Nine" in the "Key Message" WYSIWYG editor number "8"
      And I type "BEHAT Visualization Nine" in the "Visualization" WYSIWYG editor number "8"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message Ten" in the "Key Message" WYSIWYG editor number "9"
      And I type "BEHAT Visualization Ten" in the "Visualization" WYSIWYG editor number "9"
      And I fill in "URL" with "http://test.com"
      And I type "BEHAT FootNotes" in the "Footnotes" WYSIWYG editor
      And I select the autocomplete option for "Test Category" on the "Data Insight Categories" field
      And I select the autocomplete option for "insight22" on the "Tags" field
      And I fill in "BEHAT Insights" for "Search Keywords"
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Contacts"
      And I wait for ajax to finish
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait for ajax to finish
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
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "<doc_name>"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "field_documents[form][0][field_document_category]"
      And I fill in "Description" with "Test"
      And I press "Create Document"
      And I wait for ajax to finish
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I wait for ajax to finish
      And I fill in "Title" with "BEHAT Article"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT Article" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Test Behat Data Insight"
      And I should see the text "Author(s)"
      And I should see the link "Editorial Contact"
      And I should see the text "Published Date"
      And I should see the text "11/29/2019"
      And I should see the text "BEHAT Key Message One"
      And I should see the text "BEHAT Visualization One"
      And I should see the text "BEHAT Key Message Two"
      And I should see the text "BEHAT Visualization Two"
      And I should see the text "BEHAT Key Message Three"
      And I should see the text "BEHAT Visualization Three"
      And I should see the text "BEHAT Key Message Four"
      And I should see the text "BEHAT Visualization Four"
      And I should see the text "BEHAT Key Message Five"
      And I should see the text "BEHAT Visualization Five"
      And I should see the text "BEHAT Key Message Six"
      And I should see the text "BEHAT Visualization Six"
      And I should see the text "BEHAT Key Message Seven"
      And I should see the text "BEHAT Visualization Seven"
      And I should see the text "BEHAT Key Message Eight"
      And I should see the text "BEHAT Visualization Eight"
      And I should see the text "BEHAT Key Message Nine"
      And I should see the text "BEHAT Visualization Nine"
      And I should see the text "BEHAT Key Message Ten"
      And I should see the text "BEHAT Visualization Ten"
      And I should see the text "GitLab Link"
      And I should see the link "http://test.com"
      And I should see the text "Footnotes"
      And I should see the text "BEHAT FootNotes"
      And I should see the text "BEHAT Role3"
      And I should see the link "BEHAT Contact"
      And I should see the text "Data Insight Categories"
      And I should see the link "Test Category"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I should see the text "Related Articles"
      And I should see the link "BEHAT Article"
      And I should see the link "insight22"

    Examples:
      | role             | doc_name |
      | Content Approver | Name 1   |
      | sitebuilder      | Name 2   |
      | Content Creator  | Name 3   |

  @api @javascript
  Scenario: User Can Remove An Existing Visualization
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "Test Behat Data Insight"
      And I fill in "Short Description" with "Behat Short"
      And I fill in "field_published_date[0][value][date]" with "11/29/2019"
      And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
      And I type "BEHAT Key Message One" in the "Key Message" WYSIWYG editor number "0"
      And I type "BEHAT Visualization One" in the "Visualization" WYSIWYG editor number "0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the text "BEHAT Key Message One"
      And I should see the text "BEHAT Visualization One"
    When I am on "/data-insights/test-behat-data-insight/edit"
      And I press "Remove" in the "visualization" region
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the text "BEHAT Key Message One"
      And I should not see the text "BEHAT Visualization One"

  @api @javascript
  Scenario: Data Insight Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_insight" content:
      | title            | BEHAt Insight    |
      | body             | This is the body |
      | moderation_state | published        |
      And I wait 2 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Data Insight BEHAt Insight"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit Data Insight
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "data_insight" content:
      | title            | BEHAt Insight     |
      | field_summary    | behat short       |
      | field_author     | BEHAT Contact     |
      | body             | This is the body  |
      | field_contact    | Editorial Contact |
      | field_reviewer   | approver          |
      | moderation_state | published         |
    Then I should see the heading "BEHAt Insight"
      And I should see the text "Author(s)"
      And I should see the link "BEHAT Contact"
      And I should see the text "This is the body"
      And I should see "Data Insights"
    When I am on "/data-insights/behat-insight/edit"
      And I fill in "Title" with "BEHAt Insight Edited"
      And I type "This is Edited body  " in the "Bottom Line Up Front" WYSIWYG editor
      And I publish it
    Then I should see the heading "BEHAt Insight Edited"
      And I should see the text "This is Edited body"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete Data Insight
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "data_insight" content:
      | title            | BEHAt Insight     |
      | field_summary    | behat short       |
      | field_author     | BEHAT Contact     |
      | body             | This is the body  |
      | field_contact    | Editorial Contact |
      | field_reviewer   | approver          |
      | moderation_state | published         |
    Then I should see the heading "BEHAt Insight"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAt Insight" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should see "The Data Insight BEHAt Insight has been deleted."
      And I am on "/data-insights/behat-insight"
      And I should see "The requested page could not be found."

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario: Verify Data Insight Help Text, Label, And Required Fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_insight"
    Then I should see the text "Title"
      And I should see the text "Short Description"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Author"
      And I should see the text "Published Date"
      And I should see the text "Bottom Line Up Front"
      And I should see the text "Provide the key message for this insight"
      And I should see the text "Visualization"
      And I should see the text "Key Message"
      And I should see the text "GITLAB LINK"
      And I should see the text "This must be an external URL such as http://example.com."
      And I should see the text "Footnotes"
      And I should see the text "Data Insight Categories"
      And I should see the text "Reviewer"
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
      And I should see the text "Is featured item"
      And I should see the text "Search Keywords"
      And I should see the text "Tags"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
      And I should see the text "Related Datasets"
      And I should see the text "Related Reports & Statistics"
      And I should see the text "Contacts"
      And I Should see the text "Related Documents"
      And I Should see the text "Related Articles"
    When I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api @javascript
  Scenario: Search Data Insight
    Given I am logged in as a user with the "authenticated user" role
      And "data_insight" content:
      | title         | field_summary | field_author  | body             | field_data_search_index | field_tags | moderation_state |
      | BEHAt Insight | behat short   | BEHAT Contact | This is the body | index                   | something  | published        |
    When I run cron
      And I am on "/"
      And I fill in "edit-term" with "index"
      And I press "edit-submit-search-results"
    Then I should see the link "BEHAt Insight" in the "results_view" region
      And I fill in "edit-term--3" with "something"
      And I press "edit-submit-search-results--3"
    Then I should see the link "BEHAt Insight" in the "results_view" region
      And I fill in "edit-term--2" with "BEHAt Insight"
      And I press "edit-submit-search-results--2"
    Then I should see the link "BEHAt Insight" in the "results_view" region
      And I should see the text "behat short"

  @api @javascript
  Scenario: Create Data Insight With Existing Author
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "Test Data Insight Behat"
      And I fill in "Short Description" with "behat short"
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
      And I type "Behat Data Insight Description" in the "Bottom Line Up Front" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Test Data Insight Behat"
      And I should see the link "BEHAT Contact"
      And I should see the text "(DERA)"
      And I should see the text "Behat Data Insight Description"

  @api
  Scenario: Site Users Can View Data Insight Page
    Given I am logged in as a user with the "authenticated user" role
      And "data_insight" content:
      | title         | field_author  | body             | field_repository_link    | field_footnotes    | field_associated_datasets | field_documents   | field_articles | field_data_search_index | field_tags | field_published_date | moderation_state |
      | BEHAT Insight | BEHAT Contact | This is the body | Gitlab - http://test.com | This is Foot Notes | BEHAT dataset1            | Behat File Upload | BEHAT Article  | index                   | something  | 2019-11-13           | published        |
      And "forum" content:
      | title       | body                      | taxonomy_forums | field_related_content | moderation_state |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | BEHAT Insight         | published        |
    When I am on "/data-insights/behat-insight"
    Then I should see the heading "BEHAT Insight"
      And I should see the link "BEHAT Contact"
      And I should see the text "This is the body"
      And I should see the link "Gitlab"
      And I should see the text "This is Foot Notes"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I should see the text "Related Documents"
      And I should see the link "Behat File Upload"
      And I should see the text "Related Articles"
      And I should see the link "BEHAT Article"
      And I should see the text "Related Discussions"
      And I should see the link "BEHAT Category"
      And I should see the link "BEHAT Forum"

  @api @javascript
  Scenario Outline: Authorized Users Can Create DataInsight Landing Page
    Given I am logged in as a user with the "<role>" role
      And "data_insight" content:
      | title         | field_summary | field_author  | body             | field_repository_link    | field_footnotes    | field_associated_datasets | field_documents   | field_articles | field_data_search_index | field_tags | field_published_date | field_featured_item | moderation_state | field_reviewer |
      | BEHAt Insight | behat short   | BEHAT Contact | This is the body | Gitlab - http://test.com | This is Foot Notes | BEHAT dataset1            | Behat File Upload | BEHAT Article  | index                   | something  | 2019-11-13           | 1                   | published        | approver       |
      And "landing_page" content:
      | title              | field_summary | body                           | moderation_state | field_reviewer |
      | BEHAT Landing Page | behat short   | This is the BEHAT landing page | published        | approver       |
    When I am on "/data-insights/behat-insight/edit"
      And I press "Add Visualizations"
      And I wait for ajax to finish
      And I type "BEHAT Key Message One" in the "Key Message" WYSIWYG editor
      And I type "BEHAT Visualization One" in the "Visualization" WYSIWYG editor
      And I publish it
      And I am on "/behat-landing-page/layout"
      And I click "Add section"
      And I wait for ajax to finish
      And I click "Two column"
      And I wait for ajax to finish
      And I select "75%/25%" from "Column widths"
      And I press "Add section"
      And I wait for ajax to finish
      And I click on the element with css selector ".layout__region--first > div:nth-child(2) > a:nth-child(1)"
      And I wait for ajax to finish
      And I click "Block - List of Featured Data Insights"
      And I wait for ajax to finish
      And I press "Add block"
      And I wait for ajax to finish
      And I click on the element with css selector "div.layout-builder__region:nth-child(2) > div:nth-child(2) > a:nth-child(1)"
      And I wait for ajax to finish
      And I click "Block - Data Insights Landing page"
      And I wait for ajax to finish
      And I press "Add block"
      And I wait for ajax to finish
      And I click "Add section"
      And I wait for ajax to finish
      And I click "Two column"
      And I wait for ajax to finish
      And I select "50%/50%" from "Column widths"
      And I press "Add section"
      And I wait for ajax to finish
      And I click on the element with css selector ".layout__region--first > div:nth-child(2) > a:nth-child(1)"
      And I wait for ajax to finish
      And I click "Block - List of Featured Data Insights"
      And I wait for ajax to finish
      And I check "Override title"
      And I wait for ajax to finish
      And I fill in "Title" with "Data Insights List Two Left Block" in the "configure_block" region
      And I press "Add block"
      And I wait 5 seconds
      And I click on the element with css selector "div.layout-builder__region:nth-child(2) > div:nth-child(2) > a:nth-child(1)"
      And I wait for ajax to finish
      And I click "Block - Data Insights Landing page"
      And I wait for ajax to finish
      And I check "Override title"
      And I wait for ajax to finish
      And I fill in "Title" with "Data Insights List Two Right Block" in the "configure_block" region
      And I press "Add block"
      And I wait 1 seconds
      And I scroll to the top
      And I press "Save layout"
    Then I should see the heading "BEHAT Landing Page"
      And I should see the heading "Data Insights List Two Left Block" in the "first_block" region
      And I should see the text "BEHAT Visualization One" in the "first_block" region
      And I should see the heading "Data Insights List Two Right Block" in the "second_block" region
      And I should see the heading "Data Insights List" in the "second_section_block" region
      And I should see the heading "Data Insights List" in the "second_section_block" region
    When I click "More"
    Then I should see the heading "Data Insights List"
      And I should see the text "Filter by Category"

      Examples:
        | role             |
        | Content Approver |
        | sitebuilder      |

  @api @javascript
  Scenario: Add Related Datasets To Data Insight
      Given "division_office" terms:
      | name         |
      | division1    |
      | division2    |
      And "data_insight_type" terms:
      | name  |
      | typeA |
      And "data_set" content:
      | title           | field_dataset_description | moderation_state | field_division_office_multi | field_owner |
      | BEHAT Dataset 1 | This is dataset           | published        | division1                   | division2   |
      | BEHAT Dataset 2 | This is dataset           | published        | division1                   | division2   |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "Test Behat Data Insight"
      And I fill in "Short Description" with "behat short"
      And I fill in "field_published_date[0][value][date]" with "11/29/2019"
      And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
      And I select the autocomplete option for "typeA" on the "Data Insight Categories" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I scroll to the top
      And I click "Related Content"
      And I select the first autocomplete option for "BEHAT Dataset 1" on the "Related Datasets" field
      And I click on the element with css selector "#edit-field-associated-datasets-add-more"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Dataset 2" on the "Related Datasets (value 2)" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "Test Behat Data Insight"
      And I should see the text "Data Insight Categories"
      And I should see the link "typeA"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset 1"
      And I should see the link "BEHAT Dataset 2"
    When I click "BEHAT Dataset 1"
    Then I should see the heading "BEHAT Dataset 1"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Data Insights"
      And I should see the link "Test Behat Data Insight"
      And I should see the text "Data Insight Categories"
      And I should see the link "typeA"
      And I click "typeA"
      And I should see the heading "typeA"
      And I should see the text "Related Content"
      And I should see the text "Data Insight"
      And I should see the link "Test Behat Data Insight"
      And I visit "/datasets/BEHAT-Dataset-2"
      And I should see the heading "BEHAT Dataset 2"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Data Insights"
      And I should see the link "Test Behat Data Insight"
      And I should see the text "Data Insight Categories"
      And I should see the link "typeA"
    When I am on "/data-insights/test-behat-data-insight/edit"
      And I click "Related Content"
      And I fill in "Related Datasets (value 2)" with ""
      And I press "Save"
    Then I should see the heading "Test Behat Data Insight"
      And I should see the link "BEHAT Dataset 1"
      And I should not see the link "BEHAT Dataset 2"
      And I click "BEHAT Dataset 1"
      And I should see the heading "BEHAT Dataset 1"
      And I should see "Related Data Insights"
      And I should see the link "Test Behat Data Insight"
      And I should see the text "Data Insight Categories"
      And I should see the link "typeA"
      And I visit "/datasets/behat-dataset-2"
      And I should see the heading "BEHAT Dataset 2"
      And I should not see the link "Related Content" in the "horizotal_tabs" region
      And I should not see "Related Data Insights"

  @api @javascript
  Scenario: Add Reports And Statistics To Data Insight
    Given "division_office" terms:
    | name      |
    | division1 |
    | division2 |
    And "data_insight_type" terms:
    | name  |
    | typeA |
    Given "statistics" content:
     | title          | field_summary | field_author  | body              | field_contact     | field_repository_link    | field_reviewer | moderation_state |
     | BEHAT Reports1 | behat short   | BEHAT Contact | This is the body1 | Editorial Contact | Gitlab - http://test.com | approver       | published        |
     | BEHAT Reports2 | behat short   | BEHAT Contact | This is the body2 | Editorial Contact | Gitlab - http://test.com | approver       | published        |
    And I am logged in as a user with the "Content Approver" role
  When I am on "/node/add/data_insight"
    And I fill in "Title" with "Test Behat Data Insight"
    And I fill in "Short Description" with "Behat short"
    And I fill in "field_published_date[0][value][date]" with "11/29/2019"
    And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
    And I select the autocomplete option for "typeA" on the "Data Insight Categories" field
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I scroll to the top
    And I click "Related Content"
    And I select the first autocomplete option for "BEHAT Reports1" on the "Related Reports & Statistics" field
    And I click on the element with css selector "#edit-field-related-reports-statistics-add-more"
    And I wait for ajax to finish
    And I select the first autocomplete option for "BEHAT Reports2" on the "Related Reports & Statistics (value 2)" field
    And I select "Published" from "Save as"
    And I press "Save"
  Then I should see the heading "Test Behat Data Insight"
    And I should see the text "Data Insights"
    And I should see the text "Data Insight Categories"
    And I should see the link "typeA"
    And I should see the text "Related Reports & Statistics"
    And I should see the link "BEHAT Reports1"
    And I should see the link "BEHAT Reports2"
    And I scroll to the bottom
  When I click "BEHAT Reports1"
  Then I should see the heading "BEHAT Reports1"
    And I should see "Reports and Statistics"
    And I should see the text "Related Data Insights"
    And I should see the link "Test Behat Data Insight"
    And I scroll to the bottom
    And I click "Test Behat Data Insight"
  Then I should see the heading "Test Behat Data Insight"
    And I should see the link "BEHAT Reports1"
    And I should see the link "BEHAT Reports2"
  When I am on "/data-insights/test-behat-data-insight/edit"
    And I click "Related Content"
    And I fill in "Related Reports & Statistics (value 2)" with ""
    And I press "Save"
    Then I should see the heading "Test Behat Data Insight"
    And I should see the link "BEHAT Reports1"
    And I should not see the link "BEHAT Reports2"

  @api
  Scenario: Access Denied For Authenicated Users Creating Data Insight
    Given I am logged in as a user with the "authenticated user" role
    When I am on "/node/add/data_insight"
    Then I should see the text "You are not authorized to access this page"

  @api @javascript
  Scenario: Verify Data Insight List Page Sorting And Pagination
    Given I am logged in as a user with the "authenticated user" role
      And "data_insight" content:
      | title           | field_author  | body             | field_data_insights | field_featured_item | moderation_state |
      | A BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | B BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | C BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | D BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | E BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | F BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | G BEHAT Insight | BEHAT Contact | This is the body | BEHAT Category      | 1                   | published        |
      | H BEHAT Insight | BEHAT Contact | This is the body | Test Category       | 1                   | published        |
      | I BEHAT Insight | BEHAT Contact | This is the body | Test Category       | 1                   | published        |
      | J BEHAT Insight | BEHAT Contact | This is the body | Test Category       | 1                   | published        |
      | K BEHAT Insight | BEHAT Contact | This is the body | Test Category       | 1                   | published        |
      | L BEHAT Insight | BEHAT Contact | This is the body | Capital Markets1    | 1                   | published        |
      | M BEHAT Insight | BEHAT Contact | This is the body | Capital Markets1    | 1                   | published        |
      | N BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | O BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | P BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | Q BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | R BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | S BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | T BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | U BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | V BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | W BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | X BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | X BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | X BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | Y BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | X BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      | Z BEHAT Insight | BEHAT Contact | This is the body | Educational1        | 1                   | published        |
      And "landing_page" content:
      | title              | body                           | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | published        |
    When I am on "/data-insights-list"
      And I click on the element with css selector "#edit-field-data-insights-target-id"
      And I wait 1 seconds
    Then I should see "BEHAT Category (7)"
      And I should see "Test Category (4)"
      And I should see "Capital Markets1 (2)"
      And I should see "Educational1 (16)"
      And I should see "(16)"
      And I should see "(2)"
      And I should see "(4)"
      And I should see "(7)"
      And I click "Title"
      And I should see the link "A BEHAT Insight"
    Then I should see the link "A BEHAT Insight" before I see the link "B BEHAT Insight" in the "results_view" region
      And I should see the link "C BEHAT Insight" before I see the link "D BEHAT Insight" in the "results_view" region
      And I scroll to the bottom
      And I click "Last"
      And I should see the link "Z BEHAT Insight"
      And I wait 1 seconds
      And I click "First"
      And I wait 1 seconds
      And I click "Title"
      And I wait 1 seconds
      And I should see the link "Z BEHAT Insight" before I see the link "Y BEHAT Insight" in the "results_view" region
      And I should see the link "X BEHAT Insight" before I see the link "W BEHAT Insight" in the "results_view" region
      And I should see the link "Published Date"
    When I select "BEHAT Category (7)" from "Filter by Category"
      And I press "Apply"
    Then I should see the link "A BEHAT Insight" in the "results_view" region
      And I should not see the text "Educational1" in the "results_view" region
      And I should not see the text "Capital Markets1" in the "results_view" region
      And I should not see the text "Test Category" in the "results_view" region
    When I select "Educational1 (16)" from "Filter by Category"
      And I press "Apply"
    Then I should see the link "N BEHAT Insight" in the "results_view" region
      And I should not see the text "BEHAT Category" in the "results_view" region
      And I should not see the text "Capital Markets1" in the "results_view" region
      And I should not see the text "Test Category" in the "results_view" region
    When I select "Capital Markets1 (2)" from "Filter by Category"
      And I press "Apply"
    Then I should see the link "L BEHAT Insight" in the "results_view" region
      And I should see the link "M BEHAT Insight" in the "results_view" region
      And I should not see the text "BEHAT Category" in the "results_view" region
      And I should not see the text "Educational1" in the "results_view" region
      And I should not see the text "Test Category" in the "results_view" region
    When I select "Test Category (4)" from "Filter by Category"
      And I press "Apply"
    Then I should see the link "H BEHAT Insight" in the "results_view" region
      And I should see the link "J BEHAT Insight" in the "results_view" region
      And I should not see the text "BEHAT Category" in the "results_view" region
      And I should not see the text "Educational1" in the "results_view" region
      And I should not see the text "Capital Markets1" in the "results_view" region
      And I press "Reset"

  @api @javascript
  Scenario: Start A New Discussion From Data Insight Detailed Page
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_insight" content:
      | title            | BEHAT Insight    |
      | body             | This is the body |
      | moderation_state | published        |
    Then I should not see "Related Discussions"
      And I should see the link "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
      And I click "Start a New Discussion"
      And the link should open in a new tab
      And I wait 2 seconds
      And I fill in "Title" with "BEHAT Forum"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
      And I should see the text "Related Content"
      And I should see the link "BEHAT Insight"
      And I click "BEHAT Insight"
      And I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I close the current window

  @api @javascript
  Scenario: Relation Add Related Data Insights to Data Insight with Two way Sync
    Given "data_insight" content:
      | title                   | field_summary | body             | moderation_state | field_reviewer |
      | Behat Insight Main      | behat short   | This is the body | published        | approver       |
      | Behat Related Insight 1 | behat short   | This is the body | published        | approver       |
      | Behat Related Insight 2 | behat short   | This is the body | published        | approver       |
    When I am logged in as a user with the "Content Approver" role
    #Add Data Insight relationships to another Data Insight
      And I am on "/data-insights/behat-insight-main/edit"
      And I click "Related Content"
      And I select the first autocomplete option for "Behat Related Insight 1" on the "Related Data Insights" field in the "insight_related_insights" region
      And I press "Add another item" in the "insight_related_insights" region
      And I select the first autocomplete option for "Behat Related Insight 2" on the "Related Data Insights (value 2)" field in the "insight_related_insights" region
      And I press "Save"
    #Verify two way relationships before Edit
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 1"
      And I should see the link "Behat Related Insight 2"
    When I am on "/data-insights/behat-related-insight-1"
    Then I should see the heading "Behat Related Insight 1"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    When I am on "/data-insights/behat-related-insight-2"
    Then I should see the heading "Behat Related Insight 2"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    #Edit related data insights titles
    When I am logged in as a user with the "Content Approver" role
      And I am on "/data-insights/behat-related-insight-1/edit"
      And I fill in "Title" with "Behat Related Insight 1 - edited"
      And I press "Save"
      And I am on "/data-insights/behat-related-insight-2/edit"
      And I fill in "Title" with "Behat Related Insight 2 - edited"
      And I press "Save"
    #Verify new titles on data insight
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the link "Behat Related Insight 1 - edited"
      And I should see the link "Behat Related Insight 2 - edited"
    #Remove relation to data insight from related data insights
    When I am logged in as a user with the "Content Approver" role
      And I am on "/data-insights/behat-related-insight-1-edited/edit"
      And I click "Related Content"
      And I click on the element with css selector "#edit-field-relate-data-insight-0-remove-button"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the text "Related Data Insights"
      And I should not see the link "Behat Insight Main"
    When I am on "/data-insights/behat-related-insight-2-edited/edit"
      And I click "Related Content"
      And I click on the element with css selector "#edit-field-relate-data-insight-0-remove-button"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the text "Related Data Insights"
      And I should not see the link "Behat Insight Main"
    #Verify removal of relationships on other side
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should not see the text "Related Data Insights"
      And I should not see the link "Behat Related Insight 1 - edited"
      And I should not see the link "Behat Related Insight 2 - edited"

  @api @javascript
  Scenario: Delete Related Data Insight Node and Check Data Insight Two way Sync
    Given "data_insight" content:
      | title                   | field_summary | body             | moderation_state | field_reviewer | field_relate_data_insight                        | nid   |
      | Behat Related Insight 1 | behat short   | This is the body | published        | approver       |                                                  | 35252 |
      | Behat Related Insight 2 | behat short   | This is the body | published        | approver       |                                                  | 35253 |
      | Behat Insight Main      | behat short   | This is the body | published        | approver       | Behat Related Insight 1, Behat Related Insight 2 |       |
    #Verify existing two way relationships
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 1"
      And I should see the link "Behat Related Insight 2"
    When I am on "/data-insights/behat-related-insight-1"
    Then I should see the heading "Behat Related Insight 1"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    When I am on "/data-insights/behat-related-insight-2"
    Then I should see the heading "Behat Related Insight 2"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    #Delete related data insight node and check for two way relationships
    When I am logged in as a user with the "Content Approver" role
      And I am on "/data-insights/behat-related-insight-1/delete"
      And I press "Delete"
    Then I should see the text "The Data Insight Behat Related Insight 1 has been deleted."
    When I am on "/data-insights/behat-insight-main/edit"
      And I click "Related Content"
    Then the "edit-field-relate-data-insight-0-target-id" field should not contain "Behat Related Insight 1 (35252)"
      And the "edit-field-relate-data-insight-0-target-id" field should contain "Behat Related Insight 2 (35253)"
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 2"
      And I should not see the link "Behat Related Insight 1"

  @api @javascript
  Scenario: Archived Related Data Insight Node and Check Data Insight Two way Sync
    Given "data_insight" content:
      | title                   | field_summary | body             | moderation_state | field_reviewer | field_relate_data_insight                        |
      | Behat Related Insight 1 | behat short   | This is the body | published        | approver       |                                                  |
      | Behat Related Insight 2 | behat short   | This is the body | published        | approver       |                                                  |
      | Behat Insight Main      | behat short   | This is the body | published        | approver       | Behat Related Insight 1, Behat Related Insight 2 |
    #Verify existing two way relationships
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 1"
      And I should see the link "Behat Related Insight 2"
    When I am on "/data-insights/behat-related-insight-1"
    Then I should see the heading "Behat Related Insight 1"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    When I am on "/data-insights/behat-related-insight-2"
    Then I should see the heading "Behat Related Insight 2"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight Main"
    #Unpublish (Archived) related data insight node and check for two way relationships
    When I am logged in as a user with the "Content Approver" role
      And I am on "/data-insights/behat-related-insight-1/edit"
      And I scroll to the bottom
      And I select "Archived" from "Change to"
      And I press the "Save" button
    Then I should see the text "Data Insight Behat Related Insight 1 has been updated."
    When I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 1"
      And I should see the link "Behat Related Insight 2"
      And I should see the text "Unpublished"
    When I am logged in as a user with the "authenticated" role
      And I am on "/data-insights/behat-insight-main"
    Then I should see the heading "Behat Insight Main"
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Related Insight 2"
      And I should not see the link "Behat Related Insight 1"
      And I should not see the text "Unpublished"
