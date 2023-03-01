Feature: Create Basic Page Screenshot
  As a Content Approver, I should be able to create basic page.

  @new_page @wdio
  Scenario: Element Screenshot Of New Informational Page
    Given I set my screensize to desktop
    When I visit "/node/2020"
    Then I take screenshot of element ".main-container"
