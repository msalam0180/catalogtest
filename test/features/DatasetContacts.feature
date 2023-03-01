Feature: Create And View New Contacts For Dataset
  As a content creator
  I want to be able to create new Contact on the dataset create page. So that visitors
  to the site would be able to see details about a dataset and can find out more about
  a dataset, specifically information about who to contact regarding that dataset.

  Background:
    Given users:
    | name     | mail              | roles            |
    | approver | approver@test.com | Content Approver |
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
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |

  @api @javascript
  Scenario Outline: Create a Dataset With New Contact
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Contact"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "new division" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Governance"
      And I select "division1" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I scroll to the top
      And I click "Contacts"
      And I fill in "Contact Guidance" with "This is contact guidance"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "Behat" for "First Name"
      And I fill in "Contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Contact" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "Point of Contact" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset Contact"
      And I should see the link "Behat Contact" in the "contacts" region
      And I should see the text "(division1)" in the "contacts" region
      And I should see the text "Point of Contact" in the "contacts" region
      And I should see the text "This is contact guidance" in the "contacts" region
      And I close the current window

      Examples:
        | role             |
        | Sitebuilder      |
        | Content Approver |

  @api @javascript
  Scenario: Add New COR To A Dataset
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset COR Contact"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "new division" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Governance"
      And I select "division1" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "behat" for "First Name"
      And I fill in "contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "contact" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "Contract Officer Representative (COR)" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "BEHAT Dataset COR Contact"
      And I click "Contacts"
      And I should see the text "Contract Officer Representative (COR)" in the "contacts" region
      And I should see the link "behat contact" in the "contacts" region
      And I should see the text "behat contact (division1)" in the "contacts" region
      And I close the current window

  @api @javascript
  Scenario: Add Existing COR To A Dataset
    Given "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | behat            | contact         | email@email.com | DERA                  | published        |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/node/add/data_set"
      And I fill in "Title" with "BEHAT Existing COR Contact"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "new division" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select "category1" from "Data Category for Landing Page Display"
      And I scroll to the top
      And I click "Governance"
      And I select "division1" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "behat" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "Contract Officer Representative (COR)" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the heading "BEHAT Existing COR Contact"
      And I click "Contacts"
      And I should see the text "Contract Officer Representative (COR)" in the "contacts" region
      And I should see the link "behat contact" in the "contacts" region
      And I should see the text "behat contact (DERA)" in the "contacts" region
