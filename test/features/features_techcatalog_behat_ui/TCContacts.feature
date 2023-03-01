Feature: Create And View Contacts for WDIO
  As a content creator
  I want to be able to create new Contact. So that visitors
  to the site would be able to see contact information. Others can find out more about a dataset, specifically information about who to contact.

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      And users:
      | name     | mail        | pass | roles           |
      | ccreator | cc@test.com | auth | Content Creator |

  @ui @api @javascript @wdio
  Scenario: Creating a Contact For WDIO
    Given "data_insight" content:
      | title          | body             | moderation_state |
      | BEHAt Insight1 | This is the body | published        |
      | BEHAt Insight2 | This is the body | published        |
      And "contact" content:
      | field_first_name | field_last_name | field_email   | moderation_state | field_division_office | nid |
      | Dan              | Donut           | wdio@test.com | published        | division1             | 1   |
    When I am logged in as a user with the "content_creator" role
      And I am on "/node/1/edit"
      And I fill in "URL" with "https://www.sec.gov"
      And I fill in "Link text" with "SEC link"
      And I press "Add another item"
      And I select the autocomplete option for "BEHAt Insight1" on the "field_associated_websites[1][uri]" field
      And I fill in "field_associated_websites[1][title]" with "Internal link"
      And I press "Add another item"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAt Insight2" on the "field_associated_websites[2][uri]" field
      And I fill in "Phone number" with "999-000-2100"
      And I type "This is more helpful information about this contact" in the "Helpful information" WYSIWYG editor
      And I press "Add media"
      And I attach the file "behat-dog.jpeg" to "Add file"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "Dog goes bow wow"
      And I click on the element with css selector ".button.button.button--primary.js-form-submit.form-submit.ui-button.ui-corner-all.ui-widget"
      And I wait for ajax to finish
      And I click on the element with css selector "div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I publish it
    Then I take a screenshot using "contact.feature" file with "@new_contact" tag
