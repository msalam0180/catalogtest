Feature: Application Content Type
  As a content creator I want to be able to create an application node
  So that a site visitor will have access to the application information to review the details of the platform

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "faq_category" terms:
      | name        |
      | Behat FAQ   |
      | Behat Other |
      And I create "media" of type "image":
      | name              | field_media_image    | field_caption                   |
      | SQL Logo          | behat-sql-logo.png   | Behat SQL Caption               |
      | Edgar Logo        | behat-edgar-logo.png | Behat Edgar Caption             |
      | App Screenshot    | behat-CreateApp.png  | Behat App Screenshot Caption    |
      | Search Screenshot | behat-search.png     | Behat Search Screenshot Caption |
      And "tags" terms:
      | name       |
      | automation |
      | sales      |
      And "application_type" terms:
      | name            |
      | BEHAT Type      |
      | BEHAT COTS/GOTS |
      | BEHAT Custom    |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      | BEHAT Status B |
      And "hosting_location" terms:
      | name    |
      | Virtual |
      | local   |
      And "dataset_registrant_type" terms:
      | name               | parent             |
      | BEHAT Entity Type1 |                    |
      | BEHAT Entity Type2 | BEHAT Entity Type1 |
      | BEHAT Entity Type3 |                    |
      And I create "taxonomy_term" of type "status":
      | name         | field_icon | field_status_color |
      | BEHAT Retire | leaf       | #AF2525            |
      And I create "taxonomy_term" of type "component_category":
      | name            | parent         | field_summary | field_icon |
      | BEHAT Category  |                | Summary1      | landmark   |
      | BEHAT Category1 | BEHAT Category | Summary1      | building   |
      | BEHAT Category2 | BEHAT Category | Summary1      | cat        |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      | BEHAT Use Case3 |                 |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |

  @api @javascript
  Scenario Outline: Authorized Users Can Create An Application
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Name" with "Short"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I select "BEHAT Status A" from "Status"
      And I select "BEHAT Type" from "Application Type"
      And I fill in "How to Request Access" with "http://google.com"
      And I select "division2" from "Owner"
      And I fill in "Number of SEC Users" with "50"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I press "field_division_office_multi_add_more"
      And I wait for ajax to finish
      And I select "division2" from "Divisions/Offices that use this " for the "1" option of the "2" row
      And I type "Who has permission to access this application?" in the "Permissions and Usage" WYSIWYG editor
      And I select "1-500" from "How many external users?"
      And I select "BEHAT Entity Type1" from "Type of External User" for the "1" option of the "1" row
      And I select "BEHAT Use Case1" from "Use Cases" for the "1" option of the "1" row
      And I select "BEHAT Use Case2" from "Use Cases" for the "2" option of the "1" row
      And I click on the element with css selector "#edit-field-dataset-use-add-more"
      And I wait for ajax to finish
      And I select "BEHAT Use Case3" from "Use Cases" for the "1" option of the "2" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application (Short)"
      And I should see the text "This is the description of the topic"
      And I should see the text "Created"
      And I should not see the text "BEHAT Forum"
      And I should see the text "Snapshot"
      And I should see the text "Status"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
      And I should see the link "BEHAT Status A"
      And I should see the text "Owner"
      And I should see the link "division2"
      And I should see the text "Number of SEC Users"
      And I should see the text "50"
      And I should see the text "SEC Users"
      And I should see the link "division1"
      And I should see the text "Permissions"
      And I should see the text "Who has permission to access this application?"
      And I should see the text "Number of External Users"
      And I should see the text "1-500"
      And I should see the text "External Users"
      And I should see the link "BEHAT Entity Type1"
      And I should see the text "Use Cases"
      And I should see the link "BEHAT Use Case2"
      And I should see the link "BEHAT Use Case3"
      And I should not see the link "BEHAT Use Case1"
      And I should see the text "Type"
      And I should see the link "BEHAT Type"
      And I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/applications" in the "breadcrumb" region
      And I should see the link "Request Access"
      And I click "Request Access"
      And the link should open in a new tab
      And I close the current tab

    Examples:
    | role                              |
    | content_approver, migration_admin |
    | content_creator, migration_admin  |

  @api @javascript
  Scenario: Application Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Creator" role
    When I am viewing a "application" content:
      | title            | Behat Application |
      | body             | body              |
      | field_summary    | summary           |
      | moderation_state | published         |
      And I wait 3 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait for ajax to finish
    Then I should see the text "Edit Application Behat Application"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit An Application
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "application" content:
      | title                          | BEHAT Application       |
      | body                           | body                    |
      | field_summary                  | summary                 |
      | field_technology_category      | BEHAT Category1         |
      | field_number_of_users          | 5                       |
      | field_owner                    | division2               |
      | field_division_office_multi    | division1               |
      | field_permissions_and_usage    | This is the permissions |
      | field_how_to_request_access    | '' - http://test.com    |
      | field_app_status               | BEHAT Status A          |
      | field_number_of_external_users | more than 1000          |
      | field_application_type         | BEHAT COTS/GOTS         |
      | field_reviewer                 | approver                |
      | moderation_state               | published               |
    Then I should see the heading "BEHAT Application"
      And I should see the text "body"
      And I should see the text "Category"
      And I should see the link "BEHAT Category1"
      And I should see the text "Owner"
      And I should see the link "division2"
      And I should see the text "Number of SEC Users"
      And I should see the text "5"
      And I should see the text "SEC Users"
      And I should see the link "division1"
      And I should see the text "Permissions"
      And I should see the text "This is the permissions"
      And I should see the text "Number of External Users"
      And I should see the text "more than 1000"
      And I should see the link "Request Access"
      And I should see the link "BEHAT Status A"
      And I should see the link "BEHAT COTS/GOTS"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Application" row
      And I fill in "Title" with "BEHAT Edited Application"
      And I select "- Please select -" from "Technology Category" for the "1" option of the "1" row
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I select "BEHAT Type" from "Application Type"
      And I fill in "Number of SEC Users" with "40"
      And I fill in "How to Request Access" with ""
      And I select "None" from "How many external users?"
      And I select "division2" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I type "Edited this permission" in the "Permissions and Usage" WYSIWYG editor
      And I press "Save"
      And I wait 1 seconds
    Then I should see the link "BEHAT Edited Application"
      And I should not see the link "BEHAT Application"
    When I click "BEHAT Edited Application"
    Then I should see the heading "BEHAT Edited Application"
      And I should not see the text "Category"
      And I should not see the link "BEHAT Category1"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
      And I should see the text "40"
      And I should see the link "division2"
      And I should see the text "BEHAT Type"
      And I should see the text "Edited this permission"
      And I should not see the link "division1"
      And I should not see the link "Request Access"
      And I should not see the text "Number of External Users"
      And I should not see the link "BEHAT COTS/GOTS"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario Outline: Authorized Users Can Delete An Application
    Given "application" content:
      | title             | body        | field_summary | moderation_state |
      | BEHAT Application | description | summary       | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Application" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should see the text "The Application BEHAT Application has been deleted."
    When I am on "/behat-application"
    Then I should see "Page not found"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario Outline: Viewing An Application As Site Visitor
    Given I am logged in as a user with the "authenticated user" role
    When I am viewing a "application" content:
      | title                       | BEHAT Application  |
      | body                        | Body               |
      | field_summary               | Summary            |
      | field_number_of_users       | 5                  |
      | field_owner                 | division2          |
      | field_division_office_multi | division1          |
      | field_approved_version      | Version X-Y-Z      |
      | field_app_status            | BEHAT Status A     |
      | field_application_type      | BEHAT Type         |
      | field_hosting_location      | Virtual            |
      | field_dataset_use           | BEHAT Use Case3    |
      | field_type_of_external_user | BEHAT Entity Type1 |
      | field_tags                  | automation, sales  |
      | moderation_state            | published          |
    Then I should see the heading "BEHAT Application"
      And I should see the text "Body"
      And I should not see the text "Summary"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
      And I should see the text "Status"
      And I should see the link "BEHAT Status A"
      And I should see the text "Owner"
      And I should see the link "division2"
      And I should see the text "Number of SEC Users"
      And I should see the text "SEC Users"
      And I should see the link "division1"
      And I should see the text "External Users"
      And I should see the link "BEHAT Entity Type1"
      And I should see the text "Hosting Location"
      And I should see the link "Virtual"
      And I should see the text "Type"
      And I should see the link "BEHAT Type"
      And I should see the link "automation"
    When I click "<link>"
    Then I should see the heading "<link>"
      And I should see the text "<text1>"
      And I should see the text "Application"
      And I should see the text "<text2>"
      And I should see the link "<app>"
    When I click "<app>"
    Then I should see the heading "<app>"

    Examples:
      | link               | text1           | text2              | app               |
      | BEHAT Status A     | Related Content | Application Status | BEHAT Application |
      | division1          | Related Content | Division/Office    | BEHAT Application |
      | BEHAT Entity Type1 | Related Content | Entity Type        | BEHAT Application |
      | BEHAT Use Case3    | Related Content | Use Case           | BEHAT Application |
      | BEHAT Type         | Related Content | Application Type   | BEHAT Application |
      | Virtual            | Related Content | Hosting Location   | BEHAT Application |
      | automation         | Related Content | Tags               | BEHAT Application |

  @api
  Scenario Outline: Verify Application Page URL
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
      And "application" content:
      | title                   | body        | field_summary | moderation_state |
      | BEHAT.Application.Title | description | summary1      | published        |
      | BEHAT application TWO   | another     | summary2      | published        |
    When I am on "<URL>"
    Then I should see the heading "<heading>"

    Examples:
      | URL                                 | heading                 |
      | /applications/behatapplicationtitle | BEHAT.Application.Title |
      | /applications/behat-application-two | BEHAT application TWO   |

  @api
  Scenario: Verify Required Fields And HelpTexts
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
    Then I should see the text "*Fields marked with an asterisk(*) are required."
      And I should see the text "Short name is the acronym or shortened version of the title"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Technology Category"
      And I should see the text "If you choose to add a Technology Category, you MUST always select a term from EACH new drop down that appears."
      And I should see the text "What is the URL to allow a user to request access?"
      And I should see the text "What are the common use cases?"
      And I should see the text "External users include the public, registered entities, or other federal or state government agencies"
      And I should see the text 'If the application has multiple links, please add them in the "Detailed Description" field'
      And I should see the text "Horizontal Orientation instead of vertical orientation - some logos have multiple orientations - Horizontal is best."
      And I should see the text "Height of 100px or Larger"
      And I should see the text "Transparent background is preferred, but white background can be used if necessary"
      And I should see the text "Crop out extra space around the logo"
      And I should see the link "Read more about Logo Optimization"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
      And I press "Add new Logo"
      And I press "Add new Screenshot"
      And I press "Add Related Application"
      And I press "Add Contact"
      And I press "Add new Document"
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
    When I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Detailed Description field is required."
      And I should see the text "Owner field is required."
      And I should see the text "Application field is required."
      And I should see the text "Contact field is required."
      And I should see the text "Role field is required."
      And I should see the text "Name field is required."
      And I should see the text "File field is required."
      And I should see the text "Description field is required."
      And I should see the text "Image field is required."
      And I should see the text "Status field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api
  Scenario: Application Page Show Published
    Given "application" content:
      | title               | body         | field_summary | moderation_state |
      | Behat Application 1 | description1 | summary1      | published        |
      | Behat Application 2 | description2 | summary2      | draft            |
    When I run drush "cr"
      And I run cron
      And I am logged in as a user with the "authenticated user" role
      And I am on "/applications"
    Then I should see the text "Behat Application 1"
      And I should not see the text "Behat Application 2"

  @api @javascript
  Scenario: Integrate Two Applications
    Given "application" content:
      | title               | body         | field_summary | field_division_office_multi | field_owner | field_reviewer | moderation_state | field_app_status |
      | Behat Application 1 | description1 | summary1      | division1                   | division2   | approver       | draft            | BEHAT Status A   |
      | Behat Application 2 | description2 | summary2      | division1                   | division2   | approver       | published        | BEHAT Status B   |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I press "Add Related Application"
      And I wait for ajax to finish
      And I select the first autocomplete option for "Behat Application 2" on the "Application" field
      And I fill in "Description of Relationship" with "testing integration"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the link "Behat Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"
      And I should see the text "BEHAT Status A"
      And I click "Behat Application 2"
      And I should see the link "Behat Application 1"
      And I should see the heading "Behat Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"
      And I should see the text "BEHAT Status B"

  @api @javascript
  Scenario: Edit Application Integrate Between Two Applications
    Given "application" content:
      | title               | body         | field_summary | field_division_office_multi | field_owner | moderation_state | field_app_status |
      | Behat Application 1 | description1 | summary1      | division1                   | division2   | published        | BEHAT Status A   |
      | Behat Application 2 | description2 | summary2      | division1                   | division2   | published        | BEHAT Status B   |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I press "Add Related Application"
      And I wait for ajax to finish
      And I select the first autocomplete option for "Behat Application 2" on the "Application" field
      And I fill in "Description of Relationship" with "testing integration"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the link "Behat Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"
      And I should see the text "BEHAT Status A"
      And I click "Behat Application 2"
      And I should see the link "Behat Application 1"
      And I should see the heading "Behat Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"
      And I should see the text "BEHAT Status B"
    When I am on "/applications/behat-application-2/edit"
      And I fill in "Title" with "Update BEHAT Application 2"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the link "Update BEHAT Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"
      And I click "Update BEHAT Application 2"
      And I should see the link "Behat Application 1"
      And I should see the heading "Update BEHAT Application 2"
      And I should see the text "testing integration"
      And I should see the text "Integrations"

  @api @javascript
  Scenario: Integrate Application And Datasets
    Given "application" content:
      | title               | body         | field_summary | field_owner | field_division_office_multi | field_app_status | field_reviewer | moderation_state |
      | Behat Application 1 | description1 | summary1      | division2   | division1                   | BEHAT Status A   | approver       | published        |
      And "data_set" content:
      | title         | moderation_state |
      | BEHAT dataset | published        |
      | BEHAT ds2     | published        |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I press "Add Related Dataset"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT dataset" on the "Related Dataset" field
      And I select "Location" from "Technology & Dataset Relationship"
      And I press "Save"
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the text "Datasets"
      And I should see the link "BEHAT dataset"
      And I should see the text "Location"
      And I click "BEHAT dataset"
      And I should see the heading "BEHAT dataset"
      And I should see the text "Related Technology"
      And I should see the link "Behat Application 1"
      And I should see the text "Location"
    When I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I press "Add Related Dataset"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT ds2" on the "Related Dataset" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the text "Datasets"
      And I should see the link "BEHAT dataset"
      And I should see the link "BEHAT ds2"
      And I click "BEHAT ds2"
      And I should see the heading "BEHAT ds2"
      And I should see the text "Related Technology"
      And I should see the link "Behat Application 1"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT dataset"
      And I should not see the text "location"
      And I should see the link "BEHAT ds2"

  @api @javascript
  Scenario: Application Search Results Page
    Given "application" content:
      | title                | field_summary | moderation_state |
      | Behat Application 1  | summary1      | published        |
      | Behat Application 2  | summary2      | published        |
      | Behat Application 3  | summary3      | published        |
      | Behat Application 4  | summary4      | published        |
      | Behat Application 5  | summary5      | published        |
      | Behat Application 6  | summary6      | published        |
      | Behat Application 7  | summary7      | published        |
      | Behat Application 8  | bacon         | published        |
      | Behat Application 9  | summary9      | published        |
      | Behat Application 10 | summary10     | published        |
      | Behat Application 11 | summary11     | published        |
      | Behat Application 12 | summary12     | published        |
      | Behat Application 13 | summary13     | published        |
      | Behat Application 14 | summary14     | published        |
      | Behat Application 15 | summary15     | published        |
      | Behat Application 16 | summary16     | published        |
      | Behat Application 17 | summary17     | published        |
      | Behat Application 18 | summary18     | published        |
      | Behat Application 19 | summary19     | published        |
      | Behat Application 20 | summary20     | published        |
      | Behat Application 21 | summary21     | published        |
      | Behat Application 22 | summary22     | published        |
      | Behat Application 23 | summary23     | draft            |
      | Search               | summary24     | published        |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications"
    Then I should see the text "Search Terms"
      And I should see the text "Related Platforms"
      And I should see the text "Owner"
      And I should see the text "Used By Division/Office"
      And I should see the text "External Users"
      And I should see the text "Status"
      And I should see the link "Behat Application 1"
      And "summary1" should precede "summary10" for the query "//div[contains(@class, 'view-list-img')]"
      And I should see the text "Showing 1 - 20 of 23 Applications"
      And I scroll to the bottom
      And I should see the link "1"
      And I click "Last »"
      And I wait for ajax to finish
      And I should see the text "summary9"
      And I wait for ajax to finish
      And I click "1"
      And I wait for ajax to finish
      And I should see the text "summary7"

  @api
  Scenario Outline: Filter Search On Application Search
    Given "platform" content:
      | title            | body         | field_summary | moderation_state |
      | Behat Platform 1 | description1 | summary1      | published        |
      | Behat Platform 2 | description1 | summary1      | published        |
      And "application" content:
      | title               | body          | field_summary | moderation_state | <field_name> |
      | Behat Application 1 | description1  | summary1      | published        | <value1>     |
      | Behat Application 2 | description2  | summary2      | published        | <value2>     |
      | Behat Application 8 | description8  | bacon         | published        |              |
      | Search              | description24 | summary24     | published        |              |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications"
      And <search1>
      And I press "Search"
      And I wait 3 seconds
    Then I should see the link "<result_value1>"
    When I press "Reset"
      And <search2>
      And I press "Search"
      And I wait 3 seconds
    Then I should see the link "<result_value2>"

    Examples:
      | search_filter | search1                                              | search2                                              | field_name                  | value1             | value2             | result_value1       | result_value2       |
      | Search Term   | I fill in "Search Terms" with "Search"               | I fill in "Search Terms" with "bacon"                | field_data_search_index     |                    |                    | Search              | Behat Application 8 |
      | Short Name    | I fill in "Search Terms" with "mno"                  | I fill in "Search Terms" with "WER"                  | field_short_name            | MNO                | WER                | Behat Application 1 | Behat Application 2 |
      | Key Search    | I fill in "Search Terms" with "Ford"                 | I fill in "Search Terms" with "Amazon"               | field_data_search_index     | Ford               | Amazon; Andes      | Behat Application 1 | Behat Application 2 |
      | Tags          | I fill in "Search Terms" with "automation"           | I fill in "Search Terms" with "sales"                | field_tags                  | automation         | sales              | Behat Application 1 | sales               |
      | Platform      | I select "Behat Platform 1" from "Related Platforms" | I select "Behat Platform 2" from "Related Platforms" | field_related_platforms     | Behat Platform 1   | Behat Platform 2   | Behat Application 1 | Behat Platform 2    |
      | Owner         | I select "division1" from "Owner"                    | I select "division2" from "Owner"                    | field_owner                 | division1          | division2          | Behat Application 1 | Behat Application 2 |
      | Used By       | I select "division1" from "Used By Division/Office"  | I select "division2" from "Used By Division/Office"  | field_division_office_multi | division1          | division2          | Behat Application 1 | Behat Application 2 |
      | Type          | I select "BEHAT Type" from "Type"                    | I select "BEHAT COTS/GOTS" from "Type"               | field_application_type      | BEHAT Type         | BEHAT COTS/GOTS    | Behat Application 1 | Behat Application 2 |
      | Location      | I select "Virtual" from "Hosting Location"           | I select "local" from "Hosting Location"             | field_hosting_location      | Virtual            | local              | Behat Application 1 | Behat Application 2 |
      | External      | I select "BEHAT Entity Type1" from "External Users"  | I select "BEHAT Entity Type2" from "External Users"  | field_type_of_external_user | BEHAT Entity Type1 | BEHAT Entity Type2 | Behat Application 1 | Behat Application 2 |
      | Status        | I select "BEHAT Status A" from "Status"              | I select "BEHAT Status B" from "Status"              | field_app_status            | BEHAT Status A     | BEHAT Status B     | Behat Application 1 | Behat Application 2 |

  @api @javascript
  Scenario: Application Typeahead Search
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title           | body             | field_summary          | field_app_status | field_owner | ield_division_office_multi | moderation_state |
      | New Application | This is the body | Summary of Application | BEHAT Status A   | division2   | division1                  | published        |
      | 46 App          | This is the body | Summary of Application | BEHAT Status A   | division2   | division1                  | published        |
      | Test App        | This is the body | Summary of Application | BEHAT Status A   | division2   | division1                  | published        |
      | App Suggestion  | This is the body | Summary of Application | BEHAT Status A   | division2   | division1                  | published        |
      And I run cron
    When I am on "/applications"
      And I select the first autocomplete option for "new" on the "Search Terms" field
    Then I should see the heading "New Application"
    When I am on "/applications"
      And I select the first autocomplete option for "46" on the "Search Terms" field
    Then I should see the heading "46 App"
    When I am on "/applications"
      And I select the first autocomplete option for "test" on the "Search Terms" field
    Then I should see the heading "Test App"
    When I am on "/applications"
      And I select the first autocomplete option for "suggestion" on the "Search Terms" field
    Then I should see the heading "App Suggestion"

  @api @javascript
  Scenario: Add Related Datasets To An Application
    Given "data_set" content:
      | title          | field_dataset_description | moderation_state |
      | BEHAT Dataset1 | This is dataset           | published        |
      | BEHAT Dataset2 | This is dataset           | published        |
      And I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Related Technologies"
      And I press "Add Related Dataset"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT Dataset1" on the "Related Dataset" field
      And I select "Location" from "Technology & Dataset Relationship"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am on "/applications/behat-application/edit"
      And I click "Related Technologies"
      And I press "Add Related Dataset"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT Dataset2" on the "Related Dataset" field
      And I select "Location" from "Technology & Dataset Relationship"
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset1"
      And I should see the link "BEHAT Dataset2"
    When I click "BEHAT Dataset1"
    Then I should not see the link "Related Content" in the "horizotal_tabs" region
      And I should not see "Applications"
      And I should not see the link "BEHAT Application"
    When I am on "/datasets/behat-dataset2"
    Then I should not see the link "Related Content" in the "horizotal_tabs" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/datasets/behat-dataset1"
    Then I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application"

  @api @javascript
  Scenario: Add Related Software To An Application
    Given "component" content:
      | title            | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Component1 | This is the Summary | Component description | Approved           | published        |
      | BEHAT Component2 | This is the Summary | Component description | Retired            | published        |
      And I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Related Technologies"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Component1" on the "Related Software" field
      And I click on the element with css selector "#edit-field-related-components-add-more"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Component2" on the "Related Software (value 2)" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Software"
      And I should see the link "BEHAT Component1"
      And I should see the link "BEHAT Component2"
      And I should see the "a" element with the "class" attribute set to "btn btn-sm btn-status--00695C" in the "sidebar" region
      And I should see the "a" element with the "class" attribute set to "btn btn-sm btn-status--AF2525" in the "sidebar" region
      And I hover over the element "a[href='/software/behat-component1']"
      And I should see the text "Approved"
      And I hover over the element "a[href='/software/behat-component2']"
      And I should see the text "Retired"
      And I click "BEHAT Component1"
      And I should see the heading "BEHAT Component1"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component1"
    Then I should see the heading "BEHAT Component1"
      And I should not see the link "BEHAT Application"
      And I am logged in as a user with the "Content Approver" role
    When I am on "/applications/behat-application"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
      And I run drush "cr"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Software"
      And I should see the link "BEHAT Component1"
      And I should see the link "BEHAT Component2"
    When I click "BEHAT Component1"
    Then I should see the heading "BEHAT Component1"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application"

  @api @javascript
  Scenario: Edit Related Software And Dataset And Verify On Applications Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_category" terms:
      | name      |
      | category1 |
      And "component" content:
      | title           | field_summary       | body                  | field_status_usage | field_division_office_multi | moderation_state |
      | BEHAT Component | This is the Summary | Component description | Approved           | division1                   | published        |
      And "data_set" content:
      | title         | field_summary | field_dataset_description | moderation_state | field_division_office_multi | field_owner | field_data_category | field_reviewer |
      | BEHAT Dataset | behat short   | This is dataset           | published        | division2                   | division1   | category1           | approver       |
      And I am viewing a "application" content:
      | title                       | BEHAT Application       |
      | body                        | This is application one |
      | field_summary               | Application  summary    |
      | field_owner                 | division2               |
      | field_related_components    | BEHAT Component         |
      | field_division_office_multi | division1               |
      | field_app_status            | BEHAT Status A          |
      | moderation_state            | published               |
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application" on the "Related Technology" field
      And I scroll to the top
      And I click "Governance"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I press "Save"
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
      And I should see the link "BEHAT Dataset"
      And I should see the text "BEHAT Status A"
    When I am on "/software/behat-component/edit"
      And I fill in "Title" with "BEHAT Edited Component"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am on "/datasets/behat-dataset/edit"
      And I fill in "Title" with "BEHAT Edited Dataset"
      And I press "Save"
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Software"
      And I should see the link "BEHAT Edited Component"
      And I should see the link "BEHAT Edited Dataset"
      And I should not see the link "BEHAT Component"
      And I should not see the link "BEHAT Dataset"

  @api @javascript
  Scenario: Delete Related Software And Dataset And Verify On Applications Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_category" terms:
      | name      |
      | category1 |
      And "component" content:
      | title           | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Component | This is the Summary | Component description | Approved           | published        |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
      And "data_set" content:
      | title         | field_summary | field_dataset_description | moderation_state | field_division_office_multi | field_owner | field_data_category | field_reviewer | field_open_government_data_class | field_open_government_data_acces |
      | BEHAT Dataset | behat short   | This is dataset           | published        | division2                   | division1   | category1           | approver       | DAclassification                 | DAaccess                         |
      And I am viewing a "application" content:
      | title                       | BEHAT Application       |
      | body                        | This is application one |
      | field_summary               | Application  summary    |
      | field_owner                 | division2               |
      | field_related_components    | BEHAT Component         |
      | field_cer_datasets          | BEHAT Dataset           |
      | field_division_office_multi | division1               |
      | field_app_status            | BEHAT Status A          |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application" on the "Related Technology" field
      And I press "Save"
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
      And I should see the link "BEHAT Dataset"
    When I navigate to the "/edit" page from the current url
      And I click "Related Technologies"
      And I fill in "Related Software (value 1)" with ""
      And I click "Related Technologies"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should not see the text "Software"
      And I should not see the link "BEHAT Component"
      And I should not see the link "BEHAT Dataset"
    When I am on "/software/behat-component"
      And I should see the heading "BEHAT Component"
    Then I should not see the link "BEHAT Application"
    When I am on "/datasets/behat-dataset"
      And I should see the heading "BEHAT Dataset"
    Then I should not see the link "Tools" in the "horizotal_tabs" region
      And I should see the link "BEHAT Application"

  @api
  Scenario: Verify Applications Page Created/Updated Label
    Given I am logged in as a user with the "authenticated user" role
      And I am viewing a "application" content:
      | title            | BEHAT Application Created |
      | body             | This is application one   |
      | field_summary    | Application one summary   |
      | field_owner      | division2                 |
      | moderation_state | published                 |
      And I should see the text "Created"
      And I am viewing a "application" content:
      | title            | BEHAT Application Updated |
      | body             | This is application two   |
      | field_summary    | Application two summary   |
      | field_owner      | division2                 |
      | changed          | +5 day                    |
      | moderation_state | published                 |
    Then I should see the text "Updated"
      And I should not see the text "Created"

  @api @javascript
  Scenario: Integrate Applications And Platform
    Given "application" content:
      | title               | body         | field_summary | field_owner | field_division_office_multi | field_app_status | field_reviewer | moderation_state |
      | Behat Application 1 | description1 | summary1      | division2   | division1                   | BEHAT Status A   | approver       | published        |
      And "platform" content:
      | title            | body         | field_summary | field_status_usage |field_reviewer | moderation_state |
      | Behat Platform 1 | description1 | summary1      | BEHAT Retire       | approver      | published        |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application-1/edit"
      And I click "Related Technologies"
      And I select the first autocomplete option for "Behat Platform 1" on the "Related Platforms" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I am on "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should see the link "Behat Platform 1"
      And I should see the "a" element with the "class" attribute set to "btn btn-sm btn-status--AF2525" in the "sidebar" region
      And I hover over the element "a.btn > span:nth-child(2)"
      And I should see the text "BEHAT Retire"
      And I should see the text "Platform"
      And I click "Behat Platform 1"
      And I should see the link "Behat Application 1"
      And I should see the heading "Behat Platform 1"
      And I should see the text "Applications"

  @api @javascript
  Scenario: Add Existing Article To An Application
    Given "article" content:
      | title          | field_summary | body | field_category | field_article_summary | moderation_state | field_reviewer |
      | BEHAT Article1 | behat short   | test | Behat FAQ      | Article1 Summary      | published        | approver       |
      | BEHAT Article2 | Description   | test | Behat Other    |                       | published        | approver       |
      And I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
     And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Related Documentation"
      And I wait 1 seconds
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait 2 seconds
      And I switch to the "articles" selector
      And I wait 1 seconds
      And I fill in "Title" with "behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT Article1" on the files selector
      And I check "BEHAT Article2" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article1"
      And I should see the text "behat short"
      And I should see the link "BEHAT Article2"
      And I should see the text "Description"
      And I should see the link "Behat FAQ"
      And I should see the link "Behat Other"
    When I scroll to the bottom
      And I click "Behat FAQ"
    Then I should see the link "BEHAT Article1"
    When I click "BEHAT Article1"
    Then I should see the text "Applications"
      And I should see the link "BEHAT Application"
      And I click "BEHAT Application"
      And I should see the link "BEHAT Article1"

  @api
  Scenario: Edit Existing Article And Verify On Applications Page
    Given "article" content:
      | title         | field_summary | body | field_category | field_article_summary | moderation_state | field_reviewer |
      | BEHAT Article | behat short   | test | Behat FAQ      | Article Summary       | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "application" content:
      | title                       | BEHAT Application |
      | body                        | body              |
      | field_summary               | summary           |
      | field_number_of_users       | 5                 |
      | field_division_office_multi | division1         |
      | field_owner                 | division2         |
      | field_related_articles      | BEHAT Article     |
      | moderation_state            | published         |
      | field_reviewer              | approver          |
    Then I should see the heading "BEHAT Application"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the text "behat short"
      And I should see the link "Behat FAQ"
    When I am on "/behat-article/edit"
      And I fill in "Title" with "Edited Article"
      And I select "Behat Other" from "Category"
      And I press "Save"
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Articles"
      And I should not see the link "BEHAT Article"
      And I should see the link "Edited Article"
      And I should see the text "behat short"
      And I should not see the link "Behat FAQ"
      And I should see the link "Behat Other"

  @api @javascript
  Scenario: Delete Existing Article And Verify On Applications Page
    Given "article" content:
      | title         | field_summary | body | field_category | field_article_summary | moderation_state | field_reviewer |
      | BEHAT Article | behat short   | test | Behat FAQ      | Article Summary       | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "application" content:
        | title                       | BEHAT Application |
        | body                        | body              |
        | field_summary               | summary           |
        | field_number_of_users       | 5                 |
        | field_owner                 | division2         |
        | field_division_office_multi | division1         |
        | field_related_articles      | BEHAT Article     |
        | field_app_status            | BEHAT Status A    |
        | moderation_state            | published         |
        | field_reviewer              | approver          |
    Then I should see the heading "BEHAT Application"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the text "behat short"
      And I should see the link "Behat FAQ"
    When I am on "/applications/behat-application/edit"
      And I click "Related Documentation"
      And I click on the element with css selector "#edit-field-related-articles-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I check "Delete this Article from the system."
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should not see the text "Articles"
      And I should not see the link "BEHAT Article"
    When I am on "/behat-article/edit"
    Then I should see "Page not found"

  @api @javascript
  Scenario: Add New Logo To Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_app_status | moderation_state |
      | BEHAT Application | description | summary       | division1                   | division1   | BEHAT Status A   | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/applications/behat-application/edit"
      And I should see "Logo"
      And I press "Add new Logo"
      And I wait for ajax to finish
      And I fill in "Name" with "Catalog Logo"
      And I attach the file "behat-datacatalog-log.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Behat Catalog Logo"
      And I fill in "Caption" with "Behat Catalog Logo Caption"
      And I wait for ajax to finish
      And I press "Create Logo"
      And I wait 5 seconds
      And I select the autocomplete option for "approver " on the "Reviewer" field
      And I press "Save"
    Then I should see the text "Application BEHAT Application has been updated."
      And I should see "Access denied"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application/"
      And I should see the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Add Existing Logo To Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | moderation_state | field_app_status |
      | BEHAT Application | description | summary       | division1                   | division1   | published        | BEHAT Status A   |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/applications/behat-application/edit"
      And I should see "Logo"
      And I press "Add existing Logo"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for AJAX to finish
      And I switch to the iframe "entity_browser_iframe_images"
      And I wait for ajax to finish
      And I fill in "Edgar Logo" for "Media name"
      And I press "Apply"
      And I wait for ajax to finish
      And I click on the element with css selector "div.views-row:nth-child(1) > div:nth-child(3) > span"
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the autocomplete option for "approver " on the "Reviewer" field
      And I press "Save"
    Then I should see the text "Application BEHAT Application has been updated."
      And I should see "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application/"
    Then I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "logo" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "logo" region

  @api @javascript
  Scenario: Update Logo And Verify On Applications Page
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_logo | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division1   | SQL Logo   | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/edit"
      And I press "Edit" in the "create_logo" region
      And I wait for ajax to finish
      And I press "field_logo_form_inline_entity_form_entities_0_form_field_media_image_0_remove_button"
      And I wait for ajax to finish
      And I attach the file "behat-datacatalog-log.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Behat Catalog Logo"
      And I press "Update Logo"
      And I wait for ajax to finish
      And I press "Save"
    Then I should see "Application BEHAT Application has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-datacatalog-log" in the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Remove Logo From Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_logo | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division2   | SQL Logo   | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/edit"
      And I click on the element with css selector "#edit-field-logo-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should not see the "logo" region

  @api
  Scenario: Workflow For Contact Guidance On Application
    Given "application" content:
      | title             | body        | field_summary | moderation_state | field_division_office_multi | field_owner | field_contact_guidance | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | draft            | division1                   | division1   | Behat Contact Guidance | BEHAT Status A   | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications/behat-application"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Contacts"
      And I should see the text "description"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"
      And I should see the text "BEHAT Status A"

  @api @javascript
  Scenario: Authorized User Adding Contact Guidance To Application
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I wait 1 seconds
      And I click "Contacts"
      And I wait 1 seconds
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact, as needed"
      And I fill in "Contact Guidance" with "Behat Contact Guidance"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Contacts"
      And I should see the text "This is the description of the topic"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"
      And I should see the text "BEHAT Status A"

  @api @javascript
  Scenario: Add New Screenshot To Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division2   | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/applications/behat-application/edit"
      And I should see "SCREENSHOTS"
      And I press "Add new Screenshot"
      And I wait for ajax to finish
      And I fill in "Name" with "HomePage"
      And I attach the file "behat-HomePage.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Behat HomePage Screenshot"
      And I fill in "Caption" with "Behat HomePage Caption"
      And I wait for ajax to finish
      And I press "Create Screenshot"
      And I wait for ajax to finish
      And I press "Save"
    Then I should see the text "Application BEHAT Application has been updated."
      And I should see "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application/"
    Then I should see the text "Screenshots"
      And I should see the "img" element with the "alt" attribute set to "Behat HomePage Screenshot" in the "screenshot" region
      And I should see the text "Behat HomePage Caption"

  @api @javascript
  Scenario: Add Existing Screenshots To Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division2   | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/applications/behat-application/edit"
      And I should see "SCREENSHOTS"
      And I press "Add existing Screenshot"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for AJAX to finish
      And I switch to the iframe "entity_browser_iframe_images"
      And I wait for ajax to finish
      And I fill in "Screenshot" for "Media name"
      And I press "Apply"
      And I wait for ajax to finish
      And I click on the element with css selector "div.views-row:nth-child(1) > div:nth-child(3) > span"
      And I click on the element with css selector "div.views-row:nth-child(2) > div:nth-child(3) > span"
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Save"
    Then I should see the text "Application BEHAT Application has been updated."
      And I should see "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application/"
    Then I should see the "screenshot" region
      And I should see the "img" element with the "src" attribute set to "/behat-CreateApp" in the "screenshot" region
      And I should see the "img" element with the "src" attribute set to "/behat-search" in the "screenshot" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "screenshot" region
      And I should see the text "Behat App Screenshot Caption"
      And I should see the text "Behat Search Screenshot Caption"

  @api @javascript
  Scenario: Update Screenshot And Verify On Applications Page
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_screenshots | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division2   | App Screenshot    | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "screenshot" region
      And I should see the "img" element with the "src" attribute set to "/public/behat-CreateApp" in the "screenshot" region
      And I should see the text "Behat App Screenshot Caption"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/edit"
      And I press "Edit" in the "edit_screenshot" region
      And I wait for ajax to finish
      And I press "field_screenshots_form_inline_entity_form_entities_0_form_field_media_image_0_remove_button"
      And I wait for ajax to finish
      And I attach the file "behat-HomePage.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Behat HomePage Screenshot"
      And I fill in "Caption" with "Updated homepage screenshot"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "screenshot" region
      And I should see the "img" element with the "alt" attribute set to "Behat HomePage Screenshot" in the "screenshot" region
      And I should see the "img" element with the "src" attribute set to "/behat-HomePage" in the "screenshot" region
      And I should see the text "Updated homepage screenshot"
      And I should not see the text "Behat App Screenshot Caption"

  @api @javascript
  Scenario: Remove Screenshot From Application
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_screenshots | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1                   | division2   | App Screenshot    | published        | BEHAT Status A   | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the "screenshot" region
      And I should see the "img" element with the "src" attribute set to "/public/behat-CreateApp" in the "screenshot" region
      And I should see the text "Behat App Screenshot Caption"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/applications/behat-application/edit"
      And I press "edit-field-screenshots-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should not see the "screenshot" region
      And I should not see the text "Behat App Screenshot Caption"

  @api @javascript
  Scenario: Authorized users Adds Application Link
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I fill in "Application Link" with "http://webdriver.io/"
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "This is the description of the topic"
      And I should see the text "Created"
      And I should not see the text "BEHAT Forum"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the link "Visit BEHAT Application"
    When I click "Visit BEHAT Application"
    Then the link should open in a new tab
      And I should see the text "webdriverio"
      And I close the current tab
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I fill in "Short Name" with "Short"
      And I press "Save"
    Then I should see the link "Visit Short"
      And I should not see the link "Visit BEHAT Application"

  @api @javascript
  Scenario: Application With Internal App Link
    Given I am logged in as a user with the "Content Approver" role
      And "article" content:
      | title          | body | field_category | field_article_summary | moderation_state | nid   |
      | BEHAT Article1 | test | Behat FAQ      | Article1 Summary      | published        | 12345 |
      And I am viewing a "application" content:
      | title                       | BEHAT Application |
      | body                        | body              |
      | field_summary               | summary           |
      | field_owner                 | division2         |
      | field_division_office_multi | division1         |
      | field_app_status            | BEHAT Status A    |
      | field_reviewer              | approver          |
      | moderation_state            | published         |
    When I visit "/applications/behat-application/edit"
      And I select the autocomplete option for "BEHAT Article1" on the "Application Link" field
      And I press "Save"
      And I am on "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "body"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Owner"
      And I should see the link "Visit BEHAT Application"
    When I click "Visit BEHAT Application"
    Then the link should open in a new tab
      And I should be on "/behat-article1"
      And I should see the heading "BEHAT Article1"
      And I close the current tab

  @api @javascript
  Scenario: Authorized User Adds Document To Application
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Related Documentation"
      And I press "Add existing Document"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the "files" selector
      And I wait for ajax to finish
      And I fill in "Media name" with "behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat File Upload" on the files selector
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Video Media File"
      And I attach the file "behat-file.pdf" to "File"
      And I wait for ajax to finish
      And I fill in "field_documents[form][1][field_description][0][value]" with "Document Description"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "This is the description of the topic"
      And I should see the text "Documents"
      And I should see the text "Document Description"
      And I should see the link "Behat File Upload"
      And I should see the link "Video Media File"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
    When I scroll to the bottom
      And "Behat File Upload" should precede "Video Media File" for the query "//a[contains(@class, 'file-name media-title')]"
      And I click "Video Media File"
    Then the link should open in a new tab
      And I close the current tab
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I click "Related Documentation"
      And I wait for ajax to finish
      And I click on the element with css selector "#edit-field-documents > div > div.tabledrag-toggle-weight-wrapper > button"
      And I wait for ajax to finish
      And I select the option "3" from the jquery select "#edit-field-documents-entities-0-delta"
      And I press "Save"
    When I scroll to the bottom
    Then "Video Media File" should precede "Behat File Upload" for the query "//a[contains(@class, 'file-name media-title')]"

  @api @javascript
  Scenario Outline: Authorized User Adds Application Host
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "<location>" from "Hosting Location"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "This is the description of the topic"
      And I should see the text "Created"
      And I should not see the text "BEHAT Forum"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "<location>"
      And I should see the text "Hosting Location"

    Examples:
      | location     |
      | Virtual      |
      | Public Cloud |

  @api @javascript
  Scenario Outline: Verify Application Status
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "<status>" from "Status"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "This is the description of the topic"
      And I should see the text "Created"
      And I should not see the text "BEHAT Forum"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "<status>"

    Examples:
      | status         |
      | Active         |
      | In Development |
      | Retired        |

  @api @javascript
  Scenario Outline: Verify Application Type
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Short Summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "division2" from "Owner"
      And I select "BEHAT Status A" from "Status"
      And I select "<type>" from "Application Type"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/applications/behat-application"
    Then I should see the heading "BEHAT Application"
      And I should see the text "This is the description of the topic"
      And I should see the text "Created"
      And I should not see the text "BEHAT Short Summary"
      And I should see the text "Snapshot"
      And I should not see the text "Division/Office"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Type"
      And I should see the text "<type>"

    Examples:
      | type            |
      | COTS/GOTS       |
      | BEHAT Custom    |
      | Customized COTS |

  @api @javascript
  Scenario: Authorized User Adds External User
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "1-500" from "How many external users?"
      And I select "BEHAT Entity Type1" from "Type of External User" for the "1" option of the "1" row
      And I wait 1 seconds
      And I select "BEHAT Entity Type2" from "Type of External User" for the "2" option of the "1" row
      And I press "field_type_of_external_user_add_more"
      And I wait 3 seconds
      And I select "BEHAT Entity Type3" from "Type of External User" for the "1" option of the "2" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Number of External Users"
      And I should see the text "1-500"
      And I should see the text "External Users"
      And I should see the text "BEHAT Entity Type2"
      And I should see the text "BEHAT Entity Type3"
      And I should not see the text "BEHAT Entity Type1"

  @api @javascript
  Scenario: Applications List Landing Page
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/applications/edit"
    Then I should see the link "Layout"
      And I type "This is the behat description of the topic" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I should see the text "This is the behat description of the topic"

  @api @javascript
  Scenario: Application With Technology Category
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Category" from "Technology Category" for the "1" option of the "1" row
      And I select "BEHAT Category1" from "Technology Category" for the "2" option of the "1" row
      And I press "field_technology_category_add_more"
      And I wait for ajax to finish
      And I select "BEHAT Category" from "Technology Category" for the "1" option of the "2" row
      And I select "BEHAT Category2" from "Technology Category" for the "2" option of the "2" row
      And I should see the text "If you choose to add a Technology Category, you MUST always select a term from EACH new drop down that appears."
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should see the text "Category"
      And I should see the link "BEHAT Category"
      And I should see the link "BEHAT Category1"
      And I should see the link "BEHAT Category2"
    When I click "BEHAT Category"
    Then I should see the heading "BEHAT Category"
      And I should not see the link "BEHAT Application"

  @api @javascript
  Scenario: Create Application with Promote to Technology Standards Page
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Category" from "Technology Category" for the "1" option of the "1" row
      And I select "BEHAT Category1" from "Technology Category" for the "2" option of the "1" row
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I check "Promoted to Technology Standards"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/technology-standards"
    Then I should see the text "0 Items" in the "total_items" region
      And I click "BEHAT Category"
      And I should see the link "BEHAT Application"
      And I should see the text "BEHAT Summary"

  @api @javascript
  Scenario: Verify Discussions On Applications Detailed Page
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
      And "forums" terms:
      | name      |
      | App Forum |
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Related Discussions"
      And I should see "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
    When I click "Start a New Discussion"
      And the link should open in a new tab
      And I fill in "Title" with "BEHAT App Forum"
      And I select "App Forum" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
    Then I should see the text "Related Content"
      And I should see the link "BEHAT Application"
    When I click "BEHAT Application"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT App Forum"
      And I close the current window

  @api @javascript
  Scenario: Verify Application Page After Removing Use Case
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "application" content:
      | title                       | BEHAT Application |
      | body                        | Body              |
      | field_summary               | Summary           |
      | field_owner                 | division2         |
      | field_division_office_multi | division1         |
      | field_app_status            | BEHAT Status A    |
      | field_dataset_use           | BEHAT Use Case3   |
      | field_reviewer              | approver          |
      | moderation_state            | published         |
    Then I should see the heading "BEHAT Application"
      And I should see the text "Body"
      And I should not see the text "Summary"
      And I should see the link "division2"
      And I should see the link "division1"
      And I should see the link "BEHAT Status A"
      And I should see the link "BEHAT Use Case3"
    When I am on "/applications/behat-application/edit"
      And I select "" from "Use Cases" for the "1" option of the "1" row
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And I should not see the link "BEHAT Use Case3"

  @api
  Scenario: Admin Content Short Name Search For Application
    Given I am logged in as a user with the "Content Creator" role
      And "application" content:
      | title              | field_short_name | body             | moderation_state |
      | BEHAT Application1 | fruitloops       | This is the body | published        |
      | BEHAT Application2 | lucky charms     | This is the body | published        |
      And I run cron
    When I am on "/admin/content"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I fill in "Search" with "fruit"
      And I press "Filter"
    Then I should see the link "BEHAT Application1"
      And I should not see the link "BEHAT Application2"
    When I fill in "Search" with "lucky"
      And I press "Filter"
    Then I should see the link "BEHAT Application2"
      And I should not see the link "BEHAT Application1"

  @api @javascript
  Scenario: Application List Page Search Using Short Name And Autocomplete
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title              | field_short_name  | body             | moderation_state |
      | BEHAT Application3 | honeycomb         | This is the body | published        |
      | BEHAT Application4 | corn flakes       | This is the body | published        |
      And I run cron
    When I am on "/applications"
      And I select the first autocomplete option for "comb" on the "Search Terms" field
    Then I should see the heading "BEHAT Application3 (honeycomb)"
    When I am on "/applications"
      And I fill in "Search Terms" with "honey"
      And I press "Search"
    Then I should see the link "BEHAT Application3"
      And I should not see the link "BEHAT Application4"
    When I am on "/applications"
      And I fill in "Search Terms" with "flake"
      And I press "Search"
    Then I should see the link "BEHAT Application4"
      And I should not see the link "BEHAT Application3"

  @api
  Scenario Outline: Unauthorized Users cannot create an Application
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/application"
    Then I should see the text "Access Denied"
      And I should see the text "You are not authorized to access this page."

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Hide Unpublished Integrated Content For Authenticated User
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | edit-moderation-state-0-state | field_app_status | field_reviewer | field_owner |
      | BEHAT Application | description | summary1      | division1                   | Draft                         | BEHAT Status A   | approver       | division2   |
      And I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Integration To Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "Active" from "Status"
      And I select "DERA" from "Owner"
      And I select "Published" from "edit-moderation-state-0-state"
      And I scroll to the top
      And I click "Related Technologies"
      And I wait 1 seconds
      And I press "Add Related Application"
      And I wait for ajax to finish
      And I select the first autocomplete option for "Behat Application" on the "Application" field
      And I fill in "Description of Relationship" with "Receives data"
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the link "BEHAT Application"
      And I should see the text "Receives data"
    When I press "Preview as Enduser"
    Then I should see the text "You are masquerading as enduser"
      And I should not see the link "BEHAT Application"
      And I should not see the text "Receives data"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-integration-application"
    Then I should not see the text "Receives data"
