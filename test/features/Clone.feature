Feature: Clone Content Nodes
  As a content creator
  I want to be able to duplicate a content
  So that I can leverage existing content to create similar content

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | content_approver |
      | sbuilder | sbuild@test.com   | sitebuilder      |
      And "application_status" terms:
      | name       |
      | App Status |
      And "division_office" terms:
      | name         |
      | division1    |
      | division2    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |

@api
Scenario Outline: Clone Content Access
  Given "landing_page" content:
    | title              | body                           | field_summary                  | moderation_state | nid   |
    | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        | 55555 |
    And I am logged in as a user with the "<role>" role
  When I am on "/entity_clone/node/55555"
  Then the response status code should be <status_code>

    Examples:
    | role             | status_code |
    | Content Creator  | 403         |
    | Content Approver | 403         |
    | sitebuilder      | 200         |
    | administrator    | 200         |

@api
Scenario Outline: Clone Media Access
  Given I create "media" of type "image":
    | name     | field_media_image  | field_caption     | mid   |
    | SQL Logo | behat-sql-logo.png | Behat SQL Caption | 22222 |
    And I am logged in as a user with the "<role>" role
  When I am on "/entity_clone/media/22222"
  Then the response status code should be <status_code>

    Examples:
    | role             | status_code |
    | Content Creator  | 403         |
    | Content Approver | 403         |
    | sitebuilder      | 200         |
    | administrator    | 200         |

@api @javascript
Scenario: Clone Dataset Content
  Given "data_set" content:
    | title         | field_summary       | field_dataset_description | moderation_state | field_owner  | field_reviewer | field_open_government_data_class | field_open_government_data_acces | field_data_category | field_division_office_multi | field_insights | field_license_required |
    | BEHAT dataset | a short description | a test description        | published        | new division | approver       | DAclassification                 | DAAchild                         | category1           | division2                   | more details   | 1                      |
  When I am logged in as "sbuilder"
    And I am on "/admin/content"
    And I click "Edit" in the "BEHAT dataset" row
    And I click "Clone" in the "node_action" region
  Then I should see the heading "Clone Content"
    And I should see the text "Do you want to clone the Content entity named BEHAT dataset?"
  When I press the "Clone" button
  Then I should see the text "of type node was cloned."
    And I should see the heading "BEHAT dataset - Cloned"
    And I should see the text "Draft"
    And I should see the text "a test description"
    And I should see the text "more details"
    And I should see the link "new division"
    And I should see the link "division2"
    And I should see the text "DAclassification"
    And I should see the text "DAAchild"
    And I should see the text "Yes"
