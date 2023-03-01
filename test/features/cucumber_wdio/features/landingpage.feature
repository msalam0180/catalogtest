Feature: Create Landing Page Screenshot
  As a Content Creator, I should be able to create Landing page.

  @new_landing @wdio
  Scenario: Element Screenshot Of New Landing Page
    Given I set my screensize to desktop
    When I visit "/behat-landing-page"
    Then I take screenshot of element ".main-container"

  @technology_recenttech @wdio
  Scenario: Element Screenshot Of Technology Landing Page Recent Updated Technology Block
    Given I set my screensize to desktop
    When I visit "/technology"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element "div.layout__region.layout__region--second"

  @home_page @wdio
  Scenario: Element Screenshot Of Recently Updated Block
    Given I set my screensize to desktop
    When I visit "/catalog"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element ".block-views-blockrecently-updated-catalog-block-1"

  @feedback @wdio
  Scenario: Element Screenshot Of Feedback
    Given I set my screensize to desktop
    When I visit "/"
    Then I take screenshot of element ".feedbackButton"

  @masquerade @wdio
  Scenario: Element Screenshot Of Masquerading
    Given I set my screensize to desktop
    When I visit "/"
      And I wait for "10" seconds
    Then I take screenshot of element ".region-masq"
      And I click on "#edit-submit"
      And I wait for "3" seconds
    Then I take screenshot of element ".block-masquerade"

  @footer @wdio
  Scenario: Element Screenshot Of Footer
    Given I set my screensize to desktop
    When I visit "/"
      And I scroll to ".footer-container"
    Then I take screenshot of element ".footer-container"

@technology_recenttechdiss @wdio
  Scenario: Element Screenshot Of Technology Landing Page Recent Technology Discussion Block
    Given I set my screensize to desktop
    When I visit "/technology"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element ".block-views-blockdiscussions-block-2"
