Feature: Global Navigation On Data Catalog
  As a Site Visitor the user should be able to navigate to different pages from anywhere in the data catalog
  using the global navigation menu.

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | content_approver |
      And "division_office" terms:
        | name         |
        | division1    |
        | division2    |
        | new division |
      And "data_category" terms:
        | name      |
        | category1 |
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
      And "application_status" terms:
        | name           |
        | BEHAT Status A |
        | BEHAT Status B |
      And "status" terms:
        | name           |
        | BEHAT Approve  |
      And "forums" terms:
        | name         |
        | General      |
      And "article" content:
        | title               | field_summary | body                | field_category | field_reviewer | moderation_state |
        | BEHAT Article Unpub | Short         | Article description | Other          | approver       | draft            |
      And "platform" content:
        | title                | body         | field_summary | field_division_office_multi | field_status_usage | field_reviewer | moderation_state |
        | BEHAT Platform Unpub | description1 | summary1      | division1                   | BEHAT Approve      | approver       | draft            |
      And "application" content:
        | title                   | body         | field_summary | field_app_status | field_owner | field_reviewer | moderation_state |
        | BEHAT Application Unpub | description1 | summary1      | BEHAT Status A   | division1   | approver       | draft            |
      And "component" content:
        | title                 | body                     | field_summary | field_status_usage | field_division_office_multi | field_reviewer | moderation_state |
        | BEHAT Component Unpub | Description of component | summary1      | BEHAT Approve      | division1                   | approver       | draft            |
      And "tools" content:
        | title            | field_dataset_description | field_reviewer | moderation_state |
        | BEHAT Tool Unpub | its tool time             | approver       | draft            |
      And "data_set" content:
        | title               | field_dataset_description | field_summary | field_owner | field_division_office_multi | field_data_category | field_open_government_data_acces | field_open_government_data_class | field_reviewer | moderation_state |
        | BEHAT Dataset Unpub | this is the body          | summary1      | division1   | division2                   | category1           | DAaccess                         | DAclassification                 | approver       | draft            |
      And "statistics" content:
        | title               | body               | field_summary | field_reviewer | moderation_state |
        | BEHAT Reports Unpub | This is test body  | summary1      | approver       | draft            |
      And "data_insight" content:
        | title               | body                  | field_summary | field_reviewer | moderation_state |
        | BEHAT Insight Unpub | This is the body test | summary1      | approver       | draft            |

  @api
  Scenario Outline: Authorized Users Can Add New Menu Link On The Home Page
    Given I am logged in as a user with the "<role>" role
    Then I should not see the link "BEHAT Menu" in the "menu" region
    When I am on "/admin/structure/menu/manage/main/add"
      And I fill in "Menu link title" with "BEHAT Menu"
      And I fill in "Link" with "http://test.com"
      And I fill in "Description" with "This is a test menu link"
      And I press "Save"
      And I visit "/"
    Then I should see the link "BEHAT Menu" in the "menu" region

    Examples:
      | role          |
      | Sitebuilder   |
      | administrator |

  @api
  Scenario: Edit Home Page Menu
    Given I am logged in as a user with the "Sitebuilder" role
    When I visit "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Test Menu     |
        | Link            | http://www.test.com |
      And I press the "Save" button
      And I visit "/admin/structure/menu/manage/main"
      And I click "Edit" in the "BEHAT Test Menu" row
      And I fill in the following:
        | Menu link title | BEHAT Edited Menu |
      And I press the "Save" button
      And I visit "/"
    Then I should see the link "BEHAT Edited Menu" in the "menu" region
      And I should not see the link "BEHAT Test Menu" in the "menu" region

  @api
  Scenario: Delete Home Page Menu
    Given I am logged in as a user with the "Sitebuilder" role
    When I visit "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Test Menu     |
        | Link            | http://www.test.com |
      And I press the "Save" button
      And I visit "/admin/structure/menu/manage/main"
      And I click "Edit" in the "BEHAT Test Menu" row
      And I click "Delete" in the "edit_delete" region
      And I press "Delete"
      And I visit "/"
    Then I should not see the link "BEHAT Test Menu" in the "menu" region

  @api @javascript
  Scenario: Create DropDownList In Global Navigation
    Given "article" content:
      | title           | body | field_category | moderation_state |
      | dataset article | test | FAQ            | published        |
      | Article 20      | test | FAQ            | published        |
    When I am logged in as a user with the "Sitebuilder" role
    Then I should not see the link "BEHAT Menu" in the "menu" region
    When I am on "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Menu               |
        | Link            | /article-23              |
        | Description     | This is a test menu link |
      And I press "Save"
      And I am on "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Link1              |
        | Link            | /dataset-article         |
        | Description     | This is a test menu link |
      And I select "BEHAT Menu" from "Parent link"
      And I press "Save"
      And I visit "/"
      And I wait 2 seconds
    Then I should see "BEHAT Menu" in the "menu" region
      And I click "BEHAT Menu"
      And I wait 1 seconds
      And I click "BEHAT Link1"
      And I should see the heading "dataset article"

  @api @javascript
  Scenario: Create Multilayer Dropdown List
    Given "article" content:
      | title           | body | field_category | moderation_state |
      | dataset article | test | FAQ            | published        |
      | Article 23      | test | FAQ            | published        |
    When I am logged in as a user with the "Sitebuilder" role
    Then I should not see the link "BEHAT Menu" in the "menu" region
    When I am on "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Menu               |
        | Link            | /dataset-article         |
        | Description     | This is a test menu link |
      And I press "Save"
      And I am on "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Link1         |
        | Link            | /article-23         |
        | Description     | This is second menu |
      And I select "BEHAT Menu" from "Parent link"
      And I press "Save"
      And I am on "/admin/structure/menu/manage/main/add"
      And I fill in the following:
        | Menu link title | BEHAT Link2        |
        | Link            | http://google.com  |
        | Description     | This is third menu |
      And I select "BEHAT Link1" from "Parent link"
      And I press "Save"
      And I visit "/"
      And I click "BEHAT Menu"
      And I wait 1 seconds
    Then I should see the link "BEHAT Link1"
      And I click "BEHAT Link1"
      And I should see the link "BEHAT Link2"
      And I click "BEHAT Link2"
      And I should see the button "Google Search"

  @api
  Scenario Outline: Unauthorized Users Can Not Access Menus
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/menu/manage/main/add"
    Then I should see the text "Access denied"

    Examples:
      | role               |
      | Content Creator    |
      | Content Approver   |
      | authenticated user |

  @api @javascript
  Scenario Outline: Check Environment Indicator
    Given I am logged in as a user with the "<role>" role
    When I visit "/"
    Then I should see the text "LOCAL" in the "env_indicator" region
      And I should see the "div" element with the "style" attribute set to "cursor:  pointer; background-color: #f9c642; color: #212121" in the "env_indicator" region
    When I click on the element with css selector "#environment-indicator"
    Then I should see the link "Open in: Prod" in the "env_indicator" region
      And I should not see the link "Open in: Stage" in the "env_indicator" region
    When I visit "/admin/content"
    Then I should see the text "LOCAL" in the "env_indicator" region
      And I should see the "div" element with the "style" attribute set to "cursor:  pointer; background-color: #f9c642; color: #212121" in the "env_indicator" region
      And the hyperlink "Open in: Prod" should match the Drupal url "https://catalog.sec.gov/admin/content"

    Examples:
      | role               |
      | Administrator      |
      | Sitebuilder        |
      | Content Creator    |
      | Content Approver   |
      | Forum Moderator    |

  @api @javascript
  Scenario: Env Switcher On Global Search Result Page
    Given I am logged in as a user with the "Content Creator" role
      And "tools" content:
        | title       | body                 | field_tool_category | moderation_state |
        | BEHAT Tool1 | this is tool         | Data Systems        | published        |
        | BEHAT Tool2 | this is tool22  test | Data Systems        | published        |
      And "data_set" content:
        | title          | field_dataset_description | field_dataset_source_type | moderation_state |
        | BEHAT Dataset1 | description               | FINRA                     | published        |
        | BEHAT Dataset2 | description test          | FINRA                     | published        |
        | BEHAT Dataset3 | description22             | FINRA                     | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "behat" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "LOCAL" in the "env_indicator" region
    When I click on the element with css selector "#environment-indicator"
      And I wait 3 seconds
    Then I should see the "ul" element with the "style" attribute set to "border-top: 1px solid rgb(33, 33, 33); display: block;" in the "env_indicator" region
      And I should see the link "Open in: Prod" in the "env_indicator" region
      And I should not see the link "Open in: Stage" in the "env_indicator" region
    When I click on the element with css selector "#environment-indicator"
      And I wait 2 seconds
    Then I should see the "ul" element with the "style" attribute set to "border-top: 1px solid rgb(33, 33, 33); display: none;" in the "env_indicator" region

  @api @javascript
  Scenario Outline: Global Navigation To Data Landing Page
    Given I am logged in as a user with the "<role>" role
       And "data_set" content:
        | title      | moderation_state | field_data_category |
        | Data.Set10 | published        | Analytical Data     |
        | DATASET 30 | published        | Internal Data       |
        | DATASET 32 | published        | Operational Data    |
      And I run cron
    When I visit "/datasets"
    Then I should see the heading "Datasets"
      And I should see the link "Data.Set10"
      And I should see the link "DATASET 30"
      And I should see the link "DATASET 32"
      And I scroll to the bottom
    When I click on the element with css selector "#block-filterbydatacategory > div.facets-widget-checkbox > fieldset > ul > li:nth-child(2) > label > span.facet-item__value"
      And I wait for ajax to finish
      And I scroll to the top
    Then I should see the link "Data.Set10"
      And I should not see the link "DATASET 30"
      And I should not see the link "DATASET 32"
    When I press "Reset"
      And I wait for ajax to finish
      And I scroll to the bottom
      And I click on the element with css selector "#block-filterbydatacategory > div.facets-widget-checkbox > fieldset > ul > li:nth-child(3) > label > span.facet-item__value"
      And I wait for ajax to finish
      And I scroll to the top
    Then I should see the link "DATASET 30"
      And I should not see the link "Data.Set10"
      And I should not see the link "DATASET 32"
    When I press "Reset"
      And I wait for ajax to finish
      And I scroll to the bottom
      And I click on the element with css selector "#block-filterbydatacategory > div.facets-widget-checkbox > fieldset > ul > li:nth-child(4) > label > span.facet-item__value"
      And I wait for ajax to finish
      And I scroll to the top
    Then I should see the link "DATASET 32"
      And I should not see the link "Data.Set10"
      And I should not see the link "DATASET 30"

      Examples:
      | role               |
      | authenticated user |
      | Content Creator    |
      | Content Approver   |
      | Sitebuilder        |

