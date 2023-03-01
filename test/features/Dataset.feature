Feature: Create, Edit and Delete A Dataset
  As a content creator
  I want to be able to create new Datasets
  So that visitors to the site can learn about all the datasets that the SEC has to offer

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
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
      And "open_government_data_act_interna" terms:
        | name    | parent  |
        | private |         |
        | strong  | private |
      And "open_government_data_act_access" terms:
        | name     | parent   |
        | DAaccess |          |
        | DAAchild | DAaccess |
      And "open_government_data_act_classif" terms:
        | name             |
        | DAclassification |
      And "open_government_data_asset_compl" terms:
        | name             |
        | Machine readable |
        | Open license     |
      And "controlled_unclassified_informat" terms:
        | name   |
        | term a |
        | term b |
      And "sensitive_data_category" terms:
        | name  |
        | nopii |
      And "status" terms:
        | name           |
        | BEHAT Retire   |
        | BEHAT Approval |
      And "data" terms:
        | name       | parent     |
        | automation |            |
        | scripting  | automation |
      And "sensitivity_classification" terms:
        | name               |
        | very sensitive     |
        | somewhat sensitive |
      And "fips_security_classification" terms:
        | name   |
        | boring |
      And "annual_filings_type" terms:
        | name   |
        | pigeon |

  @api @javascript
  Scenario: Verify Content Creator Creating A Basic Dataset
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Access & Use"
      And I select "boring" from "FIPS Security Classification"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "private" from "Associated Inventories (value 1) Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "Draft"
      And I should see the text "BEHAT Dataset Description"
      And I should see the link "new division"
      And I should see the link "division1"
      And I should see the heading "Other Categorizations"
      And I should see the text "Associated Inventories"
      And I should see the link "private"
      And I should not see the text "FIPS Security Classification"
      And I should not see the text "boring"

  @api @javascript
  Scenario Outline: Verify Authorized Roles Creating A Basic Dataset
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Access & Use"
      And I select "boring" from "FIPS Security Classification"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "private" from "Associated Inventories (value 1) Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "BEHAT Dataset Description"
      And I click "Governance" in the "horizotal_tabs" region
      And I should see the link "new division"
      And I should see the link "division1"
      And I should see the heading "Other Categorizations"
      And I should see the text "Associated Inventories"
      And I should see the link "private"
      And I should not see the text "FIPS Security Classification"
      And I should not see the text "boring"

      Examples:
        | role             |
        | Content Approver |
        | sitebuilder      |

  @api @javascript
  Scenario: Verify Dataset General Tab
    Given I am logged in as a user with the "Content Creator" role
      And "tags" terms:
        | name       |
        | BEHAT tags |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I type "Further Details -text" in the "Further Details" WYSIWYG editor
      And I fill in "Time Period Covered" with "5days"
      And I select "Daily" from "Delivery Frequency to SEC"
      And I select "CD" from "Delivery Method to SEC" for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I click on the element with css selector "input[id^='edit-field-division-office-multi-add-more']"
      And I wait for ajax to finish
      And I select "division2" from "Divisions/Offices that use this " for the "1" option of the "2" row
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I fill in "Data Size" with "25"
      And I fill in "field_dataset_last_load_time[0][value][date]" with "11/28/2019"
      And I fill in "field_dataset_last_load_time[0][value][time]" with "12:22:30PM"
      And I select "SEC" from "Source" for the "1" option of the "1" row
      And I select "SEC/Edgar" from "Source" for the "2" option of the "1" row
      And I fill in "Average Ingestion Volume" with "1000"
      And I select "Externally and Internally" from "Externally or Internally Hosted"
      And I select "Regulated Entities" from "Entity Type" for the "1" option of the "1" row
      And I select "Auditors" from "Entity Type" for the "2" option of the "1" row
      And I select "Derivatives" from "Asset Type" for the "1" option of the "1" row
      And I select "Commodity" from "Asset Type" for the "2" option of the "1" row
      And I select "Corporate Information" from "Data Type" for the "1" option of the "1" row
      And I select "Forecasts & Estimates" from "Data Type" for the "2" option of the "1" row
      And I select "automation" from "Use Cases" for the "1" option of the "1" row
      And I select "scripting" from "Use Cases" for the "2" option of the "1" row
      And I fill in "edit-field-date-acquired-0-value-date" with "07/28/2019"
      And I select "Terminated - no perpetual rights to data" from "Status"
      And I fill in "Other Names Used" with "Another Name"
      And I fill in "edit-field-dataset-date-archive-0-value-date" with "08/28/2019"
      And I select the autocomplete option for "BEHAT tags" on the "Tags" field
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "private" from "Associated Inventories (value 1) Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I fill in "Notes" with "These are just some plain text general notes that will be hidden on view page"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "BEHAT Dataset Description"
      And I should see the text "Further Details -text"
      And I should see the text "5days"
      And I should see the link "new division"
      And I should see the link "division1"
      And I should see the link "division2"
      And I should see the text "Daily"
      And I should see the text "CD"
      And I should see the text "∼25GB"
      And I should see the text "Last Load Time"
      And I should see "Thu, 11/28/2019 - 12:22"
      And I should see the link "SEC/Edgar"
      And I should see the text "Externally and Internally"
      And I should not see "Regulated Entities"
      And I should see the link "Auditors"
      And I should see the link "Commodity"
      And I should see the link "Forecasts & Estimates"
      And I should see the link "scripting"
      And I should see the text "07/28/2019"
      And I should see the text "Terminated - no perpetual rights to data"
      And I should see the text "Another Name"
      And I should see the text "08/28/2019"
      And I should not see the text "These are just some plain text general notes that will be hidden on view page"

  @api @javascript
  Scenario: Verify Dataset Access & Use Tab
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Visit Dataset Link" with "http://webdriver.io/"
      And I fill in "Request Access URL" with "http://test.com"
      And I type "Send a note" in the "Dataset Access Details" WYSIWYG editor
      And I fill in "Data Path" with "SEC Location1"
      And I click on the element with css selector "#edit-field-dataset-path-add-more"
      And I fill in "Data Path (value 2)" with "SEC Location2"
      And I select "very sensitive" from "Dataset Risk Category"
      And I select "term b" from "Controlled Unclassified Information (CUI) Category"
      And I select "boring" from "FIPS Security Classification"
      And I check "Restricted Dataset"
      And I type "BEHAT Permission notes" in the "Permissions and Usage" WYSIWYG editor
      And I fill in "Attribution Statement" with "This is Attribution Statement"
      And I select "Enterprise" from "License Types" for the "1" option of the "1" row
      And I fill in "Number of Licenses Held" with "6"
      And I press "Add Licenses Held by Division/Office"
      And I wait for ajax to finish
      And I select "DERA" from "Division/Office"
      And I fill in "Licenses Held" with "50"
      And I select "Limited" from "License Type"
      And I fill in "License Notes" with "Notes Goes here"
      And I fill in "Number of Licenses Assigned" with "3"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "BEHAT Dataset Description"
      And I should see the link "Visit Dataset"
      And I should see the link "Request Access"
      And I should see the text "Dataset Access Details"
      And I should see the text "Send a note"
      And I should see the text "Data Path"
      And I should see the text "SEC Location1"
      And I should see the text "SEC Location2"
      And I should see the text "Dataset Risk Category"
      And I should see the text "very sensitive"
      And I should see the text "Controlled Unclassified Information (CUI) Category"
      And I should see the text "term b"
      And I should not see the text "FIPS Security Classification"
      And I should not see the text "boring"
      And I should not see the text "Restricted"
      And I should see the text "Permissions and Usage"
      And I should see the text "BEHAT Permission notes"
      And I should see the text "Attribution Statement"
      And I should see the text "This is Attribution Statement"
      And I should see the text "License Types"
      And I should see the text "Enterprise"
      And I should see the text "Number of Licenses Held"
      And I should see the text "6"
      And I should see the text "Licenses Held by Division/Office"
      And I should see the text "DERA"
      And I should see the text "50"
      And I should see the text "Limited"
      And I should see the text "Notes Goes here"
      And I should see the text "Number of Licenses Assigned"
      And I should see the text "3"

  @api @javascript
  Scenario: Verify Dataset Form Tab
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click on the element with css selector "a[href='#edit-group-form']"
      And I fill in "OMB Number" with "987"
      And I select "Electronic" from "Filing Format"
      And I press "Add Total Annual Filings"
      And I wait for ajax to finish
      And I fill in "Year" with "2000"
      And I select "pigeon" from "Type"
      And I fill in "Number of Filings Received" with "87000"
      And I fill in "Annual Burden" with "3452124"
      And I fill in "Total Annual Burden" with "146"
      And I select "Form" from "Submission Type"
      And I select "Issuer" from "Filing Entity Type"
      And I select "The Securities Act of 1933" from "Act"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "BEHAT Dataset Description"
      And I should see the text "OMB Number"
      And I should see the text "987"
      And I should see the text "Filing Format"
      And I should see the text "pigeon"
      And I should see the text "Total Annual Filings"
      And I should see the text "2000"
      And I should see the text "Electronic"
      And I should see the text "87,000"
      And I should see the text "Filings"
      And I should see the text "Annual Burden"
      And I should see the text "$3,452,124.00"
      And I should see the text "Total Annual Burden Hours"
      And I should see the text "146"
      And I should see the text "Submission Type"
      And I should see the text "Form"
      And I should see the text "Filing Entity Type"
      And I should see the text "Issuer"
      And I should see the text "The Securities Act of 1933"

  @api @javascript
  Scenario: Verify Dataset Vendor Tab
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Vendor"
      And I fill in "Vendor Name" with "Vendor Business Name"
      And I fill in "edit-field-vendor-website-0-uri" with "/testurl"
      And I fill in "edit-field-vendor-website-0-title" with "testurllink"
      And I fill in "Support Phone" with "1235678990"
      And I fill in "Support Email" with "vendor@gmail.com"
      And I fill in "Sales Rep Name" with "Sales Person"
      And I fill in "Sales Rep Phone" with "1234567889"
      And I fill in "Sales Rep Email" with "salesrep@gmail.com"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the text "Vendor Name"
      And I should see the text "Vendor Business Name"
      And I should see the text "Vendor Website"
      And I should see the link "testurllink"
      And I should see the text "Support Phone"
      And I should see the text "1235678990"
      And I should see the text "Support Email"
      And I should see the link "vendor@gmail.com"
      And I should see the text "Sales Rep Name"
      And I should see the text "Sales Person"
      And I should see the text "Sales Rep Phone"
      And I should see the text "1234567889"
      And I should see the text "Sales Rep Email"
      And I should see the link "salesrep@gmail.com"

  @api @javascript
  Scenario: Verify Dataset Governance Tab
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
      And "data_collection_type" terms:
        | name     | parent |
        | hand     |        |
        | scissors | hand   |
      And "dataset_categorization" terms:
        | name    |
        | strange |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Governance"
      And I should see the text "SEC Data Policies"
      And I select "new division" from "Owner"
      And I fill in "DAUISP Data Policies" with "http://example.com"
      And I fill in "DAUISP Audit Logs" with "http://google.com"
      And I fill in "Dataset Categorization Determination" with "Category dataset"
      And I should see the text "Open Government Data Act" in the "ogda" region
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I fill in "OPEN Government Data Act Access Level Rights" with "This is a test for Access Level"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "Machine readable" from "OPEN Government Data Asset Compliance" for the "1" option of the "1" row
      And I fill in "OGDA Determination Notes" with "These are just some plain text OGDA notes that will be hidden on view page"
      And I should see the text "Risk & Sensitivity"
      And I select "Other PII" from "PII Category"
      And I select "behat market" from "Market Sensitivity Level 0"
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I select "new division" from "Division/Office"
      And I select "behat Mission" from "Mission Criticality Rating"
      And I should see the text "Data Characteristics"
      And I select "BEHAT struct" from "Data Structure Level 0"
      And I select "BEHAT QCT" from "Completeness Level 0"
      And I select "BEHAT QCO" from "Consistency Level 0"
      And I select "BEHAT QCR" from "Timeliness/Recency Level 0"
      And I fill in "Number of active internal end users" with "5173"
      And I fill in "Retention Length" with "1024 hrs"
      And I select "private" from "Associated Inventories (value 1) Level 0"
      And I select "strong" from "Associated Inventories (value 1) Level 1"
      And I select "hand" from "Data Collection Type (value 1) Level 0"
      And I select "scissors" from "Data Collection Type (value 1) Level 1"
      And I should see the text "Other Categorizations"
      And I select "Financial Sector Oversight" from "NIST Data Type"
      And I select "strange" from "Custom Vocabulary"
      And I should see the text "Acquired Data Information"
      And I select "No" from "Purchased"
      And I check "License Restrictions"
      And I fill in "eFile Contract Link" with "http://test.com"
      And I should see the text "Cost"
      And I select "BEHAT cost category" from "Cost Category"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I fill in "Year" with "1900"
      And I select "behat cost type" from "Type"
      And I fill in "Amount" with "1389.45"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the heading "SEC Data Policies"
      And I should see the text "Owner"
      And I should see the link "new division"
      And I should see the text "DAUISP Data Policies"
      And I should see the link "View Data Policies"
      And I should see the text "DAUISP Audit Logs"
      And I should see the link "View Audit Logs"
      And I should see the text "Dataset Categorization Determination"
      And I should see the text "Category dataset"
      And I should see the heading "Open Government Data Act"
      And I should see the text "OPEN Government Data Act Access Level"
      And I should see the text "DAaccess"
      And I should see the text "OPEN Government Data Act Access Level Rights"
      And I should see the text "This is a test for Access Level"
      And I should see the text "OPEN Government Data Act Data Asset Determination"
      And I should see the text "DAclassification"
      And I should see the text "OPEN Government Data Asset Compliance"
      And I should see the link "Machine readable"
      And I should not see the text "These are just some plain text OGDA notes that will be hidden on view page"
      And I should see the heading "Risk & Sensitivity"
      And I should see the text "PII Category"
      And I should see the text "Other PII"
      And I should see the text "Market Sensitivity"
      And I should see the text "behat market"
      And I should see the text "Mission Criticality (MEFs)"
      And I should see the text "new division"
      And I should see the text "behat Mission"
      And I should see the heading "Data Characteristics"
      And I should see the text "Data Structure"
      And I should see the link "BEHAT struct"
      And I should see the text "Completeness"
      And I should see the link "BEHAT QCT"
      And I should see the text "Consistency"
      And I should see the link "BEHAT QCO"
      And I should see the text "Timeliness/Recency"
      And I should see the link "BEHAT QCR"
      And I should see the text "Number of active internal end users"
      And I should see the text "5173"
      And I should see the text "Retention Length"
      And I should see the text "1024 hrs"
      And I should see the heading "Other Categorizations"
      And I should see the text "Associated Inventories"
      And I should see the link "strong"
      And I should see the link "scissors"
      And I should see the text "NIST Data Type"
      And I should see the text "Financial Sector Oversight"
      And I should not see the text "Custom Vocabulary"
      And I should not see the text "strange"
      And I should see the heading "Acquired Data Information"
      And I should see the text "Purchased"
      And I should see the text "No"
      And I should see the text "License Restrictions"
      And I should see the text "Yes"
      And I should see the text "eFile Contract"
      And I should see the link "View eFile Contract"
      And I should not see the text "Cost Category"
      And I should not see the link "BEHAT cost category"

  @api @javascript
  Scenario: Dataset Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set" content:
      | title                     | BEHAT Dataset    |
      | field_dataset_description | This is the body |
      | moderation_state          | published        |
      And I wait 2 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Dataset BEHAT Dataset"

  @api @javascript
  Scenario: Edit The Dataset
    Given I am logged in as a user with the "Content Approver" role
      And "market_sensitivity" terms:
        | name    | parent  |
        | Pmarket |         |
        | Cmarket | Pmarket |
      And I am viewing a "data_set" content:
        | title                            | BEHAT Test Data Set  |
        | field_dataset_description        | description          |
        | field_dataset_source_type        | SEC/EDGAR, SRO       |
        | field_time_period_covered        | 5days                |
        | field_dataset_datastore          | Hadoop               |
        | field_how_to_request_access      | '' - http://test.com |
        | field_sensitivity_classification | very sensitive       |
        | field_sensitive_pii              | Yes                  |
        | field_externally_hosted          | Externally           |
        | field_license_types              | IP Authentication    |
        | open_government_data_act_interna | private              |
        | field_open_government_data_acces | DAaccess             |
        | field_open_government_data_class | DAclassification     |
        | field_reviewer                   | approver             |
        | moderation_state                 | published            |
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Test Data Set" row
      And I fill in "Title" with "BEHAT Edited Title"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Access & Use"
      And I select "Concurrent User" from "License Types" for the "1" option of the "1" row
      And I select "somewhat sensitive" from "Dataset Risk Category"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAAchild" from "OPEN Government Data Act Access Level Level 1"
      And I select "Pmarket" from "Market Sensitivity Level 0"
      And I select "Cmarket" from "Market Sensitivity Level 1"
      And I press "Save"
    Then I should not see the text "BEHAT Test Data Set"
      And I should see the text "Dataset BEHAT Edited Title has been updated."
      And I click "BEHAT Edited Title"
      And I should see the heading "BEHAT Edited Title"
      And I should see the text "somewhat sensitive"
      And I should see the text "Concurrent User"
      And I click on the element with css selector "a[href='#edit-group-licensing-usage']"
      And I should see the text "DAAchild"
      And I should not see the text "Restricted"
      And I should not see the text "IP Authentication"
      And I should not see the text "Sensitive PII"
      And I should not see the text "Pmarket"
      And I should see the text "Cmarket"

  @api
  Scenario: Delete The Dataset
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
        | title                            | BEHAT Delete Data Set |
        | field_summary                    | short description     |
        | field_dataset_description        | description           |
        | field_dataset_source_type        | SEC/EDGAR, SRO        |
        | field_time_period_covered        | 5days                 |
        | field_dataset_datastore          | Hadoop                |
        | field_how_to_request_access      | '' - http://test.com  |
        | field_reviewer                   | approver              |
        | field_data_category              | category1             |
        | field_owner                      | new division          |
        | open_government_data_act_interna | private               |
        | field_open_government_data_acces | DAaccess              |
        | field_open_government_data_class | DAclassification      |
        | moderation_state                 | published             |
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Delete Data Set" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    Then I should not see the link "BEHAT Delete Data Set"

  @api @javascript
  Scenario: Relation Add Related Data Insight To Datasets
    Given "data_insight" content:
      | title          | body             | moderation_state |
      | BEHAt Insight1 | This is the body | published        |
      | BEHAt Insight2 | This is the body | published        |
      And "data_set" content:
        | title               | field_summary       | field_dataset_description | field_reviewer | moderation_state | field_owner  | field_division_office_multi | field_related_data_insights    | open_government_data_act_interna | field_open_government_data_acces | field_open_government_data_class |
        | BEHAT Dataset Title | BEHAT Short Summary | Dataset 10 description    | approver       | published        | new division | division1                   | BEHAt Insight1, BEHAt Insight2 | private                          | DAaccess                         | DAclassification                 |
      And I am logged in as a user with the "Content Approver" role
      And I am on "/datasets/behat-dataset-title"
    Then I should see the heading "BEHAT Dataset Title"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Data Insights"
      And I should see the link "BEHAt Insight1"
      And I should see the link "BEHAt Insight2"
      And I visit "/data-insights/behat-insight1"
      And I should see the heading "BEHAt Insight1"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset Title"
      And I visit "/data-insights/behat-insight2"
      And I should see the heading "BEHAt Insight2"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset Title"
    When I am on "/datasets/behat-dataset-title/edit"
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Related Content"
      And I fill in "Related Data Insights (value 2)" with ""
      And I press "Save"
    Then I should see the link "BEHAt Insight1"
      And I should not see the link "BEHAt Insight2"
      And I visit "/data-insights/behat-insight1"
      And I should see the heading "BEHAt Insight1"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset Title"
      And I visit "/data-insights/behat-insight2"
      And I should see the heading "BEHAt Insight2"
      And I should not see the text "Related Datasets"
      And I should not see the link "BEHAT Dataset Title"

  @api
  Scenario: Negative Test Case For Authenticated User Creating Datasets
    Given I am logged in as a user with the "authenticated user" role
      When I am on "/node/add/data_set"
      Then I should see "Access Denied"

  @api @javascript
  Scenario: Verify Dataset Help Texts
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
    Then I should see the text "Title"
      And I should see the text "Short Description"
      And I should see the text "Description"
      And I should see the text "Further Details"
      And I should see the text "Do you have other information to add that users might find useful?"
      And I should see the text "Time Period Covered"
      And I should see the text "What period of time does the data cover?"
      And I should see the text "OCDO Classification"
      And I should see the text "Internal Classification for OCDO use"
      And I should see the text "Data Category for Landing Page Display"
      And I should see the text "Delivery Frequency to SEC"
      And I should see the text "How often does the SEC receive this data?"
      And I should see the text "Delivery Method to SEC"
      And I should see the text "How does the SEC receive this dataset?"
      And I should see the text "Data Size"
      And I should see the text "Approximately, how large is the dataset (in GB)?"
      And I should see the text "Source"
      And I should see the text "Externally or Internally Hosted"
      And I should see the text "From where did the SEC acquire the dataset?"
      And I should see the text "Entity Type"
      And I should see the text "What type of entity(s) does the data represent?"
      And i should see the text "Asset Type"
      And I should see the text "What is the asset category of this dataset?"
      And I should see the text "Data Type"
      And I should see the text "What type(s) of data is contained in this dataset?"
      And I should see the text "Average Ingestion Volume"
      And I should see the text "Average data volume of each ingestion and provisioning cycle (in GB)"
      And I should see the text "Last Load Time"
      And I should see the text "Use Cases"
      And I should see the text "What are common uses of this data?"
      And I should see the text "Related Datasets"
      And I should see the text "IF THIS DATASET IS THE CHILD OF ANOTHER DATASET:"
      And I should see the text "This dataset is"
      And I should see the text "Date Acquired"
      And I should see the text "Status"
      And I should see the text "Other Names Used"
      And I should see the text "Is this dataset also referred to by another or legacy name(s)?"
      And I should see the text "Discontinuation Date"
      And I should see the text "Is this dataset discontinued? If so, on what date?"
      And I should see the text "Tags"
      And I should see the text "Search Keywords"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
      And I should see the text "If you do not have an assigned reviewer, enter TechCatalog@sec.gov for tech-related content and enter DataCatalog@sec.gov for data-related content."
      And I click "Access & Use"
      And I should see the text "Visit Dataset Link"
      And I should see the text "Start typing the title of a piece of content to select it. You can also enter an internal path such as /node/add or an external URL such as http://example.com. Enter <front> to link to the front page. Enter <nolink> to display link text only. Enter <button> to display keyboard-accessible link text only."
      And I should see the text "Request Access URL"
      And I should see the text "What is the URL to allow a user to request access to the dataset?"
      And I should see the text "Start typing the title of a piece of content to select it. You can also enter a path internal to the catalog such as /node/add or a URL external to the catalog such as http://example.com. Enter <button> to display keyboard-accessible link text only."
      And I should see the text "Dataset Access Details"
      And I should see the text "Provide any additional information or website links to assist the user in finding the dataset"
      And I should see the text "Data Path"
      And I should see the text "What is the feed/file path of the data?"
      And I should see the text "Dataset Risk Category"
      And I should see the text "Controlled Unclassified Information (CUI) Category"
      And I should see the text "FIPS Security Classification"
      And I should see the text "What is the security classification for this dataset?"
      And I should see the text "Restricted Dataset"
      And I should see the text "Indicates whether this dataset is highly restricted to a few users"
      And I should see the text "Permissions and Usage"
      And I should see the text "Click here to see JS files."
      And I should see the text "Detail what type of permissions are needed under the licensing agreement for publication and usage of this dataset."
      And I should see the text "Attribution Statement"
      And I should see the text 'Add the language ("Attribution Statement") that must be used when citing the vendor as a data source in publications'
      And I should see the text "License Types"
      And I should see the text "Number of Licenses Held"
      And I should see the text "What is the contractual limit to the number of users?"
      And I should see the text "Licenses Held by Division/Office"
      And I press "Add Licenses Held by Division/Office"
      And I wait for ajax to finish
      And I should see the text "Division/Office"
      And I should see the text "Select the Division or Office permitted to hold a license for this dataset"
      And I should see the text "Licenses Held"
      And I should see the text "How many licenses are held by the selected Division or Office?"
      And I should see the text "License Type"
      And I should see the text "License Notes"
      And I should see the text "Number of Licenses Assigned"
      And I should see the text "How many approved/assigned users are there currently?"
      And I scroll to the top
      And I click on the element with css selector "a[href='#edit-group-form']"
      And I should see the text "OMB Number"
      And I should see the text "Filing Format"
      And I should see the text "Total Annual Filings"
      And I press "Add Total Annual Filings"
      And I wait for ajax to finish
      And I should see the text "Year"
      And I should see the text "Type"
      And I should see the text "Number of Filings Received"
      And I should see the text "Annual Burden"
      And I should see the text "Total Annual Burden Hours"
      And I should see the text "Submission Type"
      And I should see the text "Filing Entity Type"
      And I should see the text "Act"
      And I should see the text "Enter annual burden, which must be between 0 and 9,999,999,999.99 inclusive."
      And I should see the text "Enter total annual burden hours, which must be between 0 and 9,999,999 inclusive."
      And I click "Governance"
      And I should see the text "SEC Data Policies"
      And I should see the text "Owner"
      And I should see the text "DAUISP Data Policies"
      And I should see the text "This must be an external URL such as http://example.com."
      And I should see the text "DAUISP Audit Logs"
      And I should see the text "Dataset Categorization Determination"
      And I should see the text "Open Government Data Act" in the "ogda" region
      And I should see the text "OPEN Government Data Act Access Level"
      And I should see the text "OPEN Government Data Act Access Level Rights"
      And I should see the text "Required if Access Level value is “restricted public” or “non-public."
      And I should see the text "OPEN Government Data Act Data Asset Determination"
      And I should see the text "OPEN Government Data Asset Compliance"
      And I should see the text "SEC.gov Node ID"
      And I should see the text "The value of this field should be the SEC.gov Article Node ID."
      And I should see the text "Risk & Sensitivity"
      And I should see the text "PII Category"
      And I should see the text "Indicate what category of sensitivity the dataset falls into by choosing from one from the drop-down list."
      And I should see the text "Market Sensitivity"
      And I should see the text "Mission criticality (MEFs)"
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I should see the text "Division/Office"
      And I should see the text "Mission Criticality Rating"
      And I should see the text "How do individual divisions/offices assess the criticality of this resource?"
      And I should see the text "Data Characteristics"
      And I should see the text "Data Structure"
      And I should see the text "Completeness"
      And I should see the text "High: All desired use cases can be implemented without restrictions based on available data"
      And I should see the text "Medium: Certain use cases cannot be implemented or use cases do not deliver their full desired value due to data sparseness"
      And I should see the text "Low: Data sparseness is so high that most desired use cases would not deliver satisfactory value"
      And I should see the text "Consistency"
      And I should see the text "High: All desired use cases can be implemented without known restrictions"
      And I should see the text "Medium: Certain use cases can’t be implemented at all or use cases don’t deliver their full desired value due to high error levels in data"
      And I should see the text "Low: High error level prevents most desired use cases from delivering satisfactory value"
      And I should see the text "Timeliness/Recency"
      And I should see the text "High: All desired use cases can be implemented without restrictions"
      And I should see the text "Medium: Certain use cases cannot be implemented or use cases do not deliver their full desired value due to stale/outdated data"
      And I should see the text "Low: Age / frequency of data updates prevents most desired use cases from delivering satisfactory value"
      And I should see the text "Number of active internal end users"
      And I should see the text "Retention Length"
      And I should see the text "Use the Records Schedule Disposition."
      And I should see the text "15 years after cutoff. (0120-01-02)"
      And I should see the text "Other Categorizations"
      And I should see the text "Associated Inventories"
      And I should see the text "NIST Data Type"
      And I should see the text "What is the justification for this classification?"
      And I should see the text "Acquired Data Information"
      And I should see the text "Purchased"
      And I should see the text "Does the SEC purchase this data?"
      And I should see the text "License Restrictions"
      And I should see the text "Check if there are restrictions on the use of this dataset."
      And I should see the text "eFile Contract Link"
      And I should see the text "This must be an external URL such as http://example.com."
      And I should see the text "Cost" in the "cost" region
      And I should see the text "Cost Category"
      And I should see the text "Qualitative description of primary cost related to owning/processing this data"
      And I should see the text "Cost"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I should see the text "Year"
      And I should see the text "Type"
      And I should see the text "Amount"
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I should see the text "Contact"
      And I should see the text "Role"
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact in Offices and Divisions, as needed"
      # And I click "Permissions"   DSITE-2625 will be deployed in future so please do not delete following test case.
      # And I should see the text "This Dataset will be limited to users who are of the selected Division/Office. If no options are chosen then the Dataset is available to anyone of the any Division/Office if they match the other criteria."
      # And I should see the text "This Dataset will be limited to users who are of the selected type. If no options are chosen then the Dataset is available to anyone of the type if they match the other criteria."
      # And I should see the text "If the field is set to 'Any' then the user is authorized if they match any condition from any of the permission fields. If the field is set to 'All' then the user is authorized only if their profile matches a setting from each of the permission fields. If no option is set, the functionality defaults to 'Any'."
      And I click "Vendor"
      And I should see the text "Vendor Name"
      And I should see the text "VENDOR WEBSITE"
      And I should see the text "Start typing the title of a piece of content to select it. You can also enter an internal path such as /node/add or an external URL such as http://example.com. Enter <front> to link to the front page. "
      And I should see the text "Support Phone"
      And I should see the text "Support Email"
      And I should see the text "Sales Rep Name"
      And I should see the text "Sales Rep Phone"
      And I should see the text "Sales Rep Email"

  @api @javascript
  Scenario: Viewing A Dataset
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set":
        | title                            | BEHAT Test Data Set        |
        | field_dataset_source_type        | SEC/EDGAR, SRO             |
        | field_time_period_covered        | 5days                      |
        | field_contract_status            | One-time Purchase          |
        | field_dataset_registrant_type    | Investment Advisors (IA)   |
        | field_insights                   | Further Details            |
        | field_dataset_use                | automation                 |
        | field_dataset_category           | Mergers & Acquisitions     |
        | field_dataset_asset_category     | Commodity                  |
        | field_dataset_name_old           | leagacy                    |
        | field_date_acquired              | 08/02/2018                 |
        | field_dataset_date_archive       | 08/05/2018                 |
        | field_data_size_in_gb            | ∼7GB                       |
        | field_delivery_frequency_to_sec  | Quarterly                  |
        | field_dataset_path               | sec location               |
        | field_number_of_licenses_held    | 8                          |
        | field_number_of_licenses_assigne | 5                          |
        | field_fips_security_classificati | boring                     |
        | field_fips_category_justificatio | Financial Sector Oversight |
        | field_sensitivity_classification | very sensitive             |
        | field_sensitive_pii              | No Sir                     |
        | field_purchased                  | Yes                        |
        | field_externally_hosted          | Externally                 |
        | field_license_types              | IP Authentication          |
        | field_delivery_method_to_sec     | DVD                        |
        | field_vendor_name                | Nintendo                   |
        | field_sales_rep_email_address    | Kong@gmail.com             |
        | field_dataset_sales_rep_name     | Kong                       |
        | field_sales_rep_phone_number     | 12345678901                |
        | field_support_email_address      | DrMario@gmail.com          |
        | field_support_phone_number       | 18002553700                |
        | field_notes_regarding_permission | permission                 |
        | field_attribution_statement      | language statement         |
        | field_efile_contract_link        | '' - http://test.com       |
        | field_license_required           | No                         |
        | field_notes_regarding_permission | This is permission         |
        | field_vendor_website             | URLTest - http://test.com  |
        | field_division_office_multi      | division1                  |
        | moderation_state                 | published                  |
        | field_owner                      | new division               |
        | field_data_category              | category1                  |
        | open_government_data_act_interna | private                    |
        | field_open_government_data_acces | DAaccess                   |
        | field_open_government_data_class | DAclassification           |
    Then I should see the heading "BEHAT Test Data Set"
      And I should see "Further Details" in the "general" region
      And I should see "5days" in the "general" region
      And I should see "Quarterly" in the "general" region
      And I should see "DVD" in the "general" region
      And I should see "∼0GB" in the "general" region
      And I should see "SEC/Edgar" in the "general" region
      And I should see "SRO" in the "general" region
      And I should see "Externally" in the "general" region
      And I should see "Investment Advisors (IA)" in the "general" region
      And I should see "Commodity" in the "general" region
      And I should see "Mergers & Acquisitions" in the "general" region
      And I should see "automation" in the "general" region
      And I should see "One-Time Purchase" in the "general" region
      And I should see "division1" in the "general" region
      And I should see "leagacy" in the "general" region
      And I should see "sec location" in the "how_to_access" region
      And I should see "IP Authentication" in the "how_to_access" region
      And I should see "8" in the "how_to_access" region
      And I should see "5" in the "how_to_access" region
      And I should see "very sensitive" in the "how_to_access" region
      And I should see "This is permission" in the "how_to_access" region
      And I should see "language statement" in the "how_to_access" region
      And I click "Governance" in the "horizotal_tabs" region
      And I should see the text "OPEN Government Data Act Data Asset Determination"
      And I should see the text "OPEN Government Data Act Access Level"
      And I should not see "Sensitive PII" in the "usage_restrictons" region
      And I should see "Purchased" in the "usage_restrictons" region
      And I should see "License Restrictions" in the "usage_restrictons" region
      And I should see "View eFile Contract" in the "usage_restrictons" region
      # Validate FIP Security Classification is suppressed on node display page DSITE-8528
      And I should not see "boring" in the "usage_restrictons" region
      And I should see "Financial Sector Oversight" in the "usage_restrictons" region
      And I click "Vendor"
      And I should see "Vendor Name"
      And I should see the text "Nintendo"
      And I should see the link "URLTest"
      And I should see the text "Support Phone"
      And I should see the text "18002553700"
      And I should see the link "DrMario@gmail.com"
      And I should see the text "Sales Rep Name"
      And I should see the text "Kong"
      And I should see the text "Sales Rep Phone"
      And I should see the text "12345678901"
      And I should see the text "Sales Rep Email"
      And I should see the link "Kong@gmail.com"

  @api @javascript
  Scenario Outline: Default Mandatory Fields When Creating Dataset
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "<Title>"
      And I fill in "Short Description" with "<short_description>"
      And I type "<Description>" in the "Description" WYSIWYG editor
      And I select "<divOffice>" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "<dataCatagory>" from "Data Category"
      And I scroll to the top
      And I click "Governance"
      And I select "<owner>" from "Owner"
      And I select "<ogdac>" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "<ogdaa>" from "OPEN Government Data Act Access Level Level 0"
      And I publish it
    Then I should not see the text "Dataset <Title> has been created. "
      And I should see the text "<Result>"
      And I should see the text "Reviewer (value 1) field is required."

    Examples:
      | Title    | short_description | Description  | divOffice | owner        | dataCatagory | ogdac            | ogdaa    | Result                                                               |
      |          | short             | description1 | division1 | new division | category1    | DAclassification | DAaccess | Title field is required.                                             |
      | DataSet1 |                   | description1 | division1 | new division | category1    | DAclassification | DAaccess | Short Description field is required.                                 |
      | DataSet1 | short             |              | division1 | new division | category1    | DAclassification | DAaccess | Description field is required.                                       |
      | DataSet1 | short             | description1 |           | new division | category1    | DAclassification | DAaccess | Divisions/Offices that use this field is required.                   |
      | DataSet1 | short             | description1 | division1 |              | category1    | DAclassification | DAaccess | Owner field is required.                                             |
      | DataSet1 | short             | description1 | division1 | new division |              | DAclassification | DAaccess | Data Category for Landing Page Display field is required.            |
      | DataSet1 | short             | description1 | division1 | new division | category1    |                  | DAaccess | OPEN Government Data Act Data Asset Determination field is required. |
      | DataSet1 | short             | description1 | division1 | new division | category1    | DAclassification |          | OPEN Government Data Act Access Level field is required.             |

  @api @javascript
  Scenario: Mandatory Fields After Adding Paragraphs
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I click on the element with css selector "a[href='#edit-group-form']"
      And I press "Add Total Annual Filings"
      And I wait for ajax to finish
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I press "Add Website"
      And I wait for ajax to finish
      And I scroll to the top
      And I click "Governance"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Short Description field is required."
      And I should see the text "Description field is required."
      And I should see the text "Divisions/Offices that use this field is required."
      And I should see the text "Data Category for Landing Page Display field is required."
      And I should see the text "Reviewer (value 1) field is required."
      And I should see the text "Owner field is required."
      And I should see the text "OPEN Government Data Act Access Level field is required."
      And I should see the text "OPEN Government Data Act Data Asset Determination field is required."
      And I should see the text "Year field is required."
      And I should see the text "Type field is required."
      And I should see the text "Amount field is required."
      And I should see the text "Role field is required."
      And I should see the text "Number of Filings Received field is required."
      And I should see the text "Contact field is required."
      And I should see "URL field is required."
      And I should see "Link text field is required."

  @api @javascript
  Scenario: Add Licensing Options To A Dataset
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset LicensingOption"
      And I fill in "Short Description" with "Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Access & Use"
      And I press "Add Licenses Held by Division/Office"
      And I wait for ajax to finish
      And I fill in "Licenses Held" with "50"
      And I select "Limited" from "License Type"
      And I fill in "License Notes" with "Notes Goes here"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset LicensingOption"
      And I should see the text "Licenses Held by Division/Office"
      And I should see the text "division1"
      And I should see the text "Licenses Held"
      And I should see the text "Notes Goes here"
      And I click "Governance" in the "horizotal_tabs" region
      And I should see the link "new division"

  @api @javascript
  Scenario: Data Dictionary
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
        | title                            | BEHAT Data Dictionary |
        | field_summary                    | short                 |
        | field_dataset_description        | description           |
        | field_dataset_source_type        | SEC/EDGAR, SRO        |
        | field_how_to_request_access      | '' - http://test.com  |
        | field_reviewer                   | approver              |
        | field_division_office_multi      | division1             |
        | field_owner                      | new division          |
        | field_data_category              | category1             |
        | open_government_data_act_interna | private               |
        | field_open_government_data_acces | DAaccess              |
        | field_open_government_data_class | DAclassification      |
        | moderation_state                 | published             |
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Data Dictionary" row
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I select "Data Dictionary" from "field_documents[form][0][field_document_category]"
      And I fill in "Description" with "Test" in the "form_area"
      And I publish it
    Then I should see the text "Dataset BEHAT Data Dictionary has been updated."
    When I click "BEHAT Data Dictionary"
      And I click "Related Documentation"
    Then I should see the heading "BEHAT Data Dictionary"
      And I should see the link "Uploaded Document"

  @api
  Scenario Outline: Verify Dataset Page URL
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
        | title      | field_dataset_description | field_dataset_source_type | moderation_state |
        | Data.Set10 | Dataset 10 description    | NRSRO, DBRS               | published        |
        | DATASET 30 | Dataset 30 description    | NRSRO, Fitch              | published        |
      And I am on "<URL>"
    Then the response status code should be 200

    Examples:
      | URL                  |
      | /datasets/dataset10  |
      | /datasets/dataset-30 |

  @api @javascript
  Scenario: Articles Can Be Associated With A Dataset
    Given I am logged in as a user with the "Content Approver" role
      And  "article" content:
        | title           | body | field_category | moderation_state |
        | dataset article | test | FAQ            | published        |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "dataset with article"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I scroll to the top
      And I click "Related Documentation"
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I fill in "Title" with "dataset article"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "dataset article" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
      And I click "Related Documentation"
    Then I should see the text "Articles"
      And I should see the link "dataset article"
      And I should see the text "Category"
      And I should see the link "FAQ"

  @api @javascript
  Scenario Outline: Dataset Relationship
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_open_government_data_acces | field_open_government_data_class |
        | BEHAT dataset1 | short         | This is dataset1          | '' - http://test.com        | published        | DAaccess                         | DAclassification                 |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Relationship"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "Analytical Data" from "Data Category"
      And I select "<type>" from "This dataset is"
      And <step1>
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Relationship"
      And I should see the text "Parent Dataset"
      And <expect1>
      And I should see the link "BEHAT dataset1"
      And I click "BEHAT dataset1"
      And I should see the heading "BEHAT dataset1"
      And I should see the link "BEHAT Dataset Relationship"

      Examples:
        | type           | step1                                                                                  | expect1                                                      |
        | a subset of    | I fill in "Parent Dataset" with "BEHAT dataset1"                                       | I should see the text "This child dataset is a subset of"    |
        | transformed by | I fill in "Parent Dataset" with "BEHAT dataset1"                                       | I should see the text "This child dataset is transformed by" |
        | derived from   | I select the autocomplete option for "BEHAT dataset1" on the "Parent Dataset(s)" field | I should see the text "This child dataset is derived from"   |

  @api
  Scenario: Platform Detail
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
        | title       | field_tool_category | field_dataset_description | moderation_state |
        | Behat Tool1 | Data Systems        | test                      | published        |
      And I am viewing a "data_set" content:
        | title                       | BEHAT dataset1       |
        | field_dataset_description   | This is dataset1     |
        | field_how_to_request_access | '' - http://test.com |
        | field_tools                 | Behat Tool1          |
        | moderation_state            | published            |
    Then I should see the link "Behat Tool1" in the "how_to_access" region
      And I should see the link "Behat Tool1" in the "tools" region
      And I should see the link "Data Systems" in the "tools" region

  @api
  Scenario Outline: Dataset By SourceType
    Given I am logged in as a user with the "authenticated user" role
      And I am viewing a "data_set" content:
        | title                       | BEHAT Dataset SourceType |
        | field_dataset_description   | description              |
        | field_dataset_source_type   | SEC, FINRA               |
        | field_how_to_request_access | '' - http://test.com     |
        | moderation_state            | published                |
      And  I click "<SourceType>"
    Then I should see the link "BEHAT Dataset SourceType"

    Examples:
      | SourceType |
      | SEC        |
      | FINRA      |

  @api @javascript
  Scenario: Dataset Page Visual Distinction
    Given I am logged in as a user with the "authenticated user" role
      And I am viewing a "data_set" content:
        | title                       | BEHAT dataset1       |
        | field_dataset_description   | This is dataset1     |
        | field_how_to_request_access | '' - http://test.com |
        | moderation_state            | published            |
    Then I should see the text "Dataset" in the "sub_title" region

  @api @javascript
  Scenario: Dataset Character Test
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I wait 1 seconds
      And I should see the text "Characters: 0"
      And I type "Character test" in the "Description" WYSIWYG editor
      And I wait 1 seconds
    Then I should see the text "Characters: 14"

  @api
  Scenario: Verify Data System Tools With Associated Datasets In Tools Page
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
        | title      | field_tool_category | field_dataset_description | moderation_state |
        | Behat Tool | Data Systems        | test                      | published        |
      And "data_set" content:
        | title          | field_dataset_description | field_how_to_request_access | field_tools | moderation_state |
        | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | Behat Tool  | published        |
    When I am on "tool/behat-tool"
    Then I should see the text "Dataset Referencing this Tool"
      And I should see the link "BEHAT dataset1"

  @api
  Scenario: Verify Workstations And Servers With Associated Datasets In Tools Page
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
        | title      | field_tool_category      | field_dataset_description | moderation_state |
        | Behat Tool | Workstations and Servers | test                      | published        |
      And "data_set" content:
        | title          | field_dataset_description | field_how_to_request_access | field_tools | moderation_state |
        | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | Behat Tool  | published        |
    When I am on "tool/behat-tool"
    Then I should see the text "Dataset Referencing this Tool"
      And I should see the link "BEHAT dataset1"

  @api
  Scenario: Verify Software With Associated Datasets In Tools Page
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
        | title      | field_tool_category | field_dataset_description | moderation_state |
        | Behat Tool | Software            | test                      | published        |
      And "data_set" content:
        | title          | field_dataset_description | field_how_to_request_access | field_tools | moderation_state |
        | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | Behat Tool  | published        |
    When I am on "tool/behat-tool"
    Then I should see the text "Dataset Referencing this Tool"
      And I should see the link "BEHAT dataset1"

  @api
  Scenario: Verify Associated Datasets In Tools Page
    Given I am logged in as a user with the "authenticated user" role
      And "tools" content:
        | title      | field_dataset_description | moderation_state |
        | Behat Tool | test                      | published        |
      And "data_set" content:
        | title          | field_dataset_description | field_how_to_request_access | field_tools | moderation_state |
        | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | Behat Tool  | published        |
    When I am on "tool/behat-tool"
    Then I should see the text "Dataset Referencing this Tool"
      And I should see the link "BEHAT dataset1"

  @api
  Scenario: Verify Dataset Created/Updated Label
    Given  I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
        | title                       | BEHAT Dataset Created |
        | field_dataset_description   | This is dataset2      |
        | field_how_to_request_access | '' - http://test.com  |
        | moderation_state            | published             |
      And I should see the text "Created"
      And I am viewing a "data_set" content:
        | title                       | BEHAT Dataset Updated |
        | field_dataset_description   | This is dataset2      |
        | field_how_to_request_access | '' - http://test.com  |
        | changed                     | +5 day                |
        | moderation_state            | published             |
    Then I should see the text "Updated"

  @api
  Scenario: Vendor Tab Is Not Visible To Anonymous And Authenticated Users
    Given "data_set" content:
      | title          | field_dataset_description | field_vendor_name | field_sales_rep_email_address | moderation_state |
      | BEHAT dataset1 | This is dataset1          | New Vendor        | vendor@email.com              | published        |
    When I am on "/dataset/behat-dataset1"
    Then I should not see the link "Vendor"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/dataset/behat-dataset1"
    Then I should not see the link "Vendor"

  @api
  Scenario Outline: Vendor Tab Is Visible For CA/CC/Admin
    Given "data_set" content:
      | title          | field_dataset_description | field_vendor_name | field_sales_rep_email_address | moderation_state |
      | BEHAT dataset1 | This is dataset1          | New Vendor        | vendor@email.com              | published        |
    When I am logged in as a user with the "<User>" role
      And I am on "/datasets/behat-dataset1"
    Then I should see the link "Vendor"

    Examples:
      | User             |
      | Content Creator  |
      | Content Approver |
      | administrator    |

  @api @javascript
  Scenario: Verify Hidden Fields Under Usage Restrictions For Authenticated Users
    Given I am logged in as a user with the "authenticated user" role
      And I am viewing a "data_set" content:
        | title                            | BEHAT Dataset Created      |
        | field_dataset_description        | This is dataset2           |
        | field_sensitive_data_category    | nopii                      |
        | field_sensitivity_classification | very sensitive             |
        | field_sensitive_pii              | Yes                        |
        | field_externally_hosted          | Externally                 |
        | field_efile_contract_link        | '' - http://test.com       |
        | field_license_required           | No                         |
        | field_fips_security_classificati | Low                        |
        | field_fips_category_justificatio | Financial Sector Oversight |
        | open_government_data_act_interna | private                    |
        | field_open_government_data_class | DAclassification           |
        | field_open_government_data_acces | DAaccess                   |
        | moderation_state                 | published                  |
    Then I should see the heading "BEHAT Dataset Created"
      And I should see the text "Dataset Risk Category"
      And I should see the text "very sensitive"
      And I should not see the text "License Restrictions"
      And I should not see the link "Governance" in the "horizotal_tabs" region
      And I should not see the text "DAclassification"
      And I should not see the text "DAaccess"
      And I should not see the text "PII Category"
      And I should not see the text "Sensitive PII"
      And I should not see the link "View eFile Contract"
      And I should not see the text "FIPS Security Classification"
      And I should not see the text "NIST Data Type"

  @api @javascript
  Scenario Outline: All Fields Under Usage Restrictions Are Visible For CA/CC/Admin
    Given  I am logged in as a user with the "<User>" role
    When I am viewing a "data_set" content:
        | title                            | BEHAT Dataset Created      |
        | field_dataset_description        | This is dataset2           |
        | field_sensitive_data_category    | nopii                      |
        | field_sensitivity_classification | somewhat sensitive         |
        | field_sensitive_pii              | Yes                        |
        | field_efile_contract_link        | '' - http://test.com       |
        | field_license_required           | No                         |
        | field_fips_security_classificati | Low                        |
        | field_fips_category_justificatio | Financial Sector Oversight |
        | open_government_data_act_interna | private                    |
        | field_open_government_data_class | DAclassification           |
        | field_open_government_data_acces | DAaccess                   |
        | moderation_state                 | published                  |
    Then I should see the heading "BEHAT Dataset Created"
      And I should see the text "Dataset Risk Category"
      And I should see the text "somewhat sensitive"
    When I click "Governance" in the "horizotal_tabs" region
    Then I should see the text "PII Category"
      And I should see the text "DAclassification"
      And I should see the text "DAaccess"
      And I should not see the text "Sensitive PII"
      And I should see the text "License Restrictions"
      And I should see the text "eFile Contract"
      And I should not see the text "FIPS Security Classification"
      And I should see the text "NIST Data Type"

    Examples:
      | User             |
      | Content Creator  |
      | Content Approver |
      | administrator    |

  @api
  Scenario: Ability To Link Taxonomy
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set" content:
      | title                         | BEHAT Test Data Set  |
      | field_dataset_description     | description          |
      | field_dataset_source_type     | SEC/EDGAR, SRO       |
      | field_dataset_registrant_type | Clearing Agencies    |
      | field_dataset_asset_category  | Equity, Fixed Income |
      | field_dataset_category        | Text Analytics       |
      | field_dataset_use             | scripting            |
      | moderation_state              | published            |
    Then I should see the link "SEC/Edgar"
      And I should see the link "SRO"
      And I should see the link "Clearing Agencies"
      And I should see the link "Equity"
      And I should see the link "Fixed Income"
      And I should see the link "Text Analytics"
      And I should see the link "scripting"
      And I click "Clearing Agencies"
      And I should see the heading "Clearing Agencies"
      And I click "BEHAT Test Data Set"
      And I click "Equity"
      And I should see the heading "Equity"
      And I click "BEHAT Test Data Set"
      And I click "Fixed Income"
      And I should see the heading "Fixed Income"
      And I click "BEHAT Test Data Set"
      And I click "Text Analytics"
      And I should see the heading "Text Analytics"
      And I click "BEHAT Test Data Set"
      And I click "scripting"
      And I should see the heading "scripting"
      And I click "BEHAT Test Data Set"
      And I click "SEC/Edgar"
      And I should see the heading "SEC/Edgar"
      And I click "BEHAT Test Data Set"
      And I click "SRO"
      And I should see the heading "SRO"

  @api @javascript
  Scenario: View List Of All Updated Datasets
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
        | title           | field_dataset_description | moderation_state |
        | BEHAT dataset1  | This is dataset1          | published        |
        | BEHAT dataset2  | This is dataset2          | published        |
        | BEHAT dataset3  | This is dataset3          | published        |
        | BEHAT dataset4  | This is dataset4          | published        |
        | BEHAT dataset5  | This is dataset5          | published        |
        | BEHAT dataset6  | This is dataset6          | published        |
        | BEHAT dataset7  | This is dataset7          | published        |
        | BEHAT dataset8  | This is dataset8          | published        |
        | BEHAT dataset9  | This is dataset9          | published        |
        | BEHAT dataset10 | This is dataset10         | published        |
        | BEHAT dataset11 | This is dataset11         | published        |
        | BEHAT dataset12 | This is dataset12         | published        |
    When I am on "/"
      And I click "More" in the "recently_updated" region
    Then I should see the heading "Recently Updated Information"
      And I should see the link "BEHAT dataset1"
      And I should see the link "BEHAT dataset2"
      And I should see the link "BEHAT dataset3"
      And I should see the link "BEHAT dataset4"
      And I should see the link "BEHAT dataset5"
      And I should see the link "BEHAT dataset6"
      And I should see the link "BEHAT dataset7"
      And I should see the link "BEHAT dataset8"
      And I should see the link "BEHAT dataset9"
      And I should see the link "BEHAT dataset10"
      And I should see the link "BEHAT dataset11"
      And I should see the link "BEHAT dataset12"

  @api @javascript
  Scenario: Verify Datasets In API
    Given "data_set" content:
      | title     | field_summary  | field_dataset_description | field_dataset_source_type | moderation_state | status | field_reviewer | field_division_office_multi | field_data_category | field_owner    | field_open_government_data_acces | field_open_government_data_class |
      | DATASET20 | short summary1 | Dataset 20 description    | NRSRO, Fitch              |                  | 0      | approver       | division2                   | category1           | new division   | DAaccess                         | DAclassification                 |
      | DATASET30 | short summary2 | Dataset 30 description    | NRSRO, Fitch              | published        | 1      | approver       | division1                   | category1           | new division   | DAaccess                         | DAclassification                 |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/jsonapi/node/data_set"
    Then I should see the text "DATASET30"
      And I should not see the text "DATASET20"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content"
      And I click "Edit" in the "DATASET30" row
      And I fill in "Title" with "Dataset Edited"
      And I publish it
    When I am on "/jsonapi/node/data_set"
    Then I should see the text "Dataset Edited"
      And I should not see the text "DATASET30"
      And I am on "/admin/content"
      And I click "Edit" in the "Dataset Edited" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
    When I am on "/jsonapi/node/data_set"
    Then I should not see the text "Dataset Edited"

  @api @javascript
  Scenario: Articles Referencing A Dataset
    Given "data_set" content:
      | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_reviewer | field_division_office_multi | field_data_category | field_owner  | field_open_government_data_class | field_open_government_data_acces |
      | BEHAT dataset1 | short         | This is dataset1          | '' - http://test.com        | published        | approver       | division1                   | category1           | new division | DAclassification                 | DAaccess                         |
      And "article" content:
        | title            | body        | field_category | field_dataset_related_datasets | moderation_state | field_reviewer |
        | dataset article1 | article one | FAQ            | BEHAT dataset1                 | published        | approver       |
        | dataset article2 | article two | FAQ            |                                | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am on "datasets/behat-dataset1"
      And I click "Related Documentation"
    Then I should see the text "Articles Referencing this Dataset"
      And I should see the link "dataset article1"
      And I should not see the link "dataset article2"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT dataset1" row
      And I click "Related Documentation"
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I wait for ajax to finish
      And I fill in "Title" with "dataset article2"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "dataset article" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Save"
      And I click "BEHAT dataset1"
      And I click "Related Documentation"
      And I should see "Articles"
      And I should see the link "dataset article2"
      And I should see the link "dataset article1"

  @api @javascript
  Scenario: Edit Article Reference Title And Verify On Dataset Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_division_office_multi | field_owner  | field_data_category |
        | BEHAT dataset1 | short         | This is dataset1          | '' - http://test.com        | published        | division1                   | new division | category1           |
      And  "article" content:
        | title            | field_summary | body        | field_category | field_dataset_related_datasets | moderation_state | field_reviewer |
        | dataset article1 | short         | article one | FAQ            | BEHAT dataset1                 | published        | approver       |
    When I am on "datasets/behat-dataset1"
      And I click "Related Documentation"
    Then I should see the text "Articles Referencing this Dataset"
      And I should see the link "dataset article1"
      And I am on "/admin/content"
      And I click "Edit" in the "dataset article1" row
      And I fill in "Title" with "Article1 Edited"
      And I press "Save"
      And I click "BEHAT dataset1"
      And I click "Related Documentation"
      And I should not see the link "dataset article1"
      And I should see the link "Article1 Edited"

  @api @javascript
  Scenario: Delete Article Reference And Verify On Dataset Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_reviewer | field_division_office_multi | field_owner  | field_data_category |
        | BEHAT dataset1 | short         | This is dataset1          | '' - http://test.com        | published        | approver       | division1                   | new division | category1           |
      And  "article" content:
        | title            | body        | field_category | field_dataset_related_datasets | moderation_state | field_reviewer |
        | dataset article1 | article one | FAQ            | BEHAT dataset1                 | published        | approver       |
    When I am on "datasets/behat-dataset1"
      And I click "Related Documentation"
    Then I should see the text "Articles Referencing this Dataset"
      And I should see the link "dataset article1"
      And I am on "/admin/content"
      And I click "Edit" in the "dataset article1" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
      And I am on "datasets/behat-dataset1"
      And I should not see the link "Related Documentation"
      And I should not see the text "Articles Referencing this Dataset"
      And I should not see the link "dataset article1"

  @api @javascript
  Scenario: Verify Discussions Tab On Dataset Detailed Page
    Given I am logged in as a user with the "Content Approver" role
      And "forums" terms:
        | name     |
        | Datasets |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I publish it
    Then I should see "Related Discussions"
      And I click "Related Discussions"
      And I should see "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
      And I click "Start a New Discussion"
      And the link should open in a new tab
      And I fill in "Title" with "BEHAT Forum"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
      And I should see the text "Related Content"
      And I should see the link "BEHAT Dataset"
      And I click "BEHAT Dataset"
      And I click "Related Discussions"
      And I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I close the current window

  ## Following story was completed but not deployed on release/scheduled/2.3
  ## Test case is for Dataset Permission ticket DSITE-2625.
  ## DSITE-2625 will be deployed in future so please do not delete following test case.
  # @api @javascript
  # Scenario: Dataset Access Permissions Based On Division Office And Employment Type
  #   Given "data_set" content:
  #     | title               | field_dataset_description | field_perm_division_office | field_perm_employment_type | field_perm_operand | moderation_state |
  #     | DataSet Permission1 | Dataset description1      | DERA, MIRO                 | contractor                 | 1                  | published        |
  #     | DataSet Permission2 | Dataset description2      | TM, OIT, OSO, OA           | contractor,  fed           | 0                  | published        |
  #     | DataSet Permission3 | Dataset description4      | OIG, OA, ARO               | fed                        |                    | published        |
  #     | DataSet Permission4 | Dataset description4      |                            |                            |                    | published        |
  #     And  users:
  #     | name                 | mail               | roles            | field_division_office | field_employment_type | status |
  #     | DERA Contractor User | deract@example.com | Content Approver | DERA                  | contractor            | 1      |
  #     | DERA User            | dera@example.com   | Content Creator  | DERA                  |                       | 1      |
  #     | Fed User             | fed@example.com    |                  |                       | fed                   | 1      |
  #     | OA User              | oa@example.com     |                  | OA                    |                       | 1      |
  #   When I am logged in as "DERA Contractor User"
  #     And I am on "/dataset/dataset-permission1"
  #   Then I should see the heading "DataSet Permission1"
  #     And I am on "/dataset/dataset-permission2"
  #     And I should see the heading "DataSet Permission2"
  #     And I am on "/dataset/dataset-permission3"
  #     And I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission4"
  #     And I should see the heading "DataSet Permission4"
  #   When I am logged in as "DERA User"
  #     And I am on "/dataset/dataset-permission1"
  #   Then I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission2"
  #     And I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission3"
  #     And I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission4"
  #     And I should see the heading "DataSet Permission4"
  #   When I am logged in as "Fed User"
  #     And I am on "/dataset/dataset-permission1"
  #   Then I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission2"
  #     And I should see the heading "DataSet Permission2"
  #     And I am on "/dataset/dataset-permission3"
  #     And I should see the heading "DataSet Permission3"
  #     And I am on "/dataset/dataset-permission4"
  #     And I should see the heading "DataSet Permission4"
  #   When I am logged in as "OA User"
  #     And I am on "/dataset/dataset-permission1"
  #   Then I should see the heading "Access denied"
  #     And I am on "/dataset/dataset-permission2"
  #     And I should see the heading "DataSet Permission2"
  #     And I am on "/dataset/dataset-permission3"
  #     And I should see the heading "DataSet Permission3"
  #     And I am on "/dataset/dataset-permission4"
  #     And I should see the heading "DataSet Permission4"

  @api @javascript
  Scenario: Add Related Applications To A Dataset
    Given "application" content:
      | title              | field_summary      | body         | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | short description1 | description1 | summary1      | published        | approver       |
      | BEHAT Application2 | short description2 | description2 | summary2      | published        | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Component Description" in the "Description" WYSIWYG editor
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application2" on the "Related Technology" field
      And I select "Data analysis" from "Technology & Dataset Relationship"
      And I publish it
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I click "BEHAT Application2"
      And I should see the heading "BEHAT Application2"
      And I should not see the text "Datasets"
      And I should not see the link "BEHAT Dataset"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application2"
    Then I should see the heading "BEHAT Application2"
      And I should not see the link "BEHAT Dataset"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/datasets/behat-dataset"
      And I select "Published" from "Change to"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
      And I run drush "cr"
    When I am logged in as a user with the "authenticated user" role
      And I am on "/applications/behat-application2"
    Then I should see the heading "BEHAT Application2"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I click "BEHAT Dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"

  @api @javascript
  Scenario: Edit Related Application And Verify On Datasets Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
        | title             | field_summary       | body                  | field_division_office_multi | field_owner | field_app_status | moderation_state | field_reviewer |
        | BEHAT Application | This is the Summary | Component description | division1                   | division1   | App Status       | published        | approver       |
      And I am viewing a "data_set" content:
        | title                            | BEHAT Dataset    |
        | field_summary                    | short            |
        | field_dataset_description        | This is the body |
        | field_division_office_multi      | division1        |
        | moderation_state                 | published        |
        | field_data_category              | category1        |
        | field_owner                      | new division     |
        | open_government_data_act_interna | private          |
        | field_open_government_data_acces | DAaccess         |
        | field_open_government_data_class | DAclassification |
        | field_reviewer                   | approver         |
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application" on the "Related Technology" field
      And I press "Save"
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application"
    When I am on "/applications/behat-application/edit"
      And I fill in "Title" with "BEHAT Edited Application"
      And I press "Save"
      And I am on "/datasets/behat-dataset#edit-group-tools"
    Then I should see the heading "BEHAT Dataset"
      And I should see the text "Related Technology"
      And I should see the link "BEHAT Edited Application"
      And I should not see the link "BEHAT Application"

  @api @javascript
  Scenario: Delete Related Application And Verify On Dataset Page
    Given I am logged in as a user with the "Content Approver" role
      And "application" content:
        | title             | field_summary       | body                  | moderation_state | field_reviewer | field_division_office_multi | field_owner | field_app_status |
        | BEHAT Application | This is the Summary | Component description | published        | approver       | division1                   | division1   | App Status       |
      And I am viewing a "data_set" content:
        | title                            | BEHAT Dataset    |
        | field_summary                    | short            |
        | field_dataset_description        | This is the body |
        | moderation_state                 | published        |
        | field_reviewer                   | approver         |
        | field_division_office_multi      | division1        |
        | field_data_category              | category1        |
        | field_owner                      | new division     |
        | open_government_data_act_interna | private          |
        | field_open_government_data_class | DAclassification |
        | field_open_government_data_acces | DAaccess         |
        | field_reviewer                   | approver         |
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application" on the "Related Technology" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application"
    When I navigate to the "/edit" page from the current url
      And I click "Related Content"
      And I click on the element with css selector "#edit-field-related-apps-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I press "edit-field-related-apps-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    When I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should not see the link "Related Content" in the "horizotal_tabs" region
      And I should not see the link "BEHAT Application"
    When I am on "/applications/behat-application/edit"
      And I click "Related Technologies"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I press "edit-field-related-datasets-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT Dataset"

  @api @javascript
  Scenario: Add Multiple Mission Criticality Terms For Datasets
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title      | field_summary | field_dataset_description | field_reviewer |  field_division_office_multi | moderation_state | field_owner  | field_data_category | field_open_government_data_acces | field_open_government_data_class |
        | behat data | behat short   | Dataset 10 description    | approver       | division1                    | published        | new division | category1           | DAaccess                         | DAclassification                 |
      And "mission_criticality_mefs_" terms:
        | name     |
        | mission1 |
        | mission2 |
      And "division_office" terms:
        | name    |
        | office1 |
        | office2 |
    When I am on "/datasets/behat-data/edit"
      And I click "Governance"
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I select "office1" from "Division/Office"
      And I select "mission1" from "Mission Criticality Rating"
      And I press "Save"
    Then I should see the heading "behat data"
      And I should see the text "office1"
      And I should see the text "mission1"
      And I should not see the text "mission2"
      And I should not see the text "office2"
    When I am on "/datasets/behat-data/edit"
      And I click "Governance"
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I select "office2" from "Division/Office"
      And I press "Save"
    Then I should see the heading "behat data"
      And I should see the text "office1"
      And I should see the text "mission1"
      And I should see the text "office2"
      And I should not see the text "mission2"
    When I am on "/datasets/behat-data/edit"
      And I click "Governance"
      And I click on the element with css selector "#edit-field-mission-criticality-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I press "edit-field-mission-criticality-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Add Mission Criticality"
      And I wait for ajax to finish
      And I select "mission2" from "Mission Criticality Rating"
      And I press "Save"
    Then I should see the heading "behat data"
      And I should not see the text "office1"
      And I should not see the text "mission1"
      And I should see the text "office2"
      And I should see the text "mission2"

  @api @javascript
  Scenario Outline: Add Multiple Terms For Datasets
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title      | field_summary | field_dataset_description | field_reviewer |  field_division_office_multi | moderation_state | field_owner  | field_data_category | field_open_government_data_acces | field_open_government_data_class |
        | behat data | behat short   | Dataset 10 description    | approver       | division1                    | published        | new division | category1           | DAaccess                         | DAclassification                 |
      And "<term name>" terms:
        | name     |
        | <value1> |
        | <value2> |
    When I am on "/datasets/behat-data/edit"
      And I select "<value1>" from "<label>" for the "1" option of the "1" row
      And I click on the element with css selector "#<selector>"
      And I wait for ajax to finish
      And I select "<value2>" from "<label>" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the <expect> "<value1>"
      And I should see the <expect> "<value2>"
    When I am on "/datasets/behat-data/edit"
      And I select "- Please select -" from "<label>" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the <expect> "<value1>"
      And I should not see the <expect> "<value2>"

      Examples:
        | term name               | value1   | value2   | expect | label                  | selector                                    |
        | data                    | case 1   | case 2   | link   | Use Cases              | edit-field-dataset-use-add-more             |
        | dataset_source_type     | typeA    | typeB    | link   | Source                 | edit-field-dataset-source-type-add-more     |
        | delivery_method_to_sec  | deliver1 | deliver2 | text   | Delivery Method to SEC | edit-field-delivery-method-to-sec-add-more  |
        | dataset_registrant_type | entity1  | entity2  | link   | Entity Type            | edit-field-dataset-registrant-type-add-more |

  @api @javascript
  Scenario: Validate Owner Field Link
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
        | title      | field_summary | field_dataset_description | field_reviewer |  field_division_office_multi | moderation_state | field_owner  | field_data_category | field_open_government_data_class | field_open_government_data_acces |
        | behat data | behat short   | Dataset 10 description    | approver       | division1                    | published        | new division | category1           | DAclassification                 | DAaccess                         |
      And "application" content:
        | title              | body         | field_summary | moderation_state | field_reviewer | field_owner  |
        | BEHAT Application1 | description1 | summary1      | published        | approver       | new division |
    When I am on "/datasets/behat-data/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I press "Save"
    Then I should see the heading "behat data"
      And I click "Governance" in the "horizotal_tabs" region
      And I click "new division"
      And "Datasets Owned by new division" should precede "Applications Owned by new division" for the query "//div[contains(@class, 'view-header')]"
      And I should see the heading "new division"
      And I should not see the text "Dataset 10 description"
      And I should see the link "behat data"
      And I should see the text "Related Content"
      And I should see the text "Dataset"

  @api @javascript
  Scenario: Adding & Removing Multiple Cost Values
    Given I am logged in as a user with the "Content Approver" role
      And "cost_type" terms:
        | name            |
        | behat cost type |
      And "data_set" content:
        | title      | field_summary | field_dataset_description | field_reviewer | field_division_office_multi | moderation_state | field_owner  | field_data_category | field_open_government_data_class | field_open_government_data_acces |
        | behat data | behat short   | Dataset 10 description    | approver       | division1                   | published        | new division | category1           | DAclassification                 | DAaccess                         |
    When I am on "/datasets/behat-data/edit"
      And I click "Governance"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I fill in "Year" with "1900"
      And I select "behat cost type" from "Type"
      And I fill in "Amount" with "50"
      And I press "Save"
    Then I should see the heading "behat data"
    When I am on "/datasets/behat-data/edit"
      And I click "Governance"
    Then I should see the text "You are not allowed to view this Cost."
    When I click on the element with css selector "span[class='dropbutton-arrow']"
      And I press "edit-field-cost-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Add Cost"
      And I wait for ajax to finish
      And I fill in "Year" with "1900"
      And I select "behat cost type" from "Type"
      And I fill in "Amount" with "50"
      And I press "Save"
    Then I should see the heading "behat data"

  @api @javascript
  Scenario: Validate Cost Amount Requires Number
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I click "Governance"
      And I press "Add Cost"
      And I wait for ajax to finish
      And I fill in "Amount" with "euriosdf"
      And I press "Save"
    Then I should see the text "Amount field is required."

  @api @javascript
  Scenario: Update Divisions/Office Selection For Dataset
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Data Set |
      | field_summary                    | short description   |
      | field_dataset_description        | This is the body    |
      | field_division_office_multi      | ARO, BRO, DERA      |
      | field_owner                      | new division        |
      | moderation_state                 | published           |
      | field_data_category              | category1           |
      | open_government_data_act_interna | private             |
      | field_open_government_data_acces | DAaccess            |
      | field_open_government_data_class | DAclassification    |
      | field_reviewer                   | approver            |
    Then I should see the link "ARO"
      And I should see the link "BRO"
      And I should see the link "DERA"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Test Data Set" row
      And I select "- Please select -" from "Divisions/Offices that use this " for the "1" option of the "2" row
      And I publish it
    Then I should see the text "Dataset BEHAT Test Data Set has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/datasets/behat-test-data-set"
    Then I should see the heading "BEHAT Test Data Set"
      And I should see the link "ARO"
      And I should see the link "DERA"
      And I should not see the link "BRO"

  @api @javascript
  Scenario: Delete Divisions/Offices Selection For Dataset
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "data_set":
      | title                            | BEHAT Test Data Set |
      | field_summary                    | short description   |
      | field_dataset_description        | This is the body    |
      | field_division_office_multi      | ARO, BRO, DERA      |
      | field_owner                      | new division        |
      | moderation_state                 | published           |
      | field_data_category              | category1           |
      | open_government_data_act_interna | private             |
      | field_open_government_data_acces | DAaccess            |
      | field_open_government_data_class | DAclassification    |
      | field_reviewer                   | approver            |
    Then I should see the link "ARO"
      And I should see the link "BRO"
      And I should see the link "DERA"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Test Data Set" row
    Then I should see the "edit-field-division-office-multi-0-remove-button" button
      And I should see the "edit-field-division-office-multi-1-remove-button" button
      And I should see the "edit-field-division-office-multi-2-remove-button" button
    When I press the "edit-field-division-office-multi-0-remove-button" button
      And I wait 2 seconds
      And I publish it
    Then I should see the text "Dataset BEHAT Test Data Set has been updated."
    When I am logged in as a user with the "authenticated user" role
      And I am on "/datasets/behat-test-data-set"
    Then I should see the heading "BEHAT Test Data Set"
      And I should see the link "BRO"
      And I should see the link "DERA"
      And I should not see the link "ARO"

  @api @javascript
  Scenario: Include HTML Filtering In Dataset and Global Search
    Given "data_set" content:
      | title              | field_summary       | field_dataset_description | moderation_state | field_owner  | field_reviewer | field_open_government_data_class | field_open_government_data_acces | field_data_category | field_division_office_multi | field_insights | field_license_required |
      | BEHAT SPAC dataset | a short description | a test description        | published        | new division | approver       | DAclassification                 | DAAchild                         | category1           | division2                   | more details   | 1                      |
      | BEHAT dataset      | a space description | a space test description  | published        | new division | approver       | DAclassification                 | DAAchild                         | category1           | division2                   | more details   | 1                      |
      | BEHAT sheep        | a short description |                           | published        | new division | approver       | DAclassification                 | DAAchild                         | category1           | division1                   | more details   | 1                      |
      And I run cron
      And I am logged in as a user with the "Content Approver" role
    When I am on "/datasets/behat-sheep/edit"
      And I press "Source" in the "Description" WYSIWYG Toolbar
      And I set css selector ".cke_source" with '<div id="s4-workspace" style="width: 1192px;"><div id="s4-bodyContainer">&nbsp;</div></div>'
      And I publish it
      And I run cron
      And I am logged in as a user with the "Authenticated user" role
      And I visit "/datasets"
      And I fill in "Search Terms" with "spac"
      And I scroll to the bottom
      And I press "Submit"
      And I wait 2 seconds
    Then I should see the link "BEHAT SPAC dataset" in the "results_view" region
      And I should see the link "BEHAT dataset" in the "results_view" region
      And I should not see the link "BEHAT sheep" in the "results_view" region
    When I visit "/results"
      And I fill in "Search" with "spac" in the "search_form" region
      And I press "Search" in the "search_form" region
      And I wait 2 seconds
    Then I should see the link "BEHAT SPAC dataset" in the "results_view" region
      And I should see the link "BEHAT dataset" in the "results_view" region
      And I should not see the link "BEHAT sheep" in the "results_view" region

  @api @javascript
  Scenario: Add Related Applications, Platforms and Software To A Dataset
    Given "application" content:
      | title              | body       | field_summary | moderation_state | field_reviewer |
      | BEHAT Application1 | some-body1 | summary1      | published        | approver       |
      | BEHAT Application2 | some-body2 | summary2      | published        | approver       |
      And "platform" content:
        | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Platform1 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
        | BEHAT Platform2 | some-body2 | summary2      | BEHAT Approval     | division1                   | published        | approver       |
      And "component" content:
        | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Software1 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
        | BEHAT Software2 | some-body2 | summary2      | BEHAT Approval     | division1                   | published        | approver       |
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
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    #Adding multiple application relationships
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I should not see the button "Add Related Application"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Application2" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      #Adding multiple platform relationships
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Platform1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Platform2" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      #Adding multiple software relationships
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Software1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Software2" on the "Related Technology" field
      And I wait for ajax to finish
      And I select "Published" from "Change to"
      And I press "Save"
      And I wait for ajax to finish
    #Verifying relationships
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see "Related Technology"
      And I should see the link "BEHAT Application1"
      And I should see the link "BEHAT Application2"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Platform2"
      And I should see the link "BEHAT Software1"
      And I should see the link "BEHAT Software2"
    When I am on "/applications/behat-application1"
    Then I should see the heading "BEHAT Application1"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/applications/behat-application2"
    Then I should see the heading "BEHAT Application2"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/platforms/behat-platform1"
    Then I should see the heading "BEHAT Platform1"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/platforms/behat-platform2"
    Then I should see the heading "BEHAT Platform2"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/software/behat-software1"
    Then I should see the heading "BEHAT Software1"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/software/behat-software2"
    Then I should see the heading "BEHAT Software2"
      And I should see the text "Datasets"
      And I should see the link "BEHAT Dataset"

  @api @javascript
  Scenario: Edit related Platform and Software and Verify Sync on Dataset Page
    Given "platform" content:
      | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | BEHAT Platform1 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
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
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    #Add a platform relationship
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Platform1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
    #Add a software relationship
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Software1" on the "Related Technology" field
      And I wait for ajax to finish
      And I select "Published" from "Change to"
      And I press "Save"
      And I wait for ajax to finish
    #Verifying relationships before Edit
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Software1"
    #Edit platform and software titles
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform1/edit"
      And I fill in "Title" with "BEHAT Platform1 - edited"
      And I select "Published" from "Change to"
      And I press "Save"
      And I wait for ajax to finish
      And I am on "/software/behat-software1/edit"
      And I fill in "Title" with "BEHAT Software1 - edited"
      And I select "Published" from "Change to"
      And I press "Save"
      And I wait for ajax to finish
    #Verifying new platform and software titles on dataset
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "BEHAT Platform1 - edited"
      And I should see the link "BEHAT Software1 - edited"

  @api @javascript
  Scenario: Delete Platform and Software relationship and Verify Sync on Dataset Page
    Given "platform" content:
      | title           | body       | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
      | BEHAT Platform1 | some-body1 | summary1      | BEHAT Approval     | division1                   | published        | approver       |
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
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    #Add a platform relationship
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Platform1" on the "Related Technology" field
      And I wait for ajax to finish
      And I press "Save"
      And I wait for ajax to finish
    #Add a software relationship
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I press "Add Related Technology"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Software1" on the "Related Technology" field
      And I wait for ajax to finish
      And I select "Published" from "Change to"
      And I press "Save"
      And I wait for ajax to finish
    #Verifying relationships on dataset BEFORE delete
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "BEHAT Platform1"
      And I should see the link "BEHAT Software1"
    When I am on "/platforms/behat-platform1"
    Then I should see the heading "BEHAT Platform1"
      And I should see the link "BEHAT Dataset"
    When I am on "/software/behat-software1"
    Then I should see the heading "BEHAT Software1"
      And I should see the link "BEHAT Dataset"
    #Delete relation to dataset from platform and software pages
    When I am logged in as a user with the "Content Approver" role
      And I am on "/platforms/behat-platform1/edit"
      And I click "Related Technologies"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT Dataset"
    When I am on "/software/behat-software1/edit"
      And I click "Related Technologies"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top > div.paragraphs-dropbutton-wrapper > div > div > ul > li.dropbutton-toggle > button"
      And I click on the element with css selector "#edit-field-related-datasets-with-term-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT Dataset"
    #Verifying relationships on dataset AFTER delete
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should not see the link "BEHAT Platform1"
      And I should not see the link "BEHAT Software1"

  @api @javascript
  Scenario: Relation Add Related Reports & Statistics To Datasets with Two way Sync
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
    #Add a Report relationship & Statistics relationship
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
      And I select the first autocomplete option for "Behat Report" on the "Related Reports & Statistics" field in the "datasets_related_reports_stats" region
      And I press "Add another item" in the "datasets_related_reports_stats" region
      And I fill in "Related Reports & Statistics (value 2)" with "Behat Statistics"
      And I press "Save"
    #Verify two way relationships before Edit
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Related Content" in the "horizotal_tabs" region
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see the text "Related Data Insights"
      And I should see the link "Behat Insight"
      And I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Report"
      And I should see the link "Behat Statistics"
    When I am on "/reports-statistics/behat-report"
    Then I should see the heading "Behat Report"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/reports-statistics/behat-statistics"
    Then I should see the heading "Behat Statistics"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    #Edit reports and statistics titles
    When I am logged in as a user with the "Content Approver" role
      And I am on "/reports-statistics/behat-report/edit"
      And I fill in "Title" with "Behat Report - edited"
      And I type "Testing Behat Report" in the "Description" WYSIWYG editor
      And I select "Published" from "Change to"
      And I press "Save"
      And I am on "/reports-statistics/behat-statistics/edit"
      And I fill in "Title" with "Behat Statistics - edited"
      And I type "Testing Behat Statistics" in the "Description" WYSIWYG editor
      And I select "Published" from "Change to"
      And I press "Save"
    #Verify reports and statistics new titles on dataset
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the link "Behat Report - edited"
      And I should see the link "Behat Statistics - edited"
    #Delete relation to dataset from reports and statistics pages
    When I am logged in as a user with the "Content Approver" role
      And I am on "/reports-statistics/behat-report-edited/edit"
      And I click "Related Content"
      And I click on the element with css selector "#edit-field-associated-datasets-0-remove-button"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT Dataset"
    When I am on "/reports-statistics/behat-statistics-edited/edit"
      And I click "Related Content"
      And I click on the element with css selector "#edit-field-associated-datasets-0-remove-button"
      And I wait for ajax to finish
      And I press "Save"
    Then I should not see the link "BEHAT Dataset"
    #Verify relationships on dataset AFTER delete
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should not see the link "Behat Report - edited"
      And I should not see the link "Behat Statistics - edited"

  @api @javascript
  Scenario: Delete Related Reports & Statistics Node and Check Reports & Statistics to Dataset Two way Sync
    Given "statistics" content:
      | title            | field_summary | body                     | field_r_and_s_category | moderation_state | field_reviewer | nid   |
      | Behat Report     | behat short   | Testing Behat Report     | REPORTS                | published        | approver       | 35252 |
      | Behat Statistics | Short stat    | Testing Behat Statistics | Statistics             | published        | approver       | 35253 |
      And "data_set" content:
        | title         | field_summary       | field_dataset_description | field_reviewer | moderation_state | field_owner  | field_division_office_multi | field_data_category | open_government_data_act_interna | field_open_government_data_acces | field_open_government_data_class | field_related_reports_statistics |
        | BEHAT Dataset | BEHAT Short Summary | Dataset 10 description    | approver       | published        | new division | division1                   | category1           | private                          | DAaccess                         | DAclassification                 | Behat Report, Behat Statistics   |
    #Verify existing two way relationships
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Report"
      And I should see the link "Behat Statistics"
    When I am on "/reports-statistics/behat-report"
    Then I should see the heading "Behat Report"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/reports-statistics/behat-statistics"
    Then I should see the heading "Behat Statistics"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    #Delete related r&s node and check for two way relationships
    When I am logged in as a user with the "Content Approver" role
      And I am on "/reports-statistics/behat-report/delete"
      And I press "Delete"
    Then I should see the text "The Reports and Statistics Behat Report has been deleted."
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Content"
    Then I should not see the text "Behat Related Insight 1"
      And the "edit-field-related-reports-statistics-0-target-id" field should not contain "Behat Report (35252)"
      And the "edit-field-related-reports-statistics-0-target-id" field should contain "Behat Statistics (35253)"
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Statistics"
      And I should not see the link "Behat Report"

  @api @javascript
  Scenario: Archived Related Reports & Statistics Node and Check Reports & Statistics to Dataset Two way Sync
    Given "statistics" content:
      | title            | field_summary | body                     | field_r_and_s_category | moderation_state | field_reviewer |
      | Behat Report     | behat short   | Testing Behat Report     | REPORTS                | published        | approver       |
      | Behat Statistics | Short stat    | Testing Behat Statistics | Statistics             | published        | approver       |
      And "data_set" content:
        | title         | field_summary       | field_dataset_description | field_reviewer | moderation_state | field_owner  | field_division_office_multi | field_data_category | open_government_data_act_interna | field_open_government_data_acces | field_open_government_data_class | field_related_reports_statistics |
        | BEHAT Dataset | BEHAT Short Summary | Dataset 10 description    | approver       | published        | new division | division1                   | category1           | private                          | DAaccess                         | DAclassification                 | Behat Report, Behat Statistics   |
    #Verify existing two way relationships
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I click "Related Content" in the "horizotal_tabs" region
      And I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Report"
      And I should see the link "Behat Statistics"
    When I am on "/reports-statistics/behat-report"
    Then I should see the heading "Behat Report"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    When I am on "/reports-statistics/behat-statistics"
    Then I should see the heading "Behat Statistics"
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT Dataset"
    #Unpublish (Archived) related r&s node and check for two way relationships
    When I am logged in as a user with the "Content Approver" role
      And I am on "/reports-statistics/behat-report/edit"
      And I scroll to the bottom
      And I select "Archived" from "Change to"
      And I press the "Save" button
    Then I should see the text "Reports and Statistics Behat Report has been updated."
    When I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Report"
      And I should see the link "Behat Statistics"
      And I should see the text "Unpublished"
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should see the heading "BEHAT Dataset"
      And I should see the text "Related Reports & Statistics"
      And I should see the link "Behat Statistics"
      And I should not see the link "Behat Report"
      And I should not see the text "Unpublished"

  @api @javascript
  Scenario: Add Website Links To Related Documentation for Datasets
    Given "data_insight" content:
      | title          | body             | moderation_state |
      | BEHAt Insight1 | This is the body | published        |
      | BEHAt Insight2 | This is the body | published        |
      And "data_set" content:
        | title              | field_summary       | field_dataset_description | moderation_state | field_owner  | field_reviewer | field_open_government_data_class | field_open_government_data_acces | field_data_category | field_division_office_multi |
        | BEHAT Test Dataset | a short description | a test description        | published        | new division | approver       | DAclassification                 | DAAchild                         | category1           | division2                   |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/datasets/behat-test-dataset/edit"
      And I click "Related Documentation"
      And I press "Add Website"
      And I wait for ajax to finish
      And I fill in "URL" with "https://www.sec.gov"
      And I fill in "Link text" with "SEC.gov home page"
      And I fill in "Link Description" with "This will go to the homepage of SEC"
      And I press "Add Website"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAt Insight1" on the "field_websites[1][subform][field_link][0][uri]" field
      And I fill in "field_websites[1][subform][field_link][0][title]" with "Go to Insight1"
      And I fill in "field_websites[1][subform][field_link_description][0][value]" with "Please click above"
      And I press "Add Website"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAt Insight2" on the "field_websites[2][subform][field_link][0][uri]" field
      And I fill in "field_websites[2][subform][field_link][0][title]" with "No link description"
      And I press "Save"
    Then I should see the text "Dataset BEHAT Test Dataset has been updated."
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-test-dataset"
      And I click "Related Documentation"
    Then I should see the text "Websites"
      And I should see the link "SEC.gov home page"
      And I should see the text "This will go to the homepage of SEC"
      And I should see the link "Go to Insight1"
      And I should see the text "Please click above"
      And I should see the link "No link description"
    When I click "SEC.gov home page"
    Then I should see the text "U.S. Securities and Exchange Commission"
    When I move backward one page
      And I click "Go to Insight1"
    Then I should see the heading "BEHAt Insight1"
    When I move backward one page
      And I click "No link description"
    Then I should see the heading "BEHAt Insight2"

  @api @javascript
  Scenario: Dataset View Page should not display Related Documentation Tab if website has been removed
    Given "data_set" content:
      | title         | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_reviewer | field_division_office_multi | field_data_category | field_owner  | field_open_government_data_class | field_open_government_data_acces |
      | BEHAT Dataset | short         | This is dataset1          | '' - http://test.com        | published        | approver       | division1                   | category1           | new division | DAclassification                 | DAaccess                         |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/datasets/behat-dataset/edit"
      And I click "Related Documentation"
      And I press "Add Website"
      And I wait for ajax to finish
      And I fill in "URL" with "https://www.sec.gov"
      And I fill in "Link text" with "SEC.gov home page"
      And I press "Save"
      And I am on "/datasets/behat-dataset/edit"
      And I click "Related Documentation"
      And I press "field_websites_0_remove"
      And I press "field_websites_0_confirm_remove"
      And I press "Save"
    Then I should not see the link "Related Documentation" in the "horizotal_tabs" region
    When I am logged in as a user with the "authenticated" role
      And I am on "/datasets/behat-dataset"
    Then I should not see the link "Related Documentation" in the "horizotal_tabs" region

  # @api @javascript
  # Scenario: Limit Viewing Access to Dataset Governance Info for Authenticated User
  #   Given I am logged in as a user with the "authenticated user" role
  #   When I am viewing a "data_set" content:
  #     | title                            | BEHAT Dataset Test |
  #     | field_summary                    | short              |
  #     | field_dataset_description        | This is the body   |
  #     | field_division_office_multi      | division1          |
  #     | moderation_state                 | published          |
  #     | field_data_category              | category1          |
  #     | field_owner                      | new division       |
  #     | open_government_data_act_interna | private            |
  #     | field_open_government_data_acces | DAaccess           |
  #     | field_open_government_data_class | DAclassification   |
  #     | field_reviewer                   | approver           |
  #   Then I should see the heading "BEHAT Dataset Test"
  #     And I should not see the link "Governance" in the "horizotal_tabs" region
  #     And I should not see the text "SEC Data Policies"
  #     And I should not see the text "Owner"
  #     And I should not see the link "new division"

  # @api @javascript
  # Scenario: Limit Viewing Access to Dataset Governance Info for Masqueraded Enduser
  #   Given I am logged in as a user with the "Content Approver" role
  #   When I am viewing a "data_set" content:
  #     | title                            | BEHAT Dataset Test |
  #     | field_summary                    | short              |
  #     | field_dataset_description        | This is the body   |
  #     | field_division_office_multi      | division1          |
  #     | moderation_state                 | published          |
  #     | field_data_category              | category1          |
  #     | field_owner                      | new division       |
  #     | open_government_data_act_interna | private            |
  #     | field_open_government_data_acces | DAaccess           |
  #     | field_open_government_data_class | DAclassification   |
  #     | field_reviewer                   | approver           |
  #   Then I should see the heading "BEHAT Dataset Test"
  #     And I should see the link "Governance" in the "horizotal_tabs" region
  #     And I should see the text "SEC Data Policies"
  #     And I should see the text "Owner"
  #     And I should see the link "new division"
  #   When I press "Preview as Enduser"
  #   Then I should see the text "You are masquerading as enduser"
  #     And I should see the heading "BEHAT Dataset Test"
  #     And I should not see the link "Governance" in the "horizotal_tabs" region
  #     And I should not see the text "SEC Data Policies"
  #     And I should not see the text "Owner"
  #     And I should not see the link "new division"
