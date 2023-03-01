Feature: Screenshots of Global Navigation Elements

  @catalog_logo @wdio
  Scenario: Catalog Logo SS
    Given I set my screensize to desktop
    When I visit "/"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element "#block-dlp-branding"

  @styled_table @wdio
  Scenario: Styled Table SS
    Given I set my screensize to desktop
    When I visit "/applications/wdio-application-1"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock, .created-or-updated-date"
    Then I take screenshot of element "div.col-lg-8.mainSection.clearfix"

  @unpublished_related_content @wdio
  Scenario: SS of article with unpublished related content
    Given I set my screensize to desktop
    When I visit "/behat-article-one/"
      And I type "ca" in "#edit-name"
      And I type "ca" in "#edit-pass"
      And I click on "#edit-submit"
      And I remove "div.region.region-tabs, #toolbar-bar, .header-container, .footer-container, #navbar, #block-feedbacklinkblock, div.region.region-masq, #environment-indicator"
    Then I take full page screenshot and add text "full_page_unpublished_related_content" to filename
