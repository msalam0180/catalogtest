Feature: Global Search On Tech Catalog For WDIO

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And users:
      | name | mail          | pass | roles |
      | auth | auth@test.com | auth |       |

  @ui @api @javascript @wdio
  Scenario: Global Search With Content Type Boosts For WDIO
    Given "application" content:
      | title              | body                   | field_summary          | field_division_office_multi | field_owner | field_app_status | moderation_state |
      | BEHAT Application1 | This is the body  test | Summary of Application | division1                   | division2   | BEHAT Status A   | published        |
      | BEHAT Application2 | This is the body       | Summary of Application | division1                   | division2   | BEHAT Status A   | published        |
      And "data_set" content:
      | title          | field_dataset_description | moderation_state |
      | BEHAT Dataset1 | description               | published        |
      | BEHAT Dataset2 | description test          | published        |
      And "statistics" content:
      | title         | body                       | moderation_state |
      | BEHAT Reports | This is the body test body | published        |
      And "data_insight" content:
      | title          | body                   | moderation_state |
      | BEHAT Insight1 | This is the body  test | published        |
      And "component" content:
      | title           | body                              | field_status | field_division_office_multi | moderation_state |
      | BEHAT Component | Description about component  test | Approved     | division1                   | published        |
      And "platform" content:
      | title           | body                    | field_summary        | field_division_office_multi | moderation_state |
      | BEHAT Platform1 | This is the body test   | Summary of platform  | division1                   | published        |
      | BEHAT Platform2 | This is the description | Summary of pplatform | division2                   | published        |
      And "landing_page" content:
      | title              | body                                  | field_summary | moderation_state |
      | BEHAT Landing Page | This is the body of landing page test | new landing   | published        |
      And "page" content:
      | title          | body             | field_summary  | moderation_state |
      | Behat Info One | This is the body | page 1234 test | published        |
      And "article" content:
      | title         | field_summary | body                | moderation_state |
      | BEHAT Article | behat short   | Article description | published        |
      And "component_category" terms:
      | name              | parent            | field_summary | field_icon |
      | BEHAT CC Parent 1 |                   | Summary1      | dog        |
      | BEHAT CC Child 1  | BEHAT CC Parent 1 | Summary1      | cat        |
      And I run drush "cr"
      And I run cron
    Then I take a screenshot using "search.feature" file with "@site_search_boost" tag

  @ui @api @javascript @wdio
  Scenario: Global Search Type-Ahead for WDIO
    Given "application" content:
      | title             | body                   | field_summary          | moderation_state |
      | BEHAT Application | This is the body  test | Summary of Application | published        |
      And "data_set" content:
      | title         | field_dataset_description | moderation_state |
      | BEHAT Dataset | description               | published        |
      And "statistics" content:
      | title         | body                       | moderation_state |
      | BEHAT Reports | This is the body test body | published        |
      And "data_insight" content:
      | title         | body                  | moderation_state |
      | BEHAT Insight | This is the body test | published        |
      And "component" content:
      | title           | body                             | moderation_state |
      | BEHAT Component | Description about component test | published        |
      And "platform" content:
      | title          | body                  | field_summary        | moderation_state |
      | BEHAT Platform | This is the body test | Summary of platform  | published        |
      And "landing_page" content:
      | title              | body                                  | field_summary | moderation_state |
      | BEHAT Landing Page | This is the body of landing page test | new landing   | published        |
      And "page" content:
      | title           | body             | field_summary  | moderation_state |
      | BEHAT Info Page | This is the body | page 1234 test | published        |
      And "article" content:
      | title         | field_summary | body                | moderation_state |
      | BEHAT Article | behat short   | Article description | published        |
      And "tools" content:
      | title      | field_dataset_description | moderation_state |
      | BEHAT Tool | test                      | published        |
      And "component_category" terms:
      | name               | parent | field_summary | field_icon |
      | Wdio Tech Category |        | Summary1      | dog        |
      And I run drush "cr"
      And I run cron
    Then I take a screenshot using "search.feature" file with "@search_contenttypeahead" tag
      And I take a screenshot using "search.feature" file with "@search_techcattypeahead" tag
