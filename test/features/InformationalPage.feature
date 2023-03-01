Feature: Create, Edit And Delete A Basic/Informational Page
  As a Content Approver/Site builder, I want to create Basic Pages in the Tech Catalog

  @api @javascript
  Scenario Outline: Authorized Users Can Create An Informational Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/page"
      And I fill in "Title" with "BEHAT Informational Page"
      And I type "BEHAT basic page description" in the "Body" WYSIWYG editor
      And I fill in "Short Description" with "BEHAT Basic Page Short Description"
      And I select "published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Informational Page"
      And I should see the text "BEHAT basic page description"
      And I should not see the text "BEHAT Basic Page Short Description"
    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Unauthorized Users Can Not Create Informational Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/page"
    Then I should see "Access denied"
    Examples:
      | role               |
      | Content Creator    |
      | authenticated user |

  @api @javascript
  Scenario Outline: Authorized Users Can Edit An Informational Page
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "page" content:
      | title            | BEHAT Informational Page          |
      | body             | BEHAT Info page description       |
      | field_summary    | BEHAT Info Page Short Description |
      | moderation_state | published                         |
    Then I should see the heading "BEHAT Informational Page"
      And I should see the text "BEHAT Info page description"
    When  I navigate to the "/edit" page from the current url
      And I fill in "Title" with "BEHAT Edited Info Page"
      And I type "Edited BEHAT Info page description" in the "Body" WYSIWYG editor
      And I press "Save"
    Then I should see the heading "BEHAT Edited Info Page"
      And I should not see the heading "BEHAT Informational Page"
      And I should see the text "Edited BEHAT Info page description"
    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete An Informational Page
    Given "page" content:
      | title      | body        | field_summary | moderation_state |
      | BEHAT Page | description | summary       | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Page" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should see the text "The Informational page BEHAT Page has been deleted."
    When I am on "/admin/content"
    Then I should not see the link "BEHAT Page"
    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |
