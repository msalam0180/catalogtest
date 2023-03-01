Feature: Create Dataset Content For WDIO
  As a Content Creator, I should be able to create Application page.

  Background:
    Given users:
      | name     | mail               | pass | roles            |
      | ca2      | approver@test.com  | ca2  | Content Approver |
      | auth     | auth@test.com      | auth |                  |
      | approver | approver2@test.com | ca2  | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      | division2    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      | private  |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | Public   |          |
      | DAaccess |          |
      | DAAchild | DAaccess |
      And "open_government_data_act_classif" terms:
      | name             |
      | PD Asset         |
      | DAclassification |
      And "sensitive_data_category" terms:
      | name  |
      | nopii |
      And "status" terms:
      | name           |
      | BEHAT Retire   |
      | BEHAT Approval |
      And "application_status" terms:
      | name       |
      | App Status |
      And "open_government_data_asset_compl" terms:
      | name             |
      | Machine readable |
      | Open license     |
      And "controlled_unclassified_informat" terms:
      | name       |
      | test term1 |
      | test term2 |
      And "data" terms:
      | name       |
      | automation |
      And "dataset_categorization" terms:
      | name  |
      | evian |

  @ui @api @javascript @wdio
  Scenario: Add Related Application and Platform and Software To A Dataset for WDIO
    Given "application" content:
      | title              | body       | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | some-body1 | summary1      | published        | approver       |
      And "platform" content:
      | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | BEHAT Platform0 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
      And "component" content:
      | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | BEHAT Software1 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
    #Create Dataset
    When I am logged in as a user with the "Content Approver" role
      And I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Component Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "Public" from "OPEN Government Data Act Access Level Level 0"
      And I wait for ajax to finish
      And I select "PD Asset" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I wait for ajax to finish
    #Add application relationship
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      #Add platform relationship
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Platform0" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      #Add software relationship
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Software1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      And I select "Published" from "Change to"
      And I press "Apply"
      And I wait for ajax to finish
    #Screenshots of relationships between Technologies and Dataset
    Then I take a screenshot using "dataset.feature" file with "@tech_to_dataset" tag
      And I take a screenshot using "dataset.feature" file with "@breadcrumb" tag
      And I take a screenshot using "dataset.feature" file with "@application_to_dataset" tag
      And I take a screenshot using "dataset.feature" file with "@platform_to_dataset" tag
      And I take a screenshot using "dataset.feature" file with "@software_to_dataset" tag

  @ui @api @javascript @wdio
  Scenario: Division And Office On Dataset For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And "division_office" terms:
      | name      |
      | division1 |
      And "data_set" content:
      | title    | field_dataset_description  | field_dataset_source_type | moderation_state | field_divisions_offices |
      | Dataset1 | description about dataset1 | SEC                       | published        | division1               |
    Then I take a screenshot using "dataset.feature" file with "@dataset_DI" tag

  @ui @api @javascript @wdio
  Scenario: Add Contact To A Dataset For WDIO
    Given "roles" terms:
      | name       |
      | BEHAT Role |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Contact"
      And I type "BEHAT Component Description" in the "Description" WYSIWYG editor
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Add new Contact"
      And I wait for ajax to finish
      And I fill in "First Name" with "fname"
      And I fill in "Last Name" with "lname"
      And I fill in "Email" with "email@uio.com"
      And I select "BEHAT Role" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "dataset.feature" file with "@dataset_contact" tag

  @ui @api @javascript @wdio
  Scenario: Manually Add General And Access And Use Tab For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "division_office" terms:
        | name         |
        | division1    |
        | new division |
        | behat DO     |
      And "data_category" terms:
        | name      |
        | category1 |
      And "cost_category" terms:
        | name   |
        | Term 1 |
      And "tags" terms:
        | name |
        | tags |
      And "open_government_data_act_classif" terms:
        | name             |
        | DAclassification |
      And "open_government_data_act_access" terms:
        | name     |
        | DAaccess |
      And "sensitivity_classification" terms:
        | name      |
        | Deer park |
      And "tools" content:
        | title           | body         | field_tool_category | moderation_state |
        | DataSystem Tool | this is tool | Data Systems        | published        |
      And "data_insight" content:
        | title          | body             | moderation_state |
        | BEHAt Insight1 | This is the body | published        |
      And "data_set" content:
        | title                 | field_dataset_description | field_dataset_description | field_insights | field_division_office_multi | field_data_size_in_gb | field_delivery_method_to_sec | field_delivery_frequency_to_sec | field_externally_hosted | field_dataset_source_type | field_tools     | field_how_to_request_access | moderation_state | field_owner  | field_reviewer | field_open_government_data_class | field_open_government_data_acces | field_average_ingestion_volume | field_date_acquired | field_dataset_registrant_type | field_dataset_asset_category | field_dataset_use | field_dataset_name_old | field_date_acquired | field_contract_status | field_dataset_date_archive | field_omb_number | field_filing_format | field_time_period_covered | field_ocdo_classification | field_summary | field_data_category | field_tags | field_sensitivity_classification | field_how_to_access_this_dataset | field_dataset_path | field_notes_regarding_permission | field_number_of_licenses_held | field_number_of_licenses_assigne | field_total_annual_burden_hours | field_annual_burden | field_submission_type     | field_filing_entity_type | field_act                  | field_attribution_statement | field_related_data_insights | field_completeness | field_consistency | field_timeliness_recency | field_sensitive_data_category | field_market_sensitivity | field_sensitive_pii | field_fips_security_classificati | field_fips_category_justificatio | field_data_structure | field_number_of_active_internal_ | field_cost_category | field_vendor_name | field_dataset_vendor_www | field_support_phone_number | field_support_email_address | field_dataset_sales_rep_name | field_sales_rep_phone_number | field_sales_rep_email_address | field_dataset_category | field_license_types |
        | Behat General-Dataset | some description          | description               | further descr  | division1                   | 120                   | CD                           | Monthly                         | Internally              | FINRA                     | DataSystem Tool | '' - http://test.com        | published        | new division | approver       | DAclassification                 | DAaccess                         | 11.1                           | 1/2/1980            | The Public                    | Equity                       | automation        | other                  | 3/5/1234            | Active                | 6/7/1788                   | OMB Number       | paper               | Time Periond              | Dataset                   | short         | category1           | tags       | Deer park                        | Send a note                      | dataset location   | notes on permissions             | 12345                         | 5423424                          | 890234                          | 689345              | Accounting Certifications | Beneficial owner         | The Securities Act of 1933 | attribute                   | BEHAt Insight1              | High               | Low               | Low                      | Other PII                     |  No MNPI present         | Yes                 | Low                              | Financial Sector Oversight       | Structured           | 15                               | Term 1              | vendor name       | vendor link              |  12345789                  | test@test.test              | Sales Name                   | 123423423                    | Sales@Sales.sale              | Enforcement            | Other               |
    When I am on "/datasets/behat-general-dataset/edit"
      And I click "Access & Use"
      And I press "Add Licenses Held by Division/Office"
      And I wait for ajax to finish
      And I select "behat DO" from "Division/Office"
      And I fill in "Licenses Held" with "50"
      And I select "Limited" from "License Type"
      And I fill in "License Notes" with "Notes Goes here"
      And I fill in "Visit Dataset Link" with "http://webdriver.io/"
      And I fill in "Data Path (value 2)" with "SEC Location2"
      And I select "test term1" from "Controlled Unclassified Information (CUI) Category"
      And I check "Restricted Dataset"
      And I select "Enterprise" from "License Types" for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I take a screenshot using "dataset.feature" file with "@dataset_allaccess" tag

