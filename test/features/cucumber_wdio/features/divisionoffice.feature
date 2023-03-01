Feature: Create Division Office Page
  As a site visitor, I should be able to see Division/Office page showing content type groups

  @div_off_page @wdio
  Scenario: Element Screenshot Of Division Office Page
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/divisionoffice/division1"
      And I hide ".header-container, .footer-container"
      And I remove "#block-feedbacklinkblock"
      And I hide "header[role='banner']"
    Then I take screenshot of element ".main-container"
