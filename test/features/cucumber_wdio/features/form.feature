Feature: Create Form Screenshot
  I should be able to take form screenshots.

  @form_all @wdio
  Scenario: Element Screenshot Dataset All Fields
    Given I set my screensize to desktop
    When I visit "/forms/behat-form"
      And I wait for "10" seconds
      And I hide ".header-container"
      And I hide "#navbar"
      And I hide "#block-feedbacklinkblock"
      And I hide ".footer-container"
    Then I take full page screenshot
