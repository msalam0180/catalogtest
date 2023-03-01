Feature: Create A Landing Page And Add Columns And Custom Contents
  As a Site builder, I want to create Landing Pages in the Data Catalog with complex layouts so that I can present content
  in new and different ways based on circumstances.
  I can also add custom content onto Landing Pages so that I can provide relevant content to the user.

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |

  @api @javascript
  Scenario Outline: Authorized Users Can Create A Landing Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/landing_page"
      And I fill in "Title" with "BEHAT Landing Page"
      And I type "BEHAT landing page Description" in the "Body" WYSIWYG editor
      And I fill in "Short Description" with "BEHAT Landing Page Short Description"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
      And I select "published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Landing Page"
      And I should see the text "BEHAT landing page Description"
      And I should not see the text "BEHAT Landing Page Short Description"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Edit A Landing Page
    Given I am logged in as a user with the "<role>" role
      And "landing_page" content:
      | title              | body                           | field_summary                  | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
    When I am on "/behat-landing-page"
    Then I should see the heading "BEHAT Landing Page"
    When I am on "/behat-landing-page/edit"
      And I fill in "Title" with "BEHAT Landing Edited"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should not see the heading "BEHAT Landing Page"
      And I should see "Landing Page BEHAT Landing Edited has been updated."
      And I should see the heading "BEHAT Landing Edited"
      And I should see the text "This is the BEHAT landing page"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete A Landing Page
    Given "landing_page" content:
      | title              | body                           | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Landing Page" row
      And I click "Delete" in the "node_action" region
    Then I should see "Are you sure you want to delete the content item BEHAT Landing Page?"
      And I press "Delete"
    When I am on "/behat-landing-page"
    Then I should see "Page not found"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api
  Scenario Outline: Unauthorized Users Can Not Create A Landing Page
    Given "landing_page" content:
      | title              | body                           | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "/node/add/landing_page"
    Then I should see "Access denied"
      And I should see "You are not authorized to access this page"
    When I am on "/behat-landing-page/layout"
    Then I should see "Access denied"
      And I should see "You are not authorized to access this page"
    When I am on "<url>"
    Then I should see "Access denied"

    Examples:
      | role               | url                        |
      | authenticated user | /technology-category/edit |
      | Content Creator    | /technology-category/edit |
      | authenticated user | /platforms/edit            |
      | Content Creator    | /platforms/edit            |
      | authenticated user | /software/edit             |
      | Content Creator    | /software/edit             |
      | authenticated user | /applications/edit         |
      | Content Creator    | /applications/edit         |

  @api
  Scenario: Site Visitor Can View Only Published Landing Page
    Given "landing_page" content:
      | title                          | body                           | moderation_state |
      | BEHAT Published Landing Page   | This is the BEHAT landing page | published        |
      | BEHAT Unpublished Landing Page | This is the BEHAT landing page | draft            |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/behat-published-landing-page"
    Then I should see the heading "BEHAT Published Landing Page"
    When I am on "/behat-unpublished-landing-page"
    Then I should see the text "Access denied"

  @api @javascript
  Scenario Outline: Unauthorized Users Can View Only Published Landing Page
    Given "landing_page" content:
      | title                          | body                           | moderation_state |
      | BEHAT Published Landing Page   | This is the BEHAT landing page | published        |
      | BEHAT Unpublished Landing Page | This is the BEHAT landing page | draft            |
      And I am logged in as a user with the "<role>" role
    When I am on "/behat-published-landing-page"
    Then I should see the heading "BEHAT Published Landing Page"
    When I am on "/behat-unpublished-landing-page"
    Then I should see the text "Access denied"
      And I should see the text "You are not authorized to access this page"

    Examples:
      | role               |
      | authenticated user |
      | Content Creator    |

  @api @javascript
  Scenario Outline: Authorized Users Can Create And Move A Custom Block
    Given I am logged in as a user with the "<role>" role
      And "landing_page" content:
      | title                        | body                           | field_summary                  | moderation_state |
      | BEHAT Published Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
    When I am on "/behat-published-landing-page/layout"
      And I click "Add section"
      And I wait 2 seconds
      And I click "Two column"
      And I wait 1 seconds
      And I select "67%/33%" from "Column widths"
      And I wait 1 seconds
      And I press "Add section"
      And I wait 1 seconds
      And I click on the element with css selector ".layout__region--first > div:nth-child(2) > a:nth-child(1)"
      And I wait 2 seconds
      And I click "Create custom block"
      And I wait 1 seconds
      And I click "Custom Landing Page block" in the "block_section" region
      And I wait 2 seconds
      And I fill in "Title" with "This is behat block one"
      And I type "This is the BEHAT landing page section one block one" in the "Body" WYSIWYG editor
      And I press "Add block"
      And I wait 2 seconds
      And I click on the element with css selector "div.layout-builder__add-block:nth-child(2) > a:nth-child(1)"
      And I wait 2 seconds
      And I click "Create custom block"
      And I wait 2 seconds
      And I click "Custom Landing Page block" in the "block_section" region
      And I wait 2 seconds
      And I fill in "Title" with "This is behat block two" in the "configure_block" region
      And I type "This is the BEHAT landing page section one block two" in the "Body" WYSIWYG editor
      And I press "Add block"
      And I wait 2 seconds
      And I scroll to the top
      And I press "Save layout"
    Then I should see the heading "This is behat block one" in the "first_block" region
      And I should see the heading "This is behat block two" in the "second_block" region
    When I am on "/behat-published-landing-page/layout"
      And I press "Open This is behat block two configuration options"
      And I wait 2 seconds
      And I click "Move" in the "second_block" region
      And I wait 2 seconds
      And I select "Section: 1, Region: First" from "Region"
      And I wait 2 seconds
      And I press "Move"
      And I wait 2 seconds
      And I press "Save layout"
    Then I should see the heading "This is behat block one" in the "first_block" region
      And I should see the heading "This is behat block two" in the "first_block" region

      Examples:
       | role             |
       | Content Approver |
       | administrator    |
       | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Create, Discard, Revert A Reusable Block And Add To Landing Page
    Given I am logged in as a user with the "<role>" role
      And "landing_page" content:
      | title                        | body                           | field_summary                  | moderation_state |
      | BEHAT Published Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
    When I am on "/block/add/landing_page_block"
      And I fill in "Block description" with "BEHAT Custom Block"
      And I type "This is the BEHAT landing page section block for reuable block" in the "Body" WYSIWYG editor
      And I press "Save"
    When I am on "/behat-published-landing-page/layout"
      And I click "Add section"
      And I wait 2 seconds
      And I click "One column"
      And I wait 1 seconds
      And I press "Add section"
      And I wait 2 seconds
      And I click "Add block"
      And I wait 2 seconds
      And I click "BEHAT Custom Block"
      And I wait 2 seconds
      And I press "Add block"
      And I wait 2 seconds
      And I scroll to the top
      And I press "Save layout"
    Then I should see the heading "BEHAT Custom Block"
      And I should see the text "This is the BEHAT landing page section block for reuable block"
    When I am on "/behat-published-landing-page/layout"
      And I press "Revert to defaults"
    Then I should see "Are you sure you want to revert this to defaults?"
    When I press "Revert"
    Then I should see "The layout has been reverted back to defaults."
      And I should not see the heading "BEHAT Custom Block"
      And I should not see the text "This is the BEHAT landing page section block for reuable block"
    When I am on "/behat-published-landing-page/layout"
      And I click "Add section"
      And I wait 2 seconds
      And I click "One column"
      And I wait 1 seconds
      And I press "Add section"
      And I wait 2 seconds
      And I click "Add block"
      And I wait 2 seconds
      And I click "BEHAT Custom Block"
      And I wait 2 seconds
      And I press "Add block"
      And I wait 2 seconds
      And I scroll to the top
      And I press "Discard changes"
    Then I should see "Are you sure you want to discard your layout changes?"
    When I press "Confirm"
    Then I should not see the heading "BEHAT Custom Block"
      And I should not see the text "This is the BEHAT landing page section block for reuable block"
      # Clean up created custom block "BEHAT Custom Block"
      And I visit "/admin/structure/block/block-content"
      And I press the "List additional actions" button
      And I click "Delete" in the "BEHAT Custom Block" row
      And I press "Delete"

      Examples:
       | role             |
       | Content Approver |
       | administrator    |
       | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Edit A Custom Block In The Landing Page
    Given I am logged in as a user with the "<role>" role
      And "landing_page" content:
      | title              | body                           | field_summary                  | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
    When I am on "/behat-landing-page/layout"
      And I wait 1 seconds
      And I click "Add section"
      And I wait 2 seconds
      And I click "One column"
      And I wait 1 seconds
      And I press "Add section"
      And I wait 2 seconds
      And I click "Add block"
      And I wait 2 seconds
      And I click "Create custom block"
      And I wait 1 seconds
      And I click "Custom Landing Page block" in the "block_section" region
      And I wait 2 seconds
      And I fill in "Title" with "This is behat block"
      And I type "This is the BEHAT landing page section one block" in the "Body" WYSIWYG editor
      And I press "Add block"
      And I wait 2 seconds
      And I scroll to the top
      And I press "Save layout"
    Then I should see the heading "This is behat block"
      And I should see the text "This is the BEHAT landing page section one block"
    When I am on "/behat-landing-page/layout"
      And I press "Open This is behat block configuration options"
      And I wait 1 seconds
      And I click "Configure" in the "layout_section" region
      And I wait 1 seconds
      And I fill in "This is behat block Edited" for "Title"
      And I wait 1 seconds
      And I press "Update"
      And I wait 1 seconds
      And I press "Save layout"
    Then I should see the heading "This is behat block Edited"

      Examples:
       | role             |
       | Content Approver |
       | administrator    |
       | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete A Custom Block In The Landing Page
    Given I am logged in as a user with the "<role>" role
      And "landing_page" content:
      | title              | body                           | field_summary                  | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
    When I am on "/behat-landing-page/layout"
      And I wait 2 seconds
      And I click "Add section"
      And I wait 2 seconds
      And I click "One column"
      And I wait 2 seconds
      And I press "Add section"
      And I wait 2 seconds
      And I click "Add block"
      And I wait 2 seconds
      And I click "Create custom block"
      And I wait 2 seconds
      And I click "Custom Landing Page block" in the "block_section" region
      And I wait 2 seconds
      And I fill in "Title" with "This is behat block"
      And I type "This is the BEHAT landing page section one block" in the "Body" WYSIWYG editor
      And I press "Add block"
      And I wait 2 seconds
      And I scroll to the top
      And I press "Save layout"
    Then I should see the heading "This is behat block"
      And I should see the text "This is the BEHAT landing page section one block"
    When I am on "/behat-landing-page/layout"
      And I press "Open This is behat block configuration options"
      And I wait 2 seconds
      And I click "Remove block" in the "layout_section" region
      And I wait 2 seconds
      And I should see the text "Are you sure you want to remove the This is behat block block?"
      And I press "Remove"
      And I wait 2 seconds
      And I press "Save layout"
    Then I should not see the heading "This is behat block"

      Examples:
       | role             |
       | Content Approver |
       | administrator    |
       | sitebuilder      |

  @api @javascript
  Scenario: Recent Updates On Technology Landing Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
      | title        | body                      | field_summary          | moderation_state | changed   |
      | Application1 | This is the body new test | Summary of Application | published        | -2 min    |
      | Application2 | This is the body Category | Summary of Application | published        | now       |
      And "component" content:
      | title           | body                             | field_summary | field_status_usage | moderation_state |
      | BEHAT Component | Description about component test |               | Approved           | published        |
      | Behat Comp 1    | this is the body                 | test summary  | Catalog            | published        |
      And "platform" content:
      | title           | body                    | field_summary                 | moderation_state |
      | BEHAT Platform1 | This is the body test   | Summary of platform  category | published        |
      | BEHAT Platform2 | This is the description | Summary of platform new       | published        |
      And I run cron
      And I am on "/technology"
      And "Application2" should precede "Application1" for the query "//span[contains(@class, 'field-content')]/a"
      And I am on "/technology/edit"
      And I should see the text "Edit Landing Page Technology"
      And I am on "/technology/layout"
      And I should see the heading "Edit layout for Technology"
    When I am on "/admin/structure/taxonomy/manage/component_category/add"
      And I fill in "Name" with "Behat Taxonomy"
      And I press "Save"
      And I am on "/technology"
    Then I should see the heading "Recently Updated Technology"
      And I should see the link "Behat Taxonomy"
      And I should see the link "Application1"
      And I should see the link "Application2"
      And I should see the link "BEHAT Component"
      And I should see the link "Behat Comp 1"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2"
      And "Behat Taxonomy" should precede "Application2" for the query "//span[contains(@class, 'field-content')]/a"

  @api
  Scenario: Verify Titles On Landing Pages
    Given I am logged in as a user with the "sitebuilder" role
      And I am on "/datasets"
    Then I should see the heading "Datasets"
    When I am on "/discussions"
    Then I should see the heading "Discussions"
    When I am on "/data-insights"
    Then I should see the heading "Featured Data Insights"
    # /forms view is currently disabled but the below steps work when forms view is enabled
    When I am on "/forms"
    Then I should see the heading "Forms Search"

  @api @javascript
  Scenario Outline: Authorized User Can Update Existing Landing Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/datasets"
    Then I should see the link "Layout"
    When I am on "/discussions"
    Then I should see the link "Layout"
    When I am on "/data-insights"
    Then I should see the link "Layout"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario: Verify Breadcrumbs On Landing Pages
    Given I am logged in as a user with the "Content Approver" role
      And users:
      | name       | mail         | roles            |
      | CModerator | ca@email.com | Content Approver |
      And "data_set" content:
      | title         | field_dataset_description | field_dataset_source_type | field_how_to_request_access | moderation_state |
      | BEHAT dataset | description               | FINRA                     | '' - http://test.com        | published        |
      And "article" content:
      | title       | field_summary   | Body        | field_category | moderation_state |
      | 123 Article | This is summary | article one | FAQ            | published        |
      And "statistics" content:
      | title       | body             | field_data_search_index | moderation_state |
      | New Reports | This is the body | myReportTerm            | published        |
      And "forms" content:
      | title      | body                   | field_further_details | moderation_state |
      | BEHAT Form | Description about Form | Further Details       | published        |
      And "data_insight" content:
      | title          | body                     | moderation_state |
      | BEHAT Insight1 | This is the body  test   | published        |
    When I am on "/123-Article/edit"
      And I uncheck "Generate automatic URL alias"
      And I fill in "URL alias" with "/123-Article/123-Article"
      And I type "This is the BEHAT landing page section one block two" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "CModerator" on the "Reviewer" field
      And I press "Save"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/datasets/behat-dataset"
    Then I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/dataset" in the "breadcrumb" region
    When I am on "/data-insights/behat-insight1"
    Then I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/data-insights" in the "breadcrumb" region
    When I am on "/forms/behat-form"
    # /forms view has been disabled therefore breadcrumb will not be available but below steps work when forms view is enabled
    Then I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/forms" in the "breadcrumb" region
    Then I should see the heading "BEHAT Form"
    When I am on "/reports-statistics/new-reports"
    Then I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/reports-statistics" in the "breadcrumb" region
    When I am on "/123-Article/123-Article"
    Then I should see the "breadcrumb" region
      And I should see the "a" element with the "href" attribute set to "/123-Article" in the "breadcrumb" region

  @api @javascript
  Scenario: Technology Landing Page Updates for Recently Updated Technology Block
    Given "faq_category" terms:
      | name       |
      | Technology |
      | Covid      |
      And "article" content:
        | title          | body                | field_category | moderation_state | changed |
        | Behat Article1 | Article description | Tools          | published        | +10 day |
        | Behat Article2 | Article description | Technology     | published        | +6 day  |
        | Behat Article3 | Article description | Covid          | published        | +7 day  |
      And "application" content:
        | title              | body  | field_summary | moderation_state | changed |
        | Behat Application1 | body  | summary       | published        | +9 day  |
        | Behat Application2 | hello | summary       | published        | +5 day  |
        | Behat Application3 | body  | summary       | published        | -5 min  |
      And "platform" content:
        | title           | body        | field_summary | moderation_state | changed |
        | Behat Platform1 | description | summary       | published        | +8 day  |
        | Behat Platform2 | description | summary       | published        | +4 day  |
        | Behat Platform3 | description | summary       | published        | -30 min |
      And "component" content:
        | title            | body                  | field_status_usage | moderation_state | changed |
        | Behat Component1 | Component description | Approved           | published        | +7 day  |
        | Behat Component2 | Component description | Approved           | published        | +3 day  |
      And I create "taxonomy_term" of type "component_category":
        | name              | parent            | field_summary | field_icon | changed |
        | BEHAT CC Parent 1 |                   | Summary1      | dog        | +2 day  |
        | BEHAT CC Child 1  | BEHAT CC Parent 1 | Summary1      | cat        | +1 hour |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/technology"
    Then I should see the heading "Recently Updated Technology" in the "recent_technology" region
      # Check for all 5 types, details and updated date value
      And I should see the link "Behat Article1" in the "recent_technology" region
      And I should see "(Article)" in the "span" element with the "class" attribute set to "detail" in the "1stupdatedtech" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "1stupdatedtech" region
      And I should see the link "Behat Application1" in the "recent_technology" region
      And I should see "(Application)" in the "span" element with the "class" attribute set to "detail" in the "2ndupdatedtech" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "2ndupdatedtech" region
      And I should see the link "Behat Platform1" in the "recent_technology" region
      And I should see "(Platform)" in the "span" element with the "class" attribute set to "detail" in the "3rdupdatedtech" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "3rdupdatedtech" region
      And I should see the link "Behat Component1" in the "recent_technology" region
      And I should see "(Software)" in the "span" element with the "class" attribute set to "detail" in the "4thupdatedtech" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "4thupdatedtech" region
      And I should see the link "BEHAT CC Child 1" in the "recent_technology" region
      And I should see "(Technology Category)" in the "span" element with the "class" attribute set to "detail" in the "10thupdatedtech" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "10thupdatedtech" region
      # Check for sorted order of last updated date
      And I should see the link "Behat Article1" before I see the link "Behat Application1" in the "Recently Updated Technology" view
      And I should see the link "Behat Application1" before I see the link "Behat Platform1" in the "Recently Updated Technology" view
      And I should see the link "Behat Platform1" before I see the link "Behat Component1" in the "Recently Updated Technology" view
      And I should see the link "Behat Component1" before I see the link "Behat Article2" in the "Recently Updated Technology" view
      And I should see the link "Behat Article2" before I see the link "Behat Platform2" in the "Recently Updated Technology" view
      And I should see the link "Behat Platform2" before I see the link "Behat Component2" in the "Recently Updated Technology" view
      And I should see the link "Behat Component2" before I see the link "BEHAT CC Parent 1" in the "Recently Updated Technology" view
      And I should see the link "BEHAT CC Parent 1" before I see the link "BEHAT CC Child 1" in the "Recently Updated Technology" view
      # Check for actual updated date
      And I should see the date "+10 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(1)" selector
      And I should see the date "+9 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(2)" selector
      And I should see the date "+8 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(3)" selector
      And I should see the date "+7 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(4)" selector
      And I should see the date "+6 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(5)" selector
      And I should see the date "+5 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(6)" selector
      And I should see the date "+4 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(7)" selector
      And I should see the date "+3 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(8)" selector
      And I should see the date "+2 day" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(9)" selector
      And I should see the date "+1 hour" in the "div.layout__region.layout__region--second > section > div > div > div > div > ul > li:nth-child(10)" selector
      # Check for only 10 most recent and no article with other category than Technology and Tools
      But I should not see the link "Behat Application3" in the "recent_technology" region
      And I should not see the link "Behat Platform3" in the "recent_technology" region
      And I should not see the link "Behat Article3" in the "recent_technology" region
      # Check that clicking of link goes to details page
    When I click "Behat Application2"
    Then I should see the heading "Behat Application2"
      And I should see the text "hello"

  @api @javascript
  Scenario: Technology Landing Page Updates for Recent Technology Discussions Block
    Given "forums" terms:
      | name  |
      | Covid |
      And "forum" content:
        | title              | body                 | taxonomy_forums | moderation_state | changed |
        | BEHAT Technology 1 | This is technology 1 | Technology      | published        | +1 day  |
        | BEHAT Technology 2 | This is technology 2 | Technology      | published        | +2 day  |
        | BEHAT Tools 1      | This is tools        | Covid           | published        | +3 day  |
        | BEHAT Technology 3 | This is technology 3 | Technology      | published        | +4 day  |
        | BEHAT Technology 4 | This is technology 4 | Technology      | published        | +5 day  |
        | BEHAT Tools 2      | This is tools        | Tools           | published        | +6 day  |
        | BEHAT Technology 5 | This is technology 5 | Technology      | published        | +7 day  |
        | BEHAT Technology 6 | This is technology 6 | Technology      | published        | +8 day  |
        | BEHAT Tools 3      | This is tools        | Tools           | published        | +9 day  |
        | BEHAT Technology 7 | This is technology 7 | Technology      | published        | +10 day |
        | BEHAT Technology 8 | This is technology 8 | Technology      | published        | +11 day |
        | BEHAT Tools 4      | This is tools        | Tools           | published        | +12 day |
        | BEHAT Tools 5      | This is tools        | Tools           | published        | -1 hour |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/technology"
    Then I should see the heading "Recent Technology Discussions" in the "recent_discussions" region
    When I click "BEHAT Technology 8"
    Then I should see the heading "BEHAT Technology 8"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I should see the text "This is the First Comment"
      And I type "This is the Second Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
    Then I should see the text "This is the Second Comment"
    When I am on "/discussions/behat-technology-7"
      And I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
    Then I should see the text "This is the First Comment"
    When I am on "/technology"
      # Check for list of discussions, details (replies) and updated date value
    Then I should see the link "BEHAT Tools 4" in the "recent_discussions" region
      And I should see "(0 replies)" in the "span" element with the "class" attribute set to "detail" in the "1stupdateddiss" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "10thupdatedtech" region
      And I should see the link "BEHAT Tools 3" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 6" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 5" in the "recent_discussions" region
      And I should see the link "BEHAT Tools 2" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 4" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 3" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 2" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 1" in the "recent_discussions" region
      And I should see the link "BEHAT Technology 7" in the "recent_discussions" region
      And I should see "(1 replies)" in the "span" element with the "class" attribute set to "detail" in the "10thupdateddiss" region
      And I should see the "span" element with the "class" attribute set to "updated-date" in the "10thupdatedtech" region
      # Check for sorted order of last updated date
      And I should see the link "BEHAT Tools 4" before I see the link "BEHAT Tools 3" in the "Discussions" view
      And I should see the link "BEHAT Tools 3" before I see the link "BEHAT Technology 6" in the "Discussions" view
      And I should see the link "BEHAT Technology 6" before I see the link "BEHAT Technology 5" in the "Discussions" view
      And I should see the link "BEHAT Technology 5" before I see the link "BEHAT Tools 2" in the "Discussions" view
      And I should see the link "BEHAT Tools 2" before I see the link "BEHAT Technology 4" in the "Discussions" view
      And I should see the link "BEHAT Technology 4" before I see the link "BEHAT Technology 3" in the "Discussions" view
      And I should see the link "BEHAT Technology 3" before I see the link "BEHAT Technology 2" in the "Discussions" view
      And I should see the link "BEHAT Technology 2" before I see the link "BEHAT Technology 1" in the "Discussions" view
      And I should see the link "BEHAT Technology 1" before I see the link "BEHAT Technology 7" in the "Discussions" view
      # Check for only 10 most recent and no discussion with other category than Technology and Tools
      And I should not see the link "BEHAT Technology 8" in the "recent_discussions" region
      And I should not see the link "BEHAT Tools 1" in the "recent_discussions" region
      And I should not see the link "BEHAT Tools 5" in the "recent_discussions" region
      # Check for actual updated date
      And I should see the date "+12 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(1)" selector
      And I should see the date "+9 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(2)" selector
      And I should see the date "+8 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(3)" selector
      And I should see the date "+7 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(4)" selector
      And I should see the date "+6 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(5)" selector
      And I should see the date "+5 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(6)" selector
      And I should see the date "+4 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(7)" selector
      And I should see the date "+2 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(8)" selector
      And I should see the date "+1 day" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(9)" selector
      And I should see the date "today" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(10)" selector
      # Check for listing beyond first 10
    When I click "Page 2"
    Then I should see the link "BEHAT Technology 8" in the "recent_discussions" region
      And I should see "(2 replies)" in the "span" element with the "class" attribute set to "detail" in the "1stupdateddiss" region
      And I should see the date "today" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(1)" selector
      And I should see the link "BEHAT Tools 5" in the "recent_discussions" region
      And I should see the date "-1 hour" in the "div.layout__region.layout__region--third > section > div > div > div > div > ul > li:nth-child(2)" selector
      And I should see the link "BEHAT Technology 8" before I see the link "BEHAT Tools 5" in the "Discussions" view
      # Check for pagination
    When I click "Page 1"
    Then I should see the link "BEHAT Technology 7" in the "recent_discussions" region
    When I click "Last"
    Then I should see the link "BEHAT Technology 8" in the "recent_discussions" region
    When I click "Previous page"
    Then I should see the link "BEHAT Technology 6" in the "recent_discussions" region
    When I click "Next page"
    Then I should see the link "BEHAT Tools 5" in the "recent_discussions" region
    When I click "First page"
    Then I should see the link "BEHAT Technology 5" in the "recent_discussions" region
    When I click "Last page"
    Then I should see the link "BEHAT Technology 8" in the "recent_discussions" region
