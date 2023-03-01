Feature: Create Application Content For WDIO
  As a Content Creator, I should be able to create Application page.

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      | division3 |
      | division4 |
      | division5 |
      | division6 |
      And "faq_category" terms:
      | name        |
      | Behat FAQ   |
      | Behat Other |
      And "application_type" terms:
      | name           |
      | BEHAT Type     |
      | BEHAT App Type |
      And "dataset_registrant_type" terms:
      | name               | parent             |
      | BEHAT Entity Type1 |                    |
      | BEHAT Entity Type2 | BEHAT Entity Type1 |
      | BEHAT Entity Type3 | BEHAT Entity Type1 |
      | BEHAT Entity Type4 | BEHAT Entity Type1 |
      | BEHAT Entity Type5 | BEHAT Entity Type1 |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "hosting_location" terms:
      | name    |
      | Virtual |
      And "status" terms:
      | name          | field_icon | field_icon |
      | BEHAT Approve | check      | #00695C    |
      And "component_category" terms:
      | name            | parent          |
      | BEHAT Category0 |                 |
      | BEHAT Category1 | BEHAT Category0 |
      | BEHAT Category2 | BEHAT Category0 |
      | BEHAT Category3 |                 |
      | BEHAT Category4 | BEHAT Category0 |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case3 |                 |
      | BEHAT Use Case1 | BEHAT Use Case3 |
      | BEHAT Use Case2 | BEHAT Use Case3 |
      | BEHAT Use Case4 | BEHAT Use Case3 |
      | BEHAT Use Case5 | BEHAT Use Case3 |
      And users:
      | name     | mail              | pass | roles            |
      | approver | approver@test.com | ca   | Content Approver |
      | auth     | auth@test.com     | auth |                  |
      And "tags" terms:
      | name      |
      | Monday    |
      | Tuesday   |
      | Wednesday |
      | Thursday  |
      | Friday    |
      | Saturday  |
      | Sunday    |
      | January   |
      | February  |
      | March     |

  @ui @api @javascript @wdio
  Scenario: View Application As Logged-In User For WDIO
    Given "application" content:
      | title        | body        | field_summary | field_number_of_users | field_approved_version | field_app_status  | field_division_office_multi | field_owner | moderation_state |
      | Application1 | description | summary1      | 10                    | Version X-Y-Z          | BEHAT Status A    | division1                   | division2   | published        |
    Then I take a screenshot using "application.feature" file with "@new_application_ca" tag

  @ui @api @javascript @wdio
  Scenario: View Application As Authenticated User For WDIO
    Given "application" content:
      | title        | body        | field_summary | field_number_of_users | field_approved_version | field_app_status  | field_division_office_multi | field_owner | moderation_state |
      | Application2 | description | summary2      | 10                    | Version X-Y-Z          | BEHAT Status A    | division1                   | division2   | published        |
    Then I take a screenshot using "application.feature" file with "@new_application_au" tag

  @ui @api @javascript @wdio
  Scenario: Global Search For Application For WDIO
    Given I am logged in as a user with the "administrator" role
      And "application" content:
      | title           | body        | field_summary | field_division_office_multi | field_owner | field_app_status | moderation_state |
      | Zee Application | description | bacon         | division1                   | division2   | BEHAT Status A   | published        |
      | Messy Search    | description | summary1      | division2                   | division2   | BEHAT Status A   | published        |
    When I am on "/applications/Zee-Application/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I press "Add Related Application"
      And I wait for ajax to finish
      And I select the first autocomplete option for "Messy Search" on the "Application" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I run drush "cr"
      And I run cron
    Then I take a screenshot using "application.feature" file with "@search_application" tag
      And I take a screenshot using "application.feature" file with "@filter_application" tag
      And I take a screenshot using "application.feature" file with "@integrate_application" tag
      And I take a screenshot using "application.feature" file with "@applications_search" tag

  @ui @api @javascript @wdio
  Scenario: Add Related Datasets To An Application For WDIO
    Given "data_set" content:
      | title          | field_dataset_description | moderation_state |
      | BEHAT Dataset1 | This is dataset           | published        |
    Given I am logged in as a user with the "Administrator" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Dataset To Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I fill in "Number of SEC Users" with "50"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I scroll to the top
      And I wait 1 seconds
      And I click "Related Technologies"
      And I wait 1 seconds
      And I press "Add Related Dataset"
      And I select the autocomplete option for "BEHAT Dataset1" on the "Related Dataset" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "application.feature" file with "@dataset_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Add Related Software To An Application For WDIO
    Given "component" content:
      | title            | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Component1 | This is the Summary | Component description | Approved           | published        |
      And I am logged in as a user with the "Administrator" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Component To Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I fill in "Number of SEC Users" with "50"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I scroll to the top
      And I wait 1 seconds
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "BEHAT Component1" on the "Related Software" field
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I take a screenshot using "application.feature" file with "@component_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Adding Contact To Application For WDIO
    Given "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | firstname        | lastname        | user@email.com | published        |
      And "application" content:
      | title         | body        | field_summary | field_owner | moderation_state | field_division_office_multi | field_app_status |
      | BEHAT Contact | description | summary       | division2   | published        | division1                   | BEHAT Status A   |
      And "roles" terms:
      | name       |
      | BEHAT Role |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-contact/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@contact_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Add Article To Application For WDIO
    Given  "article" content:
      | title          | body | field_category | field_article_summary | moderation_state |
      | BEHAT Article1 | test | Behat FAQ      | Article1 Summary      | published        |
      | BEHAT Article2 | test | Behat Other    |                       | published        |
      And I am logged in as a user with the "Administrator" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Article To Application"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
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
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "application.feature" file with "@article_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Adding Contact Guidance To Application For WDIO
    Given "application" content:
      | title                              | body        | field_summary | moderation_state | field_division_office_multi | field_contact_guidance |
      | BEHAT Application contact guidance | description | summary       | published        | division1                   | Behat Contact Guidance |
    Then I take a screenshot using "application.feature" file with "@contact_guidance_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Application With Logo For WDIO
    Given I create "media" of type "image":
      | name     | field_media_image  | field_caption     |
      | SQL Logo | behat-sql-logo.png | Behat SQL Caption |
      And  "application" content:
      | title                       | body        | field_summary | field_division_office_multi | field_logo | moderation_state |
      | BEHAT Application With Logo | description | summary       | division1                   | SQL Logo   | published        |
    Then I take a screenshot using "application.feature" file with "@app_with_logo" tag

  @ui @api @javascript @wdio
  Scenario: Application With Screenshot For WDIO
    Given I create "media" of type "image":
      | name           | field_media_image   | field_caption                |
      | App Screenshot | behat-CreateApp.png | Behat App Screenshot Caption |
      And  "application" content:
      | title                             | body        | field_summary | field_division_office_multi | field_owner | field_screenshots | moderation_state |
      | BEHAT Application With Screenshot | description | summary       | division1                   | division2   | App Screenshot    | published        |
    Then I take a screenshot using "application.feature" file with "@app_with_screenshot" tag

  @ui @api @javascript @wdio
  Scenario: Application With How To Request Access For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
      | title                                 | body        | field_summary | field_number_of_users | field_division_office_multi | field_how_to_request_access | moderation_state |
      | BEHAT Application With Request Access | description | summary1      | 10                    | division1                   | '' - http://test.com        | published        |
    Then I take a screenshot using "application.feature" file with "@request_access" tag

  @ui @api @javascript @wdio
  Scenario: Add Document To Application For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "application" content:
      | title          | body        | field_summary | moderation_state | field_division_office_multi | field_documents   |
      | BEHAT Document | description | summary       | published        | division1                   | Behat File Upload |
    Then I take a screenshot using "application.feature" file with "@document_to_app" tag

  @ui @api @javascript @wdio
  Scenario: Add Application Link For WDIO
    Given I am logged in as a user with the "Administrator" role
    When I am on "/node/add/application"
      And I fill in "Title" with "WDIO Application Link"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Status A" from "Status"
      And I select "division2" from "Owner"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I fill in "Application Link" with "http://webdriver.io/"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@app_link" tag

  @ui @api @javascript @wdio
  Scenario: Add Application Type For WDIO
    Given "application" content:
      | title          | body        | field_summary | field_division_office_multi | field_owner | field_application_type | moderation_state |
      | BEHAT App Type | description | summary1      | division1                   | division2   | BEHAT Type             | published        |
    Then I take a screenshot using "application.feature" file with "@application_type" tag

  @ui @api @javascript @wdio
  Scenario: Add Type Of External Users For WDIO
    Given "application" content:
      | title              | body        | field_summary | field_division_office_multi | field_owner | field_type_of_external_user | moderation_state |
      | BEHAT App External | description | summary1      | division1                   | division2   | BEHAT Entity Type1          | published        |
    Then I take a screenshot using "application.feature" file with "@type_of_external_user" tag

  @ui @api @javascript @wdio
  Scenario: Add Permissions And Usage For WDIO
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_application_type | field_permissions_and_usage  | moderation_state |
      | BEHAT Permissions | description | summary1      | division1                   | division2   | BEHAT Type             | This is the permissions area | published        |
    Then I take a screenshot using "application.feature" file with "@permissions_usage" tag

  @ui @api @javascript @wdio
  Scenario: Application With Tech Category For WDIO
      And "application" content:
      | title               | body        | field_summary | field_technology_category         | moderation_state |
      | BEHAT Tech Category | description | summary1      | BEHAT Category1,  BEHAT Category2 | published        |
    Then I take a screenshot using "application.feature" file with "@tech_category" tag

  @ui @api @javascript @wdio
  Scenario: Application With Use Case For WDIO
      And "application" content:
      | title         | body        | field_summary | field_division_office_multi | field_owner | field_dataset_use | moderation_state |
      | BEHAT UseCase | description | summary1      | division1                   | division2   | BEHAT Use Case3   | published        |
    Then I take a screenshot using "application.feature" file with "@use_case" tag
      And I take a screenshot using "application.feature" file with "@use_case_taxonomy" tag

  @ui @api @javascript @wdio
  Scenario: Application With All Fields For WDIO
    Given I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And I create "media" of type "image":
      | name           | field_media_image   | field_caption                |
      | App Screenshot | behat-CreateApp.png | Behat App Screenshot Caption |
      | SQL Logo       | behat-sql-logo.png  | Behat SQL Caption            |
      And "component" content:
      | title              | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Related Comp | This is the Summary | Component description | Approved           | published        |
      And "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | Behat            | Contact         | user@email.com | published        |
      And "roles" terms:
      | name       |
      | BEHAT Role |
      And "tags" terms:
      | name       |
      | accounting |
      | sales      |
      And "platform" content:
      | title              | body        | field_summary | field_division_office_multi | field_status_usage | moderation_state |
      | BEHAT Related Plat | description | summary       | division1                   | BEHAT Approve      | published        |
      And "article" content:
      | title                 | body      | field_article_summary | moderation_state |
      | BEHAT Related Article | Behat FAQ | Article1 Summary      | published        |
      And  "data_set" content:
      | title                 | field_dataset_description | moderation_state |
      | BEHAT Related Dataset | This is dataset           | published        |
      And "application" content:
      | title             | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Application | description | summary1      | division1                   | published        |
      And "application" content:
      | title                 | body        | field_summary | field_app_status | field_application_type | field_hosting_location | field_application_link | field_how_to_request_access | field_owner | field_number_of_users | field_division_office_multi | field_number_of_external_users | field_type_of_external_user | field_logo | field_related_components | field_related_platforms | field_cer_datasets    | field_contact_guidance | field_related_articles | field_documents   | field_screenshots | moderation_state | field_tags        | field_permissions_and_usage     | field_technology_category | field_short_name | field_dataset_use |
      | Application Full Page | description | summary1      | BEHAT Status A   | BEHAT Type             | Virtual                | '' - http://test.com   | '' - http://test.com        | division2   | 10                    | division1                   | 1-500                          | BEHAT Entity Type1          | SQL Logo   | BEHAT Related Comp       | BEHAT Related Plat      | BEHAT Related Dataset | Behat Guidance         | BEHAT Related Article  | Behat File Upload | App Screenshot    | published        | accounting, sales | Who can access this application | BEHAT Category1           | Short            | BEHAT Use Case3   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/applications/application-full-page/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I press "Add Related Application"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application" on the "Application" field
      And I wait 1 seconds
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "Behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@application_full_page" tag
      And I take a screenshot using "application.feature" file with "@breadcrumb" tag
      And I take a screenshot using "application.feature" file with "@application_fields" tag

  @ui @api @wdio
  Scenario: Application With Multi Select Fields For WDIO
    Given I am viewing a "application" content:
      | title                          | BEHAT Multi Select Field App                                                                       |
      | body                           | body text                                                                                          |
      | field_summary                  | short summary                                                                                      |
      | field_technology_category      | BEHAT Category0, BEHAT Category1, BEHAT Category2, BEHAT Category3, BEHAT Category4                |
      | field_number_of_users          | 5                                                                                                  |
      | field_owner                    | division2                                                                                          |
      | field_hosting_location         | Virtual                                                                                            |
      | field_division_office_multi    | division1, division2, division3, division4, division5, division6                                   |
      | field_permissions_and_usage    | This is the permissions                                                                            |
      | field_how_to_request_access    | '' - http://test.com                                                                               |
      | field_app_status               | BEHAT Status A                                                                                     |
      | field_number_of_external_users | more than 1000                                                                                     |
      | field_application_type         | BEHAT App Type                                                                                     |
      | field_dataset_use              | BEHAT Use Case1, BEHAT Use Case2, BEHAT Use Case3, BEHAT Use Case4, BEHAT Use Case5                |
      | field_type_of_external_user    | BEHAT Entity Type1, BEHAT Entity Type2, BEHAT Entity Type3, BEHAT Entity Type4, BEHAT Entity Type5 |
      | field_tags                     | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, January, February, March           |
      | field_reviewer                 | approver                                                                                           |
      | moderation_state               | published                                                                                          |
    Then I take a screenshot using "application.feature" file with "@app_multi_select" tag

  @ui @api @javascript @wdio
  Scenario: Hide Unpublished Integrated Content For WDIO
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | edit-moderation-state-0-state |  field_app_status  |  field_reviewer   |  field_owner  |
      | BEHAT Application | description | summary1      | division1                   | Draft        |  BEHAT Status A    |  approver         |  division2    |
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
    Then I take a screenshot using "application.feature" file with "@Application_Integration" tag

  @ui @api @javascript @wdio
  Scenario: Application With Request Access and Aplication Link For WDIO
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application Link"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "Active" from "Status"
      And I select "DERA" from "Owner"
      And I fill in "Application Link" with "http://webdriver.io/"
      And I fill in "How to Request Access" with "https://www.google.com"
      And I select "Published" from "edit-moderation-state-0-state"
      And I wait for ajax to finish
      And I scroll to the bottom
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I take a screenshot using "application.feature" file with "@request_Visit" tag
