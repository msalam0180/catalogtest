Feature: Global Search On Data Catalog
  As a Site Visitor
  I want to be able to search all published contents(datasets, documents, Tools etc) using either keyword or title
  So that user can quickly find the data that they are looking for

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And "component_category" terms:
      | name            | parent          | body        | field_summary          | field_icon |
      | BEHAT Category1 |                 | description | Summary of parent term | dog        |
      | BEHAT Category2 | BEHAT Category1 | description | Summary of child Term  | cat        |
      | BEHAT Category3 | BEHAT Category1 | description | child Term3            |            |
      And "manufacturer" terms:
      | name          |
      | Harvard Tech  |
      | Hardvard Tech |
      | Caltech       |
      | Calitech      |
      And "tags" terms:
      | name     |
      | michigan |

  @api
  Scenario: Verify Search Field Exist In The Landing page
    Given I am logged in as a user with the "authenticated user" role
      And I am on "/results"
    Then I should see the text "Search"
      And I should see the button "Search"

  @api
  Scenario Outline: Global Search With Dataset
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title                   | field_dataset_description | field_dataset_source_type | field_dataset_name_old | moderation_state |
      | Search With Title       | with title description    | NRSRO, DBRS               |                        | published        |
      | Search With Description | This is my description    | NRSRO, Fitch              |                        | published        |
      | Search with Legacy name | Test with legacy name     |                           | Global legacy          | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "<SearchValue>" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "<Result>"

    Examples:
      | SearchValue            | Result                  |
      | Search With Title      | Search With Title       |
      | This is my description | Search With Description |
      | Global legacy          | Search with Legacy name |

  @api
  Scenario: Global Search With Tools
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
      | title      | field_dataset_description | field_how_to_request_access | moderation_state |
      | Tool Title | Tool description          | '' - http://test.com        | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "Tool Title" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Tool Title"

  @api
  Scenario: Global Search With Application
    Given I am logged in as a user with the "authenticated user" role
      And "tags" terms:
      | name      |
      | Behat Tag |
      And "application" content:
      | title            | field_short_name | body             | field_summary          | field_division_office_multi | moderation_state | field_data_search_index | field_tags |
      | New Application  | FGH              | This is the body | summary                | division1                   | published        |                         |            |
      | Key Application1 |                  | This is the body | summary                | division1                   | published        | tiger; prawn            |            |
      | Key Application2 |                  | This is the body | summary                | division1                   | published        | offer                   |            |
      | Key Application3 |                  | This is the body | summary                | division1                   | published        | watch                   |            |
      | Tag Application  | ZXC              | This is the body | summary                | division1                   | published        |                         | Behat Tag  |
      | Old Application  |                  | This is the body | Summary of Application | division1                   | draft            |                         |            |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "Application" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "New Application"
      And I should not see the link "Old Application"
      And I should see the text "summary"
      And I should not see the text "This is the body"
    When I am on "/results"
      And I fill in "Search" with "body" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "New Application"
      And I should not see the link "Old Application"
    When I am on "/results"
      And I fill in "Search" with "summary" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "New Application"
      And I should not see the link "Old Application"
    When I am on "/results"
      And I fill in "Search" with "tiger" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Application1"
      And I should not see the link "New Application"
      And I should not see the link "Tag Application"
      And I should not see the link "Old Application"
    When I am on "/results"
      And I fill in "Search" with "behat" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Tag Application"
      And I should not see the link "New Application"
      And I should not see the link "Key Application1"
      And I should not see the link "Old Application"
    When I fill in "Search" with "offer" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Application2"
      And I should not see the link "Key Application1"
    When I fill in "Search" with "watch" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Application3"
      And I should not see the link "Key Application1"
    When I am on "/results"
      And I fill in "Search" with "prawn" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Application1"
    When I press "Reset"
      And I fill in "Search" with "FGH" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "New Application"
      And I fill in "Search" with "ZXC" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I should see the link "Tag Application"

  @api
  Scenario: Global Search With Software
    Given I am logged in as a user with the "authenticated user" role
      And "tags" terms:
      | name    |
      | jackson |
      And "component" content:
      | title            | body             | field_summary              | field_status | field_division_office_multi | moderation_state | field_data_search_index | field_tags |
      | BEHAT Component1 | This is the body | Component in short summary | Approved     | division1                   | published        |                         |            |
      | Key Component1   | This is the body | Component in short summary | Approved     | division1                   | published        | mango                   |            |
      | Key Component2   | This is the body | Component in short summary | Approved     | division1                   | published        | sonic                   |            |
      | Key Component3   | This is the body | Component in short summary | Approved     | division1                   | published        | curve; papaya           |            |
      | Tag Component3   | This s the body  | Component in short summary | Approved     | division1                   | published        |                         | jackson    |
      | BEHAT Component4 | This is the body | Component Summary          | Evaluation   | division2                   | draft            |                         |            |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "Component" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
      And I should not see the text "Component in short summary"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Component4"
    When I am on "/results"
      And I fill in "Search" with "component4" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Your Search Returned No Results."
      And I should not see the link "BEHAT Component4"
    When I am on "/results"
      And I fill in "Search" with "short" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component4"
    When I am on "/results"
      And I fill in "Search" with "summary" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component4"
    When I am on "/results"
      And I fill in "Search" with "body" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component4"
    When I am on "/results"
      And I fill in "Search" with "mango" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Component1"
    When I am on "/results"
      And I fill in "Search" with "papaya" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Component3"
    When I am on "/results"
      And I fill in "Search" with "jack" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Tag Component3"
      And I should not see the link "BEHAT Component4"
    When I fill in "Search" with "Sonic" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Component2"
      And I should not see the link "BEHAT Component4"
    When I fill in "Search" with "curve" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Component3"
      And I should not see the link "BEHAT Component4"

  @api
  Scenario: Global Search With Platform
    Given I am logged in as a user with the "authenticated user" role
      And "tags" terms:
      | name |
      | york |
      And "component" content:
      | title           | body             | field_summary        | moderation_state | field_data_search_index | field_tags | field_short_name |
      | BEHAT Platform1 | This is the body | Platform one summary | published        |                         |            | TAP              |
      | Key Platform2   | This is the body | Platform one summary | published        | dragonfly               |            |                  |
      | Tag Platform3   | This is the body | Platform one summary | published        |                         | york       |                  |
      | BEHAT Platform4 | This is the body | Platform two Summary | draft            |                         |            |                  |
      And "platform" content:
      | title         | body | field_summary | moderation_state | field_data_search_index |
      | key platformA | body | Platform1 sum | published        | jinx                    |
      | key platformB | body | Platform2 sum | published        | booth; scar             |
      | key platformC | body | Platform3 sum | published        | mark                    |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "platform" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Platform1"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I am on "/results"
      And I fill in "Search" with "platform4" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Your Search Returned No Results."
      And I should not see the link "BEHAT Platform4"
    When I am on "/results"
      And I fill in "Search" with "body" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Platform1"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I am on "/results"
      And I fill in "Search" with "summary" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Platform1"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I am on "/results"
      And I fill in "Search" with "dragonfly" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Key Platform2"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I am on "/results"
      And I fill in "Search" with "york" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Tag Platform3"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I fill in "Search" with "jinx" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "key platformA"
      And I should see the text "Platform1 sum"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I fill in "Search" with "booth" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "key platformB"
      And I should see the text "Platform2 sum"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I fill in "Search" with "mark" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "key platformC"
      And I should see the text "Platform3 sum"
      And I should not see the text "This is the body"
      And I should not see the link "BEHAT Platform4"
    When I fill in "Search" with "scar" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "key platformB"
    When I fill in "Search" with "tAp" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Platform1"

  @api @javascript
  Scenario Outline: Global Search For Media File
    #This test is updated for deleted documents appearing in Search DSITE-1810
    Given I am logged in as a user with the "Content Approver" role
      And I visit "/media/add/files"
      And I fill in "Name" with "<Name>"
      And I attach the file "<file>" to "File"
      And I wait 5 seconds
      And I fill in "Description" with "Test"
      And I publish it
      And I run cron
    When I am logged in as a user with the "Authenticated user" role
      And I am on "/results"
      And I fill in "Search" with "<Name>" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should not see the link "<Name>"
      And I should see the text "Your Search Returned No Results. Please adjust your search term and try again."
    When I am on "/results"
      And I fill in "Search" with "<file>"
      And I press "Search"
    Then I should see the text "Your Search Returned No Results. Please adjust your search term and try again."

    Examples:
      | Name           | file           |
      | BEHATDocument  | behat-file.txt |
      | Test_Search_dd | behat-file.doc |

  @api
  Scenario: Global Search With Article
    Given I am logged in as a user with the "authenticated user" role
      And "article" content:
      | title         | field_category | moderation_state |
      | Article Title | FAQ            | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "Article Title" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "Article Title"

  @api
  Scenario Outline: Global Search With Misspelled Words
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title          | field_dataset_description           | field_data_search_index | moderation_state |
      | 10-K           | Test one                            | 10K 10k 1o-k 1ok        | published        |
      | Multiple Words | description description description |                         | published        |
      | Finra          | test                                |                         | published        |
      | Dataset 1      | description                         |                         | published        |
      | Dataset 2      | mortgage                            | morgage mogage          | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "<value>" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "<Result1>" in the "results_view" region
      And I should not see the link "<Result2>" in the "results_view" region

    Examples:
      | value    | Result1   | Result 2  |
      | 10-K     | 10-K      | Dataset 2 |
      | 10k      | 10-K      | Dataset 2 |
      | 1o-k     | 10-K      | Dataset 2 |
      | 1ok      | 10-K      | Dataset 2 |
      | morgage  | Dataset 2 | 10-K      |
      | mortgage | Dataset 2 | 10-K      |
      | mogage   | Dataset 2 | 10-K      |

  @api
  Scenario: Overweight Title In The Global Search Results
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title     | field_dataset_description | field_dataset_source_type | moderation_state |
      | Finra     | test                      |                           | published        |
      | Dataset 1 | Finra                     |                           | published        |
      | Dataset 2 | This is description       | Finra                     | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "Finra" in the "search_form" region
      And I press "Search" in the "search_form" region

    Then I should see the link "Finra"
      And I should see the link "Dataset 1"
      And I should not see the link "Dataset 2" in the "results_view" region

  @api @javascript
  Scenario: Verify NoResult Message For Global Search
    Given I am logged in as a user with the "authenticated user" role
      And I am on "/results"
    When I fill in "Search" with "noResult" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Your Search Returned No Results. Please adjust your search term and try again."

  @api
  Scenario Outline: Global Search With Partial Word Search
    Given "data_set" content:
      | title            | field_dataset_description           | field_data_search_index | moderation_state |
      | BankruptcyStats  | test                                |                         | published        |
      | Factivia 8pp     | mortgage                            | morgage mogage          | published        |
      | Thomson Two      | test one                            | 10K 10k 1o-k 1ok        | published        |
      | FINRA's Databank | description description description |                         | published        |
      | DBfin            | test                                |                         | published        |
      | Badger Stats     | test                                |                         | published        |
      And "tools" content:
      | title         | field_dataset_description | field_how_to_request_access | moderation_state |
      | Banking Tools | tool description          | '' - http://test.com        | published        |
      | 2Factor 8pp   | tool description plats    | '' - http://test.com        | published        |
      | DBadger c0mp  | tool description plats    | '' - http://test.com        | published        |
      And "article" content:
      | title              | field_category | moderation_state |
      | Banker's Bible     | faq            | published        |
      | The factive        | faq            | published        |
      | The Bad Actor c0mp | faq            | published        |
      And "application" content:
      | title           | body             | field_summary          | field_division_office_multi | moderation_state |
      | New 8pplication | This is the body | Summary of Application | division1                   | published        |
      And "component" content:
      | title           | body             | field_summary     | field_status | field_division_office_multi | moderation_state |
      | BEHAT C0mponent | This is the body | Component Summary | Approved     | division1                   | published        |
      And "platform" content:
      | title       | body             | field_summary    | field_division_office_multi | moderation_state |
      | BEHAT Plats | This is the body | Platform Summary | division1                   | published        |
      And I run drush "cr"
      And I run cron
      And I am logged in as a user with the "Authenticated user" role
    When I am on "/results"
      And I fill in "Search" with "<value>" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "<Result1>" in the "results_view" region
      And I should see the link "<Result2>" in the "results_view" region
      And I should see the link "<Result3>" in the "results_view" region
      But I should not see the link "<Result4>" in the "results_view" region

    Examples:
      | value | Result1         | Result2       | Result3            | Result4          |
      | bank  | BankruptcyStats | Banking Tools | Banker's Bible     | DBfin            |
      | fact  | Factivia 8pp    | 2Factor 8pp   | The factive        | FINRA's Databank |
      | bad   | DBadger         | Badger Stats  | The Bad Actor      | Thomson Two      |
      | 8pp   | New 8pplication | 2Factor 8pp   | Factivia 8pp       | Banker's Bible   |
      | c0mp  | BEHAT C0mponent | DBadger c0mp  | The Bad Actor c0mp | New 8pplication  |
      | plats | BEHAT Plats     | DBadger c0mp  | 2Factor 8pp        | BEHAT C0mponent  |

  @api
  Scenario: Global Search Results Sort
    Given "data_set" content:
      | title                | field_dataset_description       | field_dataset_last_load_time | moderation_state | changed  | field_insights | field_data_search_index |
      | Vanilla yogurt D1805 | milk                            | 2019-09-02T12:00:00          | published        | -2 days  |                |                         |
      | Banana yogurt D1805  | yogurt                          | 2019-10-02T12:00:00          | published        | -10 days | yogurt         | yogurt                  |
      | Orange yogurt D1805  | yogurt                          | 2020-11-02T12:00:00          | published        | -4 days  |                | yogurt                  |
      | Pear D1805           | yogurt yogurt D1805 D1805 D1805 | 2020-01-02T12:00:00          | published        | -5 days  |                |                         |
      And "article" content:
      | title                                 | body          | field_category | moderation_state | changed  |
      | Rice&beans for tomorrows dinner D1805 | dinner dinner | faq            | published        | -15 days |
      | Chocolate for today's dinner D1805    | body D1805    | faq            | published        |          |
      And "tools" content:
      | title                              | field_dataset_description        | field_how_to_request_access | moderation_state | changed | field_tags |
      | Selenium Test Training today D1805 | tool description                 | '' - http://test.com        | published        | -3 days | michigan   |
      | Michigan man on Automation D1805   | D1805 D1805 michigan description | '' - http://test.com        | published        | -2 days | michigan   |
      And "data_insight" content:
      | title                                           | body                    | field_insight_date | moderation_state | changed |
      | Mangoes are the best fruit D1805                | fruits description      | 07/28/2019         | published        | -5 days |
      | Nectarines are smooth skinned peach fruit D1805 | D1805 DataInsight Desc1 | 08/28/2019         | published        | -9 days |
      And "application" content:
      | title                | body             | field_summary          | field_division_office_multi | moderation_state |
      | New test Application | This is the body | Summary of Application | division1                   | published        |
      And "component" content:
      | title                 | body                                 | field_summary     | field_status | field_division_office_multi | moderation_state | changed |
      | BEHAT Component D1805 | This is the body                     | Component Summary | Approved     | division1                   | published        | -1 days |
      | BEHAT D1805           | This is the component body component | Component Summary | Approved     | division2                   | published        |         |
      And "platform" content:
      | title            | body             | field_summary           | field_division_office_multi | moderation_state |
      | New Platform new | This is the body | Summary of new platform | division1                   | published        |
      And I run cron
      And I run drush "cr"
      And I am logged in as a user with the "authenticated user" role
    When I am on "/results"
      And I fill in "Search" with "yogurt" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "Banana yogurt D1805" should precede "Orange yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Orange yogurt D1805" should precede "Vanilla yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Vanilla yogurt D1805" should precede "Pear D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I select "Ascending" from "Order"
      And I press "Search" in the "search_form" region
    Then "Pear D1805" should precede "Vanilla yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Orange yogurt D1805" should precede "Banana yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I select "Last Load Time" from "Sort by"
      And I select "Descending" from "Order"
      And I press "Search" in the "search_form" region
    Then "Orange yogurt D1805" should precede "Pear D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Pear D1805" should precede "Banana yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Banana yogurt D1805" should precede "Vanilla yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And  I fill in "Search" with "dinner" in the "search_form" region
      And I select "Title" from "Sort by"
      And I select "Ascending" from "Order"
      And I press "Search" in the "search_form" region
    Then "Chocolate for today's dinner D1805" should precede "Rice&beans for tomorrows dinner D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I select "Descending" from "Order"
      And I press "Search" in the "search_form" region
    Then "Rice&beans for tomorrows dinner D1805" should precede "Chocolate for today's dinner D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "michigan" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "Michigan man on Automation D1805" should precede "Selenium Test Training today D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "fruit" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "Mangoes are the best fruit D1805" should precede "Nectarines are smooth skinned peach fruit D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "D1805" in the "search_form" region
      And I select "Last Updated Date" from "Sort by"
      And I press "Search" in the "search_form" region
    Then "BEHAT D1805" should precede "BEHAT Component D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Chocolate for today's dinner D1805" should precede "Rice&beans for tomorrows dinner D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Vanilla yogurt D1805" should precede "Orange yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Pear D1805" should precede "Banana yogurt D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Michigan man on Automation D1805" should precede "Selenium Test Training today D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
      And "Mangoes are the best fruit D1805" should precede "Nectarines are smooth skinned peach fruit D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "test" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "New test Application" should precede "Selenium Test Training today D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "component" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "BEHAT Component D1805" should precede "BEHAT D1805" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"
    When I am on "/results"
      And I fill in "Search" with "new" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then "New Platform new" should precede "New test Application" for the query "//h2[contains(@class, 'field-content view-box-style-title')]/a"

  @api @javascript
  Scenario: Global Search Suggestions
    Given "tools" content:
      | title           | body         | field_tool_category | moderation_state |
      | DataSystem Tool | this is tool | Data Systems        | published        |
      And "data_set" content:
      | title         | field_dataset_description | field_dataset_source_type | field_how_to_request_access | moderation_state |
      | BEHAT dataset | description               | FINRA                     | '' - http://test.com        | published        |
      And "article" content:
      | title       | Body        | field_category | moderation_state |
      | 456 Article | article one | FAQ            | published        |
      And "chart" content:
      | title       | Body | field_data_search_index | moderation_state |
      | behat chart | body | XnY-axis                | published        |
      And "statistics" content:
      | title       | body             | field_data_search_index | moderation_state |
      | New Reports | This is the body | myReportTerm            | published        |
      And "application" content:
      | title         | body                    | field_summary          | field_division_office_multi | moderation_state |
      | Service Later | This is the body of app | Summary of Application | division1                   | published        |
      And "component" content:
      | title           | body             | field_summary     | field_status | field_division_office_multi | moderation_state |
      | BEHAT Component | This is the body | Component Summary | Approved     | division1                   | published        |
      And "platform" content:
      | title     | body             | field_summary       | field_division_office_multi | moderation_state |
      | Facebucks | This is the body | Summary of platform | division1                   | published        |
      And I run cron
      And I am logged in as a user with the "authenticated user" role
    When I am on "/results"
      And I select the first autocomplete option for "datasystem" on the "Search" field
    Then I should see the heading "DataSystem Tool"
    When I am on "/results"
      And I select the first autocomplete option for "behat" on the "Search" field
    Then I should see the heading "BEHAT dataset"
    When I am on "/results"
      And I select the first autocomplete option for "456" on the "Search" field
    Then I should see the heading "456 Article"
    When I am on "/results"
      And I select the first autocomplete option for "xny" on the "Search" field
    Then I should see the heading "behat chart"
    When I am on "/results"
      And I select the first autocomplete option for "myReportTerm" on the "Search" field
    Then I should see the heading "New Reports"
    When I am on "/results"
      And I select the first autocomplete option for "Service Later" on the "Search" field
    Then I should see the heading "Service Later"
      And I should see the text "this is the body of app"
    When I am on "/results"
      And I select the first autocomplete option for "compo" on the "Search" field
    Then I should see the heading "BEHAT Component"
    When I am on "/results"
      And I select the first autocomplete option for "face" on the "Search" field
    Then I should see the heading "Facebucks"

  @api @javascript
  Scenario: Search With Facets
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title              | body             | field_summary          | field_division_office_multi | moderation_state |
      | BEHAT Application1 | This is the body | Summary of Application | division1                   | published        |
      | BEHAT Application2 | This is the body | Summary of Application | division1                   | published        |
      | BEHAT Application3 | This is the body | Summary of Application | division2                   | draft            |
      And "tools" content:
      | title       | body                 | field_tool_category | moderation_state |
      | Tool1       | this is tool         | Data Systems        | published        |
      | BEHAT Tool2 | this is tool22  test | Data Systems        | published        |
      And "data_set" content:
      | title          | field_dataset_description | field_dataset_source_type | moderation_state |
      | Dataset1       | description               | FINRA                     | published        |
      | BEHAT Dataset2 | description test          | FINRA                     | published        |
      | BEHAT Dataset3 | description22             | FINRA                     | draft            |
      And "article" content:
      | title          | body               | field_category | moderation_state |
      | Article1       | article report one | FAQ            | published        |
      | BEHAT Article2 | article test       | FAQ            | published        |
      | BEHAT Article3 | article 22         | FAQ            | draft            |
      And "statistics" content:
      | title              | body                  | field_data_search_index | moderation_state |
      | BEHAT Reports Test | This is the body test | myReportTerm            | published        |
      And "data_insight" content:
      | title          | body                     | moderation_state |
      | BEHAT Insight1 | This is the body  test   | published        |
      | BEHAT Insight2 | This is the body22  test | published        |
      And "component" content:
      | title           | body                             | field_status | field_division_office_multi | moderation_state |
      | BEHAT Component | Description about component test | Approved     | division1                   | published        |
      And "platform" content:
      | title                | body                  | field_summary        | field_division_office_multi | moderation_state |
      | BEHAT Platform1      | This is the body test | Summary of platform  | division1                   | published        |
      | BEHAT Platform2 Test | This is the body      | Summary of pplatform | division2                   | published        |
      | BEHAT Platform3      | This is the body test | Summary of platform  | division1                   | draft            |
      And "page" content:
      | title          | body             | field_summary | moderation_state |
      | BEHAT Page One | This is the body | page test     | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "behat" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see "Filter by Type"
      And I should see "Show all"
      And the checkbox "facets-reset-id" is checked
      And I should see "Application (2)"
      And I should see "Data Insight (2)"
      And I should see "Platform (2)"
      And I should see "Article (1)"
      And I should see "Software (1)"
      And I should see "Dataset (1)"
      And I should see "Informational Page (1)"
      And I should see "Landing Page"
      And the checkbox "filter-by-content-type-landing-page" is unchecked
      And I should see "Reports and Statistics (1)"
      And I should see "Tool (1)"
      And I should see the link "BEHAT Dataset2"
      And I should see the link "BEHAT Tool2"
      And I should see the link "BEHAT Article2"
      And I should see the link "BEHAT Insight1"
      And I should see the link "BEHAT Insight2"
      And I should see the link "BEHAT Reports Test"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I should not see the link "BEHAT Application3"
      And I should see the link "BEHAT Component"
      And I should not see the link "BEHAT Tool1"
      And I should not see the link "BEHAT Dataset1"
      And I should not see the link "BEHAT Dataset3"
      And I should not see the link "BEHAT Article1"
      And I should not see the link "BEHAT Article3"
    When I check "Article (1)"
      And I wait 1 seconds
    Then I should see the link "BEHAT Article2"
      And I should not see the link "BEHAT Article3"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Reports Test"
      And I uncheck the box "Article (1)"
      And I wait 1 seconds
    When I check "Data Insight (2)"
      And I wait 1 seconds
    Then I should see the link "BEHAT Insight1"
      And I should see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Reports Test"
      And I uncheck the box "Data Insight (2)"
      And I wait 1 seconds
    When I check "Tool (1)"
      And I wait 1 seconds
    Then I should see the link "BEHAT Tool2"
      And I should not see the link "Tool1"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Reports Test"
      And I uncheck the box "Tool (1)"
      And I wait 1 seconds
    When I check "Application (2)"
      And I wait 1 seconds
    Then I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I should not see the link "BEHAT Application3"
      And I should not see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Reports Test"
      And I uncheck the box "Application (2)"
      And I wait 1 seconds
    When I check "Dataset (1)"
      And I wait 1 seconds
    Then I should see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Reports Test"
    When I check "Reports and Statistics (1)"
      And I wait 2 seconds
    Then I should see the link "BEHAT Reports Test"
      And I should see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Dataset1"
      And I should not see the link "BEHAT Dataset3"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Tool2"
    When I check "Software (1)"
      And I wait 2 seconds
    Then I should see the link "BEHAT Component"
      And I should see the link "BEHAT Reports Test"
      And I should see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Dataset1"
      And I should not see the link "BEHAT Dataset3"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Application2"
      And I should not see the link "BEHAT Application3"
      And I uncheck the box "Software (1)"
      And I wait 1 seconds
      And I uncheck the box "Reports and Statistics (1)"
      And I wait 1 seconds
      And I uncheck the box "Dataset (1)"
      And I wait 1 seconds
    When I check "Platform (2)"
    Then I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2 Test"
      And I should not see the link "BEHAT Dataset2"
      And I should not see the link "BEHAT Platform3"
      And I should not see the link "test Application1"
      And I should not see the link "BEHAT Dataset1"
      And I should not see the link "BEHAT Dataset3"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Insight2"
      And I should not see the link "BEHAT Article2"
      And I should not see the link "BEHAT Tool2"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Application2"
      And I should not see the link "BEHAT Application3"
      And I wait 1 seconds
      And I uncheck the box "Platform (2)"
      And I wait 1 seconds
    When I check "Informational Page (1)"
    Then I should see the link "BEHAT Page One"
      And I should not see the link "BEHAT Platform2 Test"
      And I should not see the link "BEHAT Dataset2"
      And I wait 1 seconds
      And I press "Reset" in the "search_form" region
      And I wait 1 seconds
      And I should see the text "Your Search Returned No Results."
      And I should see the text "Please adjust your search term and try again."

  @api
  Scenario: Site Search With Content Type Boost
    Given I am logged in as a user with the "authenticated user" role
      And "application" content:
      | title        | body                       | field_summary          | field_division_office_multi | moderation_state |
      | Application1 | omega123 new calgary       | Summary of Application | division1                   | published        |
      | Application2 | This is the ponzu Category | Summary of Application | division1                   | published        |
      And "tools" content:
      | title       | body                         | moderation_state |
      | BEHAT Tool1 | omega369 new calgary         | published        |
      | BEHAT Tool2 | this is tool2 ponzu Category | published        |
      And "data_set" content:
      | title          | field_dataset_description | moderation_state |
      | BEHAT Dataset1 | omega456                  | published        |
      | BEHAT Dataset2 | description calgary       | published        |
      And "article" content:
      | title          | body                              | moderation_state |
      | BEHAT Article1 | omega789 report test Category     | published        |
      | BEHAT Article2 | This is the ponzu article calgary | published        |
      | BEHAT Article3 | ponzu article22 new ponzu         | published        |
      And "statistics" content:
      | title         | body                        | moderation_state |
      | BEHAT Reports | omega157 new Category ponzu | published        |
      And "data_insight" content:
      | title          | body                    | moderation_state |
      | BEHAT Insight1 | omega135 ponzu calgary  | published        |
      | BEHAT Insight2 | This is the insight new | published        |
      And "component" content:
      | title           | body                             | field_summary   | field_status | field_division_office_multi | field_component_category | moderation_state |
      | BEHAT Component | omega234 about component calgary |                 | Approved     | division1                   |                          | published        |
      | Behat Comp 1    | this is the ponzu                | calgary summary | Recommended  | division1                   | BEHAT Category1          | published        |
      And "platform" content:
      | title           | body                       | field_summary                 | field_division_office_multi | moderation_state |
      | BEHAT Platform1 | omega369 the ponzu calgary | Summary of platform  category | division1                   | published        |
      | BEHAT Platform2 | This is the description    | Summary of platform new       | division2                   | published        |
      And "landing_page" content:
      | title              | body                        | field_summary | moderation_state |
      | BEHAT Landing Page | omega ponzu of landing page | new landing   | published        |
      And "page" content:
      | title         | body                       | field_summary | moderation_state |
      | Info Page One | omega369 This is the ponzu | page 1234     | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "calgary" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Dataset" before I see the text "Platform" in the "results_view" region
      And I should see the text "Platform" before I see the text "Application" in the "results_view" region
      And I should see the text "Application" before I see the text "Software" in the "results_view" region
      And I should see the text "Software" before I see the text "Data Insight" in the "results_view" region
      And I should see the text "Data Insight" before I see the text "Article" in the "results_view" region
      And I should see the text "Data Insight" before I see the text "Tool" in the "results_view" region
    When I fill in "Search" with "ponzu" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Landing Page" before I see the text "Platform" in the "results_view" region
      And I should see the text "Platform" before I see the text "Application" in the "results_view" region
      And I should see the text "Application" before I see the text "Software" in the "results_view" region
      And I should see the text "Software" before I see the text "Data Insight" in the "results_view" region
      And I should see the text "Data Insight" before I see the text "Reports and Statistics" in the "results_view" region
    When I fill in "Search" with "category" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Technology Category" before I see the text "Platform" in the "results_view" region
    When I fill in "Search" with "omega" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "Data Insight" before I see the text "Informational Page" in the "results_view" region
      And I should see the text "Informational Page" before I see the text "Article" in the "results_view" region
      And I should see the text "Informational Page" before I see the text "Tool" in the "results_view" region
      And I should see the text "Informational Page" before I see the text "Reports and Statistics" in the "results_view" region

  @api @javascript
  Scenario Outline: Global Search With Informational Page, Landing Page And Software Category
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title        | body         | field_summary | field_status | moderation_state | field_division_office_multi | field_component_category |
      | Behat Comp 1 | description1 | 1234          | Recommended  | published        | division1                   | BEHAT Category1          |
      | Behat Comp 2 | description2 | 5678          | Approved     | published        | division1                   | BEHAT Category3          |
      | Behat Comp 3 | description3 | 9090          | Retired      | published        | division1                   | BEHAT Category3          |
      And "page" content:
      | title         | body              | field_summary | moderation_state |
      | Info Page One | This is the body  | page 1234     | published        |
      | Info Page Two | This is the body2 | page90        | published        |
      And "landing_page" content:
      | title              | body                           | field_summary | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | new landing   | published        |
      And I run cron
    When I am on "/results"
      And I fill in "Search" with "<term>" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the text "<label>"
      And I should see the text "<summary>"
      And I should not see the text "<body>"
      And I should see the link "<result1>"
      And I should see the link "<result2>"
      And I should not see the link "<result3>"
      And I should not see the link "<result4>"

    Examples:
      | term               | label               | summary                | body                           | result1            | result2         | result3         | result4            |
      | category           | Technology Category | Summary of parent term | description                    | BEHAT Category1    | BEHAT Category2 | Behat Comp 2    | Behat Comp 3       |
      | summary            |                     | Summary of child Term  | description                    | BEHAT Category1    | BEHAT Category2 | BEHAT Category3 | Behat Comp 3       |
      | 90                 | Informational Page  |                        | description3                   | Behat Comp 3       | Info Page Two   | Behat Comp 1    | Behat Comp 2       |
      | body2              | Informational Page  | page90                 | This is the body2              | Info Page Two      |                 | Info Page One   | Behat Comp 2       |
      | landing            | Landing Page        | new landing            | This is the BEHAT landing page | BEHAT Landing Page |                 | Behat Comp 1    | Info Page One      |
      | new                | Landing Page        | new landing            | This is the BEHAT landing page | BEHAT Landing Page |                 | Behat Comp 1    | Info Page One      |
      | Info Page One      | Informational Page  | page 1234              | This is the body               | Info Page One      |                 | Info Page Two   | BEHAT Landing Page |
      | BEHAT Category1    | Technology Category | Summary of parent term | description                    | BEHAT Category1    |                 | Info Page One   | Info Page Two      |
      | BEHAT Landing Page | Landing Page        | new landing            | This is the BEHAT landing page | BEHAT Landing Page |                 | Info Page One   | Info Page Two      |

  @api @javascript
  Scenario: Exclude Dataset From Global Search
    Given I am logged in as a user with the "sitebuilder" role
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "data_category" terms:
      | name      |
      | category1 |
      And "division_office" terms:
      | name      |
      | division1 |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
      And "data_set" content:
      | title          | field_summary | field_dataset_description  | field_dataset_source_type | moderation_state | field_exclude_from_global_search | field_reviewer | field_owner | field_data_category | field_open_government_data_class | field_open_government_data_acces |
      | Dataset1       | behat short   | description about dataset1 | SEC                       | published        | 1                                | approver       | division1   | category1           | DAclassification                 | DAaccess                         |
      | BEHAT Dataset2 | behat short   | This is dataset2           | SRO                       | published        | 0                                | approver       | division1   | category1           | DAclassification                 | DAaccess                         |
      And I run cron
    When I am on "/results?term=data"
      And I fill in "Search" with "data"
      And I press "Search"
    Then I should not see the link "Datasets1"
      And I should see the link "BEHAT Dataset2"
    When I visit "/datasets/behat-dataset2/edit"
      And I press "Exclude From Global Search"
      And I wait 2 seconds
      And I check "Yes, exclude this page from the Global Search index."
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I press "Save"
      And I am on "/results?term=data"
    Then I should not see the link "Datasets1"
      And I should not see the link "BEHAT Dataset2"

  @api @javascript
  Scenario: Global Search With Keyword Search
    Given "data_set" content:
      | title        | field_dataset_description | field_data_search_index | moderation_state |
      | Factivia 8pp | mortgage                  | pear                    | published        |
      And "chart" content:
        | title       | Body | field_data_search_index | moderation_state |
        | behat chart | body | tomato                  | published        |
      And "data_insight" content:
        | title          | body                    | moderation_state | field_data_search_index |
        | BEHAT Insight1 | This is the body test   | published        | papaya                  |
      And "application" content:
        | title           | body             | field_summary          | field_division_office_multi | moderation_state | field_data_search_index |
        | New 8pplication | This is the body | Summary of Application | division1                   | published        | banana                  |
      And "component" content:
        | title           | body             | field_summary     | field_status | field_division_office_multi | moderation_state | field_data_search_index |
        | BEHAT C0mponent | This is the body | Component Summary | Approved     | division1                   | published        | mango Sorbet            |
      And "platform" content:
        | title       | body             | field_summary    | field_division_office_multi | moderation_state | field_data_search_index |
        | BEHAT Plats | This is the body | Platform Summary | division1                   | published        | orange                  |
      And "statistics" content:
        | title         | body                           | moderation_state | field_data_search_index |
        | BEHAT Reports | This is test new Category body | published        | guava                   |
      And I run cron
      And I am logged in as a user with the "Authenticated user" role
    When I am on "/results"
      And I select the first autocomplete option for "mango sorbet" on the "Search" field
    Then I should see the heading "BEHAT C0mponent"
    When I am on "/results"
      And I select the first autocomplete option for "pear" on the "Search" field
    Then I should see the heading "Factivia 8pp"
    When I am on "/results"
      And I select the first autocomplete option for "tomato" on the "Search" field
    Then I should see the heading "behat chart"
    When I am on "/results"
      And I select the first autocomplete option for "Sor" on the "Search" field
    Then I should see the heading "BEHAT C0mponent"
    When I am on "/results"
      And I select the first autocomplete option for "papaya" on the "Search" field
    Then I should see the heading "BEHAT Insight1"
    When I am on "/results"
      And I select the first autocomplete option for "banana" on the "Search" field
    Then I should see the heading "New 8pplication"
    When I am on "/results"
      And I select the first autocomplete option for "mango" on the "Search" field
    Then I should see the heading "BEHAT C0mponent"
    When I am on "/results"
      And I select the first autocomplete option for "orange" on the "Search" field
    Then I should see the heading "BEHAT Plats"
    When I am on "/results"
      And I select the first autocomplete option for "guava" on the "Search" field
    Then I should see the heading "BEHAT Reports"
    When I am on "/results"
      And I select the first autocomplete option for "sorbet" on the "Search" field
    Then I should see the heading "BEHAT C0mponent"

  @api @javascript
  Scenario: Global Search Of Software And Application Using Short Name And Autocomplete
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title            | field_short_name | body             | field_status | moderation_state |
      | BEHAT Component1 | luckycharms      | This is the body | Approved     | published        |
      And "application" content:
      | title              | field_short_name | body             | moderation_state |
      | BEHAT Application1 | fruitloops       | This is the body |  published       |
      And I run cron
    When I am on "/results"
      And I select the first autocomplete option for "luckycharms" on the "Search" field in the "search_form" region
    Then I should see the heading "BEHAT Component1 (luckycharms)"
    When I am on "/results"
      And I fill in "Search" with "luckycharms" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
    When I am on "/results"
      And I select the first autocomplete option for "loops" on the "Search" field in the "search_form" region
    Then I should see the heading "BEHAT Application1 (fruitloops)"
    When I am on "/results"
      And I fill in "Search" with "loops" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Application1"

  @api @javascript
  Scenario: Global And Local Search Using Manufacturer And Autocomplete
    Given I am logged in as a user with the "authenticated user" role
      And "component" content:
      | title            | body             | field_manufacturer | field_status | moderation_state |
      | BEHAT Component1 | This is the body | Harvard Tech       | Approved     | published        |
      | BEHAT Component2 | This is the body | Hardvard Tech      | Approved     | published        |
      And "platform" content:
      | title           | body                  | field_summary                 | field_manufacturer | field_division_office_multi | moderation_state |
      | BEHAT Platform1 | This is the body test | Summary of platform  category | Caltech            | division1                   | published        |
      | BEHAT Platform2 | This is the body test | Summary of platform  category | Calitech           | division1                   | published        |
      And I run cron
      #Homepage Search:
    When I am on "/"
      And I select the first autocomplete option for "Harvard" on the "edit-term" field in the "homepage_search" region
      And I wait 3 seconds
    Then I should see the heading "BEHAT Component1"
      And I should not see the heading "BEHAT Component2"
    When I am on "/"
      And I select the first autocomplete option for "Caltec" on the "edit-term" field in the "homepage_search" region
    Then I should see the heading "BEHAT Platform1"
      And I should not see the heading "BEHAT Platform2"
    When I am on "/results"
      And I select the first autocomplete option for "Harvard" on the "Search" field in the "search_form" region
    Then I should see the heading "BEHAT Component1"
      And I should not see the heading "BEHAT Component2"
    When I am on "/results"
      And I fill in "Search" with "Harvard" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Component1"
      And I should not see the link "BEHAT Component2"
    When I am on "/results"
      And I select the first autocomplete option for "Calt" on the "Search" field in the "search_form" region
    Then I should see the heading "BEHAT Platform1"
      And I should not see the heading "BEHAT Platform2"
    When I am on "/results"
      And I fill in "Search" with "Caltec" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Platform1"
      And I should not see the heading "BEHAT Platform2"
      #Global Search autocomplete in Header on Homepage:
    When I am on "/"
      And I select the first autocomplete option for "Harv" on the "Search" field
    Then I should see the heading "BEHAT Component1"
      And I should not see the heading "BEHAT Component2"
    When I am on "/"
      And I select the first autocomplete option for "Calte" on the "Search" field
    Then I should see the heading "BEHAT Platform1"
      And I should not see the heading "BEHAT Platform2"
