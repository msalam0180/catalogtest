Feature: Dashboard for Managing Selected Metadata Fields on Multiple Datasets
  As a content creator
  I want to be able to visit a special page from where I can manage selected metadata fields on multiple Datasets
  so that I can view and edit fields for any datasets from a single dashboard page

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      | category2 |
      | category3 |
      | category4 |
      | category5 |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "quality_completeness" terms:
      | name      |
      | quality 1 |
      | quality 2 |
      | quality 3 |
      | quality 4 |
      | quality 5 |
      And "quality_consistency" terms:
      | name                         |
      | quality consisting low       |
      | quality consisting medium    |
      | quality consisting average   |
      | quality consisting good      |
      | quality consisting excellent |
      And "contract_status" terms:
      | name              |
      | contract status 1 |
      | contract status 2 |
      | contract status 3 |
      | contract status 4 |
      | contract status 5 |
      And "cost_category" terms:
      | name       |
      | cost cat 1 |
      | cost cat 2 |
      | cost cat 3 |
      | cost cat 4 |
      | cost cat 5 |
      And "dataset_categorization" terms:
      | name          |
      | dataset cat 1 |
      | dataset cat 2 |
      | dataset cat 3 |
      | dataset cat 4 |
      | dataset cat 5 |
      And "data_structure" terms:
      | name                |
      | dataset structure 1 |
      | dataset structure 2 |
      | dataset structure 3 |
      | dataset structure 4 |
      | dataset structure 5 |
      And "delivery_frequency_to_sec" terms:
      | name               |
      | delivery freq 1 |
      | delivery freq 2 |
      | delivery freq 3 |
      | delivery freq 4 |
      | delivery freq 5 |
      And "fips_category_justification" terms:
      | name        |
      | nist type 1 |
      | nist type 2 |
      | nist type 3 |
      | nist type 4 |
      | nist type 5 |
      And "fips_security_classification" terms:
      | name       |
      | fips sec 1 |
      | fips sec 2 |
      | fips sec 3 |
      | fips sec 4 |
      | fips sec 5 |
      And "market_sensitivity" terms:
      | name          |
      | market sens 1 |
      | market sens 2 |
      | market sens 3 |
      | market sens 4 |
      | market sens 5 |
      And "ocdo_classification" terms:
      | name         |
      | ocdo class 1 |
      | ocdo class 2 |
      | ocdo class 3 |
      | ocdo class 4 |
      | ocdo class 5 |
      And "open_government_data_act_classif" terms:
      | name         |
      | ogda class 1 |
      | ogda class 2 |
      | ogda class 3 |
      | ogda class 4 |
      | ogda class 5 |
      And "sensitive_data_category" terms:
      | name      |
      | pii cat 1 |
      | pii cat 2 |
      | pii cat 3 |
      | pii cat 4 |
      | pii cat 5 |
      And "sensitivity_classification" terms:
      | name           |
      | dataset sens 1 |
      | dataset sens 2 |
      | dataset sens 3 |
      | dataset sens 4 |
      | dataset sens 5 |
      And "quality_timeliness_recency" terms:
      | name         |
      | timeliness 1 |
      | timeliness 2 |
      | timeliness 3 |
      | timeliness 4 |
      | timeliness 5 |
      And "metadata_groups" terms:
      | name | tid    | field_metadata   |
      | OG   | 999999 | node.field_owner |

  @api @javascript
  Scenario: Filtering Datasets on Metadata Dashboard
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 4551                         |
      | field_number_of_active_internal_ | 111                          |
      | field_dataset_categorization_det | Cat1                         |
      | field_dataset_name_old           | oldname1                     |
      | field_dataset_sales_rep_name     | Mario                        |
      | field_data_search_index          | keyword1                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
      | field_number_of_licenses_assigne | 4311                         |
      | field_number_of_licenses_held    | 301                          |
      | field_omb_number                 | 201                          |
      | field_retention_length           | 601                          |
      | field_sales_rep_email_address    | sales_rep+1@test.test        |
      | field_sec_gov_node_id            | 711                          |
      | field_support_email_address      | support+1@test.test          |
      | field_time_period_covered        | Jurassic                     |
      | field_total_annual_burden_hours  | 501                          |
      | field_vendor_name                | Mozzarella                   |
      | field_act                        | The Securities Act of 1931   |
      | field_child_data_type            | a subset of                  |
      | field_externally_hosted          | Externally                   |
      | field_filing_entity_type         | Beneficial owner             |
      | field_purchased                  | - Any -                      |
      | field_submission_type            | Accounting Certifications    |
      | field_ogda_access_level_rights   | heavy                        |
      | field_completeness               | quality 1                    |
      | field_consistency                | quality consisting low       |
      | field_contract_status            | contract status 1            |
      | field_cost_category              | cost cat 1                   |
      | field_dataset_categorization     | dataset cat 1                |
      | field_data_structure             | dataset structure 1          |
      | field_delivery_frequency_to_sec  | delivery freq 1              |
      | field_fips_category_justificatio | nist type 1                  |
      | field_fips_security_classificati | fips sec 1                   |
      | field_market_sensitivity         | market sens 1                |
      | field_ocdo_classification        | ocdo class 1                 |
      | field_open_government_data_class | ogda class 1                 |
      | field_sensitive_data_category    | pii cat 1                    |
      | field_sensitivity_classification | dataset sens 1               |
      | field_timeliness_recency         | timeliness 1                 |
    Then I should see the heading "BEHAT Test Dataset 1"
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 2         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category2                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 4552                         |
      | field_number_of_active_internal_ | 222                          |
      | field_dataset_categorization_det | Cat2                         |
      | field_dataset_name_old           | oldname2                     |
      | field_dataset_sales_rep_name     | Luigi                        |
      | field_data_search_index          | keyword2                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234502                      |
      | field_number_of_licenses_assigne | 4322                         |
      | field_number_of_licenses_held    | 302                          |
      | field_omb_number                 | 202                          |
      | field_retention_length           | 602                          |
      | field_sales_rep_email_address    | sales_rep+2@test.test        |
      | field_sec_gov_node_id            | 712                          |
      | field_support_email_address      | support+2@test.test          |
      | field_time_period_covered        | Cretaceous                   |
      | field_total_annual_burden_hours  | 502                          |
      | field_vendor_name                | Gouda                        |
      | field_act                        | The Securities Act of 1932   |
      | field_child_data_type            | transformed by               |
      | field_externally_hosted          | Internally                   |
      | field_filing_entity_type         | Broker-Dealer                |
      | field_purchased                  | - Any -                      |
      | field_submission_type            | Advisors Act Registration    |
      | field_ogda_access_level_rights   | heavy                        |
      | field_associated_related_dataset | BEHAT Test Dataset 1         |
      | field_completeness               | quality 2                    |
      | field_consistency                | quality consisting medium    |
      | field_contract_status            | contract status 2            |
      | field_cost_category              | cost cat 2                   |
      | field_dataset_categorization     | dataset cat 2                |
      | field_data_structure             | dataset structure 2          |
      | field_delivery_frequency_to_sec  | delivery freq 2              |
      | field_fips_category_justificatio | nist type 2                  |
      | field_fips_security_classificati | fips sec 2                   |
      | field_market_sensitivity         | market sens 2                |
      | field_ocdo_classification        | ocdo class 2                 |
      | field_open_government_data_class | ogda class 2                 |
      | field_sensitive_data_category    | pii cat 2                    |
      | field_sensitivity_classification | dataset sens 2               |
      | field_timeliness_recency         | timeliness 2                 |
    Then I should see the heading "BEHAT Test Dataset 2"
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 3         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category3                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 4553                         |
      | field_number_of_active_internal_ | 3344                         |
      | field_dataset_categorization_det | Cat3                         |
      | field_dataset_name_old           | oldname3                     |
      | field_dataset_sales_rep_name     | Bowser                       |
      | field_data_search_index          | keyword3                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234503                      |
      | field_number_of_licenses_assigne | 4333                         |
      | field_number_of_licenses_held    | 303                          |
      | field_omb_number                 | 203                          |
      | field_retention_length           | 603                          |
      | field_sales_rep_email_address    | sales_rep+3@test.test        |
      | field_sec_gov_node_id            | 713                          |
      | field_support_email_address      | support+3@test.test          |
      | field_time_period_covered        | Paleogene                    |
      | field_total_annual_burden_hours  | 503                          |
      | field_vendor_name                | Mozzarella                   |
      | field_act                        | The Securities Act of 1933   |
      | field_child_data_type            | derived from                 |
      | field_externally_hosted          | Externally and Internally    |
      | field_filing_entity_type         | Broker-Dealer-Foreign        |
      | field_purchased                  | Yes                          |
      | field_submission_type            | Beneficial Ownership Reports |
      | field_ogda_access_level_rights   | heavy                        |
      | field_associated_related_dataset | BEHAT Test Dataset 2         |
      | field_completeness               | quality 3                    |
      | field_consistency                | quality consisting average   |
      | field_contract_status            | contract status 3            |
      | field_cost_category              | cost cat 3                   |
      | field_dataset_categorization     | dataset cat 3                |
      | field_data_structure             | dataset structure 3          |
      | field_delivery_frequency_to_sec  | delivery freq 3              |
      | field_fips_category_justificatio | nist type 3                  |
      | field_fips_security_classificati | fips sec 3                   |
      | field_market_sensitivity         | market sens 3                |
      | field_ocdo_classification        | ocdo class 3                 |
      | field_open_government_data_class | ogda class 3                 |
      | field_sensitive_data_category    | pii cat 3                    |
      | field_sensitivity_classification | dataset sens 3               |
      | field_timeliness_recency         | timeliness 3                 |
    Then I should see the heading "BEHAT Test Dataset 3"
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 4         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category4                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 4554                         |
      | field_number_of_active_internal_ | 3344                         |
      | field_dataset_categorization_det | Cat4                         |
      | field_dataset_name_old           | oldname4                     |
      | field_dataset_sales_rep_name     | Toad                         |
      | field_data_search_index          | keyword4                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234504                      |
      | field_number_of_licenses_assigne | 4344                         |
      | field_number_of_licenses_held    | 304                          |
      | field_omb_number                 | 204                          |
      | field_retention_length           | 604                          |
      | field_sales_rep_email_address    | sales_rep+4@test.test        |
      | field_sec_gov_node_id            | 714                          |
      | field_support_email_address      | support+4@test.test          |
      | field_time_period_covered        | Neogene                      |
      | field_total_annual_burden_hours  | 504                          |
      | field_vendor_name                | Mozzarella                   |
      | field_act                        | The Securities Act of 1934   |
      | field_child_data_type            | - Any -                      |
      | field_externally_hosted          | - Any -                      |
      | field_filing_entity_type         | Buisness Development Company |
      | field_purchased                  | No                           |
      | field_submission_type            | Exceptive Applications       |
      | field_ogda_access_level_rights   | heavy                        |
      | field_associated_related_dataset | BEHAT Test Dataset 3         |
      | field_completeness               | quality 4                    |
      | field_consistency                | quality consisting good      |
      | field_contract_status            | contract status 4            |
      | field_cost_category              | cost cat 4                   |
      | field_dataset_categorization     | dataset cat 4                |
      | field_data_structure             | dataset structure 4          |
      | field_delivery_frequency_to_sec  | delivery freq 4              |
      | field_fips_category_justificatio | nist type 4                  |
      | field_fips_security_classificati | fips sec 4                   |
      | field_market_sensitivity         | market sens 4                |
      | field_ocdo_classification        | ocdo class 4                 |
      | field_open_government_data_class | ogda class 4                 |
      | field_sensitive_data_category    | pii cat 4                    |
      | field_sensitivity_classification | dataset sens 4               |
      | field_timeliness_recency         | timeliness 4                 |
    Then I should see the heading "BEHAT Test Dataset 4"
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 5         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category5                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 4555                         |
      | field_number_of_active_internal_ | 555                          |
      | field_dataset_categorization_det | Cat5                         |
      | field_dataset_name_old           | oldname5                     |
      | field_dataset_sales_rep_name     | Yoshi                        |
      | field_data_search_index          | keyword5                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234505                      |
      | field_number_of_licenses_assigne | 4355                         |
      | field_number_of_licenses_held    | 305                          |
      | field_omb_number                 | 205                          |
      | field_retention_length           | 605                          |
      | field_sales_rep_email_address    | sales_rep+5@test.test        |
      | field_sec_gov_node_id            | 715                          |
      | field_support_email_address      | support+5@test.test          |
      | field_time_period_covered        | Quaternary                   |
      | field_total_annual_burden_hours  | 505                          |
      | field_vendor_name                | Mozzarella                   |
      | field_act                        | The Securities Act of 1935   |
      | field_child_data_type            | - Any -                      |
      | field_externally_hosted          | - Any -                      |
      | field_filing_entity_type         | Foreign Security             |
      | field_purchased                  | - Any -                      |
      | field_submission_type            | Exempt Offerings             |
      | field_ogda_access_level_rights   | heavy                        |
      | field_associated_related_dataset | BEHAT Test Dataset 4         |
      | field_completeness               | quality 5                    |
      | field_consistency                | quality consisting excellent |
      | field_contract_status            | contract status 5            |
      | field_cost_category              | cost cat 5                   |
      | field_dataset_categorization     | dataset cat 5                |
      | field_data_structure             | dataset structure 5          |
      | field_delivery_frequency_to_sec  | delivery freq 5              |
      | field_fips_category_justificatio | nist type 5                  |
      | field_fips_security_classificati | fips sec 5                   |
      | field_market_sensitivity         | market sens 5                |
      | field_ocdo_classification        | ocdo class 5                 |
      | field_open_government_data_class | ogda class 5                 |
      | field_sensitive_data_category    | pii cat 5                    |
      | field_sensitivity_classification | dataset sens 5               |
      | field_timeliness_recency         | timeliness 5                 |
    Then I should see the heading "BEHAT Test Dataset 5"
    When I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Node ID" in the "Title" row
      And I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should see the text "1234505" in the "BEHAT Test Dataset 5" row
    #Link to dataset record from Node ID (******link should open in a new tab******)
    When I click "1234501" in the "BEHAT Test Dataset 1" row
    Then the link should open in a new tab
    When I switch to window "2"
    Then I should see the text "BEHAT Test Dataset 1"
      And I close window "2"
      And I switch to window "1"
    #Filtering by 'Title'
    When I am on "/admin/dataset-dashboard"
      And I press "Filters"
      And I fill in "Title" with "bogus"
      And I press "Apply"
    Then I should see the text "There are no results."
    When I press "Filters"
      And I fill in "Title" with "dataset 1"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Search Keywords'
    When I press "Filters"
      And I fill in "Title" with ""
      And I fill in "Search Keywords" with "keyword4"
      And I press "Apply"
    Then I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Data Size'
    When I press "Filters"
      And I fill in "Search Keywords" with ""
      And I fill in "Data Size" with "4553"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Dataset Categorization Determi...'
    When I press "Filters"
      And I fill in "Data Size" with ""
      And I fill in "Dataset Categorization Determi..." with "Cat2"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Other Names Used' - will filter on BEHAT Test Dataset 5
    When I press "Filters"
      And I fill in "Dataset Categorization Determi..." with ""
      And I fill in "Other Names Used" with "oldname5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Sales Rep Name' - will filter on BEHAT Test Dataset 2 then 3
    When I press "Filters"
      And I fill in "Other Names Used" with ""
      And I fill in "Sales Rep Name" with "luigi"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    When I press "Filters"
      And I fill in "Sales Rep Name" with ""
      And I fill in "Sales Rep Name" with "Bowser"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Number of active internal end ...' - will filter on BEHAT Test Dataset 3 and 4 together
    When I press "Filters"
      And I fill in "Sales Rep Name" with ""
      And I fill in "Number of active internal end ..." with "3344"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Data Category for Landing Page Display'
    When I press "Filters"
      And I fill in "Number of active internal end ..." with ""
      And I fill in "Data Category for Landing Page..." with "category5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Number of Licenses Assigned'
    When I press "Filters"
      And I fill in "Data Category for Landing Page..." with ""
      And I fill in "Number of Licenses Assigned" with "4333"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Number of Licenses Held'
    When I press "Filters"
      And I fill in "Number of Licenses Assigned" with ""
      And I fill in "Number of Licenses Held" with "302"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'OMB Number'
    When I press "Filters"
      And I fill in "Number of Licenses Held" with ""
      And I fill in "OMB Number" with "204"
      And I press "Apply"
    Then I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Retention Length'
    When I press "Filters"
      And I fill in "OMB Number" with ""
      And I fill in "Retention Length" with "602"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Sales Rep Email'
    When I press "Filters"
      And I fill in "Retention Length" with ""
      And I fill in "Sales Rep Email" with "sales_rep+5@test.test"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'SEC.gov Node ID'
    When I press "Filters"
      And I fill in "Sales Rep Email" with ""
      And I fill in "SEC.gov Node ID" with "711"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Support Email'
    When I press "Filters"
      And I fill in "SEC.gov Node ID" with ""
      And I fill in "Support Email" with "support+3@test.test"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Time Period Covered'
    When I press "Filters"
      And I fill in "Support Email" with ""
      And I fill in "Time Period Covered" with "Cretaceous"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Total Annual Burden Hours'
    When I press "Filters"
      And I fill in "Time Period Covered" with ""
      And I fill in "Total Annual Burden Hours" with "503"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Vendor Name' - will filter on BEHAT Test Dataset 2 then all except BEHAT Test Dataset 2
    When I press "Filters"
      And I fill in "Total Annual Burden Hours" with ""
      And I fill in "Vendor Name" with "Gouda"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    When I press "Filters"
      And I fill in "Vendor Name" with ""
      And I fill in "Vendor Name" with "Mozzarella"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 2"
    #Filtering by 'Parent Dataset'
    When I press "Filters"
      And I fill in "Vendor Name" with ""
      And I fill in "Parent Dataset" with "BEHAT Test Dataset 4"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Completeness'
    When I press "Filters"
      And I fill in "Parent Dataset" with ""
      And I fill in "Completeness" with "quality 5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Consistency'
    When I press "Filters"
      And I fill in "Completeness" with ""
      And I fill in "Consistency" with "quality consisting good"
      And I press "Apply"
    Then I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Contract Status'
    When I press "Filters"
      And I fill in "Consistency" with ""
      And I fill in "Status" with "contract status 3"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Cost Category'
    When I press "Filters"
      And I fill in "Status" with ""
      And I fill in "Cost Category" with "cost cat 5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Custom Vocabulary'
    When I press "Filters"
      And I fill in "Cost Category" with ""
      And I fill in "Custom Vocabulary" with "dataset cat 1"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Data Structure'
    When I press "Filters"
      And I fill in "Custom Vocabulary" with ""
      And I fill in "Data Structure" with "dataset structure 3"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Delivery Frequency to SEC'
    When I press "Filters"
      And I fill in "Data Structure" with ""
      And I fill in "Delivery Frequency to SEC" with "delivery freq 2"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'NIST Data Type'
    When I press "Filters"
      And I fill in "Delivery Frequency to SEC" with ""
      And I fill in "NIST Data Type" with "nist type 4"
      And I press "Apply"
    Then I should see the text "1234504" in the "BEHAT Test Dataset 4" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'FIPS Security Classification'
    When I press "Filters"
      And I fill in "NIST Data Type" with ""
      And I fill in "FIPS Security Classification" with "fips sec 1"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Market Sensitivity'
    When I press "Filters"
      And I fill in "FIPS Security Classification" with ""
      And I fill in "Market Sensitivity" with "market sens 3"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'OCDO Classification'
    When I press "Filters"
      And I fill in "Market Sensitivity" with ""
      And I fill in "OCDO Classification" with "ocdo class 2"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'OPEN Government Data Act Data Asset Determination'
    When I press "Filters"
      And I fill in "OCDO Classification" with ""
      And I fill in "OPEN Government Data Act Data ..." with "ogda class 5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'PII Category'
    When I press "Filters"
      And I fill in "OPEN Government Data Act Data ..." with ""
      And I fill in "PII Category" with "pii cat 3"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Dataset Risk Category'
    When I press "Filters"
      And I fill in "PII Category" with ""
      And I fill in "Dataset Risk Category" with "dataset sens 2"
      And I press "Apply"
    Then I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Timeliness/Recency'
    When I press "Filters"
      And I fill in "Dataset Risk Category" with ""
      And I fill in "Timeliness/Recency" with "timeliness 5"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Act'
    When I press "Filters"
      And I fill in "Timeliness/Recency" with ""
      And I select "The Securities Act of 1933" from "Act"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'This dataset is'
    When I press "Filters"
      And I select "- Any -" from "Act"
      And I select "a subset of" from "This dataset is"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Externally or Internally Hosted'
    When I press "Filters"
      And I select "- Any -" from "This dataset is"
      And I select "Externally" from "Externally or Internally Hosted"
      And I press "Apply"
    Then I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Filing Entity Type'
    When I press "Filters"
      And I select "- Any -" from "Externally or Internally Hosted"
      And I select "Foreign Security" from "Filing Entity Type"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
    #Filtering by 'Purchased'
    When I press "Filters"
      And I select "- Any -" from "Filing Entity Type"
      And I select "Yes" from "Purchased"
      And I press "Apply"
    Then I should see the text "1234503" in the "BEHAT Test Dataset 3" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 4"
      And I should not see the text "BEHAT Test Dataset 5"
    #Filtering by 'Submission Type'
    When I press "Filters"
      And I select "- Any -" from "Purchased"
      And I select "Exempt Offerings" from "Submission Type"
      And I press "Apply"
    Then I should see the text "1234505" in the "BEHAT Test Dataset 5" row
      And I should not see the text "BEHAT Test Dataset 1"
      And I should not see the text "BEHAT Test Dataset 2"
      And I should not see the text "BEHAT Test Dataset 3"
      And I should not see the text "BEHAT Test Dataset 4"
      And I press "Filters"
      And I select "- Any -" from "Submission Type"
      And I press "Apply"
    #Test Sorting Descending
    When I select "DESC" from "Sort By"
      And I press "Apply"
    Then "BEHAT Test Dataset 2" should precede "BEHAT Test Dataset 1" for the query "//td[contains(@data-field, 'title')]"
    #Test Sort Ascending
    When I select "ASC" from "Sort By"
      And I press "Apply"
    Then "BEHAT Test Dataset 1" should precede "BEHAT Test Dataset 2" for the query "//td[contains(@data-field, 'title')]"

  @api @javascript
  Scenario: Selectively configure columns to display fields on Metadata Dashboard table
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 455                          |
      | field_number_of_active_internal_ | 755                          |
      | field_dataset_categorization_det | Cat1                         |
      | field_dataset_name_old           | oldname1                     |
      | field_dataset_sales_rep_name     | Mario                        |
      | field_data_search_index          | keyword1                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
    Then I should see the heading "BEHAT Test Dataset 1"
    When I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Fields to Display" in the "metadata_db_display_opt" region
    #Adding fields to display
    When I chosen-select "#edit-display-fields" with "field_data_size_in_gb,field_dataset_categorization_det,field_number_of_active_internal_,field_dataset_name_old,field_dataset_sales_rep_name,field_data_search_index"
      #Verifying selections in 'fields to display' field
      And I should see "Data Size" in the "#edit_display_fields_chosen" element
      And I should see "Dataset Categorization Determination" in the "#edit_display_fields_chosen" element
      And I should see "Number of active internal end users" in the "#edit_display_fields_chosen" element
      And I should see "Other Names Used" in the "#edit_display_fields_chosen" element
      And I should see "Sales Rep Name" in the "#edit_display_fields_chosen" element
      And I should see "Search Keywords" in the "#edit_display_fields_chosen" element
    #Verifying fields and values display on dashboard table
    When I press "Apply"
    Then I should see the text "Node ID" in the "Title" row
      And I should see the text "Data Size" in the "Node ID" row
      And I should see the text "Dataset Categorization Determination" in the "Node ID" row
      And I should see the text "Number of active internal end users" in the "Node ID" row
      And I should see the text "Other Names Used" in the "Node ID" row
      And I should see the text "Sales Rep Name" in the "Node ID" row
      And I should see the text "Search Keywords" in the "Node ID" row
      And I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should see the text "455" in the "1234501" row
      And I should see the text "Cat1" in the "1234501" row
      And I should see the text "755" in the "1234501" row
      And I should see the text "oldname1" in the "1234501" row
      And I should see the text "Mario" in the "1234501" row
      And I should see the text "keyword1" in the "1234501" row
    #Removing 'Data Size' field from fields to display
    When I click on the element with css selector "#edit_display_fields_chosen > ul > li:nth-child(1) > a"
    Then I should not see "Data Size" in the "#edit_display_fields_chosen" element
    #Verifying field and value does not display on dashboard table
    When I press "Apply"
    Then I should not see the text "Data Size" in the "Node ID" row
      And I should not see the text "455" in the "1234501" row

  @api @javascript
  Scenario: Group Filters based on Metadata Metadata - list of columns displayed based on the Metadata Group term
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
    Then I should see the heading "BEHAT Test Dataset 1"
    When I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Display Metadata Groups" in the "metadata_db_display_opt" region
      And I chosen-select "#edit-metadata-display-fields" with "999999"
    When I press "Apply"
    Then I should see "OG" in the "#edit_metadata_display_fields_chosen" element
      And I should see the text "Owner" in the "Node ID" row
      And I should see the text "new division" in the "1234501" row

  @api @javascript
  Scenario: Selectively interact with cells in the table to edit the values and submit
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 455                          |
      | field_number_of_active_internal_ | 755                          |
      | field_dataset_categorization_det | Cat1                         |
      | field_dataset_name_old           | oldname1                     |
      | field_dataset_sales_rep_name     | Mario                        |
      | field_data_search_index          | keyword1                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
    Then I should see the heading "BEHAT Test Dataset 1"
      And I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 2         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_data_size_in_gb            | 455                          |
      | field_number_of_active_internal_ | 756                          |
      | field_dataset_categorization_det | Cat2                         |
      | field_dataset_name_old           | oldname2                     |
      | field_dataset_sales_rep_name     | Luigi                        |
      | field_data_search_index          | keyword2                     |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234502                      |
    Then I should see the heading "BEHAT Test Dataset 2"
    When I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Node ID" in the "Title" row
      And I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I should see the text "1234502" in the "BEHAT Test Dataset 2" row
      #Adding fields to display
    When I chosen-select "#edit-display-fields" with "field_data_size_in_gb,field_dataset_categorization_det,field_number_of_active_internal_,field_dataset_name_old,field_dataset_sales_rep_name,field_data_search_index"
      And I press "Apply"
    # Edit some fileds on 1st dataset for an unpublished revision ("Save and Review")
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.odd > td:nth-child(2)"
      And I fill element ".dataset-column.on-focus input" with "BEHAT Test Dataset 1-updated"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(3)"
      And I fill element ".dataset-column.on-focus input" with "555"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(4)"
      And I fill element ".dataset-column.on-focus input" with "Cat1-updated"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(5)"
      And I fill element ".dataset-column.on-focus input" with "1055"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(6)"
      And I fill element ".dataset-column.on-focus input" with "oldname1-updated"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(7)"
      And I fill element ".dataset-column.on-focus input" with "Super Mario"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr > td:nth-child(8)"
      And I fill element ".dataset-column.on-focus input" with "keyword1-updated"
    #"Save and Review" option shows node id on dashboard with (*) asterisk indicating an unpublished revision
    When I click on the element with css selector "#dataset-dashboard-container > div.my-2 > select > option:nth-child(1)"
      And I press "Save Changes"
    Then I should see the text "Following Datasets have been saved: BEHAT Test Dataset 1-updated (1234501)"
      And I should see the link "1234501 *" in the "metadata_db_table" region
      And I should see the text "455" in the "1234501 *" row
      And I should see the text "Cat1" in the "1234501 *" row
      And I should see the text "755" in the "1234501 *" row
      And I should see the text "oldname1" in the "1234501 *" row
      And I should see the text "Mario" in the "1234501 *" row
      And I should see the text "keyword1" in the "1234501 *" row
    # Edit some fields on 2nd dataset for publishing these changes ("Save and Publish")
    When I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even > td:nth-child(2)"
      And I fill element ".dataset-column.on-focus input" with "BEHAT Test Dataset 2-published"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(3)"
      And I fill element ".dataset-column.on-focus input" with "4566"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(4)"
      And I fill element ".dataset-column.on-focus input" with "Cat2-published"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(5)"
      And I fill element ".dataset-column.on-focus input" with "7566"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(6)"
      And I fill element ".dataset-column.on-focus input" with "oldname2-published"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(7)"
      And I fill element ".dataset-column.on-focus input" with "Luigi-published"
      And I click on the element with css selector "#dataset-dashboard-table > tbody > tr.dataset-row.even.edited > td:nth-child(8)"
      And I fill element ".dataset-column.on-focus input" with "keyword2-published"
    #"Save and Publish" option shows node id on dashboard WITHOUT (*) asterisk indicating changes are published
    When I click on the element with css selector "#dataset-dashboard-container > div.mb-2.mt-4 > select > option:nth-child(2)"
    When I press "Save Changes"
    Then I should see the text "Following Datasets have been saved: BEHAT Test Dataset 2-published (1234502)"
      And I should see the link "1234502" in the "metadata_db_table" region
      And I should see the text "4566" in the "1234502" row
      And I should see the text "Cat2-published" in the "1234502" row
      And I should see the text "7566" in the "1234502" row
      And I should see the text "oldname2-published" in the "1234502" row
      And I should see the text "Luigi-published" in the "1234502" row
      And I should see the text "keyword2-published" in the "1234502" row

  @api @javascript
  Scenario: Verify Metadata Dashboard Help Texts
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
    When I press "How To Use The Dashboard"
    Then I should see the text 'Step 1: Select Fields and Datasets to Edit'
      And I should see the text 'Expand the "Display Options"'
      And I should see the text 'Select fields to edit from the "Fields to Display" dropdown OR from the “Metadata Groups” dropdown. Do not use a combination of these options.'
      And I should see the text "Metadata Groups will return groupings of related fields based on frequent need."
      And I should see the text "The Title and Node ID columns are displayed by default."
      And I should see the text 'Expand the "Filters"'
      And I should see the text 'To restrict the datasets displayed in the dashboard, enter filter criteria into one or more of the fields. If you enter criteria in more than one field, the dashboard will return results where all criteria are met.'
      And I should see the text 'Text fields use a partial match to filter (e.g. "FINR" returns datasets containing FINRA).'
      And I should see the text 'To filter based on empty values, enter "<blank>" in the desired field.'
      And I should see the text 'Click "Apply" to populate the dashboard based on selections above.'
      And I should see the text 'Step 2: Edit Values'
      And I should see the text "To edit a value, click inside the cell and make changes. Node ID cannot be edited."
      And I should see the text 'Once all changes have been made, select “Save and Review” to save all changes as unpublished (i.e. "Latest Version") and to initiate the review workflow.'
      And I should see the text 'Users who are Content Approvers can choose to “Save and Publish” to directly publish the edited values. USE THIS OPTION WITH CARE.'
      And I should see the text 'If you leave the dashboard without saving, your changes will be lost.'
      And I should see the text 'Contact the Catalog@sec.gov if you have questions. If you would like to propose a metadata grouping, or if the fields you would like to edit are not available.'
      And I should see the text "Rows (*) highlighted in red have an unpublished revision."
      And I should see the text "Rows (**) highlighted in blue are unpublished."
