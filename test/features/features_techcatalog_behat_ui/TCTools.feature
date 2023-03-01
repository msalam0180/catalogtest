Feature: Create Tools Page Content Type For WDIO
  Site visitors to Catalog can view Tool content pages

  Background:

    Given users:
      | name     | mail              | pass | roles            |
      | approver | approver@test.com |      | Content Approver |
      | auth     | auth@test.com     | auth |                  |
      And "tool_types" terms:
      | name                           |
      | BEHAT Data Systems             |
      And "tags" terms:
      | name             |
      | snow flakes      |
      | butterry popcorn |

  @ui @api @javascript @wdio
  Scenario: Viewing A Tool with Tags
    Given I am logged in as a user with the "authenticated user" role
      And I am viewing a "tools":
      | title                       | Behat Tool                    |
      | field_tool_category         | BEHAT Data Systems            |
      | field_dataset_description   | test                          |
      | field_tags                  | snow flakes, butterry popcorn |
      | field_reviewer              | approver                      |
      | moderation_state            | published                     |
    Then I take a screenshot using "tools.feature" file with "@tools_page" tag