@api @javascript
Scenario: Unique Title For Contents
  Given I am logged in as a user with the "Content Creator, Migration Admin" role
    And "article" content:
      | title             | body                | field_category | moderation_state | changed |
      | BEHAT Article One | Article description | Other          | published        | -3 min  |
    And "platform" content:
      | title              | body         | field_summary | moderation_state | changed |
      | BEHAT Platform One | description1 | summary1      | published        | -7 min  |
    And "application" content:
      | title                 | body         | field_summary | moderation_state | changed |
      | BEHAT Application One | description1 | summary1      | published        | -8 min  |
    And "component" content:
      | title               | body                        | field_status_usage | moderation_state | changed |
      | BEHAT Component One | Description about component | Approved           | published        | -9 min  |
    And "tools" content:
      | title          | body                  | moderation_state |
      | BEHAT Tool One | this is tool new test | published        |
    And "data_set" content:
      | title             | field_dataset_description | moderation_state |
      | BEHAT Dataset One | this is the body          | published        |
    And "chart" content:
      | title           | Body | field_data_search_index | moderation_state |
      | BEHAT Chart One | body | XnY-axis                | published        |
    And "forum" content:
      | title                   | body                      | taxonomy_forums | moderation_state |
      | BEHAT Dataset Forum One | This is Dataset Forum one | Datasets        | published        |
    And "forms" content:
      | title          | body                   | field_further_details | moderation_state |
      | BEHAT Form One | Description about Form | Further Details       | published        |
    And "statistics" content:
      | title             | body                           | moderation_state |
      | BEHAT Reports One | This is test new Category body | published        |
    And "data_insight" content:
      | title             | body                  | moderation_state |
      | BEHAT Insight One | This is the body test | published        |
    And "landing_page" content:
      | title                  | body                             | field_summary | moderation_state |
      | BEHAT Landing Page One | This is the body of landing page | new landing   | published        |
    And "page" content:
      | title               | body             | field_summary | moderation_state |
      | BEHAT Info Page One | This is the body | page 1234     | published        |
  When I am on "/node/add/article"
    And I fill in "Title" with "BEHAT Article One"
    And I fill in "Short Description" with "BEHAT Short"
    And I type "BEHAT article Description" in the "Body" WYSIWYG editor
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I press "Save"
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Article One"
  When I am on "/node/add/platform"
    And I fill in "Title" with "BEHAT Platform One"
    And I fill in "Short Description" with "Short Description test"
    And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
    And I select "Approved" from "Approval Status"
    And I select the option "division1" from the jquery select ".form-item-field-division-office-multi-0-target-id .select-wrapper:nth-of-type(1) select"
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Platform One"
  When I am on "/node/add/application"
    And I fill in "Title" with "BEHAT Application One"
    And I fill in "Short Description" with "BEHAT Application"
    And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
    And I fill in "Application Link" with "http://webdriver.io/"
    And I select "division2" from "Owner"
    And I select "Active" from "Status"
    And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Application One"
  When I am on "/node/add/component"
    And I fill in "Title" with "BEHAT Component One"
    And I fill in "Short Description" with "Behat summary"
    And I type "BEHAT Component Description" in the "Detailed Description" WYSIWYG editor
    And I select "Approved" from "Approval Status"
    And I select "division1" from "Divisions/Offices that use this" for the "1" option of the "1" row
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Component One"
  When I am on "/node/add/tools"
    And I fill in "Title" with "BEHAT Tool One"
    And I type "BEHAT Tools Description" in the "Description" WYSIWYG editor
    And I select "Software" from "Category"
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I press "Save"
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Tool One"
  When I am on "/node/add/data_set"
    And I fill in "Title" with "BEHAT Dataset One"
    And I fill in "Short Description" with "BEHAT Short Description"
    And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
    And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
    And I select "category1" from "Data Category for Landing Page Display"
    And I scroll to the top
    And I click "Governance"
    And I select "division2" from "Owner"
    And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
    And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
    And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Dataset One"
  When I am on "/node/add/chart"
    And I fill in "Title" with "BEHAT Chart One"
    And I fill in "Short Description" with "behat short"
    And I press "Series 1"
    And I select "Scatter Plot" from "Series Type"
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Chart One"
  When I am on "/node/add/forum"
    And I fill in "Title" with "BEHAT Dataset Forum One"
    And I select "Datasets" from "Category"
    And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
    And I select "Published" from "Save as"
    And I press "Post Discussion"
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Dataset Forum One"
  When I am on "/node/add/forms"
    And I fill in "Title" with "BEHAT Form One"
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Form One"
  When I am on "/node/add/statistics"
    And I fill in "Title" with "BEHAT Reports One"
    And I fill in "Short Description" with "behat short"
    And I type "BEHAT Data Description for Reports" in the "Description" WYSIWYG editor
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Reports One"
  When I am on "/node/add/data_insight"
    And I fill in "Title" with "BEHAT Insight One"
    And I fill in "Short Description" with "Behat Short"
    And I type "BEHAT Data Insight Bottom Line Up Front" in the "Bottom Line Up Front" WYSIWYG editor
    And I type "BEHAT Key Message One" in the "Key Message" WYSIWYG editor number "0"
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Insight One"
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/node/add/landing_page"
    And I fill in "Title" with "BEHAT Landing Page One"
    And I fill in "Short Description" with "BEHAT Landing Page Short Description"
    And I select the autocomplete option for "approver" on the "Reviewer" field
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Landing Page One"
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/node/add/page"
    And I fill in "Title" with "BEHAT Info Page One"
    And I fill in "Short Description" with "BEHAT Basic Page Short Description"
    And I publish it
  Then I should see the text "The title must be unique. Other content is already using this title:"
    And I should see the link "BEHAT Info Page One"

