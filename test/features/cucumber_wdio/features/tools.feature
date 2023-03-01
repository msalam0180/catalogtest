Feature: Create Tools Page Screenshots
  As a site visitor, I should be able to see the tools page

  @tools_page @wdio
  Scenario: Element Screenshot Of Tools Page with Tags
    Given I set my screensize to desktop
    When I visit "/tool/behat-tool"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"
