Feature: Create Forms For WDIO
  As a user, I want to be able to search for all the SEC regulatory forms, so that I can discover
  information about the forms, what type of information is filed, and other metadata associated with the forms.

  @ui @api @javascript @wdio
  Scenario: Create A Form For WDIO
    Given "division_office" terms:
      | name      |
      | division1 |
      And "roles" terms:
      | name       |
      | BEHAT Role |
      And "data" terms:
      | name       |
      | BEHAT Case |
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
      And I am logged in as a user with the "Content Approver" role
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
      And I press "Add existing Contact"
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
      And I select "BEHAT struct" from "Data Structure Level 1"
      And I select "BEHAT cost" from "Cost Category"
      And I select "BEHAT mef" from "Mission criticality (MEFs)" for the "1" option of the "1" row
      And I select "new division" from "PMEF Divisions/Offices" for the "1" option of the "1" row
      And I fill in "Number of active internal end users" with "1000"
      And I select "BEHAT QCT" from "Completeness Level 1"
      And I select "BEHAT QCO" from "Consistency Level 1"
      And I select "BEHAT QCR" from "Timeliness/Recency Level 1"
      And I select "Published" from "Save as"
      And I press "Save"
    Then I take a screenshot using "form.feature" file with "@form_all" tag