@api @javascript
Scenario: Unique Title For Media
  Given I am logged in as a user with the "Content Creator" role
    And I create "media" of type "files":
      | KEY   | name           |
      | Behat | Media File One |
    And I create "media" of type "image":
      | name            | field_media_image    | field_caption    |
      | Media Image One | behat-edgar-logo.png | Behat Edgar Logo |
  When I am on "/media/add/files"
    And I fill in "Name" with "Media File One"
    And I attach the file "behat-TestJSON.json" to "File"
    And I wait for ajax to finish
    And I fill in "Description" with "This is 'JSON Format'"
    And I press "Save"
  Then I should see the text "The name must be unique. Other media is already using this name:"
    And I should see the link "Media File One"
  When I am on "/media/add/image"
    And I fill in "Name" with "Media Image One"
    And I attach the file "behat-edgar-logo.png" to "Image"
    And I wait for ajax to finish
    And I fill in "Alternative text" with "Behat Edgar Logo"
    And I wait for ajax to finish
    And I press "Save"
  Then I should see the text "The name must be unique. Other media is already using this name:"
    And I should see the link "Media Image One"

@api @javascript
Scenario Outline: Indicate unpublished related content in article
  Given "article" content:
    | title             | field_summary | body                | field_dataset_related_datasets | field_related_components | field_related_apps      | field_related_platforms	| field_category | field_reviewer | moderation_state |
    | BEHAT Article One | Short         | Article description | BEHAT Dataset Unpub            | BEHAT Component Unpub    | BEHAT Application Unpub | BEHAT Platform Unpub    | Other          | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-article-one/"
  Then I should see the heading "BEHAT Article One"
    And I should see the link "BEHAT Dataset Unpub" in the "article_related_dataset" region
    And I should see the text "Unpublished" in the "article_related_dataset" region
    And I should see the link "BEHAT Platform Unpub" in the "article_related_platform" region
    And I should see the text "Unpublished" in the "article_related_platform" region
    And I should see the link "BEHAT Component Unpub" in the "article_related_software" region
    And I should see the text "Unpublished" in the "article_related_software" region
    And I should see the link "BEHAT Application Unpub" in the "article_related_application" region
    And I should see the text "Unpublished" in the "article_related_application" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in platform
  Given "platform" content:
    | title              | body         | field_summary | field_division_office_multi | field_status_usage | field_related_components | field_related_apps      | field_reviewer | moderation_state |
    | BEHAT Platform One | description1 | summary1      | division1                   | BEHAT Approve      | BEHAT Component Unpub    | BEHAT Application Unpub | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/platforms/behat-platform-one/"
  Then I should see the heading "BEHAT Platform One"
    And I should see the link "BEHAT Component Unpub" in the "platform_related_software" region
    And I should see the text "Unpublished" in the "platform_related_software" region
    And I should see the link "BEHAT Application Unpub" in the "platform_related_application" region
    And I should see the text "Unpublished" in the "platform_related_application" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in application
  Given "application" content:
    | title                 | body         | field_summary | field_app_status | field_owner | field_related_components | field_related_platforms | field_related_articles | field_reviewer | moderation_state |
    | BEHAT Application One | description1 | summary1      | BEHAT Status A   | division1   | BEHAT Component Unpub    | BEHAT Platform Unpub	   | BEHAT Article Unpub    | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/applications/behat-application-one/"
  Then I should see the heading "BEHAT Application One"
    And I should see the link "BEHAT Platform Unpub" in the "application_related_platform" region
    And I should see the text "Unpublished" in the "application_related_platform" region
    And I should see the link "BEHAT Component Unpub" in the "application_related_software" region
    And I should see the text "Unpublished" in the "application_related_software" region
    And I should see the link "BEHAT Article Unpub" in the "application_related_article" region
    And I should see the text "Unpublished" in the "application_related_article" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in software
  Given "component" content:
    | title               | body                     | field_summary | field_status_usage | field_division_office_multi | field_related_apps      | field_related_platforms | field_related_articles | field_reviewer | moderation_state |
    | BEHAT Component One | Description of component | summary1      | BEHAT Approve      | division1                   | BEHAT Application Unpub | BEHAT Platform Unpub    | BEHAT Article Unpub    | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/software/behat-component-one/"
  Then I should see the heading "BEHAT Component One"
    And I should see the link "BEHAT Platform Unpub" in the "software_related_platform" region
    And I should see the text "Unpublished" in the "software_related_platform" region
    And I should see the link "BEHAT Application Unpub" in the "software_related_application" region
    And I should see the text "Unpublished" in the "software_related_application" region
    And I should see the link "BEHAT Article Unpub" in the "software_related_article" region
    And I should see the text "Unpublished" in the "software_related_article" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in tool
  Given "tools" content:
    | title          | field_dataset_description | field_articles      | field_dataset_related_datasets | field_reviewer | moderation_state |
    | BEHAT Tool One | its tool time             | BEHAT Article Unpub | BEHAT Dataset Unpub            | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/tool/behat-tool-one/"
  Then I should see the heading "BEHAT Tool One"
    And I should see the link "BEHAT Article Unpub" in the "tool_related_article" region
    And I should see the text "Unpublished" in the "tool_related_article" region
    And I should see the link "BEHAT Dataset Unpub" in the "tool_related_dataset" region
    And I should see the text "Unpublished" in the "tool_related_dataset" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in datasets
  Given "data_set" content:
    | title             | field_dataset_description | field_summary | field_owner | field_division_office_multi | field_data_category | field_dataset_related_datasets | field_tools      | field_related_data_insights | field_articles      | field_open_government_data_acces | field_open_government_data_class | field_reviewer | moderation_state |
    | BEHAT Dataset One | this is the body          | summary1      | division1   | division2                   | category1           | BEHAT Dataset Unpub            | BEHAT Tool Unpub | BEHAT Insight Unpub         | BEHAT Article Unpub | DAaccess                         | DAclassification                 | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/datasets/behat-dataset-one/"
  Then I should see the heading "BEHAT Dataset One"
    And I click on the element with css selector "li.vertical-tab-button.first.active.selected > a > span:nth-child(1)"
    And I should see the link "BEHAT Tool Unpub" in the "dataset_related_tool" region
    And I should see the text "Unpublished" in the "dataset_related_tool" region
    And I should see the link "BEHAT Insight Unpub" in the "dataset_related_insight" region
    And I should see the text "Unpublished" in the "dataset_related_insight" region
    And I should see the link "BEHAT Dataset Unpub" in the "dataset_related_dataset" region
    And I should see the text "Unpublished" in the "dataset_related_dataset" region
    And I click on the element with css selector "div.main-container.container-fluid.js-quickedit-main-content > div > div > section > div > article > div.main > div > div:nth-child(2) > div > div > ul > li:nth-child(2)"
    And I should see the link "BEHAT Article Unpub" in the "dataset_related_article" region
    And I should see the text "Unpublished" in the "dataset_related_article" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in reports-statistics
  Given "statistics" content:
    | title             | body               | field_summary | field_related_datasets | field_associated_datasets | field_related_data_insights | field_articles      | field_reviewer  | moderation_state |
    | BEHAT Reports One | This is test body  | summary1      | BEHAT Dataset Unpub    | BEHAT Dataset Unpub       | BEHAT Insight Unpub         | BEHAT Article Unpub | approver        | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/reports-statistics/behat-reports-one/"
  Then I should see the heading "BEHAT Reports One"
    And I should see the link "BEHAT Dataset Unpub" in the "reports_related_dataset" region
    And I should see the text "Unpublished" in the "reports_related_dataset" region
    And I should see the link "BEHAT Insight Unpub" in the "reports_related_insight" region
    And I should see the text "Unpublished" in the "reports_related_insight" region
    And I should see the link "BEHAT Article Unpub" in the "reports_related_article" region
    And I should see the text "Unpublished" in the "reports_related_article" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Indicate unpublished related content in data-insights
  Given "data_insight" content:
    | title             | body                  | field_summary | field_related_datasets | field_associated_datasets | field_related_reports_statistics | field_articles      | field_reviewer | moderation_state |
    | BEHAT Insight One | This is the body test | summary1      | BEHAT Dataset Unpub    | BEHAT Dataset Unpub       | BEHAT Reports Unpub              | BEHAT Article Unpub | approver       | published        |
  When I am logged in as a user with the "<role>" role
    And I am on "/data-insights/behat-insight-one/"
  Then I should see the heading "BEHAT Insight One"
    And I should see the link "BEHAT Dataset Unpub" in the "insight_related_dataset" region
    And I should see the text "Unpublished" in the "insight_related_dataset" region
    And I should see the link "BEHAT Reports Unpub" in the "insight_related_reports" region
    And I should see the text "Unpublished" in the "insight_related_reports" region
    And I should see the link "BEHAT Article Unpub" in the "insight_related_article" region
    And I should see the text "Unpublished" in the "insight_related_article" region
    And I should not see the "moderation_state" region

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api
Scenario Outline: Unique content identifier (node id) visible on all edit content page heading
  Given "article" content:
      | title             | body                | field_category | moderation_state | nid     |
      | BEHAT Article One | Article description | Other          | published        | 3963041 |
    And "platform" content:
      | title              | body         | field_summary | moderation_state | nid     |
      | BEHAT Platform One | description1 | summary1      | published        | 8136008 |
    And "application" content:
      | title                 | body         | field_summary | moderation_state | nid     |
      | BEHAT Application One | description1 | summary1      | published        | 5306158 |
    And "component" content:
      | title               | body                        | field_status_usage | moderation_state | nid     |
      | BEHAT Component One | Description about component | Approved           | published        | 1007252 |
    And "tools" content:
      | title          | body                  | moderation_state | nid     |
      | BEHAT Tool One | this is tool new test | published        | 3931774 |
    And "data_set" content:
      | title             | field_dataset_description | moderation_state | nid     |
      | BEHAT Dataset One | this is the body          | published        | 6828245 |
    And "chart" content:
      | title           | Body | field_data_search_index | moderation_state | nid     |
      | BEHAT Chart One | body | XnY-axis                | published        | 1874419 |
    And "forum" content:
      | title                   | body                      | taxonomy_forums | moderation_state | nid     |
      | BEHAT Dataset Forum One | This is Dataset Forum one | Datasets        | published        | 3831132 |
    And "forms" content:
      | title          | body                   | field_further_details | moderation_state | nid     |
      | BEHAT Form One | Description about Form | Further Details       | published        | 7472686 |
    And "statistics" content:
      | title             | body                           | moderation_state | nid     |
      | BEHAT Reports One | This is test new Category body | published        | 4798168 |
    And "data_insight" content:
      | title             | body                  | moderation_state | nid     |
      | BEHAT Insight One | This is the body test | published        | 5394384 |
    And "landing_page" content:
      | title                  | body                             | field_summary | moderation_state | nid     |
      | BEHAT Landing Page One | This is the body of landing page | new landing   | published        | 6086696 |
    And "page" content:
      | title               | body             | field_summary | moderation_state | nid     |
      | BEHAT Info Page One | This is the body | page 1234     | published        | 9981236 |
    And "contact" content:
      | field_first_name | field_last_name | field_email     | moderation_state | field_division_office | nid     |
      | firstname        | lastname        | user@email.com  | published        | division1             | 6089696 |
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-article-one/edit"
  Then I should see the heading "Edit Article BEHAT Article One - 3963041"
  When I am on "/platforms/behat-platform-one/edit"
  Then I should see the heading "Edit Platform BEHAT Platform One - 8136008"
  When I am on "/applications/behat-application-one/edit"
  Then I should see the heading "Edit Application BEHAT Application One - 5306158"
  When I am on "/software/behat-component-one/edit"
  Then I should see the heading "Edit Software BEHAT Component One - 1007252"
  When I am on "/tool/behat-tool-one/edit"
  Then I should see the heading "Edit Tool BEHAT Tool One - 3931774"
  When I am on "/datasets/behat-dataset-one/edit"
  Then I should see the heading "Edit Dataset BEHAT Dataset One - 6828245"
  When I am on "/chart/behat-chart-one/edit"
  Then I should see the heading "Edit Chart BEHAT Chart One - 1874419"
  When I am on "/discussions/behat-dataset-forum-one/edit"
  Then I should see the heading "Edit Discussion BEHAT Dataset Forum One - 3831132"
  When I am on "/forms/behat-form-one/edit"
  Then I should see the heading "Edit Forms BEHAT Form One - 7472686"
  When I am on "/reports-statistics/behat-reports-one/edit"
  Then I should see the heading "Edit Reports and Statistics BEHAT Reports One - 4798168"
  When I am on "/data-insights/behat-insight-one/edit"
  Then I should see the heading "Edit Data Insight BEHAT Insight One - 5394384"
  When I am on "/behat-landing-page-one/edit"
  Then I should see the heading "Edit Landing Page BEHAT Landing Page One - 6086696"
  When I am on "/behat-info-page-one/edit"
  Then I should see the heading "Edit Informational Page BEHAT Info Page One - 9981236"
  When I am on "/node/6089696/edit"
  Then I should see the heading "Edit Contact firstname lastname - 6089696"

  Examples:
    | role             |
    | Content Approver |
    | sitebuilder      |

