Feature: Search A Dataset
  As a Site Visitor
  I want to be able to search all the published datasets by keyword or metadata
  So that I can quickly find datasets that I'm looking for

  Background:
    Given "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |

  @api
  Scenario: Verify All Fields Exist In The Dataset Search View
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
        | title      | moderation_state | field_data_category |
        | Data.Set10 | published        | Analytical Data     |
        | DATASET 30 | published        | Internal Data       |
        | DATASET 32 | published        | Operational Data    |
      And I run cron
      And I am on "/datasets"
    Then I should see the text "Search Terms"
      And I should see the text "Owner"
      And I should see the text "Used by Division/Office"
      And I should see the text "Source"
      And I should see the text "Entity Type"
      And I should see the text "Asset Type"
      And I should see the text "Data Type"
      And I should see the text "Use Cases"
      And I should see the button "Submit"
      And I should see the button "Reset"
      And I should see the text "Filter By Data Category"
      And I should see the text "Show all"
      And I should see the text "Analytical Data"
      And I should see the text "Internal Data"
      And I should see the text "Operational Data"

  @api @javascript
  Scenario Outline: Search Dataset Content By Title And Description
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title          | field_dataset_description  | field_dataset_source_type | moderation_state |
      | Dataset1       | description about dataset1 | SEC                       | published        |
      | BEHAT Dataset2 | This is dataset2           | SRO                       | published        |
      | BEHAT Dataset3 |                            | SRO                       | published        |
      And I run cron
      And I am on "/datasets"
      And I fill in "Search Terms" with "<value>"
      And I press "Submit"
      And I wait for Ajax to finish
    Then I should see the link "<Result1>"
      And I should not see the link "<Result2>"
      And I press "Submit"

    Examples:
      | value            | Result1        | Result2        |
      | Dataset1         | Dataset1       | BEHAT Dataset2 |
      | This is dataset2 | BEHAT Dataset2 | Dataset1       |

  @api @javascript
  Scenario Outline: Search Dataset By Parent Selectors
    Given I am logged in as a user with the "authenticated user" role
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "data" terms:
      | name  | parent |
      | case1 |        |
      | case2 | case1  |
      And "data_set" content:
      | title                  | field_owner  | field_division_office_multi | field_dataset_source_type | field_dataset_registrant_type | field_dataset_asset_category | field_dataset_category | field_dataset_use | moderation_state |
      | Search with Owner      | new division |                             |                           |                               |                              |                        |                   | published        |
      | Search with Division   |              | division1                   |                           |                               |                              |                        |                   | published        |
      | Search with Use Case   |              |                             |                           |                               |                              |                        | case1             | published        |
      | Search with Use Case1  |              |                             |                           |                               |                              |                        | case2             | published        |
      | Search with Source     |              |                             | Other Government Agency   |                               |                              | Mergers & Acquisitions |                   | published        |
      | Search Entity Type     |              |                             |                           | Auditors                      |                              |                        |                   | published        |
      | Search with Asset Type |              |                             | NRSRO                     |                               | Equity                       |                        |                   | published        |
      | Search with Data Type  |              |                             | NRSRO                     |                               | Equity                       | Corporate Information  |                   | published        |
      And I run cron
    When I am on "/datasets"
      And I select "<ParentDropDown>" from "<dropdown>"
      And I press "Submit"
      And I wait for ajax to finish
    Then I should see the link "<Result1>" in the "results_view" region
      And I should not see the link "<Result2>" in the "results_view" region
      And I press "Reset"

    Examples:
      | ParentDropDown          | dropdown                | Result1                | Result2                |
      | new division            | Owner                   | Search with Owner      | Search with Source     |
      | division1               | Used by Division/Office | Search with Division   | Search with Source     |
      | case1                   | Use Cases               | Search with Use Case   | Search with Source     |
      | case2                   | Use Cases               | Search with Use Case1  | Search with Source     |
      | case1                   | Use Cases               | Search with Use Case1  | Search with Source     |
      | Other Government Agency | Source                  | Search with Source     | Search with Asset Type |
      | NRSRO                   | Source                  | Search with Asset Type | Search with Source     |
      | Auditors                | Entity Type             | Search Entity Type     | Search with Asset Type |
      | Equity                  | Asset Type              | Search with Asset Type | Search Entity Type     |
      | Corporate Information   | Data Type               | Search with Data Type  | Search Entity Type     |

  # @api @javascript   There is no child selector option now as per prod changes Aug 30 2019
  # Scenario Outline: Search Dataset Content By Child Selectors
  #   Given "data_set" content:
  #        | title                  |field_dataset_source_type | field_dataset_registrant_type|field_dataset_asset_category|    field_dataset_category             |  field_dataset_use    |moderation_state |
  #        | Search with Source     | NRSRO, DBRS              |                              |                            |                                       |                       | published       |
  #        | Search with Entity Type|                          |  Hedge Funds                 | Equity,Mortgages           |                                       |                       | published       |
  #        | Search with Asset Type | NRSRO, Fitch             |                              | Equity,Mortgages           |                                       |                       | published       |
  #        | Search with Data Type  |                          |                              |                            | Corporate Information, Salary Surveys |                       | published       |
  #        | Search with Use Cases  |                          |                              |                            |                                       |Analysis, Market Events| published       |
  #
  #     And I run cron
  #   When I am on "/dataset-search"
  #     And I select "<Dropdown>" from "<Field>"
  #     And I press "Apply"
  #     And I wait for ajax to finish
  #   Then I should see the link "<Result1>" in the "results_view" region
  #     And I should not see the link "<Result2>" in the "results_view" region
  #     And I press "Reset"
  #
  # Examples:
  # | Dropdown       | Field      | Result1                 | Result2                |
  # | DBRS           | Source     | Search with Source      | Search with Asset Type |
  # | Fitch          | Source     | Search with Asset Type  | Search with Source     |
  # | Hedge Funds    | Entity Type| Search with Entity Type |Search with Asset Type  |
  # | Mortgages      | Asset Type | Search with Asset Type  | Search with Source     |
  # | Salary Surveys | Data Type  | Search with Data Type   | Search with Use Cases  |
  # | Market Events  | Use Cases  | Search with Use Cases   | Search with Data Type  |

  @api @javascript
  Scenario: Dataset Search Results
    Given I am logged in as a user with the "Content Approver" role
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "tools" content:
      | title           | body         | field_tool_category | moderation_state |
      | DataSystem Tool | this is tool | Data Systems        | published        |
      And "data_set" content:
      | title         | field_summary     | field_dataset_description | field_dataset_source_type | field_tools     | field_how_to_request_access | moderation_state | field_owner  | field_reviewer | field_open_government_data_class | field_open_government_data_acces |
      | BEHAT dataset | short description | description               | FINRA                     | DataSystem Tool | '' - http://test.com        | published        | new division | approver       | DAclassification                 | DAaccess                         |
      And I run cron
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT dataset" row
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Related Documentation"
      And I wait 2 seconds
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I fill in "Description" with "Test" in the "form_area"
      And I select "Data Dictionary" from "field_documents[form][0][field_document_category]"
      And I publish it
    When I am on "/datasets"
      And I fill in "Search Terms" with "BEHAT dataset"
      And I scroll to the bottom
      And I press "Submit"
      And I wait 1 seconds
      And I wait for Ajax to finish
    Then I should see the link "BEHAT dataset" in the "results_view" region
      And I should see the text "Source"
      And I should see the link "Uploaded Document"
      And I should see the link "FINRA"
  #  And I should see the text "How to Access this Dataset"
  #  And I should see the text "Access Dataset Here"
  # And I should not see the link "SRO"
  # And I should see the link "DataSystem Tool"
  # And I should see the link "Uploaded Document"

  @api
  Scenario: Tag DataSet
    Given "tags" terms:
      | name       |
      | automation |
      And I am logged in as a user with the "authenticated user" role
    When I am viewing a "data_set" content:
      | title                       | BEHAT Dataset        |
      | field_dataset_description   | description          |
      | field_how_to_request_access | '' - http://test.com |
      | field_tags                  | automation           |
      | moderation_state            | published            |
      And I run cron
      And I am on "/datasets"
      And I fill in "Search Terms" with "automation"
      And I press "Submit"
    Then I should see the link "BEHAT Dataset"
    When I am on "/results"
      And I fill in "Search" with "automation" in the "search_form" region
      And I press "Search" in the "search_form" region
    Then I should see the link "BEHAT Dataset"

  @api
  Scenario Outline: Dataset Search With Misspelled Words
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title          | field_dataset_description           | field_data_search_index | moderation_state |
      | 10-K           | Test one                            | 10K 10k 1o-k 1ok        | published        |
      | Multiple Words | description description description |                         | published        |
      | Finra          | test                                |                         | published        |
      | Dataset 1      | description                         |                         | published        |
      | Dataset 2      | mortgage                            | morgage mogage          | published        |
      And I run cron
      And I am on "/datasets"
      And I fill in "Search Terms" with "<value>"
      And I press "Submit"
    Then I should see the link "<Result1>"
      And I should not see the link "<Result2>"
      And I press "Reset"
    Examples:
      | value    | Result1   | Result 2  |
      | 10-K     | 10-K      | Dataset 2 |
      | 10k      | 10-K      | Dataset 2 |
      | 1o-k     | 10-K      | Dataset 2 |
      | 1ok      | 10-K      | Dataset 2 |
      | morgage  | Dataset 2 | 10-K      |
      | mortgage | Dataset 2 | 10-K      |
      | mogage   | Dataset 2 | 10-K      |

  # @api @javascript
  # Scenario: Overweight Title In The Search Results  ---This feature is not worling as per prod changes Aug 30 2019
  # Given "data_set" content:
  #       | title     |field_dataset_description |field_dataset_source_type |moderation_state |
  #       | Finra     | test                     |                          | published       |
  #       | Dataset 1 | Finra                    |                          | published       |
  #       | Dataset 2 | This is description      | Finra                    | published       |
  #       And I run cron
  #       And I am on "/dataset_search"
  #       And I fill in "Search Terms" with "Finra"
  #       And I press "Submit"
  #       And I wait for Ajax to finish
  #       #Then I should see the link "Finra" before I see the link "Dataset 1" in the "results_view" region
  #       And I should not see the link "Dataset 2" in the "results_view" region
  #       #Global Dataset search results show dataset first followed by tools and then articles with explicit grouping

  # @api @javascript
  # Scenario: Higher Weighted In Results   --- This feature is also not supported in the prod version Aug 30 2019
  #   Given "data_set" content:
  #         | title     |field_dataset_description                                                      |moderation_state |
  #         | Dataset 1 | description                                                                   | published       |
  #         | Dataset 2 | This is description and this is a description and this is again a description | published       |
  #
  #     And I run cron
  #     And I am on "/dataset_search"
  #     And I fill in "Search Terms" with "description"
  #     And I press "Submit"
  #     And I wait for Ajax to finish
  #     #Then I should see the link "Dataset 2" before I see the link "Dataset 1" in the "results_view" region
  #   Then I should see the link "Dataset 1" in the "results_view" region
  #     And I should see the link "Dataset 2" in the "results_view" region
  #     #Global Dataset search results show dataset first followed by tools and then articles with explicit grouping

  @api
  Scenario: Verify NoResult Message
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title     | field_dataset_description | moderation_state |
      | Dataset 1 | description               | published        |
      | Dataset 2 | This is dataset2          | published        |
      And I run cron
    When I am on "/datasets"
      And I fill in "Search Terms" with "something"
      And I press "Submit"
    Then I should see the text "Your Search Returned No Results. You can adjust the filters or you can start the search again."

  @api @javascript
  Scenario Outline: Dataset Search With OtherNamesUsed Field
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title     | field_dataset_description | field_dataset_name_old | moderation_state |
      | Dataset 1 | description               | Other Name             | published        |
      | Dataset 2 | This is dataset2          | Old Name               | published        |
      And I run cron
    When I am on "/datasets"
      And I fill in "Search Terms" with "<value>"
      And I press "Submit"
    Then I should see the link "<Result1>" in the "results_view" region
      And I should not see the link "<Result2>" in the "results_view" region

    Examples:
      | value      | Result1   | Result 2  |
      | Other Name | Dataset 1 | Dataset 2 |
      | Old Name   | Dataset 2 | Dataset 1 |

  @api @javascript
  Scenario: Dataset Search Suggestions
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title              | field_summary      | field_dataset_description | field_dataset_source_type | field_how_to_request_access | moderation_state |
      | BEHAT dataset      | short description1 | description1              | FINRA                     | '' - http://test.com        | published        |
      | BEHAT Test dataset | short description2 | description2              | FINRA                     | '' - http://test.com        | published        |
      | 123 dataset        | short description3 | description3              | FINRA                     | '' - http://test.com        | published        |
      And "article" content:
      | title        | field_summary      | body        | field_category | moderation_state |
      | Test Article | short description4 | article one | FAQ            | published        |
      And "data_insight" content:
      | title          | field_summary       | body                 | moderation_state |
      | BEHAT Insight1 | short description 5 | Insight description1 | published        |
      | Insight 123    | short description 6 | Insight description1 | published        |
      And I run cron
    When I am on "/datasets"
      And I select the first autocomplete option for "behat" on the "Search Terms" field
    Then I should see the heading "BEHAT dataset"
      And I should not see the heading "BEHAT Insight1"
    When I am on "/datasets"
      And I select the first autocomplete option for "test" on the "Search Terms" field
    Then I should see the heading "BEHAT Test dataset"
      And I should not see the heading "Test Article"
    When I am on "/datasets"
      And I select the first autocomplete option for "123" on the "Search Terms" field
    Then I should see the heading "123 dataset"
      And I should not see the heading "Insight 123"

  @api @javascript
  Scenario: Exclude Dataset From Dataset Search
    Given I am logged in as a user with the "Content Approver" role
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "data_set" content:
      | title          | field_summary      | field_dataset_description  | field_dataset_source_type | moderation_state | field_exclude_dataset_search | field_reviewer | field_owner  | field_open_government_data_class | field_open_government_data_acces |
      | Dataset1       | short description1 | description about dataset1 | SEC                       | published        | 1                            | approver       | new division | DAclassification                 | DAaccess                         |
      | BEHAT Dataset2 | short description2 | This is dataset2           | SRO                       | published        | 0                            | approver       | new division | DAclassification                 | DAaccess                         |
      And I run cron
    When I am on "/datasets"
      And I fill in "Search Terms" with "data"
      And I scroll to the bottom
      And I press "Submit"
    Then I should not see the link "Datasets1"
      And I should see the link "BEHAT Dataset2"
    When I visit "/datasets/behat-dataset2/edit"
      And I press "Exclude from Dataset Search"
      And I wait 2 seconds
      And I check "Yes, exclude this page from the Dataset Search index."
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I press "Save"
      And I am on "/datasets"
    Then I should not see the link "Datasets1"
      And I should not see the link "BEHAT Dataset2"

  @api @javascript
  Scenario: Dataset Pagination
  Given "tags" terms:
      | name         |
      | automation   |
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "source_type" terms:
      | name |
      | SRO  |
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "source_type" terms:
      | name |
      | SRO  |
      And "data_category" terms:
      | name      |
      | category1 |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "application" content:
      | title              | field_summary      | body         | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | short description1 | description1 | summary1      | published        | approver       |
      And "data_set" content:
      | title      | field_summary       | field_dataset_description | moderation_state | field_tags |  field_dataset_source_type | field_reviewer | field_open_government_data_class | field_open_government_data_acces |
      | aDataset   | short description2  | description               | published        |            |                            |                | DAclassification                 | DAaccess                         |
      | Ba Dataset | short description3  | This is a dataset         | published        |            | SRO                        |                |                                  |                                  |
      | Db Dataset | short description4  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Gd Dataset | short description5  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | LG Dataset | short description6  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | QL Dataset | short description7  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | XxQ Dataset| short description8  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Yx Dataset | short description9  | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Zy Dataset | short description10 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | yz Dataset | short description11 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | 10- K      | short description12 | this is a dataset         | published        | automation |                            |                |                                  |                                  |
      | 30p        | short description13 | this is a dataset         | published        |            |                            | approver       | DAclassification                 | DAaccess                         |
      | LG Dataset | short description14 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | QL Dataset | short description15 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | XxQ Dataset| short description16 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Yx Dataset | short description17 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Zy Dataset | short description18 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | yz Dataset | short description19 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | 10- K      | short description20 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | 31p        | short description21 | this is a dataset         | published        |            |                            | approver       |                                  |                                  |
      | LG Dataset | short description22 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | QL Dataset | short description23 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | XxQ Dataset| short description24 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Yx Dataset | short description25 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      | Zy Dataset | short description26 | this is a dataset         | published        |            |                            |                |                                  |                                  |
      And I run cron
      And I am logged in as a user with the "Content Approver" role
    When I am on "/datasets"
    Then I should see the text "Showing 1 - 20 of 25 Datasets"
      And I should see the text "Source"
      And I should see the link "SRO"
      And I should see the text "Tags"
      And I should see the link "automation"
      And I scroll to the bottom
      And I should see the link "1"
      And I should see the link "2"
      And I should see the link "››"
      And I should see the link "Last »"
    When I am on "/datasets/30p/edit"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait 5 seconds
      And I fill in "Description" with "Test" in the "form_area"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "Document Category"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I press "Save"
      And I am on "/datasets"
    Then I should see the text "Data Dictionary"
      And I should see the link "BEHAT Application1"
      And I should see the text "Related Tech"
      And I should see the link "Uploaded Document"

  @api @javascript
  Scenario: Dataset Category Filtering Using Facet
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
        | title      | moderation_state | field_data_category |
        | Data.Set10 | published        | Analytical Data     |
        | DATASET 30 | published        | Internal Data       |
        | DATASET 32 | published        | Operational Data    |
      And I run cron
      And I am on "/datasets"
    Then I should see the text "Search Terms"
      And I should see the link "Data.Set10"
      And I should see the link "DATASET 30"
      And I should see the link "DATASET 32"
    When I check "Analytical Data"
      And I wait for ajax to finish
    Then I should see the link "Data.Set10"
      And I should not see the link "DATASET 30"
      And I should not see the link "DATASET 32"
    When I check "Internal Data"
      And I wait for ajax to finish
      And I uncheck "Analytical Data"
      And I wait for ajax to finish
    Then I should not see the link "Data.Set10"
      And I should see the link "DATASET 30"
      And I should not see the link "DATASET 32"
    When I check "Operational Data"
      And I wait for ajax to finish
      And I uncheck "Internal Data"
      And I wait for ajax to finish
    Then I should not see the link "Data.Set10"
      And I should not see the link "DATASET 30"
      And I should see the link "DATASET 32"
    When I check "Internal Data"
      And I wait for ajax to finish
    Then I should not see the link "Data.Set10"
      And I should see the link "DATASET 30"
      And I should see the link "DATASET 32"

