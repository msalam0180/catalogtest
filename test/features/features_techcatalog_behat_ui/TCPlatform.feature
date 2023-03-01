Feature: Create Platform Content For WDIO
  As a Content Creator, I should be able to create Platform page.

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      | division3 |
      | division4 |
      | division5 |
      | division6 |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Approve   | check       | #00695C            |
      | BEHAT Exception | exclamation | #EAAD23            |
      | BEHAT Retire    | check       | #AF2525            |
      And "component_category" terms:
      | name            | parent         |
      | BEHAT Category  |                |
      | BEHAT Category1 | BEHAT Category |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      | BEHAT Use Case3 |                 |
      | BEHAT Use Case4 |                 |
      | BEHAT Use Case5 | BEHAT Use Case1 |
      And users:
      | name     | mail              | pass | roles            |
      | approver | approver@test.com |      | Content Approver |
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
      And "manufacturer" terms:
      | name     |
      | Sony     |

  @ui @api @javascript @wdio
  Scenario: Platform Page For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "platform" content:
      | title    | body        | field_summary | field_manufacturer | field_approved_version | field_division_office_multi | field_status_usage | moderation_state |
      | platform | description | summary1      | Sony               | Version X-Y-Z          | division1                   | BEHAT Exception    | published        |
    Then I take a screenshot using "platform.feature" file with "@new_platform" tag
      And I am logged in as a user with the "authenticated user" role
    Then I take a screenshot using "platform.feature" file with "@new_platform" tag

  @ui @api @javascript @wdio
  Scenario: Global Search With Platform For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "platform" content:
      | title           | body             | field_summary     | field_division_office_multi | moderation_state |
      | BEHAT Platform1 | This is the body | platform in short | division1                   | published        |
      | BEHAT Platform2 | This is the body | platform Summary  | division1                   | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "plat" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I take a screenshot using "search.feature" file with "@platform_search" tag

  @ui @api @javascript @wdio
  Scenario: Adding Contact To Platform For WDIO
    Given "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | firstname        | lastname        | user@email.com | published        |
      And "platform" content:
      | title         | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage |
      | BEHAT Contact | description | summary       | published        | division1                   | BEHAT Approve      |
      And "roles" terms:
      | name       |
      | BEHAT Role |
      And I am logged in as a user with the "Content Approver" role
      And I visit "/platforms/behat-contact/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contacts with Roles"
      And I wait for ajax to finish
      And I press "Add existing Contact"
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
      And I select contact "BEHAT Role" from "edit-field-contacts-0-subform-field-role"
      And I wait for ajax to finish
      And I press "Save"
    Then I take a screenshot using "platform.feature" file with "@contact_to_platform" tag

  @ui @api @javascript @wdio
  Scenario: Adding Article To Platform For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "faq_category" terms:
      | name      |
      | Behat FAQ |
      And "article" content:
      | title                   | body        | moderation_state | field_article_summary | field_category |
      | Behat plat and article1 | article one | published        | summary1              | Behat FAQ      |
      | Behat article2          | article two | published        | summary2              | Behat FAQ      |
      And "platform" content:
      | title                     | body        | field_summary | moderation_state | field_division_office_multi | field_related_articles                 | field_status_usage |
      | BEHAT Article To Platform | description | summary       | published        | division1                   | Behat plat and article1,Behat article2 | BEHAT Approve      |
    Then I take a screenshot using "platform.feature" file with "@article_to_platform" tag

  @ui @api @javascript @wdio
  Scenario: Adding Contact Guidance To Platform For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "platform" content:
      | title                           | body        | field_summary | moderation_state | field_division_office_multi | field_contact_guidance | field_status_usage |
      | BEHAT platform contact guidance | description | summary       | published        | division1                   | Behat Contact Guidance | BEHAT Approve      |
    Then I take a screenshot using "platform.feature" file with "@contact_guidance_to_platform" tag

  @ui @api @javascript @wdio
  Scenario: Platform With Logo For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "platform" content:
      | title                    | body        | field_summary | field_division_office_multi | field_logo | moderation_state | field_status_usage |
      | BEHAT Platform With Logo | description | summary       | division1                   | SQL Logo   | published        | BEHAT Approve      |
    Then I take a screenshot using "platform.feature" file with "@plat_with_logo" tag

  @ui @api @javascript @wdio
  Scenario: Adding Document To Platform For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "platform" content:
      | title          | body             | field_summary     | field_division_office_multi | moderation_state | field_documents   | field_status_usage |
      | BEHAT Document | This is the body | platform in short | division1                   | published        | Behat File Upload | BEHAT Approve      |
    Then I take a screenshot using "platform.feature" file with "@document_to_platform" tag

  @ui @api @javascript @wdio
  Scenario: Platform List Page For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title              | body         | field_summary | moderation_state | field_division_office_multi |
      | Behat Application1 | description2 | summary1      | published        | division1                   |
      | Behat Application2 | description2 | summary2      | published        | division1                   |
      | Behat Application3 | description2 | summary3      | published        | division1                   |
      And "platform" content:
      | title              | body        | field_summary     | field_status_usage | field_division_office_multi | field_logo | field_related_apps                                         | moderation_state |
      | A BEHAT platform1  | description | summary           | BEHAT Approve      | division1                   | SQL Logo   | Behat Application1, Behat Application2                     | published        |
      | BEHAT platform2    | description | summary           | BEHAT Exception    | division1                   | Edgar Logo | Behat Application1, Behat Application2, Behat Application3 | published        |
      | C BEHAT platform3  | description | summary           | BEHAT Retire       | division1                   |            |                                                            | published        |
      | D BEHAT platform4  | description | Short Description | BEHAT Approve      | division1                   | Edgar Logo | Behat Application2                                         | published        |
      | E BEHAT platform5  | description | summary           | BEHAT Exception    | division1                   | SQL Logo   |                                                            | published        |
      | P BEHAT platform6  | description | summary           | BEHAT Retire       | division1                   |            |                                                            | published        |
      | S BEHAT platform7  | description | summary           | BEHAT Approve      | division1                   | Edgar Logo | Behat Application3                                         | published        |
      | 5 BEHAT platform8  | description | summary           | BEHAT Exception    | division1                   | SQL Logo   |                                                            | published        |
      | W BEHAT platform9  | description | summary           | BEHAT Retire       | division1                   |            | Behat Application3                                         | published        |
      | X BEHAT platform10 | description | summary           | BEHAT Retire       | division1                   | Edgar Logo |                                                            | published        |
    Then I take a screenshot using "platform.feature" file with "@platform_list_page" tag

  @ui @api @javascript @wdio
  Scenario: Platform With Tech Category For WDIO
    Given "platform" content:
      | title                    | body             | field_summary     | field_division_office_multi | field_status_usage | field_component_category | moderation_state |
      | BEHAT Plat Tech Category | This is the body | platform in short | division1                   | BEHAT Approve      | BEHAT Category1          | published        |
    Then I take a screenshot using "platform.feature" file with "@plat_tech_category" tag

  @ui @api @javascript @wdio
  Scenario: Platform With All Fields For WDIO
    Given I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And I create "media" of type "image":
      | name     | field_media_image  | field_caption     |
      | SQL Logo | behat-sql-logo.png | Behat SQL Caption |
      And "tags" terms:
      | name  |
      | sales |
      And "component" content:
      | title              | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Related Comp | This is the Summary | Component description | Approved           | published        |
      And "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | Behat            | Contact         | user@email.com | published        |
      And "article" content:
      | title                 | body      | field_article_summary | moderation_state |
      | BEHAT Related Article | Behat FAQ | Article1 Summary      | published        |
      And "application" content:
      | title             | body        | field_summary | moderation_state | field_division_office_multi |
      | BEHAT Application | description | summary       | published        | division1                   |
      And I am logged in as a user with the "authenticated user" role
      And "platform" content:
      | title              | body        | field_summary | field_logo | field_division_office_multi | field_related_apps | field_related_components | field_contact_guidance | field_related_articles | field_documents   | moderation_state | field_tags | field_status_usage | field_short_name | field_how_to_request_access | field_platform_link  |
      | Platform Full Page | description | summary1      | SQL Logo   | division1                   | BEHAT Application  | BEHAT Related Comp       | Behat Guidance         | BEHAT Related Article  | Behat File Upload | published        | sales      | BEHAT Approve      | Plat             | '' - http://test.com        | '' - http://test.com |
    Then I take a screenshot using "platform.feature" file with "@platform_full_page" tag
      And I take a screenshot using "platform.feature" file with "@breadcrumb" tag

  @ui @api @javascript @wdio
  Scenario: Platform With Related Applications For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title       | body         | field_summary | moderation_state | field_logo | field_division_office_multi |
      | 1Behat App  | description1 | summary1      | published        | SQL Logo   | division1                   |
      | QBehat App  | description2 | summary2      | published        | Edgar Logo | division1                   |
      | J Behat App | description3 | summary3      | published        |            | division1                   |
      | 3 Behat App | description4 | summary4      | published        |            | division1                   |
      | Y Behat App | description5 | summary5      | published        |            | division1                   |
      And "platform" content:
      | title           | body         | field_summary | field_status_usage | field_division_office_multi | field_related_apps                                             | moderation_state |
      | Behat Platform1 | description1 | summary1      | BEHAT Retire       | division1                   | 1Behat App, QBehat App , J Behat App, 3 Behat App, Y Behat App | published        |
      And I take a screenshot using "platform.feature" file with "@app_to_platform" tag

  @ui @api @javascript @wdio
  Scenario: Platform With How To Request Access For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "platform" content:
      | title                         | body         | field_summary | field_status_usage | field_division_office_multi | field_how_to_request_access | field_logo | moderation_state |
      | Behat Platform Request Access | description1 | summary1      | BEHAT Retire       | division1                   | '' - http://test.com        | SQL Logo   | published        |
    Then I take a screenshot using "platform.feature" file with "@request_access" tag

  @ui @api @javascript @wdio
  Scenario: Platform With Platform Link For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "platform" content:
      | title               | body         | field_summary | field_status_usage | field_division_office_multi | field_platform_link  | field_logo | moderation_state |
      | Behat Platform Link | description1 | summary1      | BEHAT Retire       | division1                   | '' - http://test.com | SQL Logo   | published        |
    Then I take a screenshot using "platform.feature" file with "@plat_link" tag

  @ui @api @javascript @wdio
  Scenario: Platform With UseCase For WDIO
      And "platform" content:
      | title         | body        | field_summary | field_division_office_multi | field_dataset_use | moderation_state |
      | BEHAT UseCase | description | summary1      | division1                   | BEHAT Use Case3   | published        |
    Then I take a screenshot using "platform.feature" file with "@use_case" tag

  @ui @api @wdio
  Scenario: Platform With Multi Select Fields For WDIO
    Given I am viewing a "platform" content:
      | title                       | BEHAT Multi Select Field Plat                                                            |
      | body                        | body                                                                                     |
      | field_summary               | summary                                                                                  |
      | field_division_office_multi | division1, division2, division3, division4, division5, division6                         |
      | field_component_category    | BEHAT Category1                                                                          |
      | field_status_usage          | BEHAT Retire                                                                             |
      | field_dataset_use           | BEHAT Use Case1, BEHAT Use Case2, BEHAT Use Case3, BEHAT Use Case4, BEHAT Use Case5      |
      | field_tags                  | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, January, February, March |
      | moderation_state            | published                                                                                |
      | field_reviewer              | approver                                                                                 |
    Then I take a screenshot using "platform.feature" file with "@plat_multi_select" tag

  @ui @api @javascript @wdio
  Scenario: Platform With Request Access and Link For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "platform" content:
      | title               | body         | field_summary | field_status_usage | field_division_office_multi | field_platform_link  | field_how_to_request_access | field_logo | moderation_state |
      | Behat Platform Link | description1 | summary1      | BEHAT Retire       | division1                   | '' - http://test.com | '' - http://test.com        | SQL Logo   | published        |
    Then I take a screenshot using "platform.feature" file with "@access_link" tag
