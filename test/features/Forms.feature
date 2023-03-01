Feature: Create, Edit And Delete A Form
  As a user, I want to be able to search for all the SEC regulatory forms, so that I can discover
  information about the forms, what type of information is filed, and other metadata associated with the forms.

  Background:
    Given "division_office" terms:
      | name                 |
      | division1            |
      | division2            |
      | Rule Making Division |
      | new division         |
      | SEC division         |

  @api @javascript
  Scenario Outline: Authorized Users Can Create A Form
    Given  "roles" terms:
      | name        |
      | BEHAT Role  |
      And "data" terms:
      | name        |
      | BEHAT Case  |
      And "data_structure" terms:
      | name         |
      | BEHAT struct |
      And "cost_category" terms:
      | name       |
      | BEHAT cost |
      And "mission_criticality_mefs_" terms:
      | name      |
      | BEHAT mef |
      And "quality_completeness" terms:
      | name      |
      | BEHAT QCT |
      And "quality_consistency" terms:
      | name      |
      | BEHAT QCO |
      And "quality_timeliness_recency" terms:
      | name      |
      | BEHAT QCR |
      And "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | Form             | Contact         | email@email.com | division1             | published        |
      | Rule             | Contact         | email@email.com | division2             | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "/node/add/forms"
      And I fill in "Title" with "BEHAT Form"
      And I type "BEHAT Form Description" in the "Description" WYSIWYG editor
      And I type "BEHAT Further Details" in the "Further Details" WYSIWYG editor
      And I select "division1" from "Division/Office"
      And I select "Paper" from "Filing Format"
      And I fill in "Number of Pages" with "90"
      And I fill in "Electronic Size" with "6"
      And I fill in "Average Ingestion Volume" with "10"
      And I select "Sensitive PII" from "Sensitivity"
      And I fill in "Annual Burden" with "8"
      And I fill in "Total Annual Burden Hours" with "80"
      And I fill in "Total Annual Filings" with "50"
      And I select "Accounting Certifications" from "Submission Type"
      And I select "Beneficial owner" from "Filing Entity Type"
      And I select "The Securities Exchange Act of 1934" from "Act"
      And I select "BEHAT Case" from "Use Cases" for the "1" option of the "1" row
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "Form"
      And I press "Apply"
      And I wait 2 seconds
      And I check "Form" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait 2 seconds
      And I scroll to the top
      And I click "Governance"
      And I fill in "DAUISP Data Policies" with "http://google.com"
      And I fill in "DAUISP Audit Logs" with "http://drupal.com"
      And I select "BEHAT struct" from "Data Structure Level 0"
      And I select "BEHAT cost" from "Cost Category"
      And I select "BEHAT mef" from "Mission criticality (MEFs)" for the "1" option of the "1" row
      And I select "new division" from "PMEF Divisions/Offices" for the "1" option of the "1" row
      And I fill in "Number of active internal end users" with "1000"
      And I select "BEHAT QCT" from "Completeness Level 0"
      And I select "BEHAT QCO" from "Consistency Level 0"
      And I select "BEHAT QCR" from "Timeliness/Recency Level 0"
      And I press "Save"
    Then I should see the heading "BEHAT Form"
      And I should see the text "BEHAT Form Description"
      And I should see the text "BEHAT Further Details"
      And I should see the text "Division/Office"
      And I should see the link "division1"
      And I should see the text "Contacts"
      And I should see the link "Form Contact"
      And I should see the text "division1"
      And I should see the text "BEHAT Role"
      And I should see the text "Filing Format"
      And I should see the text "Paper"
      And I should see the text "Sensitivity"
      And I should see the text "Sensitive PII"
      And I should see the text "Annual Burden"
      And I should see the text "8"
      And I should see the text "10"
      And I should see the text "Total Annual Burden Hours"
      And I should see the text "Total Annual Filings"
      And I should see the text "Submission Type"
      And I should see the text "Accounting Certifications"
      And I should see the text "Filing Entity Type"
      And I should see the text "Beneficial owner"
      And I should see the text "Act"
      And I should see the text "BEHAT Case"
      And I should see the text "The Securities Exchange Act of 1934"
      And I should see the text "BEHAT struct"
      And I should see the text "BEHAT cost"
      And I should see the text "BEHAT mef"
      And I should see the link "new division"
      And I should see the text "1000"
      And I should see the text "BEHAT QCT"
      And I should see the text "BEHAT QCO"
      And I should see the text "BEHAT QCR"
      And I should not see the text "Number of Pages"
      And I should not see the text "Electronic Size"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario: Forms Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "forms" content:
      | title            | BEHAT Form             |
      | body             | Description about Form |
      | moderation_state | published              |
      And I wait 3 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
    Then I should see the text "Edit Forms BEHAT Form"

  @api @javascript
  Scenario Outline: Authorized Users Can Edit An Existing Form
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "forms" content:
      | title                   | BEHAT Form                 |
      | body                    | Description about Form     |
      | field_further_details   | Further details            |
      | field_division_office   | division2                  |
      | field_filing_format     | Paper                      |
      | field_paper_size        | 6                          |
      | field_electronic_size   | 7                          |
      | field_rulemaking_office | division1                  |
      | field_act               | The Securities Act of 1933 |
      | moderation_state        | published                  |
    Then I should see the heading "BEHAT Form"
      And I should see the text "Further details"
      And I should see the text "Paper"
      And I should see the text "Rulemaking Office"
      And I should see the text "The Securities Act of 1933"
      And I should see the link "division1"
      And I should not see "Sensitivity"
      And I should not see "Annual Burden"
      And I should not see "Total Annual Burden Hours"
      And I should not see "Total Annual Filings"
      And I should not see "Submission Type"
      And I should not see "Filing Entity Type"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Form" row
      And I fill in "Title" with "BEHAT Form Edited"
      And I select "Rule Making Division" from "Rulemaking Office"
      And I select "Electronic" from "Filing Format"
      And I select "Sensitive PII" from "Sensitivity"
      And I fill in "Annual Burden" with "99"
      And I fill in "Total Annual Burden Hours" with "50"
      And I fill in "Total Annual Filings" with "400"
      And I select "The Investment Company Act of 1940" from "Act"
      And I press "Save"
      And I should see "Forms BEHAT Form Edited has been updated."
      And I click "BEHAT Form Edited"
    Then I should see the heading "BEHAT Form Edited"
      And I should see "Sensitivity"
      And I should see "Annual Burden"
      And I should see "Electronic"
      And I should see "Total Annual Burden Hours"
      And I should see "Total Annual Filings"
      And I should see the text "Rulemaking Office"
      And I should see the link "Rule Making Division"
      And I should see the text "The Investment Company Act of 1940"
      And I should not see the text "The Securities Act of 1933"
      And I should not see the link "division1"
      And I should not see "Submission Type"
      And I should not see "Filing Entity Type"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario Outline: Authorized Users Can Delete A Form
    Given "forms" content:
      | title      | body                   | field_further_details |
      | BEHAT Form | Description about Form | Further Details       |
      And I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Form" row
      And I click "Delete" in the "node_action" region
      And  I press the "Delete" button
    Then I should see "The Forms BEHAT Form has been deleted."
    When I am on "/admin/content"
    Then I should not see the link "BEHAT Form"

    Examples:
      | role             |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

  @api @javascript
  Scenario: Content Creator Can Edit A Form
    Given I am logged in as a user with the "Content Creator" role
    When I am viewing a "forms" content:
      | title                 | BEHAT Form             |
      | body                  | Description about Form |
      | field_further_details | Further details        |
      | field_division_office | division2              |
      | field_filing_format   | Paper                  |
      | field_paper_size      | 6                      |
      | field_electronic_size | 7                      |
      | moderation_state      | published              |
    Then I should see the heading "BEHAT Form"
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Form" row
      And I fill in "Title" with "BEHAT Forum Edited"
      And I press "Save"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content"
      And I click "Moderated content"
      And I click "BEHAT Forum Edited"
      And I press "Apply"
    Then I should see "The moderation state has been updated."
      And  I should see the heading "BEHAT Forum Edited"

  @api @javascript
  Scenario: Content Creator Can Not Delete A Form
    Given "forms" content:
      | title      | body                   | field_further_details | moderation_state |
      | BEHAT Form | Description about Form | Further Details       | published        |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/forms/behat-form/delete"
    Then I should see "Access Denied"

  @api @javascript
  Scenario: Verify User Can Filter Forms
    Given "forms" content:
      | title      | body                   | field_further_details | moderation_state |
      | BEHAT Form | Description about Form | Further Details       | published        |
      And "data_set" content:
      | title         | field_dataset_description | field_dataset_source_type | moderation_state |
      | BEHAT Dataset | Dataset description       | NRSRO, DBRS               | published        |
      And "article" content:
      | title         | body        | field_category | moderation_state |
      | BEHAT Article | article one | FAQ            | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
    Then I should see the link "BEHAT Form"
      And I should see the link "BEHAT Dataset"
      And I should see the link "BEHAT Article"
    When I select "Forms" from "Content type"
      And I press "Filter"
    Then I should see the link "BEHAT Form"
      And I should not see the link "BEHAT Dataset"
      And I should not see the link "BEHAT Article"

  @api @javascript
  Scenario: Verify Fields, Error Messages, And Help Text
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/forms"
      And I fill in "Number of Pages" with "90000000"
      And I fill in "Electronic Size" with "600000000000.56"
      And I fill in "Annual Burden" with "80000000000.89"
      And I fill in "Total Annual Burden Hours" with "80000000"
      And I fill in "Total Annual Filings" with "8000000"
      And I scroll to the top
      And I click "Governance"
      And I fill in "DAUISP Data Policies" with "p"
      And I press "Save"
    Then I should see "Title field is required."
      # Verify Error Messages
      And I should see "Number of Pages must be lower than or equal to 999999."
      And I should see "Electronic Size must be lower than or equal to 9999999999.99."
      And I should see "Annual Burden must be lower than or equal to 9999999999.99."
      And I should see "Total Annual Burden Hours must be lower than or equal to 9999999."
      And I should see "Total Annual Filings must be lower than or equal to 999999."
      And I should see "Manually entered paths should start with one of the following characters: / ? #"
      # Verify Fields on General
      And I should see the text "Title"
      And I should see the text "Description"
      And I should see the text "Further Details"
      And I should see the text "Division/Office"
      And I should see the text "Rulemaking Office"
      And I should see the text "Filing Format"
      And I should see the text "Number of Pages"
      And I should see the text "Electronic Size"
      And I should see the text "Average Ingestion Volume"
      And I should see the text "Sensitivity"
      And I should see the text "Annual Burden"
      And I should see the text "Total Annual Burden Hours"
      And I should see the text "Total Annual Filings"
      And I should see the text "Submission Type"
      And I should see the text "Filing Entity Type"
      And I should see the text "Act"
      And I should see the text "Use Cases"
      # Verify Help text on General
      And I should see the text "Enter number of pages, which must be between 0 and 999,999 inclusive."
      And I should see the text "Enter electronic size, which must be between 0 and 9,999,999,999.99 inclusive."
      And I should see the text "Average data volume of each ingestion and provisioning cycle (in GB)"
      And I should see the text "Enter annual burden, which must be between 0 and 9,999,999,999.99 inclusive."
      And I should see the text "Enter total annual burden hours, which must be between 0 and 9,999,999 inclusive."
      And I should see the text "Enter total annual filings, which must be between 0 and 999,999 inclusive."
      And I should see the text "What are the common use cases?"
      And I scroll to the top
      And I click "Governance"
      #Verify Fields on Governance
      And I should see the text "DAUISP Data Policies"
      And I should see the text "DAUISP Audit Logs"
      And I should see the text "Data Structure"
      And I should see the text "Cost Category"
      And I should see the text "Mission criticality (MEFs)"
      And I should see the text "PMEF Divisions/Offices"
      And I should see the text "Number of active internal end users"
      And I should see the text "Completeness"
      And I should see the text "Consistency"
      And I should see the text "Timeliness/Recency"
      #verify Help text on Governance
      And I should see the text "This must be an external URL such as http://example.com."
      And I should see the text "Qualitative description of primary cost related to owning/processing this data"
      And I should see the text "Does this data support essential functions?"
      And I should see the text "High: All desired use cases can be implemented without restrictions based on available data"
      And I should see the text "Medium: Certain use cases cannot be implemented or use cases do not deliver their full desired value due to data sparseness"
      And I should see the text "Low: Data sparseness is so high that most desired use cases would not deliver satisfactory value"

  @api @javascript
  Scenario: Forms List Page Sorting And Pagination
    Given "forms" content:
      | title          | body                   | field_division_office | field_filing_format | field_sensitivity | field_submission_type                    | field_act                           | moderation_state | changed  |
      | A BEHAT Form1  | Description about Form | new division          | Paper               | Sensitive PII     | Accounting Certifications                | The Securities Act of 1933          | published        | -2 days  |
      | B BEHAT Form2  | Description about Form | division1             | Paper               | Market Sensitive  | Advisors Act Registration                | The Securities Act of 1933          | published        | -10 days |
      | C BEHAT Form3  | Description about Form | SEC division          | Paper               | Market Sensitive  | Accounting Certifications                | The Investment Advisors Act of 1940 | published        | -15 days |
      | D BEHAT Form4  | Description about Form | division2             | Electronic          | Sensitive PII     | Trust Indenture Filings                  | The Securities Act of 1933          | published        | -20 days |
      | E BEHAT Form5  | Description about Form | new division          | Electronic          | Market Sensitive  | Beneficial Ownership Reports             | The Securities Exchange Act of 1934 | published        | -15 days |
      | F BEHAT Form6  | Description about Form | division2             | Electronic          | Non-sensitive     | Beneficial Ownership Reports             | The Securities Exchange Act of 1934 | published        | +1 days  |
      | G BEHAT Form7  | Description about Form | division1             | Paper               | SEC Sensitive     | Confidential Treatment Application       | The Investment Advisors Act of 1940 | published        | +5 days  |
      | H BEHAT Form8  | Description about Form | SEC division          | Paper               | Sensitive PII     | EDGAR Generated                          | The Securities Exchange Act of 1934 | published        | +2 days  |
      | I BEHAT Form9  | Description about Form | division2             | Electronic          | SEC Sensitive     | EDGAR Generated                          | The Investment Company Act of 1940  | published        | + 7 days |
      | J BEHAT Form10 | Description about Form | SEC division          | Electronic          | Sensitive PII     | Exceptive Applications                   | The Securities Exchange Act of 1934 | published        | + 9 days |
      | K BEHAT Form11 | Description about Form | division1             | Paper               | SEC Sensitive     | Exceptive Applications                   |                                     | published        | +10 days |
      | L BEHAT Form12 | Description about Form | SEC division          | Electronic          | Sensitive PII     | Exempt Offerings                         | The Securities Exchange Act of 1934 | published        | +50 days |
      | M BEHAT Form13 | Description about Form | division1             | Paper               | Internal          | Exempt Offerings                         | The Investment Advisors Act of 1940 | published        | -50 days |
      | N BEHAT Form14 | Description about Form | division1             | Electronic          | Sensitive PII     | Extension of Time (notices and requests) | The Investment Company Act of 1940  | published        | -25 days |
      | O BEHAT Form15 | Description about Form | new division          | Paper               | Internal          | Accounting Certifications                | The Investment Company Act of 1940  | published        | -30 days |
      | P BEHAT Form16 | Description about Form | division1             | Electronic          | Sensitive PII     | Extension of Time (notices and requests) | The Investment Company Act of 1940  | published        | +30 days |
      | Q BEHAT Form17 | Description about Form | division1             | Paper               | Internal          | Accounting Certifications                | The Securities Exchange Act of 1934 | published        | +3 days  |
      | R BEHAT Form18 | Description about Form | new division          | Electronic          | Non-sensitive     | Filing Review Correspondence             | The Securities Act of 1933          | published        | +6 days  |
      | S BEHAT Form19 | Description about Form | new division          | Paper               | Internal          | Accounting Certifications                | The Securities Act of 1933          | published        | -6 days  |
      | T BEHAT Form20 | Description about Form | division1             | Electronic          | Sensitive PII     | Filing Review Correspondence             | The Investment Company Act of 1940  | published        | -3 days  |
      | U BEHAT Form21 | Description about Form | division1             | Paper               | Non-sensitive     | Registration Withdraw Form               | The Securities Exchange Act of 1934 | published        | +8 days  |
      | V BEHAT Form22 | Description about Form | new division          | Electronic          | Sensitive PII     | Registration Withdraw Form               | The Trust Indenture Act of 1939     | published        | -8 days  |
      | W BEHAT Form23 | Description about Form | division1             | Paper               | Sensitive PII     | Section 16 Reports                       | The Investment Company Act of 1940  | published        | +4 days  |
      | X BEHAT Form24 | Description about Form | SEC division          | Paper               | Non-sensitive     | SBIC Report                              | The Trust Indenture Act of 1939     | published        | -1 days  |
      | Y BEHAT Form25 | Description about Form | new division          | Paper               | Sensitive PII     | Hardship Extension                       | The Trust Indenture Act of 1939     | published        |          |
    When I am logged in as a user with the "authenticated user" role
      # /forms view is currently disabled but the below steps work when forms view is enabled
      And I am on "/forms"
    Then I should see the link "Title"
      And I should see the link "Division/Office"
      And I should see the link "Sensitivity"
      And I should see the link "Act"
      And I should see the link "Submission Type"
      And I should see the link "Updated"
      And I wait 1 seconds
    When I click "Division"
    Then I should see the link "division1" before I see the link "division2" in the "results_view" region
    Then I should see the link "division2" before I see the link "new division" in the "results_view" region
      And I wait 1 seconds
    When I click "Submission Type"
      And I wait 2 seconds
    Then I should see the text "Accounting Certifications" before I see the text "Advisors Act Registration" in the "results_view" region
      And I should see the text "Beneficial Ownership Reports" before I see the text "Confidential Treatment Application" in the "results_view" region
      And I should see the text "EDGAR Generated" before I see the text "Exceptive Applications" in the "results_view" region
      And I wait 1 seconds
    When I click "Act"
      And I wait 2 seconds
    Then I should see the text "The Investment Company Act of 1940" before I see the text "The Securities Act of 1933" in the "results_view" region
      And I should see the text "The Securities Act of 1933" before I see the text "The Securities Exchange Act of 1934" in the "results_view" region
    When I click "Title"
      And I wait 2 seconds
    Then I should see the link "A BEHAT Form1" before I see the link "B BEHAT Form2" in the "results_view" region
      And I should see the link "C BEHAT Form3" before I see the link "D BEHAT Form4" in the "results_view" region
      And I should see the link "Q BEHAT Form17" before I see the link "R BEHAT Form18" in the "results_view" region
      And I click "Last"
      And I wait 2 seconds
      And I should see the link "V BEHAT Form22" before I see the link "W BEHAT Form23" in the "results_view" region
      And I should see the link "X BEHAT Form24" before I see the link "Y BEHAT Form25" in the "results_view" region
      And I click "First"
      And I wait 1 seconds
    When I click "Updated"
      And I wait 2 seconds
    Then I should see the link "M BEHAT Form13" before I see the link "O BEHAT Form15" in the "results_view" region
      And I should see the link "N BEHAT Form14" before I see the link "D BEHAT Form4" in the "results_view" region
      And I should see the link "V BEHAT Form22" before I see the link "S BEHAT Form19" in the "results_view" region
      And I click "Last"
      And I wait 2 seconds
      And I should see the link "P BEHAT Form16" before I see the link "L BEHAT Form12" in the "results_view" region
      And I should see the link "J BEHAT Form10" before I see the link "K BEHAT Form11" in the "results_view" region
      And I click "First"
      And I wait 1 seconds
    When I click "Sensitivity"
      And I wait 2 seconds
    Then I should see the text "Internal" before I see the text "Market Sensitive" in the "results_view" region
      And I should see the text "Market Sensitive" before I see the text "Non-sensitive" in the "results_view" region

  @api
  Scenario Outline: Forms List Page Filter
    Given "forms" content:
      | title          | body                   | field_division_office | field_filing_format | field_sensitivity | field_submission_type              | field_act                           | moderation_state | changed  |
      | A BEHAT Form1  | Description about Form | new division          | Paper               | Sensitive PII     | Accounting Certifications          | The Securities Act of 1933          | published        | -2 days  |
      | B BEHAT Form2  | Description about Form | division1             | Paper               | Market Sensitive  | Advisors Act Registration          | The Securities Exchange Act of 1934 | published        | -10 days |
      | C BEHAT Form3  | Description about Form | SEC division          | Paper,Electronic    | Internal          | Accounting Certifications          |                                     | published        | -15 days |
      | D BEHAT Form4  | Description about Form | division2             | Electronic          | Sensitive PII     | Trust Indenture Filings            | The Securities Exchange Act of 1934 | published        | -20 days |
      | E BEHAT Form5  | Description about Form | new division          | Electronic          | Market Sensitive  | Beneficial Ownership Reports       | The Investment Company Act of 1940  | published        | -15 days |
      | F BEHAT Form6  | Description about Form | division2             | Electronic          | Non-sensitive     | Exempt Offerings                   |                                     | published        | +1 days  |
      | G BEHAT Form7  | Description about Form | division1             | Paper               | SEC Sensitive     | Confidential Treatment Application | The Investment Company Act of 1940  | published        | +5 days  |
      | H BEHAT Form8  | Description about Form | SEC division          | Paper               | Sensitive PII     | EDGAR Generated                    |                                     | published        | +2 days  |
      | I BEHAT Form9  | Description about Form | division2             | Electronic          | SEC Sensitive     | Hardship Extension                 | The Investment Company Act of 1940  | published        | + 7 days |
      | J BEHAT Form10 | Description about Form | SEC division          | Electronic, Paper   | Non-sensitive     | Exceptive Applications             |                                     | published        | + 9 days |
      | K BEHAT Form11 | Description about Form | new division          | Electronic          | Non-sensitive     | Exceptive Applications             |                                     | published        | + 9 days |
      | L BEHAT Form12 | Description about Form | division1             | Electronic, Paper   | SEC Sensitive     | Exceptive Applications             |                                     | published        | + 9 days |
      And I am logged in as a user with the "authenticated user" role
      # /forms view is currently disabled but the below steps work when forms view is enabled
      And I am on "/forms"
    When I select "<item>" from "<dropdown>"
      And I press "Apply"
      And I wait 2 seconds
    Then I should see the link "<result1>"
      And I should see the link "<result2>"
      And I should see the link "<result3>"
      And I should not see the link "<result4>"
      And I should not see the link "<result5>"
      And I should not see the link "<result6>"

    Examples:
      | item                                | dropdown                   | result1        | result2        | result3        | result4        | result5        | result6        |
      | division1                           | Division/Office            | B BEHAT Form2  | G BEHAT Form7  | L BEHAT Form12 | A BEHAT Form1  | C BEHAT Form3  | D BEHAT Form4  |
      | division2                           | Division/Office            | D BEHAT Form4  | F BEHAT Form6  | I BEHAT Form9  | E BEHAT Form5  | A BEHAT Form1  | B BEHAT Form2  |
      | SEC division                        | Division/Office            | H BEHAT Form8  | C BEHAT Form3  | J BEHAT Form10 | A BEHAT Form1  | L BEHAT Form12 | D BEHAT Form4  |
      | new division                        | Division/Office            | A BEHAT Form1  | E BEHAT Form5  | K BEHAT Form11 | B BEHAT Form2  | C BEHAT Form3  | D BEHAT Form4  |
      | Paper                               | Filing Format              | A BEHAT Form1  | B BEHAT Form2  | C BEHAT Form3  | D BEHAT Form4  | E BEHAT Form5  | F BEHAT Form6  |
      | Electronic                          | Filing Format              | C BEHAT Form3  | D BEHAT Form4  | E BEHAT Form5  | A BEHAT Form1  | B BEHAT Form2  | G BEHAT Form7  |
      | Sensitive PII                       | Sensitivity Classification | A BEHAT Form1  | D BEHAT Form4  | H BEHAT Form8  | B BEHAT Form2  | C BEHAT Form3  | L BEHAT Form12 |
      | Market Sensitive                    | Sensitivity Classification | B BEHAT Form2  | E BEHAT Form5  |                | A BEHAT Form1  | F BEHAT Form6  | K BEHAT Form11 |
      | Internal                            | Sensitivity Classification | C BEHAT Form3  |                |                | A BEHAT Form1  | D BEHAT Form4  | K BEHAT Form11 |
      | Non-sensitive                       | Sensitivity Classification | F BEHAT Form6  | J BEHAT Form10 | K BEHAT Form11 | L BEHAT Form12 | G BEHAT Form7  | B BEHAT Form2  |
      | SEC Sensitive                       | Sensitivity Classification | G BEHAT Form7  | I BEHAT Form9  | L BEHAT Form12 | K BEHAT Form11 | J BEHAT Form10 | F BEHAT Form6  |
      | Accounting Certifications           | Submission Type            | A BEHAT Form1  | C BEHAT Form3  |                | K BEHAT Form11 | B BEHAT Form2  | D BEHAT Form4  |
      | Exceptive Applications              | Submission Type            | L BEHAT Form12 | K BEHAT Form11 | J BEHAT Form10 | F BEHAT Form6  | B BEHAT Form2  | D BEHAT Form4  |
      | Confidential Treatment Application  | Submission Type            | G BEHAT Form7  |                |                | F BEHAT Form6  | B BEHAT Form2  | D BEHAT Form4  |
      | The Securities Act of 1933          | Act                        | A BEHAT Form1  |                |                | F BEHAT Form6  | B BEHAT Form2  | C BEHAT Form3  |
      | The Securities Exchange Act of 1934 | Act                        | B BEHAT Form2  | D BEHAT Form4  |                | F BEHAT Form6  | K BEHAT Form11 | E BEHAT Form5  |
      | The Investment Company Act of 1940  | Act                        | E BEHAT Form5  | G BEHAT Form7  | I BEHAT Form9  | F BEHAT Form6  | K BEHAT Form11 | J BEHAT Form10 |

  @api @javascript
  Scenario: Add Multiple Use Cases
    Given I am logged in as a user with the "Content Creator" role
      And "data" terms:
      | name         |
      | BEHAT Case 1 |
      | BEHAT Case 2 |
    When I am on "/node/add/forms"
      And I fill in "Title" with "behat form"
      And I select "BEHAT Case 1" from "Use Cases" for the "1" option of the "1" row
      And I press "Add another item"
      And I wait for ajax to finish
      And I select "BEHAT Case 2" from "Use Cases" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the link "BEHAT Case 1"
      And I should see the link "BEHAT Case 2"
    When I am on "/forms/behat-form/edit"
      And I select "- Please select -" from "Use Cases" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the link "BEHAT Case 1"
      And I should not see the link "BEHAT Case 2"

  @api @javascript
  Scenario: Add Multiple Terms
    Given I am logged in as a user with the "Content Creator" role
      And "mission_criticality_mefs_" terms:
      | name      |
      | BEHAT mef |
      | BEHAT tbd |
    When I am on "/node/add/forms"
      And I fill in "Title" with "behat form"
      And I click "Governance"
      And I select "BEHAT mef" from "Mission criticality (MEFs)" for the "1" option of the "1" row
      And I click on the element with css selector "#edit-field-mission-criticality-mefs-add-more"
      And I wait for ajax to finish
      And I select "BEHAT tbd" from "Mission criticality (MEFs)" for the "1" option of the "2" row
      And I select "new division" from "PMEF Divisions/Offices" for the "1" option of the "1" row
      And I click on the element with css selector "#edit-field-pmef-divisions-offices-add-more"
      And I wait for ajax to finish
      And I select "SEC division" from "PMEF Divisions/Offices" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the link "BEHAT mef"
      And I should see the link "BEHAT tbd"
      And I should see the link "new division"
      And I should see the link "SEC division"
    When I am on "/forms/behat-form/edit"
      And I click "Governance"
      And I select "- Please select -" from "Mission criticality (MEFs)" for the "1" option of the "2" row
      And I select "- Please select -" from "PMEF Divisions/Offices" for the "1" option of the "2" row
      And I press "Save"
    Then I should see the link "BEHAT mef"
      And I should not see the link "BEHAT tbd"
      And I should see the link "new division"
      And I should not see the link "SEC division"