# @api @javascript
# Scenario Outline: Dataset Pagination Top  -- This feature is not in the current prod version Aug 30 2019
# Given "data_set" content:
#      | title      |field_dataset_description |moderation_state |
#      | aDataset   | description              |published        |
#      | Ba Dataset | This is a dataset        |published        |
#      | Db Dataset | this is a dataset        |published        |
#      | Gd Dataset | this is a dataset        |published        |
#      | LG Dataset | this is a dataset        |published        |
#      | QL Dataset | this is a dataset        |published        |
#      | XxQ Dataset| this is a dataset        |published        |
#      | Yx Dataset | this is a dataset        |published        |
#      | Zy Dataset | this is a dataset        |published        |
#      | yz Dataset | this is a dataset        |published        |
#      | 10- K      | this is a dataset        |published        |
#      | 30p        | this is a dataset        |published        |
#
#      And I run cron
#      When I am on "/dataset_search"
#      And I click on the element with css selector "<letter>"
#      Then I should see the link "<result1>" in the "results_view" region
#      And I should not see the link "<result2>" in the "results_view" region
#
#      Examples:
#      | letter                              |result1     |result2    |
#      | #block-glossary-top li:nth-child(2) | aDataset   |Ba Dataset |
#      | #block-glossary-top li:nth-child(3) | Ba Dataset |Db Dataset |
#      | #block-glossary-top li:nth-child(4) | Db Dataset |Gd Dataset |
#      | #block-glossary-top li:nth-child(5) | Gd Dataset |LG Dataset |
#      | #block-glossary-top li:nth-child(6) | LG Dataset |QL Dataset |
#      | #block-glossary-top li:nth-child(7) | QL Dataset |XxQ Dataset |
#      | #block-glossary-top li:nth-child(8) | XxQ Dataset|Yx Dataset |
#      | #block-glossary-top li:nth-child(9) | Yx Dataset |Zy Dataset |
#      | #block-glossary-top li:nth-child(10)| Zy Dataset |yz Dataset |
#      | #block-glossary-top li:nth-child(11)| 10- K      |Zy Dataset |
#      | #block-glossary-top li:nth-child(11)| 30p        |Zy Dataset |

