Feature: Global Navigation For WDIO
  As User of the site, I should be able to navigate through the site

  Background:
    Given users:
      | name     | mail              | pass | roles            |
      | auth     | auth@test.com     | auth |                  |
      | ca       | ca@test.com       | ca   | content_approver |
      | approver | approver@test.com |      | content_approver |
      And "division_office" terms:
        | name         |
        | division1    |
        | division2    |
      And "data_category" terms:
        | name         |
        | category1    |
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
      And "status" terms:
        | name           |
        | BEHAT Approve  |
      And "platform" content:
        | title                | body         | field_summary | field_division_office_multi | field_status_usage | field_reviewer | moderation_state |
        | BEHAT Platform Unpub | description1 | summary1      | division1                   | BEHAT Approve      | approver       | draft            |
      And "application" content:
        | title                   | body         | field_summary | field_app_status | field_owner | field_reviewer | moderation_state |
        | BEHAT Application Unpub | description1 | summary1      | BEHAT Status A   | division1   | approver       | draft            |
      And "component" content:
        | title                 | body                     | field_summary | field_status_usage | field_division_office_multi | field_reviewer | moderation_state |
        | BEHAT Component Unpub | Description of component | summary1      | BEHAT Approve      | division1                   | approver       | draft            |
      And "data_set" content:
        | title               | field_dataset_description | field_summary | field_owner | field_division_office_multi | field_data_category | field_open_government_data_acces | field_open_government_data_class | field_reviewer | moderation_state |
        | BEHAT Dataset Unpub | this is the body          | summary1      | division1   | division2                   | category1           | DAaccess                         | DAclassification                 | approver       | draft            |

  @ui @api @javascript @wdio
  Scenario: Catalog Logo WDIO
    Given I am logged in as a user with the "Authenticated user" role
    Then I take a screenshot using "global.feature" file with "@catalog_logo" tag

  @ui @api @javascript @wdio
  Scenario: Display Unpublished Related Content In Article
    Given "article" content:
      | title             | field_summary | body                | field_dataset_related_datasets | field_related_components | field_related_apps      | field_related_platforms	| field_category | field_reviewer | moderation_state |
      | BEHAT Article One | Short         | Article description | BEHAT Dataset Unpub            | BEHAT Component Unpub    | BEHAT Application Unpub | BEHAT Platform Unpub    | Other          | approver       | published        |
    Then I take a screenshot using "global.feature" file with "@unpublished_related_content" tag
