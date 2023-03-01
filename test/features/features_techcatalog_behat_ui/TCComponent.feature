Feature: Create Software Content Type For Image Comparison
  As a Content Creator, I should be able to create or edit a component page.

  Background:
    Given "component_category" terms:
      | name               | parent            |
      | BEHAT CC Header 1  |                   |
      | BEHAT Category     |                   |
      | BEHAT Category1    | BEHAT Category    |
      | BEHAT Category2    | BEHAT Category    |
      | BEHAT H1 Child 1   | BEHAT CC Header 1 |
      | BEHAT H1 Child 2   | BEHAT CC Header 1 |
      | A1 BEHAT Category  |                   |
      | A1 BEHAT Category1 | A1 BEHAT Category |
      | A1 BEHAT Category2 | A1 BEHAT Category |
      And "division_office" terms:
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
      And "status" terms:
      | name                    | field_icon  | field_status_color |
      | BEHAT Approve           | check       | #00695C            |
      | BEHAT Retire            | trash-alt   | #AF2525            |
      | BEHAT Exception         | info        | #00838F            |
      | BEHAT Recommended       | flag        | #436BC3            |
      | BEHAT Life Cycle Failed | leaf        | #C43E00            |
      | BEHAT Catalog           | exclamation | #EAAD23            |
      | BEHAT Unapproved        | check       | #585757            |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      | BEHAT Use Case3 |                 |
      | BEHAT Use Case4 |                 |
      | BEHAT Use Case5 |                 |
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
  Scenario: Create A Software For WDIO
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "Behat Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select the autocomplete option for "Sony" on the "Manufacturer" field
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I wait 1 seconds
      And I select the option "BEHAT Category" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I select "BEHAT Retire" from "Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I press "field_division_office_multi_add_more"
      And I wait 2 seconds
      And I select "division2" from "Divisions/Offices that use this" for the "1" option of the "2" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "component.feature" file with "@new_component" tag

  @ui @api @javascript @wdio
  Scenario: Global Search With Software For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title                  | body             | field_summary  | field_status_usage | field_division_office_multi | moderation_state |
      | BEHAT Component1       | This is the body | mango in short | BEHAT Approve      | division1                   | published        |
      | BEHAT Component2       | This is mango    | Summary        | BEHAT Recommended  | division1                   | published        |
      | BEHAT Mango Component3 | This is the text | Summary        | BEHAT Exception    | division1                   | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "mango" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I take a screenshot using "search.feature" file with "@component_search" tag

  @ui @api @javascript @wdio
  Scenario: Software And Platform Relationship For WDIO
    Given "platform" content:
      | title                  | body         | field_summary | field_status_usage | moderation_state |
      | Component and Platform | description1 | summary1      | BEHAT Approve      | published        |
      And "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_related_platforms |
      | Behat Component 1 | description1 | summary1      | BEHAT Recommended  | published        | Component and Platform  |
    Then I take a screenshot using "platform.feature" file with "@integration_component_platform" tag
      And I take a screenshot using "platform.feature" file with "@integration_platform_component" tag

  @ui @api @javascript @wdio
  Scenario: Software With Related Application For WDIO
    Given "application" content:
      | title              | body         | field_summary | moderation_state |
      | BEHAT Application2 | description1 | summary1      | published        |
      And "component" content:
      | title                            | body                        | field_summary | field_status_usage | moderation_state | field_related_apps |
      | BEHAT Component With Application | BEHAT Component Description | Behat summary | BEHAT Exception    | published        | BEHAT Application2 |
    Then I take a screenshot using "component.feature" file with "@app_to_component" tag

  @ui @api @javascript @wdio
  Scenario: Adding Contact To Software For WDIO
    Given "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | firstname        | lastname        | user@email.com | published        |
      And "component" content:
      | title         | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage |
      | BEHAT Contact | description | summary       | published        | division1                   | BEHAT Recommended  |
      And "roles" terms:
      | name       |
      | BEHAT Role |
      And I am logged in as a user with the "Content Approver" role
      And I visit "/software/behat-contact/edit"
      And I scroll to the top
      And I wait 1 seconds
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
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
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I take a screenshot using "component.feature" file with "@contact_to_component" tag

  @ui @api @javascript @wdio
  Scenario: Add Article To Software For WDIO
    Given  "article" content:
      | title          | body | field_category | field_article_summary | moderation_state |
      | BEHAT Article1 | test | Behat FAQ      | Article1 Summary      | published        |
      | BEHAT Article2 | test | Behat Other    |                       | published        |
      And I am logged in as a user with the "Administrator" role
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component With Article"
      And I fill in "Short Description" with "BEHAT summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approve" from "Approval Status"
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
      And I select "Published" from "Save as"
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I take a screenshot using "component.feature" file with "@article_to_comp" tag

  @ui @api @javascript @wdio
  Scenario: Software With Logo For WDIO
    Given I create "media" of type "image":
      | name     | field_media_image  | field_caption     |
      | SQL Logo | behat-sql-logo.png | Behat SQL Caption |
      And I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title                     | body        | field_summary | field_division_office_multi | field_status_usage | field_logo | moderation_state |
      | BEHAT Component With Logo | description | summary       | division1                   | BEHAT Recommended  | SQL Logo   | published        |
    Then I take a screenshot using "component.feature" file with "@comp_with_logo" tag

  @ui @api @javascript @wdio
  Scenario: Add Contact Guidance To Software For WDIO
    Given "component" content:
      | title                            | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_contact_guidance |
      | behat component contact guidance | description | summary       | published        | division1                   | BEHAT Recommended  | Behat Contact Guidance |
    Then I take a screenshot using "component.feature" file with "@contact_guidance_to_component" tag

  @ui @api @javascript @wdio
  Scenario: Adds Document To Software For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "component" content:
      | title          | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_documents   |
      | BEHAT Document | description | summary       | published        | division1                   | BEHAT Exception    | Behat File Upload |
    Then I take a screenshot using "component.feature" file with "@document_to_comp" tag

  @ui @api @javascript @wdio
  Scenario: Software Category Icon For WDIO
    Given I create "media" of type "image":
      | name     | field_media_image  | field_caption     |
      | SQL Logo | behat-sql-logo.png | Behat SQL Caption |
      And "component" content:
      | title            | field_summary | body                  | field_status_usage | field_division_office_multi | field_logo | moderation_state | field_promote_it_to_the_technolo | field_component_category |
      | BEHAT Component  | Summary       | Component description | BEHAT Approve      | division1                   |            | published        | 1                                | A1 BEHAT Category1       |
      | BEHAT Component2 | Summary       | Component description | BEHAT Approve      | division1                   | SQL Logo   | published        | 1                                | A1 BEHAT Category1       |
      And I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I click "Edit" in the "A1 BEHAT Category" row
      And I select the first autocomplete option for "landmark" on the "Icon" field
      And I press "Save"
      And I am on "/technology-standards"
    Then I take a screenshot using "component.feature" file with "@technology-standard" tag
      And I take a screenshot using "component.feature" file with "@category_icon" tag

  @ui @api @javascript @wdio
  Scenario: Software With All Fields For WDIO
    Given I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And I create "media" of type "image":
      | name     | field_media_image  | field_caption     |
      | SQL Logo | behat-sql-logo.png | Behat SQL Caption |
      And "tags" terms:
      | name  |
      | sales |
      And "contact" content:
      | field_first_name | field_last_name | field_email    | moderation_state |
      | Behat            | Contact         | user@email.com | published        |
      And "platform" content:
      | title              | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Related Plat | description | summary       | division1                   | published        |
      And "article" content:
      | title                 | body      | field_article_summary | moderation_state |
      | BEHAT Related Article | Behat FAQ | Article1 Summary      | published        |
      And "application" content:
      | title             | body        | field_summary | moderation_state | field_division_office_multi |
      | BEHAT Application | description | summary       | published        | division1                   |
      And I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title               | body        | field_summary | field_logo | field_division_office_multi | field_related_apps | field_related_platforms | field_contact_guidance | field_related_articles | field_documents   | moderation_state | field_tags | field_approved_version | field_restrictions | field_request_installation | field_component_category | field_promote_it_to_the_technolo | field_short_name | field_status_usage |
      | Component Full Page | description | summary1      | SQL Logo   | division1                   | BEHAT Application  | BEHAT Related Plat      | Behat Guidance         | BEHAT Related Article  | Behat File Upload | published        | sales      | Behat Version 1        | External Users     | '' - http://test.com       | BEHAT Category1          | 1                                | Comp             | BEHAT Recommended  |
    When I visit "/software/component-full-page"
    Then I take a screenshot using "component.feature" file with "@component_full_page" tag
      And I take a screenshot using "component.feature" file with "@breadcrumb" tag
      And I take a screenshot using "component.feature" file with "@component_approve_version" tag
      And I take a screenshot using "component.feature" file with "@component_restriction" tag

  @ui @api @javascript @wdio
  Scenario: Order Of Applications, Software And Platform For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title        | body             | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App1   | app description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      | A BEHAT App2 | app description2 | summary of app2 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 2          | SQL Logo   | 1                                |
      | BEHAT App3   | app description3 | summary of app3 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      | E BEHAT App1 | app description4 | summary of app4 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 2          | SQL Logo   | 1                                |
      | Z BEHAT App1 | app description5 | summary of app5 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      And "component" content:
      | title         | body         | field_summary | field_status_usage       | moderation_state | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | Behat Comp1   | description1 | summary1      | BEHAT Recommended        | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp2   | description1 | summary1      | BEHAT Approve            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | A Behat Comp3 | description1 | summary1      | BEHAT Approve            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | C Behat Comp4 | description1 | summary1      | BEHAT Exception          | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp5   | description1 | summary1      | BEHAT Retire             | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp6   | description1 | summary1      | BEHAT Exception          | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp7   | description1 | summary1      | BEHAT Unapproved         | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp8   | description1 | summary1      | BEHAT Retire             | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp9   | description1 | summary1      | BEHAT Catalog            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      And "platform" content:
      | title         | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | Behat Plat1   | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | A Behat Plat3 | description1 | summary1      | BEHAT Approve      | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | C Behat Plat4 | description1 | summary1      | BEHAT Exception    | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat5   | description1 | summary1      | BEHAT Catalog      | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat7   | description1 | summary1      | BEHAT Retire       | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat8   | description1 | summary1      | BEHAT Unapproved   | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      And I run cron
    When I am on "/technology-standards/behat-cc-header-1"
    Then I take a screenshot using "component.feature" file with "@status_order" tag

  @ui @api @javascript @wdio
  Scenario: Add Request Installation To Software For WDIO
    Given "component" content:
      | title                 | body        | field_summary | moderation_state | field_division_office_multi | field_status | field_request_installation |
      | Behat Request Install | description | summary       | published        | division1                   | BEHAT Recommended  | '' - http://test.com       |
    Then I take a screenshot using "component.feature" file with "@request_installation" tag

  @ui @api @javascript @wdio
  Scenario: Software With UseCase For WDIO
      And "component" content:
      | title         | body        | field_summary | field_division_office_multi | field_dataset_use | moderation_state |
      | BEHAT UseCase | description | summary1      | division1                   | BEHAT Use Case3   | published        |
    Then I take a screenshot using "component.feature" file with "@use_case" tag

  @ui @api @wdio
  Scenario: Software With Multi Select Fields For WDIO
    Given I am viewing a "component" content:
      | title                       | BEHAT Multi Select Field Comp                                                            |
      | field_summary               | This is the Summary                                                                      |
      | body                        | This is the description                                                                  |
      | field_component_category    | BEHAT Category2                                                                          |
      | field_approved_version      | Version 3.4.5                                                                            |
      | field_status_usage          | BEHAT Approve                                                                            |
      | field_restrictions          | Public External                                                                          |
      | field_division_office_multi | division1, division2, division3, division4, division5, division6                         |
      | field_dataset_use           | BEHAT Use Case1, BEHAT Use Case2, BEHAT Use Case3, BEHAT Use Case4, BEHAT Use Case5      |
      | field_tags                  | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, January, February, March |
      | field_reviewer              | approver                                                                                 |
      | moderation_state            | published                                                                                |
      And I run cron
    Then I take a screenshot using "component.feature" file with "@comp_multi_select" tag

  @ui @api @javascript @wdio
  Scenario: Software Search List Page For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title         | body         | field_summary | field_status_usage      | moderation_state | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | Behat Comp1   | description1 | summary1      | BEHAT Recommended       | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp2   | description1 | summary1      | BEHAT Approve           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | A Behat Comp3 | description1 | summary1      | BEHAT Approve           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | C Behat Comp4 | description1 | summary1      | BEHAT Exception         | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp5   | description1 | summary1      | BEHAT Life Cycle Failed | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp6   | description1 | summary1      | BEHAT Exception         | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp7   | description1 | summary1      | BEHAT Catalog           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp8   | description1 | summary1      | BEHAT Retire            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp9   | description1 | summary1      | BEHAT Unapproved        | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      And I run cron
    When I am on "/software"
    Then I take a screenshot using "component.feature" file with "@software" tag