#@api @javascript
#Scenario Outline: Dataset Pagination Bottom
#Given "data_set" content:
#      | title      |field_dataset_description |moderation_state |
#      | aDataset   | description              |published        |
#      | Ba Dataset | This is a dataset        |published        |
#      | Db Dataset | this is a dataset        |published        |
#      | Gd Dataset | this is a dataset        |published        |
#      | LG Dataset | this is a dataset        |published        |
#      | QL Dataset | this is a dataset        |published        |
#      | XxQ Dataset| this is a dataset        |published        |
#      | Yx Dataset | this is a dataset        |published        |
#      | Zy Dataset | this is a dataset        |published        |
#      | yz Dataset | this is a dataset        |published        |
#      | 10- K      | this is a dataset        |published        |
#      | 30p        | this is a dataset        |published        |

#      And I run cron
#      When I am on "/"
#      And I scroll to the bottom
#      And I click on the element with css selector "<letter>"
#      Then I should see the link "<result1>" in the "results_view" region
#      And I should not see the link "<result2>" in the "results_view" region

#      Examples:
#      |letter                                                                    |result1     |result2    |
#      |#block-glossary-bottom li:nth-child(2) | aDataset   |Ba Dataset |
#      |#block-glossary-bottom li:nth-child(3) | Ba Dataset |Db Dataset |
#      |#block-glossary-bottom li:nth-child(4) | Db Dataset |Gd Dataset |
#      |#block-glossary-bottom li:nth-child(5) | Gd Dataset |LG Dataset |
#      |#block-glossary-bottom li:nth-child(6) | LG Dataset |QL Dataset |
#      |#block-glossary-bottom li:nth-child(7) | QL Dataset |XxQ Dataset|
#      |#block-glossary-bottom li:nth-child(8) | XxQ Dataset|Yx Dataset |
#      |#block-glossary-bottom li:nth-child(9) | Yx Dataset |Zy Dataset |
#      |#block-glossary-bottom li:nth-child(10)| Zy Dataset |yz Dataset |
#      |#block-glossary-bottom li:nth-child(11)| 10- K      |Zy Dataset |
#      |#block-glossary-bottom li:nth-child(11)| 30p        |Zy Dataset |
