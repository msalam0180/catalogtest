Feature: Technology Standards Page
  Users can visit technology standards page to review technology on their block at a high level

  Background:
    Given I create "taxonomy_term" of type "component_category":
      | name                 | parent            | field_summary | field_icon |
      | BEHAT CC Header 1    |                   | Summary1      | dog        |
      | BEHAT H1 Child 1     | BEHAT CC Header 1 | Summary1      | cat        |
      | BEHAT H1 Child 2     | BEHAT CC Header 1 | Summary2      |            |
      | BEHAT H1 Child 3     | BEHAT CC Header 1 | Summary3      |            |
      | BEHAT H1 Child 4     | BEHAT CC Header 1 | Summary4      |            |
      | 1A Steak Sauce       | BEHAT CC Header 1 | Summary5      |            |
      | 12B-1 Fee            | BEHAT CC Header 1 | Summary6      |            |
      | 401K Retirement      | BEHAT CC Header 1 | Summary7      |            |
      | 5 Guys               | BEHAT CC Header 1 | Summary8      |            |
      | Retirement           | BEHAT CC Header 1 | Summary9      |            |
      | Money Laundering     | BEHAT CC Header 1 | Summary10     |            |
      | Money Market Account | BEHAT CC Header 1 | Summary11     |            |
      | Zero Cost Collar     | BEHAT CC Header 1 | Summary12     |            |
      | BEHAT CC Header 2    |                   | Summary2      | cat        |
      | BEHAT H2 Child 1     | BEHAT CC Header 2 | Summary1      | book       |
      | BEHAT H2 Child 2     | BEHAT CC Header 2 | Summary2      | node       |
      | BEHAT CC Header 3    |                   |               | car        |
      | BEHAT CC Header 4    |                   | Summary4      | list       |
      | BEHAT CC Header 5    |                   | Summary5      | smile      |
      | BEHAT H1 Child 5     | BEHAT CC Header 3 | Summary5      | bird       |
      And "division_office" terms:
      | name      |
      | division1 |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | SQL Logo   | behat-sql-logo.png   | Behat SQL Caption   |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And I create "taxonomy_term" of type "status":
      | name              | field_icon | field_status_color |
      | BEHAT Retire      | leaf       | #AF2525            |
      | BEHAT Approve     | leaf       | #00695C            |
      | BEHAT Exception   | leaf       | #00838F            |
      | BEHAT Recommended | flag       | #436BC3            |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |

  @api
  Scenario: Content Creator Edit Body
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/technology-category/edit"
    Then I should see the text "Access denied"

  @api @javascript
  Scenario: Visitor To Tech Standards Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
      | title      | body             | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT App1 | app description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                | approver       |
      | BEHAT App2 | app description2 | summary of app2 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | SQL Logo   | 1                                | approver       |
      | BEHAT App3 | app description3 | summary of app3 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 5          | SQL Logo   | 1                                | approver       |
      And "component" content:
      | title        | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo | field_reviewer |
      | Behat Cmpt   | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                | approver       |
      | Behat Cmpt 2 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 2         |            | 1                                | approver       |
      | Behat Cmpt 3 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 3         |            | 1                                | approver       |
      | Behat Cmpt 4 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H2 Child 1         |            | 1                                | approver       |
      And "platform" content:
      | title        | body              | field_summary      | field_division_office_multi | field_status_usage | field_component_category | moderation_state | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT Plat 1 | This is the body1 | platform1 in short | division1                   | BEHAT Approve      | BEHAT H1 Child 1         | published        | 1                                | approver       |
      | BEHAT Plat 2 | This is the body2 | platform2 in short | division1                   | BEHAT Retire       | BEHAT H1 Child 1         | published        | 1                                | approver       |
      And I visit "/technology-standards"
      And I click "BEHAT CC Header 1"
      And I click "(edit)"
      And I fill in "Title" with "Behat Cmpt 1"
      And I press "Save"
      And I visit "/admin/structure/taxonomy/manage/component_category/overview"
      And I click "Edit" in the "BEHAT CC Header 1" row
      And I press "Save"
      And I click "Edit" in the "BEHAT CC Header 2" row
      And I press "Save"
      And I click "Edit" in the "BEHAT CC Header 3" row
      And I press "Save"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/technology-standards"
    Then I should see the heading "Technology Category"
      And I should see the link "BEHAT CC Header 1"
      And I should see the text "Summary1"
      And I should see the text "5 Items"
      And I should see the text "1 Items"
      And "BEHAT CC Header 1" should precede "BEHAT CC Header 2" for the query "//div[contains(@class, 'tech-view-box--header')]/h2/a"
      And I should see the link "BEHAT CC Header 2"
      And I should see the link "BEHAT CC Header 3"
      And I should see the link "BEHAT CC Header 4"
      And I should see the link "BEHAT CC Header 5"
    When I click "BEHAT CC Header 1"
    Then I should see the heading "BEHAT CC Header 1"
      And I should see the text "Browse by subcategory:"
      And I should see the link "BEHAT H1 Child 1" in the "sub_category" region
      And I should see the link "BEHAT H1 Child 2" in the "sub_category" region
      And I should see the link "BEHAT H1 Child 3" in the "sub_category" region
      And I should see the link "BEHAT H1 Child 4" in the "sub_category" region
      And I should see the "img" element with the "src" attribute set to "/behat-sql-logo" in the "forum_content" region
      And I should see the link "BEHAT App1"
      And I should see the link "BEHAT App2"
      And I should see the link "Behat Cmpt"
      And I should see the link "Behat Cmpt 2"
      And I should see the link "Behat Cmpt 3"
      And I should see the link "BEHAT Plat 1"
      And I should see the link "BEHAT Plat 2"
      And I should see the text "summary1"
      And I should see the text "BEHAT Recommended"
    When I click "BEHAT H1 Child 1"
    Then I should see the heading "BEHAT H1 Child 1"
      And I should see the heading "Platforms, Software, and Tools"
      And I should see the heading "Business Applications"
      And I should see the link "BEHAT CC Header 1"
      And I should see the link "Behat Cmpt 1"
      And I should see the link "BEHAT Plat 1"
      And I should see the link "BEHAT Plat 2"
      And I should see the link "BEHAT App1"
      And I should see the link "BEHAT App2"
      And I should see the text "summary of app1"
      And I should not see the link "Behat Cmpt 2"
      And I should not see the link "Behat Cmpt 3"
      And I should see the link "Technology Category" in the "breadcrumb" region
      And I should see the link "BEHAT CC Header 1" in the "breadcrumb" region
    # Validate for zero state for Component category term page with no components
    When I click "Technology Category" in the "breadcrumb" region
      And I click "BEHAT CC Header 2"
    Then I should see the heading "BEHAT CC Header 2"
      And I should see the link "BEHAT H2 Child 1"
      And I should see the text "There are no Business Applications"
    When I click "BEHAT H2 Child 1"
    Then I should see the text "There are no Business Applications"
    When I am on "/technology-standards"
      And I click "BEHAT CC Header 3"
    Then I should see the heading "BEHAT CC Header 3"
      And I should see the link "BEHAT H1 Child 5"
      And I should see the text "There are no Software, Platforms or Tools"
    When I click "BEHAT H1 Child 5"
    Then I should see the text "There are no Software, Platforms or Tools"
    When I am on "/technology-standards"
      And I click "BEHAT CC Header 4"
      And I should see the text "There are no Software, Platforms or Tools"
      And I should see the text "There are no Business Applications"

  @api @javascript
  Scenario: UnPublished Contents Do Not Show Up On Technology Standards Page
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title        | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo |
      | Behat Cmpt 1 | description1 | summary1      | BEHAT Recommended  | draft            | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
      | Behat Cmpt 3 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
    When I am on "/technology-standards"
    Then I should see the heading "Technology Category"
      And I should see the link "BEHAT CC Header 1"
      And I should see the text "Summary1"
      And I should see the text "1 Items"
      And I click "BEHAT CC Header 1"
      And I should see the link "Behat Cmpt 3"
      And I should not see the link "Behat Cmpt 1"

  @api @javascript
  Scenario: Remove Component Updates Technology Standards Page
    Given I am logged in as a user with the "Content Approver" role
      And "component" content:
      | title        | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo |
      | Behat Cmpt 1 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
      | Behat Cmpt 3 | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
    When I visit "/technology-standards"
    Then I should see the heading "Technology Category"
      And I should see the link "BEHAT CC Header 1"
      And I should see the text "Summary1"
      And I should see the text "2 Items"
    When I am on "/software/behat-cmpt-1/delete"
      And I press "Delete"
      And I visit "/technology-standards"
    Then I should see the heading "Technology Category"
      And I should see the link "BEHAT CC Header 1"
      And I should see the text "Summary1"
      And I should see the text "1 Items"

  @api @javascript
  Scenario: Verify Order Of Applications, Software And Platforms
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title        | body             | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App1   | app description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      | A BEHAT App2 | app description2 | summary of app2 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 2          | SQL Logo   | 1                                |
      | BEHAT App3   | app description3 | summary of app3 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      | E BEHAT App1 | app description4 | summary of app4 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 2          | SQL Logo   | 1                                |
      | Z BEHAT App1 | app description5 | summary of app5 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      And "component" content:
      | title         | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | Behat Comp1   | description1 | summary1      | Catalog            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp2   | description1 | summary1      | Approved           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | A Behat Comp3 | description1 | summary1      | Approved           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | C Behat Comp4 | description1 | summary1      | Waiver             | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp5   | description1 | summary1      | Pending Retirement | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp6   | description1 | summary1      | Waiver             | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp7   | description1 | summary1      | Pending Lifecycle  | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp8   | description1 | summary1      | Retired            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Comp9   | description1 | summary1      | Pending Retirement | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      And "platform" content:
      | title         | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | Behat Plat1   | description1 | summary1      | Catalog            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | A Behat Plat3 | description1 | summary1      | Approved           | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | C Behat Plat4 | description1 | summary1      | Waiver             | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat5   | description1 | summary1      | Pending Retirement | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat7   | description1 | summary1      | Pending Lifecycle  | published        | division1                   | BEHAT H1 Child 1         | 1                                |
      | Behat Plat8   | description1 | summary1      | Retired            | published        | division1                   | BEHAT H1 Child 1         | 1                                |
    When I am on "/technology-standards"
      And I click "BEHAT CC Header 1"
    Then I should see the link "BEHAT H1 Child 1" in the "group_heading" region
      And I should see the heading "Platforms, Software, and Tools"
     Then I should see the text "Approved" before I see the text "Waiver" in the "category_list" region
      And I should see the text "Waiver" before I see the text "Pending Lifecycle" in the "category_list" region
      And I should see the text "Pending Lifecycle" before I see the text "Pending Retirement" in the "category_list" region
      And I should see the text "Pending Retirement" before I see the text "Retired" in the "category_list" region
      And I should see the text "Retired" before I see the text "Catalog" in the "category_list" region
      And I should see the link "Behat Comp1" before I see the link "Behat Plat1" in the "category_list" region
      And I should see the link "A Behat Comp3" before I see the link "A Behat Plat3" in the "category_list" region
      And I should see the text "Behat Comp6" before I see the text "C Behat Comp4" in the "category_list" region
      And I should see the heading "Business Applications"
      And I should not see the link "BEHAT H1 Child 1" in the "applications" region
      And I should not see the link "BEHAT H1 Child 2" in the "applications" region
      And "A BEHAT App2" should precede "BEHAT App1" for the query "//div[contains(@class, 'view-list-img')]/h3/a"
      And "BEHAT App1" should precede "BEHAT App3" for the query "//div[contains(@class, 'view-list-img')]/h3/a"
      And "BEHAT App3" should precede "E BEHAT App1" for the query "//div[contains(@class, 'view-list-img')]/h3/a"
      And "E BEHAT App1" should precede "Z BEHAT App1" for the query "//div[contains(@class, 'view-list-img')]/h3/a"

  @api @javascript
  Scenario: Promote Application, Component And Platform To Technology Standards Page
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title      | body         | field_summary   | field_division_office_multi | field_app_status | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App1 | description1 | summary of app1 | division1                   | BEHAT Status A   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      | BEHAT App2 | description2 | summary of app2 | division1                   | BEHAT Status A   | published        | BEHAT H1 Child 1          | EDGAR Logo | 0                                |
      And "component" content:
      | title       | body         | field_summary    | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT Comp1 | description1 | summary of comp1 | BEHAT Retire       | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
      | BEHAT Comp2 | description1 | summary of comp2 | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 0                                |
      And "platform" content:
      | title       | body        | field_summary    | moderation_state | field_status_usage | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo |
      | BEHAT Plat1 | description | summary of plat1 | published        | BEHAT Recommended  | division1                   | BEHAT H1 Child 1         | 1                                |
      | BEHAT Plat2 | description | summary of plat2 | published        | BEHAT Retire       | division1                   | BEHAT H1 Child 1         | 0                                |
    When I am on "/technology-standards"
    Then I should see the text "2 Items" in the "total_items" region
    When I click "BEHAT CC Header 1"
    Then I should see the link "BEHAT Comp1"
      And I should see the link "BEHAT Plat1"
      And I should see the link "BEHAT App1"
      And I should not see the link "BEHAT Comp2"
      And I should not see the link "BEHAT Plat2"
      And I should not see the link "BEHAT App2"
      And I should see the link "BEHAT Recommended"
      And I should see the link "BEHAT Retire"
      And I should see the text "summary of comp1"
      And I should see the text "summary of plat1"
      And I should see the text "summary of app1 "

  @api @javascript
  Scenario: Remove Promoted Content And Verify On Technology Standards Page
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title      | body         | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT App1 | description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                | approver       |
      And "component" content:
      | title       | body         | field_summary    | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT Comp1 | description1 | summary of comp1 | BEHAT Retire       | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                | approver       |
      And "platform" content:
      | title       | body        | field_summary    | moderation_state | field_status_usage | field_division_office_multi | field_component_category | field_promote_it_to_the_technolo | field_reviewer |
      | BEHAT Plat1 | description | summary of plat1 | published        | BEHAT Recommended  | division1                   | BEHAT H1 Child 1         | 1                                | approver       |
    When I am on "/technology-standards"
    Then I should see the text "2 Items" in the "total_items" region
    When I click "BEHAT CC Header 1"
    Then I should see the link "BEHAT Comp1"
      And I should see the link "BEHAT Plat1"
      And I should see the link "BEHAT App1"
      And I should see the link "BEHAT Recommended"
      And I should see the link "BEHAT Retire"
      And I should see the text "summary of comp1"
      And I should see the text "summary of plat1"
      And I should see the text "summary of app1"
      And I am logged in as a user with the "Content Approver" role
    When I am on "/software/behat-comp1/edit"
      And I uncheck "Promoted to Technology Standards"
      And I press "Save"
      And I am on "platforms/behat-plat1/edit"
      And I uncheck "Promoted to Technology Standards"
      And I press "Save"
    When I am on "applications/behat-app1/edit"
      And I uncheck "Promoted to Technology Standards"
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
    When I am on "/technology-standards/behat-cc-header-1"
    Then I should not see the link "BEHAT Comp1"
      And I should not see the link "BEHAT Plat1"
      And I should not see the link "BEHAT App1"

  @api @javascript
  Scenario: Authorized Users Can Edit Category Subheading And Paragraph
    Given I am logged in as a user with the "sitebuilder" role
      And "application" content:
      | title     | body             | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App | app description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      And "component" content:
      | title      | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo |
      | Behat Comp | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
      And "platform" content:
      | title      | body              | field_summary      | field_division_office_multi | field_status_usage | field_component_category | moderation_state | field_promote_it_to_the_technolo |
      | BEHAT Plat | This is the body1 | platform1 in short | division1                   | BEHAT Approve      | BEHAT H1 Child 1         | published        | 1                                |
      And I visit "/technology-standards/behat-cc-header-1"
      And I wait 2 seconds
    When I hover over the element "#block-platformssoftwareandtools > div:nth-child(2) > button:nth-child(1)"
      And I wait 2 seconds
      And I press "Open Platforms, Software, and Tools configuration options"
      And I click on the element with css selector "#block-platformssoftwareandtools > div.contextual > ul > li.block-contentblock-edit > a"
    Then I should see the heading "Edit custom block Platforms, Software, and Tools"
      And I type "This is the description of software block" in the "Body" WYSIWYG editor
      And I press "Save"
    Then I should see the heading "Platforms, Software, and Tools"
      And I should see the text "This is the description of software block"
      And I wait 2 seconds
    When I hover over the element "#block-businessapplications > div:nth-child(2) > button:nth-child(1)"
      And I wait 2 seconds
      And I press "Open Business Applications configuration options"
      And I click on the element with css selector "#block-businessapplications > div.contextual > ul > li.block-contentblock-edit > a"
    Then I should see the heading "Edit custom block Business Applications"
      And I type "This is the description of applications block" in the "Body" WYSIWYG editor
      And I press "Save"
    Then I should see the heading "Business Applications"
      And I should see the text "This is the description of applications block"

  @api
  Scenario Outline: UnAuthorized Users Can Not Edit Category Subheading And Paragraph Block
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/block/block-content"
    Then I should see the text "<result1>"
      And I should not see the text "<result2>"
      And I should not see the text "<result3>"

    Examples:
      | role               | result1              | result2                        | result3               |
      | Content Creator    | Access denied        | Platforms, Software, and Tools | Business Applications |
      | Content Approver   | Custom block library | Platforms, Software, and Tools | Business Applications |
      | authenticated user | Access denied        | Platforms, Software, and Tools | Business Applications |

  @api @javascript
  Scenario: Verify SectionID For Subheading Section
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title     | body             | field_summary   | field_division_office_multi | field_app_status | field_owner | moderation_state | field_technology_category | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App | app description1 | summary of app1 | division1                   | BEHAT Status A   | division1   | published        | BEHAT H1 Child 1          | EDGAR Logo | 1                                |
      And "component" content:
      | title      | body         | field_summary | field_status_usage | moderation_state | field_division_office_multi | field_component_category | field_logo | field_promote_it_to_the_technolo |
      | Behat Comp | description1 | summary1      | BEHAT Recommended  | published        | division1                   | BEHAT H1 Child 1         | SQL Logo   | 1                                |
      And "platform" content:
      | title      | body              | field_summary      | field_division_office_multi | field_status_usage | field_component_category | moderation_state | field_promote_it_to_the_technolo |
      | BEHAT Plat | This is the body1 | platform1 in short | division1                   | BEHAT Approve      | BEHAT H1 Child 1         | published        | 1                                |
    When I visit "/technology-standards/behat-cc-header-1"
    Then I should see the "a" element with the "id" attribute set to "software" in the "main_container" region
      And I should see the "a" element with the "id" attribute set to "applications" in the "main_container" region

  @api @javascript
  Scenario: Verify Application Listed Only Once In The Category Page
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title      | body             | field_summary   | field_division_office_multi | moderation_state | field_technology_category          | field_logo | field_promote_it_to_the_technolo |
      | BEHAT App1 | app description1 | summary of app1 | division1                   | published        | BEHAT H1 Child 1, BEHAT H1 Child 2 | EDGAR Logo | 1                                |
      | BEHAT App2 | app description2 | summary of app1 | division1                   | published        | BEHAT H1 Child 2                   | SQL Logo   | 1                                |
    When I visit "/technology-standards"
    Then I should see the text "0 Items" in the "category_term_title" region
    When I click "BEHAT CC Header 1"
    Then I should see the link "BEHAT App1"
      And I should see the link "BEHAT App2"

  @api @javascript
  Scenario: Browse by Subcategory list is Alphabetized
    Given I am logged in as a user with the "authenticated user" role
    When I visit "/technology-standards"
      And I click "BEHAT CC Header 1"
    Then "12B-1 Fee" should precede "1A Steak Sauce" for the query "//ul[contains(@class, 'list-inline')]/li/span/span/a"
      And "401K Retirement" should precede "Retirement" for the query "//ul[contains(@class, 'list-inline')]/li/span/span/a"
      And "401K Retirement" should precede "5 Guys" for the query "//ul[contains(@class, 'list-inline')]/li/span/span/a"
      And "Money Laundering" should precede "Money Market Account" for the query "//ul[contains(@class, 'list-inline')]/li/span/span/a"
      And "Money Market Account" should precede "Zero Cost Collar" for the query "//ul[contains(@class, 'list-inline')]/li/span/span/a"
