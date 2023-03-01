Feature: The Getting started page can be edited to make it easier for first time users to use
  As an Admin
  I want to be able to edit the getting started page
  So that a site visitor will have an easier time navigating the site.

  @api
  Scenario: Admins Can Edit The Getting Started Page
    Given I am logged in as a user with the "administrator" role
    When I am on "/gettingstarted"
    Then I should see the text "Getting Started"
      And I am on "/gettingstarted/edit"
      And I should see the text "Edit Informational Page Getting Started"
