Feature: Create DataInsight Screenshot
  As a Content Creator, I should be able to create data insights page.

  @datainsight_all @wdio
  Scenario: Full Page Screenshot Of New Data Insight
    Given I set my screensize to desktop
    When I visit "/data-insights/test-behat-data-insight"
      And I wait for "10" seconds
      And I remove "#toolbar-administration"
      And I remove ".header-container"
      And I remove "#environment-indicator"
      And I remove "#navbar"
      And I remove ".region-masq"
      And I remove "#block-feedbacklinkblock"
      And I remove ".footer-container"
    Then I take full page screenshot

    @datainsight_link_report @wdio
    Scenario: Element Screenshot of Data Insight and Reports Relationship
      Given I set my screensize to desktop
      When I visit "/reports-statistics/behat-reports1"
        And I wait for "5" seconds
      Then I take screenshot of element ".field--name-field-related-data-insights"

    @datainsight_2insights @wdio
    Scenario: Element Screenshot of Data Insight and Data Insight Relationship
      Given I set my screensize to desktop
      When I visit "/user"
        And I type "auth" in "#edit-name"
        And I type "auth" in "#edit-pass"
        And I click on "#edit-submit"
        And I visit "/data-insights/behat-insight-main"
        And I remove "#navbar, #block-feedbacklinkblock"
      Then I take screenshot of element ".main-container"
