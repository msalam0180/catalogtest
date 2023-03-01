Feature: Platform Content Type
  As a content creator I want to be able to create a Platform node
  So that a site visitor will have access to a Platform information to review

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "tags" terms:
      | name     |
      | hardware |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And I create "taxonomy_term" of type "status":
      | name            | field_icon  | field_status_color |
      | BEHAT Retire    | leaf        | #AF2525            |
      | BEHAT Exception | exclamation | #EAAD23            |
      | BEHAT Approve   | check       | #00695C            |
      And I create "taxonomy_term" of type "component_category":
      | name            | field_icon |
      | BEHAT Category1 | landmark   |
      | BEHAT Category2 | building   |
      | BEHAT Category3 |            |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      | BEHAT Use Case3 |                 |
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "manufacturer" terms:
      | name     |
      | Sony     |

  @api @javascript
  Scenario Outline: Authorized Users Can Create A Platform
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Name" with "Short"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select the autocomplete option for "Sony" on the "Manufacturer" field
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I select "BEHAT Exception" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I press "Add another item"
      And I wait for ajax to finish
      And I select the option "division2" from the jquery select ".form-item-field-division-office-multi-1-target-id .select-wrapper:nth-of-type(1) select"
      And I select "BEHAT Use Case1" from "Use Cases" for the "1" option of the "1" row
      And I select "BEHAT Use Case2" from "Use Cases" for the "2" option of the "1" row
      And I click on the element with css selector "#edit-field-dataset-use-add-more"
      And I wait for ajax to finish
      And I select "BEHAT Use Case3" from "Use Cases" for the "1" option of the "2" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I am on "/platforms/behat-platform"
      And I should see the heading "BEHAT Platform (Short)"
      And I should not see the text "BEHAT Forum"
      And I should see the link "BEHAT Exception"
      And I should see the text "This is the description of the topic"
      And I should see the text "Snapshot"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "division2"
      And I should see the text "Use Cases"
      And I should see the link "BEHAT Use Case2"
      And I should see the link "BEHAT Use Case3"
      And I should not see the link "BEHAT Use Case1"
      And I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/platforms" in the "breadcrumb" region

    Examples:
      | role                             |
      | Administrator                    |
      | content_creator, migration_admin |

  @api @javascript
  Scenario: Platform Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "platform" content:
      | title            | Behat Platform |
      | body             | body           |
      | field_summary    | summary        |
      | moderation_state | published      |
      And I wait 3 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Platform Behat Platform"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit A Platform
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "platform" content:
      | title                       | BEHAT Platform |
      | body                        | body           |
      | field_summary               | summary        |
      | field_division_office_multi | division1      |
      | field_status_usage          | BEHAT Retire   |
      | moderation_state            | published      |
      | field_reviewer              | approver       |
    Then I should see the heading "BEHAT Platform"
      And I should see the text "body"
      And I should see the text "division1"
      And I should see the link "BEHAT Retire"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Platform" row
      And I fill in "Title" with "BEHAT Edited Platform"
      And I select the autocomplete option for "Sony" on the "Manufacturer" field
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I select "BEHAT Approve" from "Approval Status"
      And I select the option "division2" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I press "Save"
    Then I should see the link "BEHAT Edited Platform"
      And I should not see the link "BEHAT Platform"
    When I click "BEHAT Edited Platform"
    Then I should see the heading "BEHAT Edited Platform"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
      And I should see the text "body"
      And I should see the text "division2"
      And I should see the link "BEHAT Approve"
      And I should not see the text "BEHAT Retire"
      And I should not see the text "division1"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete A Platform
    Given "platform" content:
      | title          | body        | field_summary | moderation_state | field_review |
      | BEHAT Platform | description | summary       | published        | approver     |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Platform" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should see the text "The Platform BEHAT Platform has been deleted."
    When I am on "/behat-platform"
    Then I should see "Page not found"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api
  Scenario: Viewing A Platform
    Given I am logged in as a user with the "authenticated user" role
    When I am viewing a "platform" content:
      | title                       | BEHAT Platform |
      | body                        | Body           |
      | field_summary               | Summary        |
      | field_division_office_multi | division1      |
      | field_tags                  | hardware       |
      | moderation_state            | published      |
      | field_reviewer              | approver       |
      | field_manufacturer          | Sony           |
      | field_approved_version      | Version X-Y-Z  |
    Then I should see the heading "BEHAT Platform"
      And I should see the text "Body"
      And I should see the link "hardware"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
    When I click "Sony"
    Then I should see the text "Sony"
      And I should see the text "Related Content"
      And I should see the text "BEHAT Platform"

  @api
  Scenario Outline: Verify Platform Page URL
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
      And "platform" content:
      | title                | body        | field_summary | moderation_state |
      | BEHAT.Platform.Title | description | summary1      | published        |
      | BEHAT platform TWO   | another     | summary2      | published        |
    When I am on "<URL>"
    Then I should see the heading "<heading>"

    Examples:
      | URL                           | heading              |
      | /platforms/behatplatformtitle | BEHAT.Platform.Title |
      | /platforms/behat-platform-two | BEHAT platform TWO   |

  @api
  Scenario: Verify Platform Required Fields And Help Texts
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/platform"
    Then I should see the text "*Fields marked with an asterisk(*) are required."
      And I should see the text "Short name is the acronym or shortened version of the title"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Technology Category"
      And I should see the text "If you choose to add a Technology Category, you MUST always select a term from EACH new drop down that appears."
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact, as needed"
      And I should see the text "Horizontal Orientation instead of vertical orientation - some logos have multiple orientations - Horizontal is best."
      And I should see the text "What are the common use cases?"
      And I should see the text "Height of 100px or Larger"
      And I should see the text "Transparent background is preferred, but white background can be used if necessary"
      And I should see the text "Crop out extra space around the logo"
      And I should see the link "Read more about Logo Optimization"
      And I should see the text "Search Keywords"
      And I should see the text "Tags"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
      And I press "Add new Logo"
      And I press "Add Contact"
      And I press "Add new Document"
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
    When I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Detailed Description field is required."
      And I should see the text "Approval Status field is required."
      And I should see the text "Name field is required."
      And I should see the text "Image field is required."
      And I should see the text "Divisions/Offices that use this field is required."
      And I should see the text "Contact field is required."
      And I should see the text "Role field is required."
      And I should see the text "File field is required."
      And I should see the text "Description field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api
  Scenario: Verify Platform Page Created/Updated Label
    Given  I am logged in as a user with the "authenticated user" role
      And I am viewing a "platform" content:
      | title            | BEHAT Platform Created |
      | body             | Platform description   |
      | field_summary    | Platform1 summary      |
      | moderation_state | published              |
      And I should see the text "Created"
      And I am viewing a "platform" content:
      | title            | BEHAT Platform Updated    |
      | body             | Platform1 description     |
      | field_summary    | Updated platform1 summary |
      | changed          | +1 day                    |
      | moderation_state | published                 |
    Then I should see the text "Updated"
      And I should not see the text "Created"

  @api @javascript
  Scenario: Relationship Platform And Software
    Given "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Exception    | published        | approver       |
      And "platform" content:
      | title            | body         | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | BEHAT Exception    | division2                   | published        | approver       |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "Behat Component 1" on the "Related Software" field
      And I press "Save"
    Then I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Component 1"
      And I should see the text "Software"
      And I click "Behat Component 1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1"
      And I should see the text "Platforms"
      And I click "BEHAT Exception"
      And I should see the heading "BEHAT Exception"
      And I should see the link "Behat Component 1"
      And I should see the link "Behat Platform 1"

  @api @javascript
  Scenario: Integrate Platform And Application
    Given "application" content:
      | title               | body         | field_summary | moderation_state | field_division_office_multi |
      | Behat Application 2 | description2 | summary2      | published        | division2                   |
      And "platform" content:
      | title            | body         | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | BEHAT Retire       | division1                   | published        | approver       |
    When I am logged in as a user with the "Content Creator" role
      And I am on "/platforms/behat-platform-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "Behat Application 2" on the "Related Applications" field
      And I press "Save"
    Then I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Application 2"
      And I should see the text "Applications"
      And I click "Behat Application 2"
      And I should see the link "Behat Platform 1"
      And I should see the heading "Behat Application 2"
      And I should see the text "Platforms"

  @api @javascript
  Scenario: Integrate Platform And Many Applications
    Given "application" content:
      | title              | body         | field_summary | moderation_state | field_logo | field_division_office_multi |
      | 1Behat Application | description1 | summary1      | published        | SQL Logo   | division1                   |
      | QBehat Application | description2 | summary2      | published        | Edgar Logo | division2                   |
      | J Behat App        | description3 | summary3      | published        |            | division2                   |
      | 3 Behat App        | description4 | summary4      | published        |            | division1                   |
      | Y Behat App        | description5 | summary5      | published        |            | division2                   |
      And "platform" content:
      | title            | body         | field_summary | field_status_usage | field_division_office_multi | field_related_apps                    | moderation_state |
      | Behat Platform 1 | description1 | summary1      | BEHAT Retire       | division1                   | J Behat App, 3 Behat App, Y Behat App | draft            |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform-1/edit"
      And I click "Related Technologies"
      And I wait for ajax to finish
      And I select the first autocomplete option for "1Behat Application" on the "Related Applications (value 4)" field
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-related-apps-add-more']"
      And I wait for ajax to finish
      And I select the first autocomplete option for "QBehat Application" on the "Related Applications (value 5)" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform-1"
    Then I should see the heading "Behat Platform 1"
      And I should see the text "Applications Hosted on this Platform"
      And I should see the link "1Behat Application"
      And I should see the link "3 Behat App"
      And I should see the link "J Behat App"
      And I should see the link "QBehat Application"
      And I should see the link "Y Behat App"
      And I should see the text "summary1"
      And I should see the text "summary2"
      And I should see the text "summary3"
      And I should see the text "summary4"
      And I should see the text "summary5"
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "related_apps" region
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "related_apps" region
      And "1Behat Application" should precede "3 Behat App" for the query "//h3[contains(@class, 'view-list-img--title')]/a"
      And "3 Behat App" should precede "J Behat App" for the query "//h3[contains(@class, 'view-list-img--title')]/a"
      And "J Behat App" should precede "QBehat Application" for the query "//h3[contains(@class, 'view-list-img--title')]/a"
      And "QBehat Application" should precede "Y Behat App" for the query "//h3[contains(@class, 'view-list-img--title')]/a"
      And I click "3 Behat App"
      And I should see the heading "3 Behat App"
      And I should see the text "Platforms"
      And I should see the link "Behat Platform 1"
      And I should see the "a" element with the "class" attribute set to "btn btn-sm btn-status--AF2525" in the "sidebar" region
    When I am on "/platforms/behat-platform-1"
      And I wait 3 seconds
      And I click on the element with css selector "img[src*='behat-sql-logo']"
      And I should see the heading "1Behat Application"
      And I should see the text "description1"
      And I should see the link "Behat Platform 1"

  @api @javascript
  Scenario: Remove Application On Platform And Application Relationship
    Given "application" content:
      | title               | body         | field_summary | moderation_state | field_division_office_multi |
      | Behat Application 2 | description2 | summary2      | published        | division2                   |
      And "platform" content:
      | title            | body         | field_summary | field_related_apps  | field_status_usage | field_division_office_multi | moderation_state |
      | Behat Platform 1 | description1 | summary1      | Behat Application 2 | BEHAT Retire       | division1                   | published        |
    When I am logged in as a user with the "Content Approver" role
    Then I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Application 2"
      And I should see the text "Applications"
      And I click "Behat Application 2"
      And I should see the link "Behat Platform 1"
      And I should see the heading "Behat Application 2"
      And I should see the text "Platforms"
    When I am on "/platforms/behat-platform-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I fill in "Related Applications" with ""
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Behat Platform 1"
      And I should not see the link "Behat Application 2"
      And I am on "/applications/behat-application-2"
      And I should see the heading "Behat Application 2"
      And I should not see the link "Behat Platform 1"

  @api @javascript
  Scenario: Workflow Publish To Archive For Platform And Application Relationship
    Given "application" content:
      | title               | body         | field_summary | moderation_state | field_division_office_multi |
      | Behat Application 1 | description1 | summary1      | published        | division1                   |
      | Behat Application 2 | description2 | summary2      | published        | division2                   |
      And "platform" content:
      | title            | body         | field_summary | moderation_state | field_status_usage | field_related_apps  | field_division_office_multi |
      | Behat Platform 1 | description1 | summary1      | published        | BEHAT Retire       | Behat Application 2 | division1                   |
    When I am logged in as a user with the "Content Approver" role
    Then I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Application 2"
      And I should see the text "Applications"
      And I click "Behat Application 2"
      And I should see the link "Behat Platform 1"
      And I should see the heading "Behat Application 2"
      And I should see the text "Platforms"
    When I am on "/platforms/behat-platform-1/edit"
      And I fill in "Title" with "BEHAT Platform Edit"
      And I select "Archived" from "edit-moderation-state-0-state"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I visit "/platforms/behat-platform-edit"
      And I should see "Access Denied"
      And I visit "/applications/behat-application-1"
      And I should see the heading "Behat Application 1"
      And I should not see the text "BEHAT Platform Edit"

  @api @javascript
  Scenario: Authorized user Adding Article To Platform
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
      And "faq_category" terms:
      | name      |
      | Behat FAQ |
      And "article" content:
      | title          | field_summary | body        | moderation_state | field_article_summary | field_category |
      | Behat article1 | behat short   | article one | published        | summary               | Behat FAQ      |
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "Short Description"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Exception" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I scroll to the top
      And I wait 1 seconds
      And I click "Related Documentation"
      And I wait 1 seconds
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I wait 1 seconds
      And I check "Behat article1" on the files selector
      And I wait 1 seconds
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "Content Approver" role
      And I visit "platforms/behat-platform/edit"
      And I select "BEHAT Exception" from "Approval Status"
      And I select "Published" from "edit-moderation-state-0-state"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I am on "/platforms/behat-platform"
      And I should see the heading "BEHAT Platform"
      And I should see the link "Behat article1"
      And I should see the text "Articles"
      And I click "Behat article1"
      And I should see the heading "Behat article1"
      And I should see the link "BEHAT Platform"
      And I should see the text "Platforms"
      And I should see the text "summary"
      And I should see the link "Behat FAQ"

  @api @javascript
  Scenario: Adding Multiple Article To Platform
    Given I am logged in as a user with the "Content Approver" role
      And "article" content:
      | title          | body        | moderation_state |
      | Behat article1 | article one | published        |
      | Behat article2 | article two | published        |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi | field_related_articles        |
      | BEHAT platform | description | summary       | published        | BEHAT Retire       | division1                   | Behat article1,Behat article2 |
    When I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT platform"
      And I should see the link "Behat article1"
      And I should see the link "Behat article2"
      And I should see the text "Articles"
      And I click "Behat article1"
      And I should see the heading "Behat article1"
      And I should see the link "BEHAT platform"
      And I should see the text "Platforms"
      And I visit "behat-article2"
      And I should see the heading "Behat article2"
      And I should see the link "BEHAT platform"
      And I should see the text "Platforms"

  @api @javascript
  Scenario: Remove An Article From Platform
    Given I am logged in as a user with the "Content Approver" role
      And "article" content:
      | title          | body        | moderation_state |
      | Behat article1 | article one | published        |
      | Behat article2 | article two | published        |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi | field_related_articles        |
      | BEHAT platform | description | summary       | published        | BEHAT Retire       | division1                   | Behat article1,Behat article2 |
    When I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT platform"
      And I should see the link "Behat article1"
      And I should see the link "Behat article2"
      And I should see the text "Articles"
    When I am on "/platforms/behat-platform/edit"
      And I click "Related Documentation"
      And I wait 1 seconds
      And I click on the element with css selector "#edit-field-related-articles-entities-1-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-related-articles-form-entities-1-form-actions-ief-remove-confirm']"
      And I wait for ajax to finish
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/platforms/behat-platform"
    Then I should see the heading "BEHAT platform"
      And I should see the link "Behat article1"
      And I should not see the link "Behat article2"
      And I should see the text "Articles"
      And I click "Behat article1"
      And I should see the heading "Behat article1"
      And I should see the link "BEHAT platform"
      And I should see the text "Platforms"

  @api @javascript
  Scenario: Updating An Existing Article To Platform
    Given I am logged in as a user with the "Content Approver" role
      And "article" content:
      | title          | field_summary | body        | moderation_state |
      | Behat article1 | behat short   | article one | published        |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi | field_related_articles |
      | BEHAT platform | description | summary       | published        | BEHAT Approve      | division1                   | Behat article1         |
    When I am on "/platforms/behat-platform/edit"
      And I fill in "Title" with "Update Behat platform"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/behat-article1/edit"
      And I fill in "Title" with "Update Behat article1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/platforms/behat-platform"
    Then I should see the heading "Update Behat platform"
      And I should see the link "Update Behat article1"
      And I should see the text "Articles"
      And I click "Update Behat article1"
      And I should see the heading "Update Behat article1"
      And I should see the link "Update Behat platform"
      And I should see the text "Platforms"

  @api @javascript
  Scenario: Add New Logo To Platform
    Given "platform" content:
      | title          | body        | field_summary | field_division_office_multi | field_status_usage | moderation_state |
      | BEHAT Platform | description | summary       | division1                   | BEHAT Approve      | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/platforms/behat-platform/edit"
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
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the text "Platform BEHAT Platform has been updated."
      And I should see "Access denied"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
      And I should see the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Add Existing Logo To Platform
    Given "platform" content:
      | title          | body        | field_summary | field_division_office_multi | field_status_usage | moderation_state |
      | BEHAT Platform | description | summary       | division1                   | BEHAT Approve      | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/platforms/behat-platform/edit"
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
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the text "Platform BEHAT Platform has been updated."
      And I should see "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
    Then I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "logo" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "logo" region

  @api @javascript
  Scenario: Update Logo And Verify On Platforms Page
    Given "platform" content:
      | title          | body        | field_summary | field_division_office_multi | field_status_usage | field_logo | moderation_state |
      | BEHAT Platform | description | summary       | division1                   | BEHAT Approve      | SQL Logo   | published        |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT Platform"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform/edit"
      And I press "Edit" in the "create_logo" region
      And I wait for ajax to finish
      And I press "field_logo_form_inline_entity_form_entities_0_form_field_media_image_0_remove_button"
      And I wait for ajax to finish
      And I attach the file "behat-datacatalog-log.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Behat Catalog Logo"
      And I press "Update Logo"
      And I wait 1 seconds
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Platform BEHAT Platform has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT Platform"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-datacatalog-log" in the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Remove Logo From Platform
    Given "platform" content:
      | title          | body        | field_summary | field_division_office_multi | field_status_usage | field_logo | moderation_state | field_reviewer |
      | BEHAT Platform | description | summary       | division1                   | BEHAT Exception    | SQL Logo   | published        | approver       |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT Platform"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform/edit"
      And I press "edit-field-logo-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT Platform"
      And I should not see the "logo" region

  @api @javascript
  Scenario: Workflow For Contact Guidance On Platform
    Given "platform" content:
      | title          | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_contact_guidance |
      | BEHAT platform | description | summary       | draft            | division1                   | BEHAT Retire       | Behat Contact Guidance |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/platforms/behat-platform"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/platforms/behat-platform/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/platforms/behat-platform"
    Then I should see the heading "BEHAT platform"
      And I should see the text "Contacts"
      And I should see the text "description"
      And I should see the text "Snapshot"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"

  @api @javascript
  Scenario: Authorized User Adding Contact Guidance To Platform
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approve" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Contacts"
      And I wait for ajax to finish
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact, as needed"
      And I fill in "Contact Guidance" with "Behat Contact Guidance"
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the text "BEHAT Platform"
      And I should see the heading "BEHAT Platform"
      And I should see the text "This is the description of the topic"
      And I should see the text "Contacts"
      And I should see the text "Snapshot"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"

  @api @javascript
  Scenario: Authorized User Adds Document To Platform
    Given  I am logged in as a user with the "Content Creator, Migration Admin" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approve" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Related Documentation"
      And I wait for ajax to finish
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
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I fill in "Description" with "Document Description"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Platform"
      And I should see the text "This is the description of the topic"
      And I should see the text "Documents"
      And I should see the text "Document Description"
      And I should see the link "Behat File Upload"
      And I should see the link "Video Media File"
      And I should see the text "Snapshot"
      And I should see the text "SEC Users"
      And I should see the text "division1"
    When I click "Video Media File"
    Then the link should open in a new tab
      And I should see the text "this is a txt file"
      And I close the current tab

  @api @javascript
  Scenario: Verify Platform List Page
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title              | body         | field_summary | moderation_state | field_division_office_multi |
      | Behat Application1 | description2 | summary1      | published        | division2                   |
      | Behat Application2 | description2 | summary2      | published        | division2                   |
      | Behat Application3 | description2 | summary3      | published        | division2                   |
      And "platform" content:
      | title              | body        | field_summary     | field_status_usage | field_division_office_multi | field_logo | field_related_apps                                         | moderation_state |
      | A BEHAT platform1  | description | summary           | BEHAT Approve      | division1                   | SQL Logo   | Behat Application1, Behat Application2                     | published        |
      | BEHAT platform2    | description | summary           | BEHAT Exception    | division1                   | Edgar Logo | Behat Application1, Behat Application2, Behat Application3 | published        |
      | C BEHAT platform3  | description | summary           | BEHAT Retire       | division1                   |            |                                                            | published        |
      | D BEHAT platform4  | description | Short Description | BEHAT Approve      | division1                   | Edgar Logo | Behat Application2                                         | published        |
      | E BEHAT platform5  | description | summary           | BEHAT Exception    | division1                   | SQL Logo   |                                                            | published        |
      | P BEHAT platform6  | description | summary           | BEHAT Retire       | division1                   |            |                                                            | published        |
      | S BEHAT platform7  | description | summary           | BEHAT Exception    | division1                   | Edgar Logo | Behat Application3                                         | published        |
      | 5 BEHAT platform8  | description | summary           | BEHAT Approve      | division1                   | SQL Logo   |                                                            | published        |
      | W BEHAT platform9  | description | summary           | BEHAT Retire       | division1                   |            | Behat Application3                                         | published        |
      | X BEHAT platform10 | description | summary           | BEHAT Exception    | division1                   | Edgar Logo |                                                            | published        |
    When I am on "/platforms"
    Then I should see the text "10 Platforms"
      And I should see the link "A BEHAT platform1"
      And I should see the link "BEHAT platform2"
      And I should see the link "D BEHAT platform4"
      And I should see the link "S BEHAT platform7"
      And I should see the link "X BEHAT platform10"
      And I should see the link "5 BEHAT platform8"
      And I should see the text "1 Applications"
      And I should see the text "2 Applications"
      And I should see the text "3 Applications"
      And I should see the text "summary"
      And I should see the text "Short Description"
      And I should see the text "BEHAT Approve"
      And I should see the text "BEHAT Exception"
      And I should see the text "BEHAT Retire"
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "results_view" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "results_view" region
      And "5 BEHAT platform8" should precede "A BEHAT platform1" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "A BEHAT platform1" should precede "BEHAT platform2" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "C BEHAT platform3" should precede "D BEHAT platform4" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "D BEHAT platform4" should precede "E BEHAT platform5" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "E BEHAT platform5" should precede "P BEHAT platform6" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "P BEHAT platform6" should precede "S BEHAT platform7" for the query "//h2[contains(@class, 'view-list-img')]/a"
      And "W BEHAT platform9" should precede "X BEHAT platform10" for the query "//h2[contains(@class, 'view-list-img')]/a"
    When I click "BEHAT platform1"
    Then I should see the heading "A BEHAT platform1"
    When I am on "/platforms"
      And I wait for ajax to finish
      And I click on the element with css selector "div.views-row:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > a:nth-child(1)"
    Then I should see the heading "5 BEHAT platform8"

  @api @javascript
  Scenario: Content Approver Edit Platform List Page
    Given "platform" content:
      | title           | body        | field_summary | field_status_usage | field_division_office_multi | field_logo | moderation_state |
      | BEHAT platform1 | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | BEHAT platform2 | description | summary       | BEHAT Exception    | division1                   | Edgar Logo | published        |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/edit"
    Then I should see "Title"
      And I should see "Body"
    When I type "BEHAT Platform Description " in the "Body" WYSIWYG editor
      And I fill in "Short Description" with "Behat summary"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
     Then I should see "Landing Page Platforms has been updated."
     When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms"
    Then I should see the text "BEHAT Platform Description"
      And I should see the link "BEHAT platform1"
      And I should see the link "BEHAT platform2"

  @api @javascript
  Scenario: Edit A Platform And Verify On List Page
    Given "platform" content:
      | title           | body        | field_summary | field_status_usage | field_division_office_multi | field_logo | moderation_state | field_reviewer |
      | BEHAT Platform1 | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        | approver       |
      | BEHAT Platform2 | description | summary       | BEHAT Exception    | division1                   | Edgar Logo | published        | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/platforms"
    Then I should see "2 Platforms"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform1/edit"
      And I fill in "Title" with "BEHAT Edited Platform1"
      And I press "Save"
      And I am on "/platforms"
    Then I should not see the link "BEHAT Platform1"
      And I should see the link "BEHAT Edited Platform1"
      And I should see the link "BEHAT Platform2"
      And I click on the element with css selector "a[href*='behat-platform2'] span"
      And I fill in "Title" with "BEHAT Edited Platform2"
      And I press "Save"
    When I am on "/platforms"
    Then I should not see the link "BEHAT Platform2"
      And I should see the link "BEHAT Edited Platform1"
      And I should see the link "BEHAT Edited Platform2"

  @api @javascript
  Scenario: Delete A Platform And Verify On List Page
    Given "platform" content:
      | title           | body        | field_summary | field_status_usage | field_division_office_multi | field_logo | moderation_state |
      | BEHAT Platform1 | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | BEHAT Platform2 | description | summary       | BEHAT Exception    | division1                   | Edgar Logo | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/platforms"
    Then I should see "2 Platforms"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Platform1" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should see the text "The Platform BEHAT Platform1 has been deleted."
    When I am on "/platforms"
    Then I should not see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2"

  @api @javascript
  Scenario Outline: Create A Platform With Different Status
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "<status>" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Platform BEHAT Platform has been created."
      And I should see the heading "BEHAT Platform"
      And I should see the text "This is the description of the topic"
      And I should see "<status>"
      And I should not see the text "Behat summary"

    Examples:
      | status            |
      | Catalog           |
      | Approved          |
      | Waiver            |
      | Retired           |
      | Pending Lifecycle |

  @api @javascript
  Scenario: Verify Sorting On Status Term Page
    Given "platform" content:
      | title            | body        | field_summary | field_status_usage | field_division_office_multi | field_logo | moderation_state |
      | 1 BEHAT Platform | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | BEHAT Platform   | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | D BEHAT Platform | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | H BEHAT Platform | description | summary       | BEHAT Approve      | division1                   | SQL Logo   | published        |
      | W BEHAT Platform | description | summary       | BEHAT Approve      | division1                   | Edgar Logo | published        |
    When  I am logged in as a user with the "Content Approver" role
      And I am on "/admin/structure/taxonomy/manage/status/overview"
      And I click "BEHAT Approve"
    Then I should see the link "1 BEHAT Platform"
      And I should see the link "BEHAT Platform"
      And I should see the link "D BEHAT Platform"
      And I should see the link "H BEHAT Platform"
      And I should see the link "W BEHAT Platform"
      And "1 BEHAT Platform" should precede "BEHAT Platform" for the query "//span[contains(@class, 'field-content')]/a"
      And "BEHAT Platform" should precede "D BEHAT Platform" for the query "//span[contains(@class, 'field-content')]/a"
      And "D BEHAT Platform" should precede "H BEHAT Platform" for the query "//span[contains(@class, 'field-content')]/a"
      And "H BEHAT Platform" should precede "W BEHAT Platform" for the query "//span[contains(@class, 'field-content')]/a"

  @api @javascript
  Scenario: Platform With Technology Category
    Given I am logged in as a user with the "sitebuilder" role
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I drag taxonomy term "BEHAT Category2" onto "BEHAT Category1"
      And I press "Save"
    When I am logged in as a user with the "Content Approver, Migration Admin" role
      And  I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I should see the text "If you choose to add a Technology Category, you MUST always select a term from EACH new drop down that appears."
      And I select "BEHAT Exception" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I check "Promoted to Technology Standards"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Platform"
      And I should see the text "Category"
      And I should see the link "BEHAT Category1"
      And I should see the link "BEHAT Category2"
    When I click "BEHAT Category1"
    Then I should see the heading "BEHAT Category1"
      And I should see the link "BEHAT Category2"
    When I click "BEHAT Category2"
    Then I should see the link "BEHAT Platform"
      And I should see the text "BEHAT Short Description"
      And I should see the link "BEHAT Exception"
    When I click "BEHAT Exception"
    Then I should see the heading "BEHAT Exception"
      And I should see the link "BEHAT Platform"

  @api @javascript
  Scenario: Create Platform with Promote to Technology Standards Page
    Given I am logged in as a user with the "Sitebuilder, Migration Admin" role
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I wait for ajax to finish
      And I drag taxonomy term "BEHAT Category2" onto "BEHAT Category1"
      And I press "Save"
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I select "BEHAT Exception" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I check "Promoted to Technology Standards"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/technology-standards"
    Then I should see the text "1 Items" in the "total_items" region
      And I click "BEHAT Category1"
      And I should see the link "BEHAT Platform"

  @api @javascript
  Scenario: Verify Discussions On Platform Detailed Page
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
      And "forums" terms:
      | name       |
      | Plat Forum |
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "Short Description test"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Exception" from "Approval Status"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see "Related Discussions"
      And I should see "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
    When I click "Start a New Discussion"
      And the link should open in a new tab
      And I fill in "Title" with "BEHAT Plat Forum"
      And I select "Plat Forum" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
    Then I should see the text "Related Content"
      And I should see the link "BEHAT Platform"
    When I click "BEHAT Platform"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Plat Forum"
      And I close the current window

  @api @javascript
  Scenario: Create Platform With Request Access And Link
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/platform"
      And I fill in "Title" with "BEHAT Platform"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Exception" from "Approval Status"
      And I fill in "Platform Link" with "http://test.com"
      And I fill in "How to Request Access" with "http://google.com"
      And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Platform"
      And I should see the link "Visit BEHAT Platform"
      And I should see the link "Request Access"
      And I click "Request Access"
      And the link should open in a new tab
    When I am on "/platforms/behat-platform"
      And I click "Visit BEHAT Platform"
      And the link should open in a new tab
    When I am on "/platforms/behat-platform/edit"
     And I fill in "Short Name" with "Short"
     And I select the autocomplete option for "approver" on the "Reviewer" field
     And I press "Save"
    Then I should see the link "Visit Short"
     And I should not see the link "Visit BEHAT Platform"
     And I close the current window

  @api @javascript
  Scenario: Verify Platform Page After Removing Use Case
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "platform" content:
      | title                       | BEHAT Platform    |
      | body                        | Body              |
      | field_summary               | Summary           |
      | field_division_office_multi | division1         |
      | field_status_usage          | BEHAT Approve     |
      | field_dataset_use           | BEHAT Use Case3   |
      | moderation_state            | published         |
      | field_reviewer              | approver          |
    Then I should see the heading "BEHAT Platform"
      And I should see the text "Body"
      And I should not see the text "Summary"
      And I should see the link "division1"
      And I should see the link "BEHAT Use Case3"
    When I am on "/platforms/behat-platform/edit"
      And I select "" from "Use Cases" for the "1" option of the "1" row
      And I press "Save"
    Then I should see the heading "BEHAT Platform"
      And I should not see the link "BEHAT Use Case3"

  @api @javascript
  Scenario: Restrict length of Application Short Description displayed on Platform Page to approx 300 char
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
    When I am on "/node/add/application"
      And I fill in "Title" with "BEHAT Application"
      And I fill in "Short Description" with "529 Characters to be truncated at approximately 300 characters Lorem ipsum dolor sit amet consectetur adipiscing elit Sed rutrum enim lectus at sagittis turpis porttitor ac Duis egestas nec velit at finibus Fusce et augue leo Proin ac justo accumsan sapien accumsan vehicula ut vitae nulla Donec pellentesque nibh vel nunc aliquam egestas id in urna Vivamus quis egestas ante Integer iaculis sit amet dolor quis dignissim Praesent nec ipsum lectus Maecenas eget volutpat enim Proin dui ligula porta in facilisis vel rutrum id est"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I fill in "Approved Version" with "Version X-Y-Z"
      And I select "Active" from "Status"
      And I select "division2" from "Owner"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Application"
      And "platform" content:
      | title            | body         | field_summary | field_status_usage | field_division_office_multi | field_related_apps | moderation_state |
      | Behat Platform 1 | description1 | summary1      | BEHAT Retire       | division1                   | BEHAT Application  | published        |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/platforms/behat-platform-1"
    Then I should see the text "529 Characters to be truncated at approximately 300 characters Lorem ipsum dolor sit amet consectetur adipiscing elit Sed rutrum enim lectus at sagittis turpis porttitor ac Duis egestas nec velit at finibus Fusce et augue leo Proin ac justo accumsan sapien accumsan vehicula ut vitae nulla Donec…"

  @api
  Scenario Outline: unauthorized Users cannot create an Platform
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/platform"
    Then I should see the text "Access Denied"
      And I should see the text "You are not authorized to access this page."

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
