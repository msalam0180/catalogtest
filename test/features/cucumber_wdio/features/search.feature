Feature: Screenshots of Search Page

  @component_search @wdio
  Scenario: Element Screen Component-Search
    Given I set my screensize to desktop
    When I visit "/results?term=mango"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @platform_search @wdio
  Scenario: Element Screen Platform-Search
    Given I set my screensize to desktop
    When I visit "/results?term=plat"
    Then I take screenshot of element ".main-container"

  @site_search_boost @wdio
  Scenario: Full Screen Site Search With Content Boost
    Given I set my screensize to desktop
    When I visit "/results?term=behat"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
      And I hide "header[role='banner']"
      And I hide ".footer-container"
    Then I take full page screenshot and add text "SiteSearchBoost" to filename

  @search_contenttypeahead @wdio
  Scenario: Search Content Type Ahead
    Given I set my screensize to desktop
    When I visit "/results"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
      And I type "behat" in "#edit-term--2"
      And I wait for "3" seconds
    Then I take screenshot of element ".main-container"

  @search_techcattypeahead @wdio
  Scenario: Search Tech Category Type Ahead
    Given I set my screensize to desktop
    When I visit "/results"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock, header[role='banner']"
      And I type "wdio" in "#edit-term--2"
      And I wait for "3" seconds
    Then I take screenshot of element "div.content-wrap.max-width-wrap"
