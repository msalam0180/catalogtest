Feature: Create Contact Screenshot
As a Content Creator, I should be able to create or edit a contact.

  @new_contact @wdio
  Scenario: Element Screenshot Of Contact
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "ccreator" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/node/1"
      And I remove ".region-masq"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"