@ui @api @javascript @wdio
  Scenario: Manually Add General And Governance Tab For WDIO
    Given I am logged in as a user with the "Content Approver" role
      And "data_structure" terms:
        | name         |
        | BEHAT struct |
      And "cost_category" terms:
        | name                |
        | BEHAT cost category |
      And "quality_completeness" terms:
        | name      |
        | BEHAT QCT |
      And "quality_consistency" terms:
        | name      |
        | BEHAT QCO |
      And "quality_timeliness_recency" terms:
        | name      |
        | BEHAT QCR |
      And "market_sensitivity" terms:
        | name         |
        | behat market |
      And "cost_type" terms:
        | name            |
        | behat cost type |
      And "mission_criticality_mefs_" terms:
        | name          |
        | behat Mission |
      And "fips_category_justification" terms:
        | name         |
        | behat justif |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I fill in "DAUISP Data Policies" with "http://example.com"
      And I fill in "DAUISP Audit Logs" with "http://google.com"
      And I fill in "Dataset Categorization Determination" with "This is any free-text for dataset categorization"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAAchild" from "OPEN Government Data Act Access Level Level 1"
      And I fill in "OPEN Government Data Act Access Level Rights" with "This is a test for Access Level"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "Open license" from "OPEN Government Data Asset Compliance (value 1) Level 0"
      And I fill in "SEC.gov Node ID" with "98765"
      And I select "Other PII" from "PII Category"
      And I select "behat market" from "Market Sensitivity Level 0"
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I select "division2" from "Division/Office"
      And I select "behat Mission" from "Mission Criticality Rating"
      And I select "BEHAT struct" from "Data Structure Level 0"
      And I select "BEHAT QCT" from "Completeness Level 0"
      And I select "BEHAT QCO" from "Consistency Level 0"
      And I select "BEHAT QCR" from "Timeliness/Recency Level 0"
      And I fill in "Number of active internal end users" with "5173"
      And I fill in "Retention Length" with "1024 hrs"
      And I select "behat justif" from "NIST Data Type"
      And I select "evian" from "Custom Vocabulary"
      And I select "No" from "Purchased"
      And I check "License Restrictions"
      And I fill in "eFile Contract Link" with "http://test.com"
      And I select "BEHAT cost category" from "Cost Category"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I fill in "Year" with "1900"
      And I select "behat cost type" from "Type"
      And I fill in "Amount" with "1389.45"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "dataset.feature" file with "@dataset_governance" tag

  @ui @api @javascript @wdio
  Scenario: Data Category Filter For Dataset WDIO Search Page
    Given I am logged in as a user with the "Content Approver" role
      And "tags" terms:
      | name         |
      | atlas        |
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
      | title              | body         | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | description1 | summary1      | published        | approver       |
      And "data_set" content:
      | title      | field_dataset_description | moderation_state | field_data_category | field_tags |  field_dataset_source_type | field_reviewer |
      | Data.Set10 |                           | published        | Analytical Data     | atlas      | SRO                        | approver       |
      | DATASET 30 | description               | published        | Internal Data       |            |                            | approver       |
      | DATASET 32 |                           | published        | Operational Data    |            |                            |                |
      And I run cron
    When I am on "/datasets/DATASET-30/edit"
      And I select "new division" from "Owner"
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
      And I fill in "Name" with " Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait 20 seconds
      And I select "Article" from "field_documents[form][inline_entity_form][field_document_category]"
      And I fill in "Description" with "Test" in the "form_area"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "Document Category"
      And I press "Save"
    Then I take a screenshot using "dataset.feature" file with "@dataset_search_page" tag

  @ui @api @javascript @wdio
  Scenario: Dataset Link To Application
    Given I am logged in as a user with the "Content Approver" role
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "data_category" terms:
      | name      |
      | category1 |
      And "application" content:
      | title              | body         | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | description1 | summary1      | published        | approver       |
      And "data_set" content:
      | title      | field_dataset_description | moderation_state | field_reviewer |
      | DATASET 30 | description               | published        | approver       |
    When I am on "/datasets/DATASET-30/edit"
      And I select "new division" from "Owner"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I press "Save"
    Then I take a screenshot using "dataset.feature" file with "@dataset_app" tag

  @ui @api @javascript @wdio
  Scenario: Dataset Link To Data Insight
    Given I am logged in as a user with the "Content Approver" role
      And "data_insight" content:
      | title          | body             | moderation_state |
      | BEHAt Insight1 | This is the body | published        |
      And "data_set" content:
      | title               | moderation_state | field_related_data_insights |
      | BEHAT Dataset Title | published        | BEHAt Insight1              |
    Then I take a screenshot using "dataset.feature" file with "@dataset_di" tag

  @ui @api @javascript @wdio
  Scenario: Dataset Link To Dataset
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
      | title          | moderation_state | field_dataset_related_datasets |
      | Dataset Title1 | published        |                                |
      | Dataset Title2 | published        | Dataset Title1                 |
    Then I take a screenshot using "dataset.feature" file with "@dataset_dataset" tag

  @ui @api @wdio
  Scenario: Creating Tags On A Dataset
    Given "tags" terms:
      | name      |
      | Monday    |
      | Tuesday   |
      | Wednesday |
      | Thursday  |
      | Friday    |
      | Saturday  |
      | Sunday    |
      | January   |
      | February  |
      | March     |
    When I am viewing a "data_set":
      | title                            | BEHAT Test Data Set                                                                      |
      | field_time_period_covered        | Time Period                                                                              |
      | field_dataset_description        | Focus on wrap-around tags                                                                |
      | moderation_state                 | published                                                                                |
      | field_tags                       | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, January, February, March |
    Then I take a screenshot using "dataset.feature" file with "@dataset_tags" tag

  @ui @api @wdio @javascript
  Scenario: Add Related Reports & Statistics To Datasets WDIO
    Given "statistics" content:
      | title            | field_summary | body                     | field_r_and_s_category | moderation_state | field_reviewer |
      | Behat Report     | behat short   | Testing Behat Report     | REPORTS                | published        | approver       |
      | Behat Statistics | Short stat    | Testing Behat Statistics | Statistics             | published        | approver       |
      And "data_insight" content:
      | title         | field_summary | body             | moderation_state |
      | Behat Insight | behat short   | This is the body | published        |
      And "data_set" content:
      | title         | field_summary       | field_dataset_description | field_reviewer | moderation_state | field_owner  | field_division_office_multi | field_data_category | field_related_data_insights | open_government_data_act_interna | field_open_government_data_acces | field_open_government_data_class |
      | BEHAT Dataset | BEHAT Short Summary | Dataset 10 description    | approver       | published        | new division | division1                   | category1           | BEHAt Insight               | private                          | DAaccess                         | DAclassification                 |
    When I am logged in as a user with the "Content Approver" role
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I select the first autocomplete option for "Behat Report" on the "Related Reports & Statistics" field in the "datasets_related_reports_stats" region
      And I press "Add another item" in the "datasets_related_reports_stats" region
      And I fill in "Related Reports & Statistics (value 2)" with "Behat Statistics"
      And I press "Save"
    Then I take a screenshot using "dataset.feature" file with "@dataset_rs" tag

  @ui @api @wdio @javascript
  Scenario: Add Dataset With Request Access Button WDIO
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Request Access Dataset"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "dataset.feature" file with "@requestaccess_dataset" tag

  @ui @api @wdio @javascript
  Scenario: Dataset With Visit Link And Request Access Button WDIO
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Request And Visit Link Dataset"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Visit Dataset Link" with "http://webdriver.io/"
      And I fill in "Request Access URL" with "http://test.com"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I take a screenshot using "dataset.feature" file with "@requestvisit_dataset" tag
