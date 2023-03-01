Feature: Division Office Page For WDIO
  As a site visitor, I should be able to see Division/Office Page with grouping of content types

  Background:
    Given I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |
      And users:
      | name     | mail              | pass | roles            |
      | approver | approver@test.com |      | Content Approver |
      | auth     | auth@test.com     | auth |                  |

  @ui @api @javascript @wdio
  Scenario: Division Office Page For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "division_office" terms:
      | name      |
      | division1 |
      And "application" content:
      | title        | body                      | field_summary          | moderation_state | field_division_office_multi | 	field_owner | field_logo |
      | Application1 | This is the body new test | Summary of Application | published        | division1                   | division1    | Edgar Logo |
      And "component" content:
      | title           | body                             | field_summary | field_status_usage | moderation_state | field_division_office_multi |
      | BEHAT Component | Description about component test |               | Approved           | published        | division1                   |
      And "platform" content:
      | title           | body                    | field_summary                 | moderation_state | field_division_office_multi |
      | BEHAT Platform1 | This is the body test   | Summary of platform  category | published        | division1                   |
    Then I take a screenshot using "divisionoffice.feature" file with "@div_off_page" tag
