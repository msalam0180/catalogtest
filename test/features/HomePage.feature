Feature: Data Catalog Home Page
  Site Builders and Admins are able to edit the static message on the Data Catalog homepage

  @api @javascript
  Scenario: Admin Can Edit Introduction Text Content
    Given I am logged in as a user with the "administrator" role
    When I am on "/admin/structure/block/block-content"
      And I fill in "edit-info" with "Data Callout"
      And I press "edit-submit-block-content"
      And I click "Edit" in the "Data Callout" row
      And I type "Edited Content " in the "Body" WYSIWYG editor
      And I publish it
      And I should see the text "Custom Landing Page block Data Callout has been updated."
      And I click "Home"
    Then I should see the text "Edited Content"

  @api
  Scenario: Verify Recently Updated Block
    Given I am logged in as a user with the "authenticated user" role
      And I am on "/"
    Then I should see the text "Recently Updated Information"

  @api @javascript
  Scenario: Display Contents In Recently Updated Information Block
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state | changed |
      | BEHAT Dataset1 | This is Dataset1          | '' - http://test.com        | published        | -2 days |
      | BEHAT Dataset2 | This is Dataset2          | '' - http://test.com        | published        | -1 days |
      | BEHAT Dataset3 | This is Dataset3          | '' - http://test.com        | published        |         |
      | BEHAT Dataset4 | This is Dataset4          | '' - http://test.com        | published        |         |
      | BEHAT Dataset5 | This is Dataset5          | '' - http://test.com        | published        | -8 days |
      | BEHAT Dataset6 | This is Dataset6          | '' - http://test.com        | published        | -3 days |
      And "article" content:
      | title               | body                | field_category | moderation_state | changed |
      | BEHAT Article One   | Article description | Other          | published        |         |
      | BEHAT Article TWO   | another Article     | Other          | published        |         |
      | BEHAT Article Three | Article description | Other          | published        |         |
      | BEHAT Article Four  | another Article     | Other          | published        |         |
      | BEHAT Article Five  | another Article     | Other          | published        | -4 days |
      And "data_insight" content:
      | title          | body                 | moderation_state | changed |
      | BEHAT Insight1 | Insight description1 | published        | -3 days |
      | BEHAT Insight2 | Insight description2 | published        | -9 days |
      | BEHAT Insight3 | Insight description3 | published        |         |
      | BEHAT Insight4 | Insight description4 | published        |         |
      | BEHAT Insight5 | Insight description5 | published        | -2 days |
      | BEHAT Insight6 | Insight description6 | published        | -5 days |
      And "statistics" content:
      | title          | body             | moderation_state | changed |
      | BEHAT Reports1 | This is the body | published        |         |
      | BEHAT Reports2 | This is the body | published        |         |
      | BEHAT Reports3 | This is the body | published        | -1 days |
      | BEHAT Reports4 | This is the body | published        | -2 days |
      | BEHAT Reports5 | This is the body | published        | -3 days |
      And I run cron
    When I am on "/"
      And I wait 1 seconds
    Then I should see the link "BEHAT Article One" in the "recently_updated" region
      And I should see the link "BEHAT Article TWO" in the "recently_updated" region
      And I should see the link "BEHAT Article Three" in the "recently_updated" region
      And I should see the link "BEHAT Article Four" in the "recently_updated" region
      And I should see the link "BEHAT Dataset3" in the "recently_updated" region
      And I should see the link "BEHAT Dataset4" in the "recently_updated" region
      And I should see the link "BEHAT Insight3" in the "recently_updated" region
      And I should see the link "BEHAT Insight4" in the "recently_updated" region
      And I should see the link "BEHAT Reports1" in the "recently_updated" region
      And I should see the link "BEHAT Reports2" in the "recently_updated" region
      And I should not see the link "BEHAT Dataset1" in the "recently_updated" region
      And I should not see the link "BEHAT Dataset2" in the "recently_updated" region
      And I should not see the link "BEHAT Insight1" in the "recently_updated" region
      And I should not see the link "BEHAT Insight2" in the "recently_updated" region
      And I should not see the link "BEHAT Article Five" in the "recently_updated" region
      And I should not see the link "BEHAT Reports3" in the "recently_updated" region
    When I click "BEHAT Article One"
    Then I should see the heading "BEHAT Article One"
      And I am on "/"
      And I click "More" in the "recently_updated" region
      And I should see the heading "Recently Updated Information"
      And I should see the link "BEHAT Dataset1"
      And I should see the link "BEHAT Dataset2"
      And I should see the link "BEHAT Insight1"
      And I should see the link "BEHAT Insight5"
      And I should see the link "BEHAT Article Five"
      And I should see the link "BEHAT Reports3"
      And I click "Next"
      And I should see the link "BEHAT Dataset5"
      And I should see the link "BEHAT Insight2"
      And I click "BEHAT Insight2"
      And I should see the text "Insight description2"

  @api @javascript
  Scenario Outline: All Users Can View Recently Updated Information Block
    Given I am logged in as a user with the "<role>" role
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state | changed |
      | BEHAT Dataset1 | This is Dataset1          | '' - http://test.com        | published        | -2 days |
      | BEHAT Dataset2 | This is Dataset2          | '' - http://test.com        | published        | -1 days |
      | BEHAT Dataset3 | This is Dataset3          | '' - http://test.com        | published        |         |
      | BEHAT Dataset4 | This is Dataset4          | '' - http://test.com        | published        |         |
      And "article" content:
      | title               | body                | field_category | moderation_state |
      | BEHAT Article One   | Article description | Other          | published        |
      | BEHAT Article TWO   | another Article     | Other          | published        |
      | BEHAT Article Three | Article description | Other          | published        |
      | BEHAT Article Four  | another Article     | Other          | published        |
      And "data_insight" content:
      | title          | body                 | moderation_state |
      | BEHAT Insight1 | Insight description1 | published        |
      | BEHAT Insight2 | Insight description2 | published        |
      | BEHAT Insight3 | Insight description3 | published        |
      | BEHAT Insight4 | Insight description4 | published        |
      And I run cron
    When I am on "/"
      And I wait 1 seconds
    Then I should see the link "BEHAT Article One" in the "recently_updated" region
      And I should see the link "BEHAT Article TWO" in the "recently_updated" region
      And I should see the link "BEHAT Article Three" in the "recently_updated" region
      And I should see the link "BEHAT Article Four" in the "recently_updated" region
      And I should see the link "BEHAT Insight1" in the "recently_updated" region
      And I should see the link "BEHAT Insight2" in the "recently_updated" region
      And I should see the link "BEHAT Insight3" in the "recently_updated" region
      And I should see the link "BEHAT Insight4" in the "recently_updated" region
      And I should see the link "BEHAT Dataset3" in the "recently_updated" region
      And I should see the link "BEHAT Dataset4" in the "recently_updated" region
      And I should not see the link "BEHAT Dataset1" in the "recently_updated" region
      And I should not see the link "BEHAT Dataset2" in the "recently_updated" region
    When I click "BEHAT Article One"
    Then I should see the heading "BEHAT Article One"
      And I am on "/"
      And I click "More" in the "recently_updated" region
      And I should see the heading "Recently Updated Information"
      And I should see the link "BEHAT Dataset1"
      And I should see the link "BEHAT Dataset2"
      And I click "BEHAT Insight1"
      And I should see the text "Insight description1"
    Examples:
      | role               |
      | administrator      |
      | Content Creator    |
      | Content Approver   |
      | authenticated user |

  @api @javascript
  Scenario: UnPublished Contents Don't Show Up In Recently Updated Block
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title     | field_dataset_description | field_dataset_source_type | moderation_state |
      | DATASET10 | Dataset 30 description    | NRSRO, Fitch              | published        |
      | DATASET20 | Dataset 20 description    | NRSRO, Fitch              | draft            |
      And "article" content:
      | title             | body                | field_category | moderation_state |
      | BEHAT Article One | Article description | Other          | published        |
      | BEHAT Article TWO | another Article     | Other          | draft            |
      And "data_insight" content:
      | title          | body                 | moderation_state |
      | BEHAT Insight1 | Insight description1 | published        |
      | BEHAT Insight2 | Insight description2 | draft            |
      And I run cron
    When I am on "/"
    Then I should see the link "DATASET10" in the "recently_updated" region
      And I should see the link "BEHAT Article One" in the "recently_updated" region
      And I should see the link "BEHAT Insight1" in the "recently_updated" region
      And I should not see the link "DATASET20" in the "recently_updated" region
      And I should not see the link "BEHAT Article Two" in the "recently_updated" region
      And I should not see the link "BEHAT Insight2" in the "recently_updated" region

  @api @javascript
  Scenario: Verify Sorting On Recently Updated Block
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      And "data_category" terms:
      | name      |
      | category1 |
      And "data_set" content:
      | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_owner | field_data_category | field_division_office_multi | field_reviewer |
      | BEHAT Dataset1 | behat short   | This is Dataset1          | '' - http://test.com        | published        | division1   | category1           | division1                   | approver       |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
      And I run cron
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article Title"
      And I fill in "Short Description" with "Behat short"
      And I type "BEHAT Article Body" in the "Body" WYSIWYG editor
      And I select "Tools" from "Category"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Dataset1" row
      And I fill in "Title" with "BEHAT Edited Dataset1"
      And I click "Governance"
      And I select "division1" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I publish it
    When I am on "/"
    Then I should see the link "BEHAT Edited Dataset1" before I see the link "BEHAT Article Title" in the "recently_updated" region
    When I click "BEHAT Edited Dataset1"
    Then I should see the heading "BEHAT Edited Dataset1"

  @api @javascript
  Scenario: Verify Sorting On Recently Updated Information Page
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title      | field_dataset_description | field_dataset_source_type | moderation_state | changed |
      | 1DATASET10 | Dataset 10 description    | NRSRO, Fitch              | published        | -6 min  |
      | 2DATASET20 | Dataset 20 description    | NRSRO, Fitch              | published        | -5 min  |
      | 3DATASET30 | Dataset 30 description    | NRSRO, Fitch              | published        | -4 min  |
      | 4DATASET40 | Dataset 40 description    | NRSRO, Fitch              | published        | -3 min  |
      | 5DATASET50 | Dataset 50 description    | NRSRO, Fitch              | published        | -2 min  |
      | 6DATASET60 | Dataset 60 description    | NRSRO, Fitch              | published        | -1 min  |
      And "article" content:
      | title              | body                | field_category | moderation_state | changed |
      | 7BEHAT Article One | Article description | Other          | published        | -8 min  |
      | 8BEHAT Article TWO | another Article     | Other          | published        | -7 min  |
      And "data_insight" content:
      | title            | body                 | moderation_state | changed |
      | 10BEHAT Insight1 | Insight description1 | published        | -11 min |
      | 9BEHAT Insight1  | Insight description1 | published        | -10 min |
      | 99BEHAT Insight2 | Insight description2 | published        | -9 min  |
      And I run cron
    When I am on "/"
      And I click "More" in the "recently_updated" region
      And "6DATASET60" should precede "5DATASET50" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "4DATASET40" should precede "3DATASET30" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "2DATASET20" should precede "1DATASET10" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "8BEHAT Article TWO" should precede "7BEHAT Article One" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "99BEHAT Insight2" should precede "9BEHAT Insight1" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "9BEHAT Insight1" should precede "10BEHAT Insight1" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And I click "Title"
      And I wait 2 seconds
      And "1DATASET10" should precede "2DATASET20" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "3DATASET30" should precede "4DATASET40" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "5DATASET50" should precede "6DATASET60" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "7BEHAT Article One" should precede "8BEHAT Article TWO" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "99BEHAT Insight2" should precede "9BEHAT Insight1" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And I click "Type"
      And I wait 1 seconds
      And "Article" should precede "Data Insight" for the query "//td[contains(@class, 'views-field views-field-type')]"
      And "Data Insight" should precede "Dataset" for the query "//td[contains(@class, 'views-field views-field-type')]"

  @api @javascript
  Scenario: Homepage Search Suggestions
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
      | title           | body         | field_tool_category | moderation_state |
      | DataSystem Tool | this is tool | Data Systems        | published        |
      And "data_set" content:
      | title         | field_dataset_description | field_dataset_source_type | field_how_to_request_access | moderation_state |
      | BEHAT dataset | description               | FINRA                     | '' - http://test.com        | published        |
      And "article" content:
      | title       | body        | field_category | moderation_state |
      | 456 Article | article one | FAQ            | published        |
      And "data_insight" content:
      | title      | body             | field_data_search_index | moderation_state |
      | 24 Insight | This is the body | index                   | published        |
      And I run cron
    When I am on "/"
      And I select the first autocomplete option for "datasystem" on the "edit-term" field in the "homepage_search" region
    Then I should see the heading "DataSystem Tool"
      And I am on "/"
      And I select the first autocomplete option for "behat" on the "edit-term" field in the "homepage_search" region
      And I should see the heading "BEHAT dataset"
      And I am on "/"
      And I select the first autocomplete option for "456" on the "edit-term" field in the "homepage_search" region
      And I should see the heading "456 Article"
      And I am on "/"
      And I select the first autocomplete option for "24" on the "edit-term" field in the "homepage_search" region
      And I should see the heading "24 Insight"

  @api @javascript
  Scenario: Catalog Homepage Recently Updated Information Block
    Given "data_set" content:
      | title      | field_dataset_description | field_dataset_source_type | moderation_state | changed |
      | 1DATASET10 | Dataset 10 description    | NRSRO, Fitch              | published        | -1 min  |
      | 2DATASET20 | Dataset 20 description    | NRSRO, Fitch              | published        | -2 min  |
      | 3DATASET20 | Dataset 30 description    | NRSRO, Fitch              | published        | -11 min |
      | 4DATASET20 | Dataset 40 description    | NRSRO, Fitch              | published        | -12 min |
      And "article" content:
      | title              | body                | field_category | moderation_state | changed |
      | 7BEHAT Article One | Article description | Other          | published        | -3 min  |
      And "data_insight" content:
      | title            | body                 | moderation_state | changed |
      | 10BEHAT Insight1 | Insight description1 | published        | -4 min  |
      | 10BEHAT Insight1 | Insight description1 | published        | -13 min |
      And "statistics" content:
      | title          | body             | moderation_state | changed |
      | BEHAT Reports1 | This is the body | published        | -5 min  |
      And "page" content:
      | title      | body        | field_summary | moderation_state | changed |
      | BEHAT Page | description | summary       | published        | -6 min  |
      And "platform" content:
      | title            | body         | field_summary | moderation_state | changed |
      | Behat Platform 1 | description1 | summary1      | published        | -7 min  |
      And "application" content:
      | title               | body         | field_summary | moderation_state | changed |
      | Behat Application 1 | description1 | summary1      | published        | -8 min  |
      And "component" content:
      | title           | body                        | field_status_usage | moderation_state | changed |
      | BEHAT Component | Description about component | Approved           | published        | -9 min  |
      And "component_category" terms:
      | name            | field_icon |
      | BEHAT Category1 | landmark   |
    When I am logged in as a user with the "sitebuilder" role
      And I am on "/technology-standards/behat-category1/edit"
      And I fill in "Short Description" with "Test"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I run cron
      And I am on "/"
    Then I should see the heading "Recently Updated Information"
      # And I should see "BEHAT Category1 (Technology Category)"  DSITE-4963 -Bug
      And I should see "1DATASET10 (Dataset)"
      And I should see "7BEHAT Article One (Article)"
      And I should see "10BEHAT Insight1 (Data Insight)"
      And I should see "BEHAT Reports1 (Reports and Statistics)"
      And I should see "BEHAT Page (Informational Page)"
      And I should see "Behat Platform 1 (Platform)"
      And I should see "Behat Application 1 (Application)"
      And I should see "BEHAT Component (Software)"
      And "BEHAT Category1" should precede "1DATASET10" for the query "//span[contains(@class, 'field-content')]/a"
      And "1DATASET10" should precede "2DATASET20" for the query "//span[contains(@class, 'field-content')]/a"
      And "2DATASET20" should precede "7BEHAT Article One" for the query "//span[contains(@class, 'field-content')]/a"
      And "7BEHAT Article One" should precede "10BEHAT Insight1" for the query "//span[contains(@class, 'field-content')]/a"
      And "10BEHAT Insight1" should precede "BEHAT Reports1" for the query "//span[contains(@class, 'field-content')]/a"
      And "BEHAT Reports1" should precede "BEHAT Page" for the query "//span[contains(@class, 'field-content')]/a"
      And "BEHAT Page" should precede "Behat Platform 1" for the query "//span[contains(@class, 'field-content')]/a"
      And "Behat Platform 1" should precede "Behat Application 1" for the query "//span[contains(@class, 'field-content')]/a"
      And "Behat Application 1" should precede "BEHAT Component" for the query "//span[contains(@class, 'field-content')]/a"

  @api @javascript
  Scenario: Content Approver Can Edit Catalog HomePage
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/catalog/layout"
    Then I should see the heading "Edit layout for Catalog"
      And I should see "Edit"
      And I click on the element with css selector "#block-adminimal-theme-primary-local-tasks > nav > nav > ul > li:nth-child(2) > a"
      And I type "This is the behat home page" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Landing Page Catalog has been updated."
    And I am logged in as a user with the "Content Approver" role
    When I am on "/catalog/edit"
      And I select "Review" from "Change to"
      And I press "Save"
    Then I should see the text "This is the behat home page"
      And I select "Published" from "Change to"
      And I press "Apply"
      And I should see the text "The moderation state has been updated"

  @api @javascript
  Scenario: Update Welcome Message And Recently Updated Block To Catalog Homepage
    Given "application" content:
      | title             | body        | field_summary | moderation_state | changed  |
      | Behat Application | body        | summary       | published        | +10 days |
      And "article" content:
      | title             | body                      | moderation_state | changed |
      | Behat Article1    | Article description       | published        | +9 days |
      | Behat Article2    | Article description       | published        | +1 days |
      And "component" content:
      | title              | body                  | field_status_usage | moderation_state | changed |
      | Behat Component    | Component description | Approved           | published        | +8 days |
      And "data_insight" content:
      | title             | body                      | moderation_state | changed |
      | Behat Insight1    | Insight description1      | published        | +7 days |
      And "data_set" content:
      | title             | field_dataset_description | moderation_state | changed |
      | Behat Dataset1    | This is Dataset1          | published        | +6 days |
      | Behat Dataset2    | This is Dataset1          | published        | +30 min |
      And "page" content:
      | title             | body        | field_summary | moderation_state | changed |
      | Behat Info Page   | description | summary       | published        | +5 days |
      And "statistics" content:
      | title             | body                      | moderation_state | changed |
      | Behat Stats1      | This is the body          | published        | +4 days |
      And "platform" content:
      | title              | body        | field_summary | moderation_state | changed |
      | Behat platform one | description | summary       | published        | +3 days |
      And I create "taxonomy_term" of type "component_category":
      | name              | field_icon | changed |
      | Behat TechCatTerm | landmark   | +2 days |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/"
    Then I should see "Welcome to the SEC Catalog!"
      And I should see "Search for datasets or technology" in the "homepage_search" region
      And I should see the heading "Recently Updated Information" in the "recently_updated" region
      # Check for all 9 types, details and updated date value
      And I should see the link "Behat Application" in the "1st_updated_info" region
      And I should see the text "(Application)" in the "1st_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "1st_updated_info" region
      And I should see the link "Behat Article1" in the "2nd_updated_info" region
      And I should see the text "(Article)" in the "2nd_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "2nd_updated_info" region
      And I should see the link "Behat Component" in the "3rd_updated_info" region
      And I should see the text "(Software)" in the "3rd_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "3rd_updated_info" region
      And I should see the link "Behat Insight1" in the "4th_updated_info" region
      And I should see the text "(Data Insight)" in the "4th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "4th_updated_info" region
      And I should see the link "Behat Dataset1" in the "5th_updated_info" region
      And I should see the text "(Dataset)" in the "5th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "5th_updated_info" region
      And I should see the link "Behat Info Page" in the "6th_updated_info" region
      And I should see the text "(Informational Page)" in the "6th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "6th_updated_info" region
      And I should see the link "Behat Stats1" in the "7th_updated_info" region
      And I should see the text "(Reports and Statistics)" in the "7th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "7th_updated_info" region
      And I should see the link "Behat platform one" in the "8th_updated_info" region
      And I should see the text "(Platform)" in the "8th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "8th_updated_info" region
      And I should see the link "Behat TechCatTerm" in the "9th_updated_info" region
      And I should see the text "(Technology Category)" in the "9th_updated_info" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "9th_updated_info" region
      # Check for sorted order of last updated date
      And I should see the link "Behat Application" before I see the link "Behat Article1" in the "recently_updated" region
      And I should see the link "Behat Article1" before I see the link "Behat Component" in the "recently_updated" region
      And I should see the link "Behat Component" before I see the link "Behat Insight1" in the "recently_updated" region
      And I should see the link "Behat Insight1" before I see the link "Behat Dataset1" in the "recently_updated" region
      And I should see the link "Behat Dataset1" before I see the link "Behat Info Page" in the "recently_updated" region
      And I should see the link "Behat Info Page" before I see the link "Behat Stats1" in the "recently_updated" region
      And I should see the link "Behat Stats1" before I see the link "Behat platform one" in the "recently_updated" region
      And I should see the link "Behat platform one" before I see the link "Behat TechCatTerm" in the "recently_updated" region
      And I should see the link "Behat TechCatTerm" before I see the link "Behat Article2" in the "recently_updated" region
      # Check for actual updated date
      And I should see the date "+10 day" in the "div.layout__region.layout__region--second > section > div > div > div > div:nth-child(1)" selector
      And I should see the date "+9 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(2)" selector
      And I should see the date "+8 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(3)" selector
      And I should see the date "+7 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(4)" selector
      And I should see the date "+6 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(5)" selector
      And I should see the date "+5 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(6)" selector
      And I should see the date "+4 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(7)" selector
      And I should see the date "+3 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(8)" selector
      And I should see the date "+2 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(9)" selector
      And I should see the date "+1 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(10)" selector
      # Check for most recent 10 only
      But I should not see the link "Behat Dataset2" in the "recently_updated" region
    When I click "Behat TechCatTerm"
    Then I should see the heading "Behat TechCatTerm"
    When I am on "/"
    Then I should see "More Updates" in the "recently_updated" region
    When I click "More Updates"
    Then I should see the heading "Recently Updated Information"
      And I should see the link "Behat Dataset2"
