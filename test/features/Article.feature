Feature: Articles Can Be Created And Users Can Search For Them Using The Global Search
  As a content creator
  I want to be able to create articles and add it to the data sets
  So that a site visitor will have access to all the articles from the dataset page

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "faq_category" terms:
      | name        |
      | Behat FAQ   |
      | Behat Other |
      And  "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT Dataset  | This is dataset1          | '' - http://test.com        | published        |
      | BEHAT Dataset2 | This is dataset2          |                             | published        |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "status" terms:
      | name         | field_icon | field_status_color |
      | BEHAT Retire | leaf       | #00695C            |

  @api @javascript
  Scenario Outline: Authorized Users Can Create An Article
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select "Behat FAQ" from "Category"
      And I type "This is the article summary" in the "Article Summary" WYSIWYG editor
      And I select the autocomplete option for "BEHAT Dataset" on the "Related Datasets" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Article"
      And I should see the text "BEHAT article Description"
      And I should see the text "Category"
      And I should see the link "Behat FAQ"
      And I should see the text "This is the article summary"
      And I should see the text "Related Datasets"
    When I scroll to the bottom
    Then I should see the link "BEHAT Dataset"
    When I click "BEHAT Dataset"
    Then I should see the heading "BEHAT Dataset"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Article Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "article" content:
      | title            | Behat Article |
      | body             | test          |
      | moderation_state | published     |
      And I wait 2 seconds
      And I hover over the element "article.contextual-region > div:nth-child(1) > button"
      And I wait 2 seconds
    When I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Article Behat Article"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit An Article
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "article" content:
      | title                          | BEHAT Article |
      | field_summary                  | behat short   |
      | body                           | Body          |
      | field_category                 | Behat FAQ     |
      | field_article_summary          | Summary       |
      | field_dataset_related_datasets | BEHAT Dataset |
      | field_reviewer                 | approver      |
      | moderation_state               | published     |
    Then I should see the heading "BEHAT Article"
      And I should see the text "body"
      And I should see the text "Category"
      And I should see the text "summary"
      And I should see the link "Behat FAQ"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Article" row
      And I fill in "Title" with "BEHAT Edited Article"
      And I select "Behat Other" from "Category"
      And I select the autocomplete option for "BEHAT Dataset2" on the "Related Datasets" field
      And I press "Save"
    Then I should see the link "BEHAT Edited Article"
      And I should not see the link "BEHAT Article"
      And I click "BEHAT Edited Article"
      And I should see the heading "BEHAT Edited Article"
      And I should see the text "body"
      And I should see the text "Category"
      And I should see the text "summary"
      And I should see the link "Behat Other"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset2"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario Outline: Authorized Users Can Delete An Article
    Given "article" content:
      | title         | field_summary | body                | field_category | moderation_state |
      | BEHAT Article | behat short   | Article description | Behat Other    | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Article" row
      And I click "Delete" in the "node_action" region
      And  I press the "Delete" button
    Then I should see the text "The Article BEHAT Article has been deleted."
    When I am on "/behat-article"
    Then I should see "Page not found"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario: Viewing An Article
    Given I am logged in as a user with the "authenticated user" role
    When I am viewing a "article" content:
      | title                 | BEHAT Article |
      | body                  | Body          |
      | field_category        | Behat FAQ     |
      | field_article_summary | Summary       |
      | moderation_state      | published     |
      And I should see the heading "BEHAT Article"
      And I should see the text "Body"
      And I should see the text "category"
      And I should see the text "Summary"
    Then I should see the link "Behat FAQ"
      And I click "Behat FAQ"
      And I should see the heading "Behat FAQ"
      And I should see the link "BEHAT Article"

  @api
  Scenario Outline: Verify Article Page URL
    Given I am logged in as a user with the "authenticated user" role
      And "article" content:
      | title               | body                | field_category | moderation_state |
      | BEHAT.Article.Title | Article description | Behat Other    | published        |
      | BEHAT article TWO   | another Article     | Behat Other    | published        |
    When I am on "<URL>"
    Then the response status code should be 200

    Examples:
      | URL                |
      | /behatarticletitle |
      | /behat-article-two |

  @api
  Scenario: Verify Article Labels, Help Texts And Required Fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
    Then I should see the text "Title"
      And I should see the text "Short Description"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Body"
      And I should see the text "Only 300 characters will appear as a summary and 600 in search results."
      And I should see the text "Category"
      And I should see the text "Reviewer"
      And I should see the text "Article Summary"
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
      And I should see the text "Related Datasets"
      And I should see the text "Related Software"
      And I should see the text "Related Applications"
      And I should see the text "Related Platforms"
    When I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Body field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api @javascript
  Scenario: Article Character Test
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
      And I wait 1 seconds
      And I should see the text "Characters: 0"
      And I type "Character test" in the "Body" WYSIWYG editor
      And I wait 1 seconds
    Then I should see the text "Characters: 14"
      And I should see the text "Only 300 characters will appear as a summary and 600 in search results."

  @api
  Scenario: Site User Can View Related Datasets In Article Page
    Given I am logged in as a user with the "authenticated user" role
      And "article" content:
      | title            | body        | field_category | moderation_state |
      | dataset article1 | article one | Behat FAQ      | published        |
      | dataset article2 | article two | Behat Other    | published        |
    When I am viewing a "data_set" content:
      | title                     | BEHAT dataset1                     |
      | field_dataset_description | This is dataset1                   |
      | field_articles            | dataset article1, dataset article2 |
      | moderation_state          | published                          |
      And I click "Related Documentation"
      And I should see the link "dataset article1"
      And I should see the link "dataset article2"
      And I click "dataset article1"
    Then I should see the heading "dataset article1"
      And I should see the text "Datasets Referencing This Article"
      And I should see the link "BEHAT dataset1"
      And I click "BEHAT dataset1"
      And I wait 1 seconds
      And I should see the heading "BEHAT dataset1"

  @api
  Scenario: SiteBuilder Can Create Article SubType
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/faq_category/add"
      And I fill in "Name" with "BEHAT SubType"
      And I press "Save"
      And I am viewing a "article" content:
      | title            | BEHAT Article |
      | body             | Test          |
      | field_category   | BEHAT SubType |
      | moderation_state | published     |
      And I click "BEHAT SubType"
    Then I should see the link "BEHAT Article"

  @api @javascript
  Scenario: Tag A Datasets In Article Page
    Given "article" content:
      | title            | field_summary | body        | field_category | field_reviewer | moderation_state |
      | dataset article1 | behat short   | article one | Behat FAQ      | approver       | published        |
      And "data_set" content:
      | title           | field_dataset_description | field_how_to_request_access | field_articles   | field_reviewer | moderation_state |
      | BEHAT Dataset11 | This is dataset1          | '' - http://test.com        | dataset article1 | approver       | published        |
      | BEHAT Dataset12 | This is dataset2          | '' - http://test.com        |                  | approver       | published        |
    When I am logged in as a user with the "sitebuilder" role
      And I am on "/admin/content"
      And I click "Edit" in the "dataset article1" row
      And I select the autocomplete option for "BEHAT Dataset12" on the "Related Datasets" field
      And I press "Save"
      And I am on "/dataset-article1"
    Then I should see "Related Datasets"
      And I should see the link "BEHAT Dataset11"
      And I should see the text "Datasets Referencing This Article"
      And I should see the link "BEHAT Dataset12"
      And I click "BEHAT Dataset11"
      And I should see the heading "BEHAT Dataset11"
      And I click "Related Documentation"
      And I should see the link "dataset article1"

  @api @javascript
  Scenario: Start A New Discussion From Article Detailed Page
    Given I am logged in as a user with the "Content Approver" role
      And "forums" terms:
      | name     |
      | Datasets |
    When I am viewing a "article" content:
      | title            | BEHAT Article    |
      | body             | This is the body |
      | moderation_state | published        |
      | field_reviewer   | approver         |
    Then I should not see "Related to this Discussions"
      And I should see the link "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
      And I click "Start a New Discussion"
      And the link should open in a new tab
      And I fill in "Title" with "BEHAT Forum"
      And I select "Datasets" from "Category"
      And I wait 1 seconds
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
      And I should see the text "Related Content"
      And I should see the link "BEHAT Article"
      And I click "BEHAT Article"
      And I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I close the current window

  @api @javascript
  Scenario: Add Related Applications To An Article
    Given "application" content:
      | title              | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Application1 | description | summary1      | division1                   | published        |
      | BEHAT Application2 | description | summary2      | division1                   | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select "Behat FAQ" from "Category"
      And I type "This is the article summary" in the "Article Summary" WYSIWYG editor
      And I select the autocomplete option for "BEHAT Application1" on the "Related Applications" field
      And I click on the element with css selector "#edit-field-related-apps-add-more"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT Application2" on the "Related Applications (value 2)" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Article"
      And I should see the text "BEHAT article Description"
      And I should see the text "Category"
      And I should see the link "Behat FAQ"
      And I should see the text "This is the article summary"
      And I should see the text "Applications"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I click "BEHAT Application1"
      And I should see the heading "BEHAT Application1"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the text "BEHAT Short"
      And I should see the link "Behat FAQ"

  @api
  Scenario: Edit Related Application And Verify On Articles Page
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | field_owner | field_app_status | moderation_state | field_reviewer |
      | BEHAT Application | description | summary1      | division1                   | division2   | BEHAT Status A   | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "article" content:
      | title                 | BEHAT Article     |
      | body                  | Body              |
      | field_category        | Behat FAQ         |
      | field_article_summary | Summary           |
      | field_related_apps    | BEHAT Application |
      | moderation_state      | published         |
    Then I should see the heading "BEHAT Article"
      And I should see the text "Body"
      And I should see the text "Summary"
      And I should see the link "Behat FAQ"
      And I should see the text "Application"
      And I should see the link "BEHAT Application"
    When I am on "/applications/behat-application/edit"
      And I fill in "Title" with "Edited Application"
      And I press "Save"
    When I am on "/behat-article"
    Then I should see the heading "BEHAT Article"
      And I should see the text "Application"
      And I should not see the link "BEHAT Application"
      And I should see the link "Edited Application"
    When I click "Edited Application"
    Then I should see the text "Articles"
      And I should see the link "BEHAT Article"

  @api @javascript
  Scenario: Remove Related Application From Articles Page
    Given "application" content:
      | title             | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Application | description | summary1      | division1                   | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "article" content:
      | title                 | BEHAT Article     |
      | field_summary         | BEHAT Short       |
      | body                  | Body              |
      | field_category        | Behat FAQ         |
      | field_article_summary | Summary           |
      | field_related_apps    | BEHAT Application |
      | moderation_state      | published         |
    Then I should see the heading "BEHAT Article"
      And I should see the text "Body"
      And I should see the text "Summary"
      And I should see the link "Behat FAQ"
      And I should see the text "Application" in the "article_side" region
      And I should see the link "BEHAT Application" in the "article_side" region
    When I am on "/behat-article/edit"
      And I fill in "Related Applications" with ""
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Article"
      And I should not see the text "Application" in the "article_side" region
      And I should not see the link "BEHAT Application" in the "article_side" region
    When I am on "/applications/behat-application"
    Then I should not see the text "Articles"
      And I should not see the link "BEHAT Article"

  @api @javascript
  Scenario: Add Related Software To An Article
    Given "component" content:
      | title            | field_summary       | body                  | field_status | moderation_state |
      | BEHAT Component1 | This is the Summary | Component description | Approved     | published        |
      | BEHAT Component2 | This is the Summary | Component description | Retire       | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article"
      And I fill in "Short Description" with "BEHAT short"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select "Behat FAQ" from "Category"
      And I type "This is the article summary" in the "Article Summary" WYSIWYG editor
      And I select the autocomplete option for "BEHAT Component1" on the "Related Software" field
      And I click on the element with css selector "#edit-field-related-components-add-more"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAT Component2" on the "Related Software (value 2)" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I wait 1 seconds
      And I press "Save"
    Then I should see the heading "BEHAT Article"
      And I should see the text "Software"
      And I should see the link "BEHAT Component1"
      And I should see the link "BEHAT Component2"
      And I click "BEHAT Component1"
      And I should see the heading "BEHAT Component1"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
      And I should see the text "BEHAT short"
      And I should see the link "Behat FAQ"

  @api
  Scenario: Edit Related Software And Verify On Articles Page
    Given "component" content:
      | title           | field_summary       | body                  | field_status | field_division_office_multi | field_status_usage | moderation_state | field_reviewer |
      | BEHAT Component | This is the Summary | Component description | Approved     | division1                   | BEHAT Retire       | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "article" content:
      | title                    | BEHAT Article   |
      | body                     | Body            |
      | field_category           | Behat FAQ       |
      | field_article_summary    | Summary         |
      | field_related_components | BEHAT Component |
      | moderation_state         | published       |
    Then I should see the heading "BEHAT Article"
      And I should see the text "Body"
      And I should see the text "Summary"
      And I should see the link "Behat FAQ"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
    When I am on "/software/behat-component/edit"
      And I fill in "Title" with "Edited Software"
      And I press "Save"
    Then I should see the heading "Edited Software"
      And I should see the text "Articles"
      And I should see the link "BEHAT Article"
    When I am on "/behat-article"
    Then I should see the heading "BEHAT Article"
      And I should see the text "Software"
      And I should not see the link "BEHAT Component"
      And I should see the link "Edited Software"

  @api @javascript
  Scenario: Remove Related Software From Articles Page
    Given "component" content:
      | title           | field_summary       | body                  | field_status | moderation_state |
      | BEHAT Component | This is the Summary | Component description | Approved     | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am viewing a "article" content:
      | title                    | BEHAT Article   |
      | field_summary            | Behat Short     |
      | body                     | Body            |
      | field_category           | Behat FAQ       |
      | field_article_summary    | Summary         |
      | field_related_components | BEHAT Component |
      | moderation_state         | published       |
    Then I should see the heading "BEHAT Article"
      And I should see the text "Body"
      And I should see the text "Summary"
      And I should see the link "Behat FAQ"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
      And I am logged in as a user with the "Content Approver" role
    When I am on "/behat-article/edit"
      And I fill in "Related Software" with ""
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Article"
      And I should not see the text "Software"
      And I should not see the link "BEHAT Component"
    When I am on "/Components/behat-component"
    Then I should not see the text "Articles"
      And I should not see the link "BEHAT Article"

  @api @javascript
  Scenario: Create An Article Related To A Platform
    Given I am logged in as a user with the "Content Approver" role
      And "division_office" terms:
      | name      |
      | division1 |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage |
      | BEHAT platform | description | summary       | published        | division1                   | BEHAT Retire       |
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "BEHAT platform" on the "Related Platforms" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/behat-article"
    Then I should see the heading "BEHAT Article"
      And I should see the link "BEHAT platform"
      And I should see the "a" element with the "class" attribute set to "btn btn-sm btn-status--00695C" in the "article_side" region
      And I hover over the element "a.btn > span:nth-child(2)"
      And I should see the text "BEHAT Retire"
      And I should see the text "Platforms"
      And I click "BEHAT platform"
      And I should see the heading "BEHAT platform"
      And I should see the link "BEHAT Article"
      And I should see the text "behat short"
      And I should see the text "Articles"
