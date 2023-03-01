Feature: Create Basic Page Content Type For WDIO
  As a Content Approver, I should be able to create or edit a basic page.

  Background:
    Given users:
      | name | mail          | pass | roles |
      | auth | auth@test.com | auth |       |

  @ui @api @javascript @wdio
  Scenario: Create A Landing Page For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "landing_page" content:
      | title              | body                           | field_summary                  | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | published        |
      And I take a screenshot using "landingpage.feature" file with "@new_landing" tag
      And I take a screenshot using "landingpage.feature" file with "@feedback" tag
      And I take a screenshot using "landingpage.feature" file with "@masquerade" tag
      And I take a screenshot using "landingpage.feature" file with "@footer" tag

  @ui @api @javascript @wdio
  Scenario: Verify Technology Landing Page Recently Updated Tech Block For WDIO
    Given "faq_category" terms:
      | name       |
      | Technology |
      | Covid      |
      And "article" content:
      | title          | body                | field_category | moderation_state | changed             |
      | Behat Article1 | Article description | Tools          | published        | 2031-12-31 12:00:00 |
      | Behat Article2 | Article description | Technology     | published        | 2031-12-27 12:00:00 |
      | Behat Article3 | Article description | Covid          | published        | 2031-12-28 12:00:00 |
      And "application" content:
      | title              | body  | field_summary | moderation_state | changed             |
      | Behat Application1 | body  | summary       | published        | 2031-12-30 12:00:00 |
      | Behat Application2 | hello | summary       | published        | 2031-12-26 12:00:00 |
      | Behat Application3 | body  | summary       | published        | 2031-12-22 09:00:00 |
      And "platform" content:
      | title           | body        | field_summary | moderation_state | changed             |
      | Behat Platform1 | description | summary       | published        | 2031-12-29 12:00:00 |
      | Behat Platform2 | description | summary       | published        | 2031-12-25 12:00:00 |
      | Behat Platform3 | description | summary       | published        | 2031-12-22 07:00:00 |
      And "component" content:
      | title            | body                  | field_status_usage | moderation_state | changed             |
      | Behat Component1 | Component description | Approved           | published        | 2031-12-28 12:00:00 |
      | Behat Component2 | Component description | Approved           | published        | 2031-12-24 12:00:00 |
      And I create "taxonomy_term" of type "component_category":
      | name              | parent            | field_summary | field_icon | changed             |
      | BEHAT CC Parent 1 |                   | Summary1      | dog        | 2031-12-23 12:00:00 |
      | BEHAT CC Child 1  | BEHAT CC Parent 1 | Summary1      | cat        | 2031-12-22 10:00:00 |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    Then I take a screenshot using "landingpage.feature" file with "@technology_recenttech" tag

  @ui @api @javascript @wdio
  Scenario: Catalog Homepage Recently Updated Block For WDIO
    Given "data_set" content:
      | title      | field_dataset_description | field_dataset_source_type | moderation_state | changed             |
      | 1DATASET10 | Dataset 10 description    | NRSRO, Fitch              | published        | 2031-12-31 12:00:00 |
      | 2DATASET20 | Dataset 20 description    | NRSRO, Fitch              | published        | 2031-12-30 12:00:00 |
      And "article" content:
        | title              | body                | field_category | moderation_state | changed             |
        | 7BEHAT Article One | Article description | Other          | published        | 2031-12-29 12:00:00 |
      And "data_insight" content:
        | title            | body                 | moderation_state | changed             |
        | 10BEHAT Insight1 | Insight description1 | published        | 2031-12-28 12:00:00 |
      And "statistics" content:
        | title          | body             | moderation_state | changed             |
        | BEHAT Reports1 | This is the body | published        | 2031-12-27 12:00:00 |
      And "page" content:
        | title      | body        | field_summary | moderation_state | changed             |
        | BEHAT Page | description | summary       | published        | 2031-12-26 12:00:00 |
      And "platform" content:
        | title            | body         | field_summary | moderation_state | changed             |
        | Behat Platform 1 | description1 | summary1      | published        | 2031-12-25 12:00:00 |
      And "application" content:
        | title               | body         | field_summary | moderation_state | changed             |
        | Behat Application 1 | description1 | summary1      | published        | 2031-12-24 12:00:00 |
      And "component" content:
        | title           | body                  | field_status_usage | moderation_state | changed             |
        | Behat Component | Component description | Approved           | published        | 2031-12-23 12:00:00 |
      And I create "taxonomy_term" of type "component_category":
        | name              | field_icon | changed             |
        | Behat TechCatTerm | landmark   | 2031-12-20 12:00:00 |
    When I am logged in as a user with the "authenticated user" role
      And I run cron
    Then I take a screenshot using "landingpage.feature" file with "@home_page" tag

  @ui @api @javascript @wdio
  Scenario: Technology Landing Page For Recent Technology Discussions Block
    Given "forums" terms:
      | name  |
      | Covid |
      And "forum" content:
        | title              | body                 | taxonomy_forums | moderation_state | changed             |
        | BEHAT Technology 1 | This is technology 1 | Technology      | published        | 2031-12-20 12:00:00 |
        | BEHAT Technology 2 | This is technology 2 | Technology      | published        | 2031-12-21 12:00:00 |
        | BEHAT Tools 1      | This is tools        | Covid           | published        | 2031-12-22 12:00:00 |
        | behat Technology 3 | This is technology 3 | Technology      | published        | 2031-12-23 12:00:00 |
        | BEHAT Technology 4 | This is technology 4 | Technology      | published        | 2031-12-24 12:00:00 |
        | BEHAT Tools 2      | This is tools        | Tools           | published        | 2031-12-25 12:00:00 |
        | BEHAT Technology 5 | This is technology 5 | Technology      | published        | 2031-12-26 12:00:00 |
        | BEHAT Technology 6 | This is technology 6 | Technology      | published        | 2031-12-27 12:00:00 |
        | BEHAT Tools 3      | This is tools        | Tools           | published        | 2031-12-28 12:00:00 |
        | BEHAT Technology 7 | This is technology 7 | Technology      | published        | 2031-12-29 12:00:00 |
        | BeHAT Technology 8 | This is technology 8 | Technology      | published        | 2031-12-30 12:00:00 |
        | Behat Tools 4      | This is tools        | Tools           | published        | 2031-12-31 12:00:00 |
        | BehAT Tools 5      | This is tools        | Tools           | published        | 2031-12-19 12:00:00 |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    Then I take a screenshot using "landingpage.feature" file with "@technology_recenttechdiss" tag
