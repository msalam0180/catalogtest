Feature: Footer on Data Catalog
  As a Site Visitor the user should be able to see footer from anywhere in the UI.

  @api @javascript
  Scenario: Verify All Footer Links On The Home Page
    Given I am logged in as a user with the "authenticated" role
    When am on "/"
    Then I should see the link "About the Site" in the "footer" region
      And the hyperlink "About the Site" should match the Drupal url "/gettingstarted"
      And I should see the link "Contact Us" in the "footer" region
      And the hyperlink "Contact Us" should match the Drupal url "mailto:datacatalog@sec.gov"
      And I should see the link "Report an Error" in the "footer" region
      And the hyperlink "Report an Error" should match the Drupal url "/contact/feedback"
      And I should see the link "Provide Feedback" in the "footer" region
      And the hyperlink "Provide Feedback" should match the Drupal url "/contact/feedback"
      And I should see the link "The Exchange" in the "footer" region
      And the hyperlink "The Exchange" should match the Drupal url "https://theexchange.sec.gov"

  @api @javascript
  Scenario: Verify Customizable Footer
    Given I am logged in as a user with the "administrator" role
    When I am on "/"
    Then I should not see the link "Footer Level1" in the "footer" region
      And I should not see the link "Footer Level2" in the "footer" region
    When I am on "/admin/structure/menu"
      And I click "Edit menu" in the "Footer Level 1" row
      And I click on the element with css selector "#block-adminimal-theme-local-actions > ul > li > a"
      And I fill in "Menu link title" with "Footer Level1"
      And I fill in "Link" with "https://www.sec.gov/"
      And I scroll to the bottom
      And I press "Save"
    When I am on "/admin/structure/menu"
      And I click "Edit menu" in the "Footer Level 2" row
      And I click on the element with css selector "#block-adminimal-theme-local-actions > ul > li > a"
      And I fill in "Menu link title" with "Footer Level2"
      And I fill in "Link" with "https://www.sec.gov/"
      And I scroll to the bottom
      And I press "Save"
    When I am on "/"
    Then I should see the link "Footer Level1" in the "footer" region
      And I should see the link "Footer Level2" in the "footer" region
      And I click "Footer Level1"
      And I wait 2 seconds
      And I should be on "https://www.sec.gov"
      And I should see "U.S. SECURITIES AND EXCHANGE COMMISSION"
    When I am on "/admin/structure/menu"
      And I click "Edit menu" in the "Footer Level 1" row
      And I click "Edit" in the "Footer Level1" row
      And I scroll to the bottom
      And I click on the element with css selector "#edit-delete"
      And I click on the element with css selector "#edit-submit"
    When I am on "/admin/structure/menu"
      And I click "Edit menu" in the "Footer Level 2" row
      And I click "Edit" in the "Footer Level2" row
      And I scroll to the bottom
      And I click on the element with css selector "#edit-delete"
      And I click on the element with css selector "#edit-submit"

  @api
  Scenario Outline: Verify Customizable Footer Negative Test Case
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/menu"
    Then I should see "Access denied"
      And I should see "You are not authorized to access this page."

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | Forum Moderator  |
