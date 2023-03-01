Feature: Create Informational Page Content Type For WDIO
  As a Content Approver, I should be able to create or edit a basic page.

  @ui @api @javascript @wdio
  Scenario: Create An Informational Page For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "page" content:
      | title      | body                    | field_summary | moderation_state | nid  |
      | BEHAT Page | This is the description | summary       | published        | 2020 |
      And I take a screenshot using "infopage.feature" file with "@new_page" tag