@api
Scenario: Unique content identifier (node id) visible on edit content page heading for content creator
  Given "article" content:
      | title             | body                | field_category | moderation_state | nid     |
      | BEHAT Article One | Article description | Other          | published        | 3963041 |
    And "platform" content:
      | title              | body         | field_summary | moderation_state | nid     |
      | BEHAT Platform One | description1 | summary1      | published        | 8136008 |
    And "application" content:
      | title                 | body         | field_summary | moderation_state | nid     |
      | BEHAT Application One | description1 | summary1      | published        | 5306158 |
    And "component" content:
      | title               | body                        | field_status_usage | moderation_state | nid     |
      | BEHAT Component One | Description about component | Approved           | published        | 1007252 |
    And "tools" content:
      | title          | body                  | moderation_state | nid     |
      | BEHAT Tool One | this is tool new test | published        | 3931774 |
    And "data_set" content:
      | title             | field_dataset_description | moderation_state | nid     |
      | BEHAT Dataset One | this is the body          | published        | 6828245 |
    And "chart" content:
      | title           | Body | field_data_search_index | moderation_state | nid     |
      | BEHAT Chart One | body | XnY-axis                | published        | 1874419 |
    And "forum" content:
      | title                   | body                      | taxonomy_forums | moderation_state | nid     |
      | BEHAT Dataset Forum One | This is Dataset Forum one | Datasets        | published        | 3831132 |
    And "forms" content:
      | title          | body                   | field_further_details | moderation_state | nid     |
      | BEHAT Form One | Description about Form | Further Details       | published        | 7472686 |
    And "data_insight" content:
      | title             | body                  | moderation_state | nid     |
      | BEHAT Insight One | This is the body test | published        | 5394384 |
    And "contact" content:
      | field_first_name | field_last_name | field_email     | moderation_state | field_division_office | nid     |
      | firstname        | lastname        | user@email.com  | published        | division1             | 6089696 |
  When I am logged in as a user with the "Content Creator" role
    And I am on "/behat-article-one/edit"
  Then I should see the heading "Edit Article BEHAT Article One - 3963041"
  When I am on "/platforms/behat-platform-one/edit"
  Then I should see the heading "Edit Platform BEHAT Platform One - 8136008"
  When I am on "/applications/behat-application-one/edit"
  Then I should see the heading "Edit Application BEHAT Application One - 5306158"
  When I am on "/software/behat-component-one/edit"
  Then I should see the heading "Edit Software BEHAT Component One - 1007252"
  When I am on "/tool/behat-tool-one/edit"
  Then I should see the heading "Edit Tool BEHAT Tool One - 3931774"
  When I am on "/datasets/behat-dataset-one/edit"
  Then I should see the heading "Edit Dataset BEHAT Dataset One - 6828245"
  When I am on "/chart/behat-chart-one/edit"
  Then I should see the heading "Edit Chart BEHAT Chart One - 1874419"
  When I am on "/discussions/behat-dataset-forum-one/edit"
  Then I should see the heading "Edit Discussion BEHAT Dataset Forum One - 3831132"
  When I am on "/forms/behat-form-one/edit"
  Then I should see the heading "Edit Forms BEHAT Form One - 7472686"
  When I am on "/data-insights/behat-insight-one/edit"
  Then I should see the heading "Edit Data Insight BEHAT Insight One - 5394384"
  When I am on "/node/6089696/edit"
  Then I should see the heading "Edit Contact firstname lastname - 6089696"
