Feature: Create Discussion Screenshot
  As a Content Creator, I should be able to create discussion page.

  @discussion @wdio
  Scenario: Element Screenshot Of Discussion With App Comp Plat
    Given I set my screensize to desktop
    When I visit "/discussions/behat-discussions"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".node-created-date, #block-feedbacklinkblock"
      And I hide "body > div.dialog-off-canvas-main-canvas > div.main-container.container-fluid.js-quickedit-main-content > div > div > section > div > article > div > section"
    Then I take screenshot of element ".main-container"

  @app_discussion @wdio
  Scenario: Element Screenshot Of App With discussion
    Given I set my screensize to desktop
    When I visit "/applications/behat-app-discussion"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @comp_discussion @wdio
  Scenario: Element Screenshot Of Comp With discussion
    Given I set my screensize to desktop
    When I visit "/software/behat-comp-discussion"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @plat_discussion @wdio
  Scenario: Element Screenshot Of Plat With discussion
    Given I set my screensize to desktop
    When I visit "/platforms/behat-plat-discussion"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @landing_discussions @wdio
  Scenario: Element Screenshot Of Discussions
    Given I set my screensize to desktop
    When I visit "/discussions"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
      And I hide "body > div.dialog-off-canvas-main-canvas > div.main-container.container-fluid.js-quickedit-main-content > div > div > section > div > article > div > div:nth-child(2) > div > section > div > div > div.view-content > div > table > tbody > tr > td.views-field.views-field-last-comment-timestamp > div:nth-child(2) > em"
    Then I take screenshot of element ".main-container"

  @discussion_image @wdio
  Scenario: Element Screenshot Of Discussions With Image
    Given I set my screensize to desktop
    When I visit "/discussions/discussion-image"
      And I hide ".author-details"
    Then I take screenshot of element ".main-container"

  @discussion_file @wdio
  Scenario: Element Screenshot Of Discussions With File
    Given I set my screensize to desktop
    When I visit "/discussions/discussion-file"
      And I hide ".author-details"
    Then I take screenshot of element ".main-container"

  @discussion_link @wdio
  Scenario: Element Screenshot Of Discussions With Link
    Given I set my screensize to desktop
    When I visit "/discussions/discussion-link"
      And I hide ".author-details"
    Then I take screenshot of element ".main-container"

  @discussion_comment @wdio
  Scenario: Element Screenshot Of Comment
    Given I set my screensize to desktop
    When I visit "/discussions/discussion-comment"
    Then I take screenshot of element ".field--name-comment-body"
