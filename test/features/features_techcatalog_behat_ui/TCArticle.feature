Feature: Create Article Content Type For Image Comparison
  As a Content Creator, I should be able to create or edit an article page.

  Background:
    Given "faq_category" terms:
      | name        |
      | Behat FAQ   |
      | Behat Other |
      And "division_office" terms:
        | name      |
        | division1 |
        | division2 |
      And "status" terms:
        | name           | field_icon | field_status_color |
        | BEHAT Approved | check      | #00695C            |
        | BEHAT Retired  | trash-alt  | #AF2525            |
      And users:
        | name | mail          | pass |
        | auth | auth@test.com | auth |

  @ui @api @javascript @wdio
  Scenario: Add Component To Article For WDIO
    Given "component" content:
      | title            | field_summary       | body                  | field_status_usage | moderation_state |
      | BEHAT Component1 | This is the Summary | Component description | BEHAT Approved     | published        |
      | BEHAT Component2 | This is the Summary | Component description | BEHAT Retired      | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article With Component"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select "Behat FAQ" from "Category"
      And I type "This is the article summary" in the "Article Summary" WYSIWYG editor
      And I select the autocomplete option for "BEHAT Component1" on the "Related Software" field
      And I click on the element with css selector "#edit-field-related-components-add-more"
      And I wait 1 seconds
      And I select the autocomplete option for "BEHAT Component2" on the "Related Software (value 2)" field
      And I wait 1 seconds
      And I select the autocomplete option for "app" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "article.feature" file with "@comp_to_article" tag

  @ui @api @javascript @wdio
  Scenario: Add Applications To Article For WDIO
    Given "application" content:
      | title              | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Application1 | description | summary1      | division1                   | published        |
      | BEHAT Application2 | description | summary2      | division2                   | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article With Application"
      And I type "BEHAT article Description" in the "Body" WYSIWYG editor
      And I select "Behat FAQ" from "Category"
      And I type "This is the article summary" in the "Article Summary" WYSIWYG editor
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Applications" field
      And I click on the element with css selector "#edit-field-related-apps-add-more"
      And I wait 1 seconds
      And I select the first autocomplete option for "BEHAT Application2" on the "Related Applications (value 2)" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "article.feature" file with "@app_to_article" tag
