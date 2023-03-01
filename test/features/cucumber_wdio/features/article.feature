Feature: Create Article Screenshot

  @comp_to_article @wdio
  Scenario: Element Screenshot Of Article With Related Software
    Given I set my screensize to desktop
    When I visit "/behat-article-component"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @app_to_article @wdio
  Scenario: Element Screenshot Of Article With Related Application
    Given I set my screensize to desktop
    When I visit "/behat-article-application"
    Then I take screenshot of element ".main-container"
