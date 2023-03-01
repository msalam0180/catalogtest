Feature: Create, Edit And Delete Software Content Type
  As a Content Creator, I should be able to create or edit a component page.
  As a Site User, I want the ability to have a base content type that gives the ability to add key information about a given technology
  so that I understand relationships (business and technology) it has.

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And I create "taxonomy_term" of type "component_category":
      | name            | parent          | field_summary | field_icon |
      | BEHAT Category1 |                 | Summary1      | landmark   |
      | BEHAT Category2 | BEHAT Category1 | Summary2      | building   |
      | BEHAT Category3 | BEHAT Category1 | Summary3      | building   |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "faq_category" terms:
      | name        |
      | Behat FAQ   |
      | Behat Other |
      And "tags" terms:
      | name       |
      | automation |
      | sales      |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And "application_status" terms:
      | name       |
      | App Status |
      And I create "taxonomy_term" of type "status":
      | name           | field_icon | field_status_color |
      | BEHAT Retire   | leaf       | #AF2525            |
      | BEHAT Approval | mailchimp  | #862CCA            |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      | BEHAT Use Case3 |                 |
      And "manufacturer" terms:
      | name      |
      | Sony      |
      | Microhard |

  @api @javascript
  Scenario Outline: Authorized Users Can Create A New Software
    Given I am logged in as a user with the "<role>" role
      And I am on "/node/add/component"
      And I fill in "Title" with "Behat Component"
      And I fill in "Short Name" with "Short"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I select the autocomplete option for "Sony" on the "Manufacturer" field
      And I fill in "Approved Version" with "Version 1.0"
      And I fill in "How to Request Installation" with "http://test.com"
      And I select "BEHAT Approval" from "Approval Status"
      And I fill in "Restrictions" with "SEC (Internal)"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I press "field_division_office_multi_add_more"
      And I wait 2 seconds
      And I select "division2" from "Divisions/Offices that use this" for the "1" option of the "2" row
      And I select "BEHAT Use Case1" from "Use Cases" for the "1" option of the "1" row
      And I select "BEHAT Use Case2" from "Use Cases" for the "2" option of the "1" row
      And I click on the element with css selector "#edit-field-dataset-use-add-more"
      And I wait for ajax to finish
      And I select "BEHAT Use Case3" from "Use Cases" for the "1" option of the "2" row
      And I check "Promoted to Technology Standards"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Software Behat Component has been created."
      And I should see the heading "Behat Component (Short)"
      And I should see the text "BEHAT Component Description"
      And I should see the link "BEHAT Approval"
      And I should see the link "Request Install"
      And I should see the text "Snapshot"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
      And I should see the text "Approved Version"
      And I should see the text "Version 1.0"
      And I should see the text "SEC Users"
      And I should see the link "division1"
      And I should see the link "division2"
      And I should see the text "Use Cases"
      And I should see the link "BEHAT Use Case2"
      And I should see the link "BEHAT Use Case3"
      And I should not see the link "BEHAT Use Case1"
      And I should see the text "Restrictions"
      And I should see the text "SEC (Internal)"
      And I should see the text "Category"
      And I should see the link "BEHAT Category1"
      And I should see the link "BEHAT Category2"
      And I should see the text "Created"
      And I should not see the text "Behat summary"
      And I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/software" in the "breadcrumb" region
    When I visit "/technology-standards/behat-category1"
    Then I should see the "breadcrumb" region
    When I visit "/technology-standards/behat-category1/behat-category2"
    Then I should see the "breadcrumb" region

    Examples:
      | role                              |
      | content_creator, migration_admin  |
      | content_approver, migration_admin |

  @api
  Scenario: Viewing A Software
    Given I am logged in as a user with the "authenticated user" role
    When I am viewing a "component" content:
      | title                       | BEHAT Component |
      | body                        | Body            |
      | field_summary               | Summary         |
      | field_status_usage          | BEHAT Approval  |
      | field_status_usage          | BEHAT Approval  |
      | field_approved_version      | Version X-Y-Z   |
      | field_division_office_multi | division1       |
      | field_tags                  | automation      |
      | moderation_state            | published       |
      | field_manufacturer          | Sony            |
    Then I should see the heading "BEHAT Component"
      And I should see the text "Body"
      And I should not see the text "Summary"
      And I should see the text "division1"
      And I should see the link "automation"
      And I should see the link "BEHAT Approval"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
      And I should see the text "Approved Version"
      And I should see the text "Version X-Y-Z"
    When I click "Sony"
    Then I should see the text "Manufacturer"
      And I should see the text "Sony"

  @api @javascript
  Scenario Outline: Create A Software With Different Status
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "Behat Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select "<status>" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see "Software Behat Component has been created."
      And I should see the heading "Behat Component"
      And I should see the text "BEHAT Component Description"
      And I should see "<status>"
      And I should not see the text "Behat summary"

    Examples:
      | status             |
      | Approved           |
      | Waiver             |
      | Pending Lifecycle  |
      | Pending Retirement |
      | Retired            |
      | BEHAT Approval     |

  @api @javascript
  Scenario: Verify User Can Click On The Software Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "component" content:
      | title              | BEHAT Component         |
      | field_summary      | This is the Summary     |
      | body               | This is the description |
      | field_status_usage | BEHAT Approval          |
      | moderation_state   | published               |
      And I wait 2 seconds
    When I hover over the element "article.contextual-region > div:nth-child(1) > button"
      And I wait for ajax to finish
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait for ajax to finish
    Then I should see the text "Edit Software BEHAT Component"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit A Software
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | field_summary               | This is the Summary     |
      | body                        | This is the description |
      | field_component_category    | BEHAT Category2         |
      | field_approved_version      | Version 3.4.5           |
      | field_status_usage          | BEHAT Approval          |
      | field_restrictions          | Public External         |
      | field_division_office_multi | division1               |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "This is the description"
      And I should see the text "Version 3.4.5"
      And I should see the link "BEHAT Approval"
      And I should see the text "Public External"
      And I should see the link "BEHAT Category1"
      And I should see the link "BEHAT Category2"
      And I should see the text "SEC Users"
      And I should see the link "division1"
      And I should not see the text "This is the Summary"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Component" row
      And I fill in "Title" with "BEHAT Edited Component"
      And I fill in "Short Description" with "Edited Behat summary"
      And I type "BEHAT Component Description Edited " in the "Detailed Description" WYSIWYG editor
      And I select the option "BEHAT Category3" from the jquery select "#edit-field-component-category-wrapper > div > div:nth-child(4) > select"
      And I select "BEHAT Retire" from "Status"
      And I select "division2" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I press "Save"
    Then I should see "Software BEHAT Edited Component has been updated."
    When I click "BEHAT Edited Component"
    Then I should not see the heading "BEHAT Component"
      And I should see the heading "BEHAT Edited Component"
      And I should see the text "BEHAT Component Description Edited"
      And I should see the link "BEHAT Retire"
      And I should see the link "BEHAT Category1"
      And I should see the link "BEHAT Category3"
      And I should not see the link "BEHAT Category2"
      And I should see the link "division2"
      And I should not see the link "division1"
      And I should not see the text "Limit Use"
      And I should not see the text "Edited Behat summary"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Content Creator Can Edit A Software
    Given I am logged in as a user with the "Content Creator" role
      And I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | field_summary               | This is the Summary     |
      | body                        | This is the description |
      | field_status_usage          | BEHAT Approval          |
      | field_division_office_multi | division1               |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "This is the description"
      And I should not see the text "This is the Summary"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Component" row
      And I fill in "Title" with "BEHAT Edited Component"
      And I fill in "Short Description" with "Edited Behat summary"
      And I type "BEHAT Component Description Edited " in the "Detailed Description" WYSIWYG editor
      And I select the autocomplete option for "Sony" on the "Manufacturer" field
      And I press "Save"
      And I should see "Software BEHAT Edited Component has been updated."
      And I click "BEHAT Edited Component"
    Then I should see the heading "BEHAT Component"
      And I should not see the heading "BEHAT Edited Component"
    When I am on "/software/behat-component/revisions"
      And I click on the element with css selector "#edit-node-revisions-table > tbody > tr.odd > td:nth-child(1) > a:nth-child(1)"
      And I should see the text "Manufacturer"
      And I should see the text "Sony"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content/moderated"
      And I click "BEHAT Edited Component"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
      And  I should see the heading "BEHAT Edited Component"

  @api
  Scenario: Content Creator Can Not Delete Other Software
    Given "component" content:
      | title           | body                        | field_status_usage | moderation_state | field_reviewer |
      | BEHAT Component | Description about component | Approved           | published        | approver       |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/software/behat-component/delete"
    Then I should see "Access Denied"

  @api
  Scenario Outline: Authorized Users Can Delete A Software
    Given "component" content:
      | title           | body                  | field_status_usage | field_component_category | moderation_state | field_reviewer |
      | BEHAT Component | Component description | Approved           | BEHAT Category1          | published        | approver       |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Component" row
      And I click "Delete" in the "node_action" region
      And  I press the "Delete" button
    Then I should see the text "The Software BEHAT Component has been deleted."
    When I am on "/admin/content"
    Then I should not see the link "BEHAT Component"
    When I am on "/software/behat-component"
    Then I should see "Page not found"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario: Verify User Can Filter Software
    Given "component" content:
      | title           | body                  | field_status_usage | moderation_state |
      | BEHAT Component | Component description | Approved           | published        |
      And "data_set" content:
      | title         | field_dataset_description | field_dataset_source_type | moderation_state |
      | BEHAT Dataset | Dataset description       | NRSRO, DBRS               | published        |
      And "article" content:
      | title         | body        | field_category | moderation_state |
      | BEHAT Article | article one | FAQ            | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
    Then I should see the link "BEHAT Component"
      And I should see the link "BEHAT Dataset"
      And I should see the link "BEHAT Article"
    When I select "Software" from "Content type"
      And I press "Filter"
    Then I should see the link "BEHAT Component"
      And I should not see the link "BEHAT Dataset"
      And I should not see the link "BEHAT Article"

  @api
  Scenario: Authenticated User Can View Only Published Software
    Given "component" content:
      | title            | body                  | field_status_usage | moderation_state |
      | BEHAT Component1 | Component description | Pending Lifecycle  | published        |
      | BEHAT Component2 | Component description | Retired            | draft            |
      And I am logged in as a user with the "Authenticated user" role
    When I am on "/software/behat-component1"
    Then I should see the text "BEHAT Component1"
      And I should see the link "Pending Lifecycle"
    When I am on "/software/behat-component2"
    Then I should see "Access denied"
      And I should not see the text "BEHAT Component2"

  @api
  Scenario: Verify Software Labels, Required Fields, And HelpTexts
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/component"
    Then I should see the text "*Fields marked with an asterisk(*) are required."
      And I should see the text "Short name is the acronym or shortened version of the title"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Technology Category"
      And I should see the text "If you choose to add a Technology Category, you MUST always select a term from EACH new drop down that appears."
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact, as needed"
      And I should see the text "Enter the URL to allow a user to request installation."
      And I should see the text "What are the common use cases?"
      And I should see the text "Horizontal Orientation instead of vertical orientation - some logos have multiple orientations - Horizontal is best."
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
      And I should see the text "Status field is required."
      And I should see the text "Divisions/Offices that use this field is required."
      And I should see the text "Contact field is required."
      And I should see the text "Role field is required."
      And I should see the text "File field is required."
      And I should see the text "Description field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api @javascript
  Scenario: Add Related Application To A Software
    Given "application" content:
      | title              | body         | field_summary | moderation_state |
      | BEHAT Application1 | description1 | summary1      | published        |
      | BEHAT Application2 | description2 | summary2      | published        |
      And I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approval" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I scroll to the top
      And I wait for ajax to finish
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Applications" field
      And I click on the element with css selector "#edit-field-related-apps-add-more"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application2" on the "Related Applications (value 2)" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I click "BEHAT Application2"
      And I should see the heading "BEHAT Application2"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application2"
    Then I should see the heading "BEHAT Application2"
      And I should not see the text "Software"
      And I should not see the link "BEHAT Component"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
      And I run drush "cr"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application2"
    Then I should see the heading "BEHAT Application2"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
    When I click "BEHAT Component"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"

  @api
  Scenario: Edit Related Application And Verify On Software Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
      | title             | field_summary       | body                  | field_division_office_multi | field_owner | field_app_status | moderation_state | field_reviewer |
      | BEHAT Application | This is the Summary | Component description | division2                   | division1   | App Status       | published        | approver       |
      And I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | body                        | This is application one |
      | field_summary               | Application  summary    |
      | field_status_usage          | Approved                |
      | field_division_office_multi | division1               |
      | field_related_apps          | BEHAT Application       |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application"
    When I am on "/applications/behat-application/edit"
      And I fill in "Title" with "BEHAT Edited Application"
      And I press "Save"
      And I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Applications"
      And I should see the link "BEHAT Edited Application"
      And I should not see the link "BEHAT Application"

  @api @javascript
  Scenario: Delete Related Application And Verify On Software Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
      | title             | field_summary       | body                  | moderation_state | field_reviewer |
      | BEHAT Application | This is the Summary | Component description | published        | approver       |
      And I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | body                        | This is application one |
      | field_summary               | Application  summary    |
      | field_status_usage          | Approved                |
      | field_division_office_multi | division1               |
      | field_related_apps          | BEHAT Application       |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "Applications" in the "sidebar" region
      And I should see the link "BEHAT Application" in the "sidebar" region
    When  I navigate to the "/edit" page from the current url
      And I click "Related Technologies"
      And I wait 1 seconds
      And I fill in "Related Applications (value 1)" with ""
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should not see the text "Applications" in the "sidebar" region
      And I should not see the link "BEHAT Application" in the "sidebar" region
    When I am on "/applications/behat-application"
      And I should see the heading "BEHAT Application"
    Then I should not see the link "BEHAT Component"

  @api
  Scenario: Verify Software Page Created/Updated Label
    Given  I am logged in as a user with the "authenticated user" role
      And I am viewing a "component" content:
      | title                       | BEHAT Component Created |
      | body                        | Component description   |
      | field_summary               | Component summary       |
      | field_division_office_multi | division1               |
      | moderation_state            | published               |
      And I should see the text "Created"
      And I am viewing a "component" content:
      | title                       | BEHAT Component Updated   |
      | body                        | Component description     |
      | field_summary               | Updated component summary |
      | field_division_office_multi | division1                 |
      | changed                     | +2 day                    |
      | moderation_state            | published                 |
    Then I should see the text "Updated"
      And I should not see the text "Created"

  @api @javascript
  Scenario: Adding A Software and Platform Relationship
    Given "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Approval     | published        | division2                   | approver       |
      And  "platform" content:
      | title            | body         | field_summary | field_status_usage | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | BEHAT Retire       | published        | approver       |
    When I am logged in as a user with the "Content Creator" role
      And I am on "/software/behat-Component-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "Behat Platform 1" on the "Related Platforms" field
      And I press "Save"
    Then I am on "/software/behat-component-1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1"
      And I hover over the element "a.btn > span:nth-child(2)"
      And I should see the text "BEHAT Retire"
      And I should see the text "Platforms"
      And I click "Behat Platform 1"
      And I should see the link "Behat Component 1"
      And I should see the heading "Behat Platform 1"
      And I should see the text "Software"

  @api @javascript
  Scenario: Integrate Software With Many Platforms
    Given "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Approval     | published        | division2                   | approver       |
      And "platform" content:
      | title            | body         | field_summary | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | published        | approver       |
      | Behat Platform 2 | description1 | summary2      | published        | approver       |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I select the first autocomplete option for "Behat Platform 1" on the "Related Platform" field
      And I click on the element with css selector "input[id^='edit-field-related-platforms-add-more']"
      And I wait 2 seconds
      And I select the first autocomplete option for "Behat Platform 2" on the "Related Platforms (value 2)" field
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
    Then I am on "/software/behat-component-1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1"
      And I should see the link "Behat Platform 2"
      And I should see the text "Platforms"
      And I click "Behat Platform 2"
      And I should see the heading "Behat Platform 2"
      And I should see the link "Behat Component 1"
      And I should see the text "SoftWare"
      And I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Component 1"
      And I should see the text "Software"

  @api @javascript
  Scenario: Remove Platform On Software And Platform Relationship
    Given "platform" content:
      | title            | body         | field_summary | field_division_office_multi | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | division2                   | published        | approver       |
      And "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_related_platforms | field_division_office_multi | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Approval     | published        | Behat Platform 1        | division2                   | approver       |
    When I am logged in as a user with the "Content Approver" role
    Then I am on "/software/behat-component-1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1" in the "sidebar" region
      And I should see the text "Platforms" in the "sidebar" region
      And I click "Behat Platform 1"
      And I should see the heading "Behat Platform 1"
      And I should see the link "Behat Component 1" in the "sidebar" region
      And I should see the text "Software" in the "sidebar" region
    When I am on "/software/behat-component-1/edit"
      And I click "Related Technologies"
      And I wait 1 seconds
      And I fill in "Related Platform" with ""
      And I press "Save"
    Then I should see the heading "Behat Component 1"
      And I should not see the link "Behat Platform 1" in the "sidebar" region
      And I should not see the text "Platforms" in the "sidebar" region
      And I am on "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should not see the link "Behat Component 1" in the "sidebar" region
      And I should not see the text "Software" in the "sidebar" region

  @api @javascript
  Scenario: Workflow Publish To Archive For Software And Platform Relationship
    Given "platform" content:
      | title            | body         | field_summary | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | published        | approver       |
      And "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_related_platforms | field_division_office_multi | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Approval     | published        | Behat Platform 1        | division2                   | approver       |
    When I am logged in as a user with the "Content Approver" role
    Then I am on "/software/behat-component-1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1"
      And I should see the text "Platforms"
      And I click "Behat Platform 1"
      And I should see the link "Behat Component 1"
      And I should see the heading "Behat Platform 1"
      And I should see the text "Software"
    When I am on "/software/behat-component-1/edit"
      And I select "Archived" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    Then I visit "/software/behat-component-1"
      And I should see "Access Denied"
      And I visit "/platforms/behat-platform-1"
      And I should see the heading "Behat Platform 1"
      And I should not see the text "BEHAT Platform Edit"
      And I should not see the text "Software"

  @api
  Scenario: Edit Title Of A Software And Platform Relationship
    Given "platform" content:
      | title            | body         | field_summary | moderation_state | field_reviewer |
      | Behat Platform 1 | description1 | summary1      | published        | approver       |
      And "component" content:
      | title             | body         | field_summary | field_status_usage | moderation_state | field_related_platforms | field_division_office_multi | field_reviewer |
      | Behat Component 1 | description1 | summary1      | BEHAT Approval     | published        | Behat Platform 1        | division2                   | approver       |
    When I am logged in as a user with the "authenticated user" role
    Then I am on "/software/behat-component-1"
      And I should see the heading "Behat Component 1"
      And I should see the link "Behat Platform 1"
      And I should see the text "Platforms"
      And I click "Behat Platform 1"
      And I should see the link "Behat Component 1"
      And I should see the heading "Behat Platform 1"
      And I should see the text "Software"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component-1/edit"
      And I fill in "Title" with "Behat Software Update"
      And I press "Save"
    Then I should see the heading "Behat Software Update"
      And I should see the link "Behat Platform 1"
      And I should see the text "Platforms"
      And I click "Behat Platform 1"
      And I should see the link "Behat Software Update"
      And I should see the heading "Behat Platform 1"
      And I should see the text "Software"

  @api @javascript
  Scenario: Add Existing Article To Software
    Given  "article" content:
      | title          | field_summary | body | field_category | field_article_summary | moderation_state |
      | BEHAT Article1 | behat short   | test | Behat FAQ      | Article1 Summary      | published        |
      | BEHAT Article2 | description2  | test | Behat Other    |                       | published        |
      And I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component"
      And I fill in "Short Description" with "BEHAT summary"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "Approved" from "Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I scroll to the top
      And I wait 1 seconds
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
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article1"
      And I should see the text "behat short"
      And I should see the link "BEHAT Article2"
      And I should see the text "description"
      And I should see the link "Behat FAQ"
      And I should see the link "Behat Other"
    When I click "Behat FAQ"
    Then I should see the link "BEHAT Article1"
    When I click "BEHAT Article1"
      And I wait 1 seconds
    Then I should see the text "Software"
      And I should see the link "BEHAT Component"
      And I click "BEHAT Component"
      And I should see the link "BEHAT Article1"

  @api
  Scenario: Edit Existing Article And Verify On Software Page
    Given  "article" content:
      | title         | field_summary | body | field_category | field_article_summary | moderation_state | field_reviewer |
      | BEHAT Article | behat short   | test | Behat FAQ      | Article Summary       | published        | approver       |
    When I am logged in as a user with the "Content Approver" role
      And I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | field_summary               | This is the Summary     |
      | body                        | This is the description |
      | field_component_category    | BEHAT Category1         |
      | field_status_usage          | BEHAT Approval          |
      | field_division_office_multi | division1               |
      | field_related_articles      | BEHAT Article           |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "This is the description"
      And I should see the link "BEHAT Approval"
      And I should see the text "BEHAT Category1"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should not see the text "This is the Summary"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the link "Behat FAQ"
    When I am on "/behat-article/edit"
      And I fill in "Title" with "Edited Article"
      And I select "Behat Other" from "Category"
      And I press "Save"
    When I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Articles"
      And I should not see the link "BEHAT Article"
      And I should see the link "Edited Article"
      And I should see the text "behat short"
      And I should not see the link "Behat FAQ"

  @api @javascript
  Scenario: Delete Existing Article And Verify On Software Page
    Given  "article" content:
      | title         | field_summary | body | field_category | field_article_summary | moderation_state |
      | BEHAT Article | behat short   | test | Behat FAQ      | Article Summary       | published        |
    When I am logged in as a user with the "Content Approver" role
      And I am viewing a "component" content:
      | title                       | BEHAT Component         |
      | field_summary               | This is the Summary     |
      | body                        | This is the description |
      | field_component_category    | BEHAT Category2         |
      | field_status_usage          | BEHAT Approval          |
      | field_division_office_multi | division1               |
      | field_related_articles      | BEHAT Article           |
      | field_reviewer              | approver                |
      | moderation_state            | published               |
    Then I should see the heading "BEHAT Component"
      And I should see the text "This is the description"
      And I should see the link "BEHAT Approval"
      And I should see the text "BEHAT Category1"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should not see the text "This is the Summary"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the link "Behat FAQ"
      And I am logged in as a user with the "Content Approver" role
    When I am on "/software/behat-component/edit"
      And I click "Related Documentation"
      And I press "edit-field-related-articles-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I check "Delete this Article from the system."
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should not see the text "Articles"
      And I should not see the link "BEHAT Article"
    When I am on "/behat-article/edit"
    Then I should see "Page not found"

  @api @javascript
  Scenario: Add New Logo To Software
    Given "component" content:
      | title           | body        | field_summary | field_division_office_multi | field_status_usage | moderation_state | field_reviewer |
      | BEHAT component | description | summary       | division1                   | BEHAT Approval     | published        | approver       |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/software/behat-component/edit"
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
      And I press "Save"
    Then I should see the text "Software BEHAT Component has been updated."
      And I should see "Access denied"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component/"
      And I should see the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Add Existing Logo To Software
    Given "component" content:
      | title           | body        | field_summary | field_division_office_multi | field_status_usage | moderation_state | field_reviewer |
      | BEHAT component | description | summary       | division1                   | BEHAT Approval     | published        | approver       |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/software/behat-component/edit"
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
      And I press "Save"
    Then I should see the text "Software BEHAT Component has been updated."
      And I should see "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component/latest"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component/"
    Then I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "logo" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "logo" region

  @api @javascript
  Scenario: Update Logo And Verify On Software Page
    Given "component" content:
      | title           | body        | field_summary | field_division_office_multi | field_status_usage | field_logo | moderation_state | field_reviewer |
      | BEHAT Component | description | summary       | division1                   | BEHAT Approval     | SQL Logo   | published        | approver       |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component/edit"
      And I press "Edit" in the "create_logo" region
      And I wait for ajax to finish
      And I press "field_logo_form_inline_entity_form_entities_0_form_field_media_image_0_remove_button"
      And I wait for ajax to finish
      And I attach the file "behat-datacatalog-log.png" to "Image"
      And I wait for ajax to finish
      And I wait 2 seconds
      And I fill in "Alternative text" with "Behat Catalog Logo"
      And I press "Update Logo"
      And I wait for ajax to finish
      And I press "Save"
    Then I should see "Software BEHAT Component has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-datacatalog-log" in the "logo" region
      And I should see the "img" element with the "alt" attribute set to "Behat Catalog Logo" in the "logo" region

  @api @javascript
  Scenario: Remove Logo From Software
    Given "component" content:
      | title           | body        | field_summary | field_division_office_multi | field_status_usage | field_logo | moderation_state | field_reviewer |
      | BEHAT Component | description | summary       | division1                   | BEHAT Approval     | SQL Logo   | published        | approver       |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "Content Approver" role
      And I am on "/software/behat-component/edit"
      And I press "edit-field-logo-entities-0-actions-ief-entity-remove"
      And I wait for ajax to finish
      And I press "Remove" in the row_form region
      And I wait for ajax to finish
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/software/behat-component"
    Then I should see the heading "BEHAT Component"
      And I should not see the "logo" region

  @api @javascript
  Scenario: Workflow For Contact Guidance On Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_contact_guidance | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Behat Contact Guidance | BEHAT Approval     | approver       |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/software/behat-component"
    Then I should see the text "Access denied"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/software/behat-component/edit"
      And I select "Published" from "edit-moderation-state-0-state"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/software/behat-component"
    Then I should see the heading "BEHAT component"
      And I should see the text "Contacts"
      And I should see the text "description"
      And I should see the text "Snapshot"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"

  @api @javascript
  Scenario: Content Creator Adding Contact Guidance To Software
    Given I am logged in as a user with the "Content Creator, Migration Admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approval" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I scroll to the top
      And I wait 1 seconds
      And I click "Contacts"
      And I wait 1 seconds
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact, as needed"
      And I fill in "Contact Guidance" with "Behat Contact Guidance"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should see the text "Contacts"
      And I should see the text "This is the description of the topic"
      And I should see the text "Snapshot"
      And I should see the text "SEC Users"
      And I should see the text "division1"
      And I should see the text "Behat Contact Guidance"

  @api @javascript
  Scenario: Content Creator Adds Document To Software
    Given  I am logged in as a user with the "Content Creator, Migration Admin" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component"
      And I fill in "Short Description" with "BEHAT Forum"
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approval" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
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
      And I wait 5 seconds
      And I fill in "field_documents[form][1][field_description][0][value]" with "Document Description"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Component"
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
  Scenario: Site User Can View Software Category Icon
    Given "component" content:
      | title            | field_summary | body                  | field_status_usage | field_division_office_multi | field_logo | moderation_state | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT Component  | Summary       | Component description | BEHAT Approval     | division1                   |            | published        | 1                                | approver       |
      | BEHAT Component2 | Summary       | Component description | BEHAT Retire       | division1                   | SQL Logo   | published        | 1                                | approver       |
      And I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I drag taxonomy term "BEHAT Category2" onto "BEHAT Category1"
      And I press "Save"
      And I click "Edit" in the "BEHAT Category1" row
      And I select the first autocomplete option for "landmark" on the "Icon" field
      And I press "Save"
    When I am on "/software/behat-component/edit"
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I press "Save"
    When I am on "/software/behat-component2/edit"
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/technology-standards"
    Then I should see the link "BEHAT Category1"
      And I should see "2 Items"
      And I should see the "div" element with the "class" attribute set to "fontawesome-icon" in the "icon" region
    When I click "BEHAT Category1"
    Then I should see the heading "BEHAT Category1"
      And I should see the link "BEHAT Component"
      And I should see the link "BEHAT Component2"
      And I should see the link "BEHAT Approval"
      And I should see the link "BEHAT Retire"
      And I should see the "div" element with the "class" attribute set to "fontawesome-icon" in the "component_fallback_icon" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "logo" region
    When I am logged in as a user with the "sitebuilder" role
      And I visit "/admin/structure/taxonomy/manage/component_category/overview"
      And I click "Edit" in the "BEHAT Category1" row
      And I scroll to the bottom
      And I click "edit-delete"
      And I press "Delete"
      And I am on "/technology-standards"
    Then I should not see the link "BEHAT Category1"

  @api @javascript
  Scenario: Software Search Page Pagination
    Given "component" content:
      | title                | field_summary | moderation_state | field_approved_version | field_status_usage | field_component_category |
      | Behat A Component 1  | summary1      | published        | Behat AV 1.0           | Approved           |                          |
      | Behat B Component 2  | summary2      | published        |                        | Approved           |                          |
      | Behat C Component 3  | summary3      | published        |                        | Approved           |                          |
      | Behat Component 4    | summary4      | published        |                        | Approved           |                          |
      | Behat Component 5    | summary5      | published        |                        | Retired            |                          |
      | Behat Component 6    | summary6      | published        |                        | Retired            |                          |
      | Behat Component 7    | summary7      | published        |                        | Retired            |                          |
      | Behat D Component 8  | bacon         | published        |                        | Retired            |                          |
      | Behat Component 9    | summary9      | published        |                        | Pending Retirement |                          |
      | Behat Component 10   | summary10     | published        |                        | Pending Retirement |                          |
      | Behat Component 11   | summary11     | published        |                        | Pending Retirement |                          |
      | Behat Component 12   | summary12     | published        |                        | Pending Retirement |                          |
      | Behat E Component 13 | summary13     | published        |                        | Pending Retirement | BEHAT Category1          |
      | Behat F Component 14 | summary14     | published        |                        | Pending Retirement | BEHAT Category1          |
      | Behat T Component 15 | summary15     | published        |                        | Pending Retirement | BEHAT Category1          |
      | Behat Component 16   | summary16     | published        |                        |                    | BEHAT Category1          |
      | Behat Component 17   | summary17     | published        |                        |                    | BEHAT Category1          |
      | Behat Component 18   | summary18     | published        |                        |                    | BEHAT Category2          |
      | Behat Component 19   | summary19     | published        |                        |                    | BEHAT Category2          |
      | Behat Component 20   | summary20     | published        |                        |                    | BEHAT Category2          |
      | Behat Component 22   | summary21     | published        |                        |                    |                          |
      | Behat Component 23   | summary22     | published        |                        |                    |                          |
      | Behat Component 24   | summary23     | draft            |                        |                    |                          |
      | Search               | summary24     | published        |                        |                    |                          |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/software"
      And "Behat A Component 1" should precede "Behat B Component 2" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And "Behat B Component 2" should precede "Behat C Component 3" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And "Behat E Component 13" should precede "Behat F Component 14" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And "Behat F Component 14" should precede "Behat T Component 15" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And I select "Approved" from "Status"
      And I press "Search"
      And I wait for ajax to finish
    Then I should see the link "Behat A Component 1"
      And I should see the link "Behat B Component 2"
      And I should see the link "Behat C Component 3"
      And "Behat A Component 1" should precede "Behat B Component 2" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And "Behat B Component 2" should precede "Behat C Component 3" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
    When I press "Reset"
      And I select "BEHAT Category1" from "Technology Category"
      And I press "Search"
      And I wait for ajax to finish
    Then I should see the link "Behat E Component 13"
      And I should see the link "Behat F Component 14"
      And I should see the link "Behat T Component 15"
      And "Behat E Component 13" should precede "Behat F Component 14" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And "Behat F Component 14" should precede "Behat T Component 15" for the query "//div[contains(@class, 'view-list-img--header')]/h2/a[2]"
      And I press "Reset"
    Then I should see the heading "Software"
      And I should see the text "Search Terms"
      And I should see the text "Approval Status"
      And I should see the text "Technology Category"
      And I should not see the text "Behat AV 1.0"
      And I should see the link "Approved"
      And I should see the text "Showing 1 - 20 of 23 Software"
      And I scroll to the bottom
      And I should see the link "1"
      And I click "Last »"
      And I wait for ajax to finish
      And I should not see the text "summary24"
      And I wait for ajax to finish
      And I click "1"
      And I wait for ajax to finish
      And I should not see the text "summary7"

  @api @javascript
  Scenario: Software Search Validate Technology Category Parent And Child Search
    Given "component_category" terms:
      | name             | parent           |
      | BEHAT Category P |                  |
      | BEHAT Category C | BEHAT Category P |
      And "component" content:
      | title             | field_summary | body                  | field_status_usage | field_division_office_multi | moderation_state | field_component_category | field_short_name |
      | BEHAT Component P | Summary       | Component description | BEHAT Approval     | division1                   | published        | BEHAT Category P         | POP              |
      | BEHAT Component C | Summary       | Component description | BEHAT Retire       | division2                   | published        | BEHAT Category C         |                  |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I drag taxonomy term "BEHAT Category C" onto "BEHAT Category P"
      And I press "Save"
      And I am on "/software/behat-component-p/edit"
      And I select the option "BEHAT Category C" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/software"
      And I select "BEHAT Category P" from "Technology Category"
      And I press "Search"
      And I wait 2 seconds
    Then I should see the link "BEHAT Component P"
      And I wait 1 seconds
    When I press "Reset"
      And I select "BEHAT Category C" from "Technology Category"
      And I press "Search"
      And I wait 2 seconds
    Then I should see the link "BEHAT Component P"
      And I should see the link "BEHAT Component C"
      And I wait 1 seconds
    When I press "Reset"
      And I fill in "Search Terms" with "pop"
      And I press "Search"
      And I wait 2 seconds
    Then I should see the link "BEHAT Component P"

  @api
  Scenario Outline: Filter Software Search Page
    Given "component" content:
      | title             | body          | field_summary | moderation_state | <field_name> |
      | Behat Component 1 | description1  | summary1      | published        | <value1>     |
      | Behat Component 2 | description2  | summary2      | published        | <value2>     |
      | Behat Component 8 | description8  | bacon         | published        |              |
      | Search            | description24 | summary24     | published        |              |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/software"
      And <search1>
      And I press "Search"
      And I wait 2 seconds
    Then I should see the link "<result_value1>"
    When I press "Reset"
      And <search2>
      And I press "Search"
      And I wait 2 seconds
    Then I should see the link "<result_value2>"

    Examples:
      | search_filter       | search1                                               | search2                                               | field_name               | value1          | value2          | result_value1     | result_value2     |
      | Search Term         | I fill in "Search Terms" with "Search"                | I fill in "Search Terms" with "bacon"                 | field_data_search_index  |                 |                 | Search            | Behat Component 8 |
      | Key Search          | I fill in "Search Terms" with "Ford"                  | I fill in "Search Terms" with "Amazon"                | field_data_search_index  | Ford            | Amazon; Andes   | Behat Component 1 | Behat Component 2 |
      | Tags                | I fill in "Search Terms" with "automation"            | I fill in "Search Terms" with "sales"                 | field_tags               | automation      | sales           | Behat Component 1 | Behat Component 2 |
      | Status              | I select "Approved" from "Status"                     | I select "Retired" from "Status"                      | field_status_usage       | Approved        | Retired         | Behat Component 1 | Behat Component 2 |
      | Technology Category | I select "BEHAT Category1" from "Technology Category" | I select "BEHAT Category2" from "Technology Category" | field_component_category | BEHAT Category1 | BEHAT Category2 | Behat Component 1 | Behat Component 2 |

  @api @javascript
  Scenario: Software Typeahead Search
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title           | field_summary | body             | field_status_usage | field_division_office_multi | moderation_state | field_data_search_index |
      | BEHAT Component | Summary       | Comp description | Approved           | division1                   | published        |                         |
      | Test Component  | Summary       | full body        | BEHAT Approval     | division2                   | published        |                         |
      | Mario Kart      | Summary       | body text        | BEHAT Approval     | division2                   | published        | jackfruit               |
      | Splatoon        | Summary       | ink gun          | BEHAT Approval     | division2                   | published        | green apple             |
      And I run cron
    When I am on "/software"
      And I select the first autocomplete option for "test" on the "Search Terms" field
    Then I should see the heading "Test Component"
      And I should see the text "full body"
    When I am on "/software"
      And I select the first autocomplete option for "jack" on the "Search Terms" field
    Then I should see the heading "Mario Kart"
      And I should see the text "body text"
    When I am on "/software"
      And I select the first autocomplete option for "green" on the "Search Terms" field
    Then I should see the heading "Splatoon"
      And I should see the text "ink gun"
    When I am on "/software"
      And I select the first autocomplete option for "fruit" on the "Search Terms" field
    Then I should see the heading "Mario Kart"
      And I should see the text "body text"
    When I am on "/software"
      And I select the first autocomplete option for "apple" on the "Search Terms" field
    Then I should see the heading "Splatoon"
      And I should see the text "ink gun"
    When I am on "/software"
      And I select the first autocomplete option for "behat" on the "Search Terms" field
    Then I should see the heading "BEHAT Component"
      And I should see the text "Comp description"
    When I am on "/software"
      And I select the first autocomplete option for "green apple" on the "Search Terms" field
    Then I should see the heading "Splatoon"
      And I should see the text "ink gun"

  @api @javascript
  Scenario: Software List Landing Page
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/software/edit"
    Then I should see the link "Layout"
      And I type "This is the behat description of the topic" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I should see the text "This is the behat description of the topic"

  @api @javascript
  Scenario: Create A New Software With Request Installation
    Given I am logged in as a user with the "sitebuilder" role
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I drag taxonomy term "BEHAT Category2" onto "BEHAT Category1"
      And I press "Save"
    When I am logged in as a user with the "Content Approver, Migration Admin" role
      And I am on "/node/add/component"
      And I fill in "Title" with "Behat Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select "Waiver" from "Status"
      And I fill in "How to Request Installation" with "http://test.com"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading ""
      And I should see the link "Request Install"
    When I click "Request Install"
    Then the link should open in a new tab
      And I close the current tab

  @api @javascript
  Scenario: Create Software with Promote to Technology Standards Page
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
      And I drag taxonomy term "BEHAT Category2" onto "BEHAT Category1"
      And I press "Save"
      And I am on "/node/add/component"
      And I fill in "Title" with "Behat Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select the option "BEHAT Category1" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(1) select"
      And I select the option "BEHAT Category2" from the jquery select ".form-item-field-component-category-0-target-id .select-wrapper:nth-of-type(2) select"
      And I select "BEHAT Approval" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I check "Promoted to Technology Standards"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/technology-standards"
    Then I should see the text "1 Items" in the "total_items" region
      And I click "BEHAT Category1"
      And I should see the link "Behat Component"

  @api @javascript
  Scenario: Verify Discussions On Software Detailed Page
    Given I am logged in as a user with the "Content Approver, Migration Admin" role
      And "forums" terms:
      | name       |
      | Comp Forum |
    When I am on "/node/add/component"
      And I fill in "Title" with "BEHAT Component"
      And I fill in "Short Description" with "Behat summary"
      And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
      And I select "BEHAT Approval" from "Approval Status"
      And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see "Related Discussions"
      And I should see "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
    When I click "Start a New Discussion"
      And the link should open in a new tab
      And I wait 2 seconds
      And I fill in "Title" with "BEHAT Comp Forum"
      And I select "Comp Forum" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
    Then I should see the text "Related Content"
      And I should see the link "BEHAT Component"
    When I click "BEHAT Component"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Comp Forum"
      And I close the current window

  @api @javascript
  Scenario: Verify Software Page After Removing Use Case
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "component" content:
      | title                       | BEHAT Component   |
      | body                        | Body              |
      | field_summary               | Summary           |
      | field_division_office_multi | division1         |
      | field_status_usage          | BEHAT Approval    |
      | field_dataset_use           | BEHAT Use Case3   |
      | field_reviewer              | approver          |
      | moderation_state            | published         |
    Then I should see the heading "BEHAT Component"
      And I should see the text "Body"
      And I should not see the text "Summary"
      And I should see the link "division1"
      And I should see the link "BEHAT Use Case3"
    When I am on "/software/behat-component/edit"
      And I select "" from "Use Cases" for the "1" option of the "1" row
      And I press "Save"
    Then I should see the heading "BEHAT Component"
      And I should not see the link "BEHAT Use Case3"

  @api
  Scenario: Admin Content Short Name Search For Software
    Given I am logged in as a user with the "Content Creator" role
      And "component" content:
      | title            | field_short_name | body             | moderation_state |
      | BEHAT Component1 | cocopuffs        | This is the body | published        |
      | BEHAT Component2 | trix             | This is the body | published        |
      And I run cron
    When I am on "/admin/content"
      And I should see the link "BEHAT Component1"
      And I should see the link "BEHAT Component2"
      And I fill in "Search" with "coco"
      And I press "Filter"
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component2"

  @api @javascript
  Scenario: Software List Page Search Using Short Name And Autocomplete
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title            | field_short_name | body             | moderation_state |
      | BEHAT Component3 | raisin cheerios  | This is the body | published        |
      | BEHAT Component4 | oatmeal          | This is the body | published        |
      And I run cron
    When I am on "/software"
      And I select the first autocomplete option for "cheerios" on the "Search Terms" field
    Then I should see the heading "BEHAT Component3 (raisin cheerios)"
    When I am on "/software"
      And I fill in "Search Terms" with "raisin"
      And I press "Search"
    Then I should see the link "BEHAT Component3"
      And I should not see the link "BEHAT Component4"
    When I am on "/software"
      And I select the first autocomplete option for "oat" on the "Search Terms" field
    Then I should see the heading "BEHAT Component4 (oatmeal)"

  @api @javascript
  Scenario: Software List Page Search Using Manufacturer and Autocomplete
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title            | body             | field_manufacturer | field_status | moderation_state |
      | BEHAT Component1 | This is the body | Microhard          | Approved     | published        |
      | BEHAT Component2 | trix             | Microsoft          |              | published        |
      And I run cron
    When I am on "/software"
      And I select the first autocomplete option for "Microh" on the "Search Terms" field
    Then I should see the heading "BEHAT Component1"
      And I should not see the heading "BEHAT Component2"
    When I am on "/software"
      And I fill in "Search Terms" with "Microhard"
      And I press "Search"
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component2"

  @api
  Scenario Outline: unauthorized Users cannot create an Software
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/component"
    Then I should see the text "Access Denied"
      And I should see the text "You are not authorized to access this page."

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
