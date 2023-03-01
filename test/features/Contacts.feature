Feature: Create And View Contacts
  As a content creator
  I want to be able to create new Contact. So that visitors
  to the site would be able to see contact information. Other  can find out more about
  a dataset, specifically information about who to contact.

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
      And "roles" terms:
      | name        | parent      |
      | BEHAT Role  |             |
      | BEHAT Role3 |             |
      | BEHAT Role4 | BEHAT Role3 |
      And "contact" content:
      | field_first_name | field_last_name | field_email     | moderation_state | field_division_office |
      | firstname        | lastname        | user@email.com  | published        | division1             |
      | firstname2       | lastname        | user2@email.com | published        | division2             |
      | Tom Jeffrey      | Yanks           | user3@email.com | published        | new division          |
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

  @api
  Scenario Outline: Authorized Users Can Create A Contact
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/contact"
      And I fill in "First Name" with "First"
      And I fill in "Last Name" with "Last"
      And I fill in "Email" with "First@Last.name"
      And I select "division1" from "Division/Office"
      And I publish it
    Then I should see the text "First Last"
      And I should see the text "First@Last.name"

      Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Adding Single Existing Contact To Application
    Given "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "application" content:
      | title             | body        | field_summary | moderation_state | field_owner | field_division_office_multi | field_reviewer | field_app_status |
      | BEHAT Application | description | summary       | draft            | division2   | division1                   | approver       | BEHAT Status A   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname2 lastname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname2" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/applications/behat-application/"
      And I should see the text "Contact"
      And I should see the link "firstname2 lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Manually Adding Contact To Application
    Given "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "application" content:
      | title             | body        | field_summary | field_owner | field_division_office_multi | moderation_state | field_app_status |
      | BEHAT Application | description | summary       | division2   | division1                   | draft            | BEHAT Status A   |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I should see the text "If a person is not in the list of Existing Contacts, you must first create the Contact using the Admin menu (Content >> Add content >> Contact)."
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "fname" for "First Name"
      And I fill in "lname" for "Last Name"
      And I fill in "email@uio.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "lname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "lname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/applications/behat-application/"
      And I should see the text "Contact"
      And I should see the link "fname lname"
      And I should see the text "(division1)"
      And I should see the text "BEHAT Role4"
      And I close the current window

  @api @javascript
  Scenario: Adding Multiple Contacts To Application
    Given "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "application" content:
      | title             | body        | field_summary | field_owner | moderation_state | field_division_office_multi | field_app_status |
      | BEHAT Application | description | summary       | division1   | draft            | division1                   | BEHAT Status A   |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "fname" for "First Name"
      And I fill in "lname" for "Last Name"
      And I fill in "email@uio.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "lname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "lname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/applications/behat-application/"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the link "fname lname"
      And I should see the text "(division1)"
      And I should see the text "BEHAT Role"
      And I should see the text "Role4"
      And I close the current window

  @api @javascript
  Scenario: Remove Existing Contact From Application
    Given "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "application" content:
      | title             | body        | field_summary | field_owner | moderation_state | field_division_office_multi | field_app_status |
      | BEHAT Application | description | summary       | division2   | draft            | division1                   | BEHAT Status A   |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/applications/behat-application"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I click on the element with css selector ".dropbutton-toggle"
      And I click on the element with css selector "input[id^='edit-field-contacts-0-top-links-remove-button']"
      And I click on the element with css selector ".dropbutton--multiple"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/applications/behat-application"
      And I should not see the link "firstname lastname"
      And I should not see the text "BEHAT Role"

  @api @javascript
  Scenario: Update Existing Contacts To Application
    Given "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "application" content:
      | title             | body        | field_summary | field_owner | field_division_office_multi | moderation_state | field_app_status | field_reviewer |
      | BEHAT Application | description | summary       | division1   | division1                   | draft            | BEHAT Status A   | approver       |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/applications/behat-application"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/applications/behat-application/edit"
      And I click "Contacts"
      And I click on the element with css selector "#edit-field-contacts-0-top-links-edit-button"
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-contacts-0-subform-field-contact-entities-0-actions-ief-entity-edit']"
      And I wait for ajax to finish
      And I fill in "First Name" with "firstname update"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/applications/behat-application"
      And I should see the text "Contact"
      And I should see the link "firstname update lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Adding Single Existing Contact To Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Approved           | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component/"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Manually Adding Contact To Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Approved           | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I should see the text "If a person is not in the list of Existing Contacts, you must first create the Contact using the Admin menu (Content >> Add content >> Contact)."
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "fname" for "First Name"
      And I fill in "lname" for "Last Name"
      And I fill in "email@uio.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "lname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "lname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/software/behat-component/"
      And I should see the text "Contact"
      And I should see the link "fname lname"
      And I should see the link "division1"
      And I should see the text "BEHAT Role4"
      And I close the current window

  @api @javascript
  Scenario: Adding Multiple Contacts To Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Approved           | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I press "Save"
      And I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "fname" for "First Name"
      And I fill in "lname" for "Last Name"
      And I fill in "email@uio.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "lname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "lname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component/"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the link "fname lname"
      And I should see the link "division1"
      And I should see the text "BEHAT Role"
      And I should see the text "BEHAT Role4"
      And I close the current window

  @api @javascript
  Scenario: Remove Existing Contacts From Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Approved           | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I click on the element with css selector ".dropbutton-toggle"
      And I click on the element with css selector "input[id^='edit-field-contacts-0-top-links-remove-button']"
      And I click on the element with css selector ".dropbutton--multiple"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component"
      And I should not see the link "firstname lastname"
      And I should not see the text "BEHAT Role"

  @api @javascript
  Scenario: Update Existing Contacts To Software
    Given "component" content:
      | title           | body        | field_summary | moderation_state | field_division_office_multi | field_status_usage | field_reviewer |
      | BEHAT component | description | summary       | draft            | division1                   | Approved           | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/software/behat-component/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I click on the element with css selector "#edit-field-contacts-0-top-links-edit-button"
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-contacts-0-subform-field-contact-entities-0-actions-ief-entity-edit']"
      And I wait for ajax to finish
      And I fill in "First Name" with "firstname update"
      And I wait for ajax to finish
      And I press "Save"
    Then I visit "/software/behat-component"
      And I should see the text "Contact"
      And I should see the link "firstname update lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Create Data Insight With New Contact
    Given I am logged in as a user with the "administrator" role
    When I am on "/node/add/data_insight"
      And I fill in "Title" with "BEHAT Dataset Contact"
      And I fill in "Short Description" with "Behat short"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I click "create the Contact" in the "insight_contact" region
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
      And I fill in "edit-name" with "Behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Contact" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I should see the heading "BEHAT Dataset Contact"
      And I should see the link "Behat Contact"
      And I should see the text "Contacts"
      And I should see the text "BEHAT Role"
      And I close the current window

  @api @javascript
  Scenario: Content Creator Can Create Dataset With New Contact
    Given "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
        | name     |
        | DAaccess |
      And I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset Contact"
      And I fill in "Short Description" with "behat short"
      And I select "category1" from "Data Category"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
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
      And I fill in "edit-name" with "Behat"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Contact" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I scroll to the top
      And I click on the element with css selector "a[href='#edit-group-form']"
      And I press "Add Total Annual Filings"
      And I wait for ajax to finish
      And I fill in "Year" with "2000"
      And I select "Paper" from "Type"
      And I fill in "Number of Filings Received" with "87"
      And I scroll to the top
      And I click "Governance"
      And I select "division2" from "Owner"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I wait for ajax to finish
      And I publish it
    Then I should see the heading "BEHAT Dataset Contact"
      And I click "Contacts"
      And I should see the link "Behat Contact" in the "contacts" region
      And I should see the text "This is contact guidance" in the "contacts" region
      And I close the current window

  @api @javascript
  Scenario: Create Dataset With Existing Contact
    Given "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | behat            | contact         | email@email.com | DERA                  | published        |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
    When I am logged in as a user with the "administrator" role
      And I visit "/node/add/data_set"
      And I fill in "Title" with "BEHAT Dataset with Existing Contact"
      And I fill in "Short Description" with "behat short"
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I scroll to the top
      And I click "Contacts"
      And I fill in "Contact Guidance" with "This is contact guidance"
      And I wait 2 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "behat"
      And I press "Apply"
      And I wait 2 seconds
      And I check "behat" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I click on the element with css selector "a[href='#edit-group-form']"
      And I press "Add Total Annual Filings"
      And I wait for ajax to finish
      And I fill in "Year" with "2000"
      And I select "Paper" from "Type"
      And I fill in "Number of Filings Received" with "87"
      And I scroll to the top
      And I click "Governance"
      And I select "division2" from "Owner"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I should see the heading "BEHAT Dataset with Existing Contact"
      And I scroll to the bottom
      And I click "Contacts"
      And I should see the link "behat contact" in the "contacts" region
      And I should see the text "This is contact guidance" in the "contacts" region

  @api @javascript
  Scenario: Edit Contact From Dataset
    Given "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | MyNew            | contact         | email@email.com | DERA                  | published        |
      And I am logged in as a user with the "administrator" role
      And I am viewing a "data_set" content:
      | title                            | BEHAT Delete dataset Contact |
      | field_summary                    | behat short                  |
      | field_dataset_description        | description                  |
      | field_how_to_request_access      | '' - http://test.com         |
      | field_contact_guidance           | Guidance Contact             |
      | moderation_state                 | published                    |
      | field_reviewer                   | approver                     |
      | field_open_government_data_class | DAclassification             |
      | field_open_government_data_acces | DAaccess                     |
      And I should see the text "Contacts"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Delete dataset Contact" row
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Contacts"
      And I fill in "Edited" for "Contact Guidance"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "MyNew"
      And I press "Apply"
      And I wait 2 seconds
      And I check "MyNew" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-contacts-0-subform-field-contact-entities-0-actions-ief-entity-edit-']"
      And I wait for ajax to finish
      And I fill in "Edited" for "First Name"
      And I click the input with the value "Update Contact"
      And I wait for ajax to finish
      And I should not see the text "MyNew"
      And I scroll to the top
      And I click "Governance"
      And I select "division2" from "Owner"
      And I publish it
      And I should see the text "Dataset BEHAT Delete dataset Contact has been updated."
      And I click "BEHAT Delete dataset Contact"
      And I click "Contacts"
    Then I should see the link "Edited contact" in the "contacts" region
      And I should see the text "Edited" in the "contacts" region

  @api @javascript
  Scenario: Delete Contact From Dataset
    Given "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | MyNew            | contact         | email@email.com | division2             | published        |
      And I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
      | title                            | BEHAT Delete dataset Contact |
      | field_dataset_description        | description                  |
      | field_how_to_request_access      | '' - http://test.com         |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | point_of_contact                 | MyNew contact                |
      | moderation_state                 | published                    |
      | field_reviewer                   | approver                     |
      | field_data_category              | category1                    |
      | field_owner                      | new division                 |
      | field_summary                    | short                        |
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Delete dataset Contact" row
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "MyNew"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "MyNew" on the contact selector
      And I press "Select Contacts"
      And I wait 2 seconds
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I publish it
      And I click "Edit" in the "BEHAT Delete dataset Contact" row
      And I click "Contacts"
      And I press the "List additional actions" button
      And I click on the element with css selector "#edit-field-contacts-0-top-links-remove-button"
      And I wait for ajax to finish
      And I press "Confirm removal"
      And I wait for ajax to finish
    Then I should not see the text "MyNew"
    When I publish it
      And I click "BEHAT Delete dataset Contact"
    Then I should not see the text "Contacts"

  @api @javascript
  Scenario: Adding Single Existing Contact to Platform
    Given "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Approve   | check       | #00695C            |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi |
      | BEHAT platform | description | summary       | draft            | BEHAT Approve      | division1                   |
    When I am logged in as a user with the "Content Approver" role
      And I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform/"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Manually Adding Contact to Platform
    Given "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Approve   | check       | #00695C            |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi |
      | BEHAT platform | description | summary       | draft            | BEHAT Approve      | division1                   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I should see the text "If a person is not in the list of Existing Contacts, you must first create the Contact using the Admin menu (Content >> Add content >> Contact)."
      And I click "create the Contact"
      And the link should open in a new tab
      And I fill in "fname" for "First Name"
      And I fill in "lname" for "Last Name"
      And I fill in "email@uio.com" for "Email"
      And I select "division1" from "Division/Office"
      And I press "Save"
      And I switch to tab "1"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I fill in "edit-name" with "lname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "lname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
       And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should see the text "Contact"
      And I should see the link "fname lname"
      And I should see the text "(division1)"
      And I should see the text "BEHAT Role"
      And I close the current window

  @api @javascript
  Scenario: Adding Multiple Contacts to Platform
    Given "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Approve   | check       | #00695C            |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi |
      | BEHAT platform | description | summary       | draft            | BEHAT Approve      | division1                   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "Tom Jeffrey Yanks"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Tom" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the link "Tom Jeffrey Yanks"
      And I should see the text "(division1)"
      And I should see the text "(new division)"
      And I should see the text "BEHAT Role"
      And I should see the text "BEHAT Role4"

  @api @javascript
  Scenario: Remove Existing Contacts From Platform
    Given "status" terms:
      | name         | field_icon  | field_status_color |
      | BEHAT Retire | leaf        | #AF2525            |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi |
      | BEHAT platform | description | summary       | draft            | BEHAT Retire       | division1                   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I click on the element with css selector ".dropbutton-toggle"
      And I click on the element with css selector "input[id^='edit-field-contacts-0-top-links-remove-button']"
      And I click on the element with css selector ".dropbutton--multiple"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should not see the link "firstname lastname"
      And I should not see the text "BEHAT Role"

  @api @javascript
  Scenario: Update Existing Contacts to Platform
    Given "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Exception | exclamation | #EAAD23            |
      And "platform" content:
      | title          | body        | field_summary | moderation_state | field_status_usage | field_division_office_multi |
      | BEHAT platform | description | summary       | draft            | BEHAT Exception    | division1                   |
      And I am logged in as a user with the "Content Approver" role
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should see the text "Contact"
      And I should see the link "firstname lastname"
      And I should see the text "BEHAT Role"
    When I visit "/platforms/behat-platform/edit"
      And I click "Contacts"
      And I click on the element with css selector "#edit-field-contacts-0-top-links-edit-button"
      And I wait for ajax to finish
      And I click on the element with css selector "input[id^='edit-field-contacts-0-subform-field-contact-entities-0-actions-ief-entity-edit']"
      And I wait for ajax to finish
      And I fill in "First Name" with "firstname update"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I visit "/platforms/behat-platform"
      And I should see the text "Contact"
      And I should see the link "firstname update lastname"
      And I should see the text "BEHAT Role"

  @api @javascript
  Scenario: Adding Contact On Reports And Statistics
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/statistics"
      And I fill in "Title" with "Test Behat Reports And Statistics"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Data Description for Reports" in the "Description" WYSIWYG editor
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
    Then I should see the heading "Test Behat Reports And Statistics"
      And I should see the text "BEHAT Data Description for Reports"
      And I should see the text "Contacts"
      And I should see the link "firstname lastname"
      And I should see the text "division1"
      And I should see the text "BEHAT Role"

  @api
  Scenario Outline: Access To Contact Admin Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content/contacts"
    Then I should see the heading "Search by Contact"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | administrator    |
      | sitebuilder      |

 @api @javascript
  Scenario: Contact Admin List Page
    Given I am logged in as a user with the "Content Approver" role
      And "division_office" terms:
      | name      |
      | division3 |
      | division4 |
      And "status" terms:
      | name            | field_icon  | field_status_color |
      | BEHAT Exception | exclamation | #EAAD23            |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "contact" content:
      | field_first_name | field_last_name | field_email     | moderation_state | field_division_office |
      | behat            | test1           | behat@test1.com | published        | division3             |
      | wdio             | test2           | wdio@test2.com  | published        | division4             |
      And "data_insight" content:
      | title                  | field_summary | body                    | field_insight_date | moderation_state | field_reviewer |
      | Mangoes                | behat short   | fruits description      | 07/28/2019         | published        | approver       |
      And "application" content:
      | title                | body             | field_summary          | field_division_office_multi | moderation_state | field_reviewer | field_app_status | field_owner |
      | New test Application | This is the body | Summary of Application | division1                   | draft            | approver       |  BEHAT Status A  | division1   |
      And "component" content:
      | title                 | body              | field_summary     | field_status    | field_division_office_multi | moderation_state | changed |  field_reviewer | field_status_usage |
      | BEHAT Component D1805 | This is the body  | Component Summary | BEHAT Exception | division1                   | published        | -1 days |  approver       | Approved           |
      And "platform" content:
      | title            | body             | field_summary           | field_division_office_multi | moderation_state | field_reviewer | field_status_usage |
      | New Platform new | This is the body | Summary of new platform | division1                   | published        | approver       | BEHAT Exception    |
    When I am on "/data-insights/mangoes/edit"
      And I click "Contacts"
      And I press "Add Contact"
      And I wait for ajax to finish
      And I select "BEHAT Role" from "Role Level 0"
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Save"
    When I am on "/applications/new-test-application/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "firstname2"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "firstname2" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role3" from "Role Level 0"
      And I select "BEHAT Role4" from "Role Level 1"
      And I press "Save"
    When I am on "/platforms/new-platform-new/edit"
      And I click "Contacts"
      And I wait 1 seconds
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
      And I select "BEHAT Role" from "Role Level 0"
      And I press "Save"
    When I am on "/software/behat-component-d1805/edit"
      And I click "Contacts"
      And I wait 1 seconds
      And I press "Add Contact"
      And I wait for ajax to finish
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the "contacts" selector
      And I wait 1 seconds
      And I fill in "edit-name" with "wdio"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "wdio" on the contact selector
      And I press "Select Contacts"
      And I wait for ajax to finish
      And I switch to the main window
      And I select "BEHAT Role" from "Role Level 0"
      And I press "Save"
    When I am on "/admin/content/contacts"
    Then I should see the text "Contact Details"
      And I should see the text "Contact's Division/Office"
      And I should see the text "Content Title"
      And I should see the text "Content type"
      And I should see the text "Published status"
      And I should see the link "Content ID"
      And I should see the link "Contact ID"
      And I should see the link "BEHAT Component D1805"
      And I should see the text "Component"
      And I should see the link "wdio test2"
      And I should see the link "BEHAT Role"
      And I should see the link "division4"
      And I should see the link "approver"
      And I should see the link "BEHAT Component D1805"
      And I select "division1" from "Division/Office"
      And I press "Filter"
    Then I should see the link "Mangoes"
      And I should not see the link "BEHAT Component D1805"
      And I should not see the link "New Platform new"
      And I should not see the link "New test Application"
    When I press "Reset"
      And I select "Application" from "Content type"
      And I press "Filter"
    Then I should see the link "New test Application"
      And I should not see the link "BEHAT Component D1805"
      And I should not see the link "New Platform new"
      And I should not see the link "Mangoes"
    When I press "Reset"
      And I fill in "Contact Details" with "behat"
      And I press "Filter"
    Then I should see the link "New Platform new"
      And I should not see the link "BEHAT Component D1805"
      And I should not see the link "New test Application"
      And I should not see the link "Mangoes"
    When I press "Reset"
      And I fill in "Contact Details" with "test"
      And I press "Filter"
    Then I should see the link "New Platform new"
      And I should see the link "BEHAT Component D1805"
      And I should not see the link "New test Application"
      And I should not see the link "Mangoes"
    When I press "Reset"
      And I fill in "Content Title" with "mang"
      And I press "Filter"
    Then I should see the link "Mangoes"
      And I should not see the link "BEHAT Component D1805"
      And I should not see the link "New test Application"
      And I should not see the link "New Platform new"
    When I press "Reset"
      And I fill in "Contact Details" with "wdio@test2.com"
      And I press "Filter"
    Then I should see the link "BEHAT Component D1805"
      And I should not see the link "Mangoes"
      And I should not see the link "New test Application"
      And I should not see the link "New Platform new"
    When I press "Reset"
      And I click "Content Title"
    Then "BEHAT Component D1805" should precede "Mangoes" for the query "//td[contains(@class, 'views-field-title')]"
      And "Mangoes" should precede "New Platform new" for the query "//td[contains(@class, 'views-field-title')]"
      And "New Platform new" should precede "New test Application" for the query "//td[contains(@class, 'views-field-title')]"
    When I click "Content Title"
    Then "New test Application" should precede "New Platform new" for the query "//td[contains(@class, 'views-field-title')]"
      And "New Platform new" should precede "Mangoes" for the query "//td[contains(@class, 'views-field-title')]"
      And "Mangoes" should precede "BEHAT Component D1805" for the query "//td[contains(@class, 'views-field-title')]"
    When I press "Reset"
      And I click on the element with css selector "#view-field-contact-table-column > a:nth-child(1)"
    Then "firstname lastname" should precede "firstname2 lastname" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "firstname2 lastname" should precede "behat test1" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "behat test1" should precede "wdio test2" for the query "//td[contains(@class, 'views-field-field-contact')]"
    When I press "Reset"
      And I click "Content ID"
    Then "Mangoes" should precede "New test Application" for the query "//td[contains(@class, 'views-field-title')]"
    And "New test Application" should precede "BEHAT Component D1805" for the query "//td[contains(@class, 'views-field-title')]"
    And "BEHAT Component D1805" should precede "New Platform new" for the query "//td[contains(@class, 'views-field-title')]"
    When I click "Content ID"
    Then "New Platform new" should precede "BEHAT Component D1805" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Component D1805" should precede "New test Application" for the query "//td[contains(@class, 'views-field-title')]"
      And "New test Application" should precede "Mangoes" for the query "//td[contains(@class, 'views-field-title')]"
    When I press "Reset"
      And I click "Contact ID"
    Then "firstname lastname" should precede "firstname2 lastname" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "firstname2 lastname" should precede "behat test1" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "behat test1" should precede "wdio test2" for the query "//td[contains(@class, 'views-field-field-contact')]"
    When I click "Contact ID"
    Then "wdio test2" should precede "behat test1" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "behat test1" should precede "firstname2 lastname" for the query "//td[contains(@class, 'views-field-field-contact')]"
      And "firstname2 lastname" should precede "firstname lastname" for the query "//td[contains(@class, 'views-field-field-contact')]"
    When I click "Edit" in the "Mangoes" row
    Then I should see the text "Edit Data Insight Mangoes"

  @api
  Scenario: Prevent from creating duplicate contact
    #Constraint is only email has to be unique
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/contact"
      And I fill in "First Name" with "fname1"
      And I fill in "Last Name" with "lname1"
      And I fill in "Email" with "First@Last.name"
      And I select "division1" from "Division/Office"
      And I publish it
    Then I should see the text "First@Last.name"
    When I am on "/node/add/contact"
      And I fill in "First Name" with "fname2"
      And I fill in "Last Name" with "lname2"
      And I fill in "Email" with "First@Last.name"
      And I select "division1" from "Division/Office"
      And I publish it
    Then I should see the text "A contact record with this email address already exists. Click here to see this contact record."
    When I click "here"
    Then I should see the text "fname1 lname1"

  @api @javascript
  Scenario Outline: Authorized Users Can Create a Contact
    Given "data_insight" content:
      | title          | body             | moderation_state |
      | BEHAt Insight1 | This is the body | published        |
      | BEHAt Insight2 | This is the body | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/node/add/contact"
      And I fill in "First Name" with "<firstname>"
      And I fill in "Last Name" with "<lastname>"
      And I fill in "Email" with "<email>"
      And I select "division1" from "Division/Office"
      And I fill in "URL" with "https://www.sec.gov"
      And I fill in "Link text" with "SEC link"
      And I press "Add another item"
      And I select the autocomplete option for "BEHAt Insight1" on the "field_associated_websites[1][uri]" field
      And I fill in "field_associated_websites[1][title]" with "Internal link"
      And I press "Add another item"
      And I wait for ajax to finish
      And I select the autocomplete option for "BEHAt Insight2" on the "field_associated_websites[2][uri]" field
      And I fill in "Phone number" with "999-000-2100"
      And I type "This is more helpful information about this contact" in the "Helpful information" WYSIWYG editor
      And I press "Add media"
      And I attach the file "<upload_file>" to "Add file"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "<alt_text>"
      And I click on the element with css selector ".button.button.button--primary.js-form-submit.form-submit.ui-button.ui-corner-all.ui-widget"
      And I wait for ajax to finish
      And I click on the element with css selector "div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div.ui-dialog-buttonset.form-actions > button"
      And I publish it
    Then I should see the text "Contact <firstname> <lastname> has been created."
      And I should see the heading "<firstname> <lastname>"
      And I should see the text "<firstname>"
      And I should see the text "<lastname>"
      And I should see the text "<email>"
      And I should see the text "division1"
      And I should see the link "SEC link"
      And I should see the link "999-000-2100"
      And I should see the text "This is more helpful information about this contact"
      And I should see the link "SEC link"
      And I should see the link "Internal link"
      And I should see the link "/data-insights/behat-insight2"
      And I should see the "img" element with the "alt" attribute set to "<alt_text>" in the "logo" region
      And I should see the "img" element with the "src" attribute set to "<src_file>" in the "logo" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "logo" region
    When I click "SEC link"
      And I switch to tab "2"
    Then I should see the text "U.S. Securities and Exchange Commission"
      And I close tab "2"
    When I switch to tab "1"
      And I click "Internal link"
      And I switch to tab "2"
    Then I should see the text "BEHAt Insight1"
    When I close tab "2"
      And I switch to tab "1"
      And I click "/data-insights/behat-insight2"
      And I switch to tab "2"
    Then I should see the text "BEHAt Insight2"
      And I close the current window

    Examples:
      | role             | firstname | lastname | email            | alt_text            | upload_file      | src_file      |
      | Content Creator  | fname1    | lname1   | first1@Last.name | Bird does tweets    | behat-bird.gif   | /behat-bird   |
      | Content Approver | fname2    | lname2   | first2@Last.name | Cat goes meow meow  | behat-cat.png    | /behat-cat    |
      | sitebuilder      | fname3    | lname3   | first3@Last.name | Dog goes bow wow    | behat-dog.jpeg   | /behat-dog    |
      | administrator    | fname4    | lname4   | first4@Last.name | Rabbit goes bonkers | behat-rabbit.jpg | /behat-rabbit |

  @api @javascript
  Scenario: Create a Contact Using Existing Media
    Given I create "media" of type "image":
      | name        | field_media_image    | field_caption                   |
      | SQL Logo    | behat-sql-logo.png   | Behat SQL Caption               |
      | Edgar Logo  | behat-edgar-logo.png | Behat Edgar Caption             |
      | App Logo    | behat-CreateApp.png  | Behat App Screenshot Caption    |
      | Search Logo | behat-search.png     | Behat Search Screenshot Caption |
    When I am logged in as a user with the "Content Creator" role
      And I am on "/node/add/contact"
      And I fill in "First Name" with "John"
      And I fill in "Last Name" with "Smith"
      And I fill in "Email" with "quality@test.come"
      And I select "division1" from "Division/Office"
      And I press "Add media"
      And I wait for ajax to finish
      And I fill in "Edgar" for "Name"
      And I press "Apply filters"
      And I wait for ajax to finish
      And I check the box "media_library_select_form[0]"
      And I click "Insert selected" on the modal "Add or select media"
      And I wait for ajax to finish
      And I switch to the main window
      And I publish it
    Then I should see the text "Contact John Smith has been created."
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "logo" region
      And I should see the "img" element with the "typeof" attribute set to "foaf:Image" in the "logo" region
