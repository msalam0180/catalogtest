Feature: Create Platform Screenshot
  As a Content Creator, I should be able to create platform page.

  @new_platform @wdio
  Scenario: Element Screenshot Of New Platform
    Given I set my screensize to desktop
    When I visit "/platforms/platform"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @integration_component_platform @wdio
  Scenario: Element Screenshot Of Component And Platform Integration
    Given I set my screensize to desktop
    When I visit "/software/behat-component-1"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @integration_platform_component @wdio
  Scenario: Element Screenshot Of Platform And Component Integration
    Given I set my screensize to desktop
    When I visit "/platforms/component-and-platform"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @contact_to_platform @wdio
  Scenario: Element Screenshot Of Platform With Contacts
    Given I set my screensize to desktop
    When I visit "/platforms/behat-contact"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @article_to_platform @wdio
  Scenario: Element Screenshot Of Platform With Article
    Given I set my screensize to desktop
    When I visit "/platforms/behat-article-platform"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @contact_guidance_to_platform @wdio
  Scenario: Element Screenshot Of Platform With Contact Guidance
    Given I set my screensize to desktop
    When I visit "/platforms/behat-platform-contact-guidance"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @plat_with_logo @wdio
  Scenario: Element Screenshot of Platform With Logo
    Given I set my screensize to desktop
    When I visit "/platforms/behat-platform-logo"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @document_to_platform @wdio
  Scenario: Element Screenshot Of Platform With Document
    Given I set my screensize to desktop
    When I visit "/platforms/behat-document"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @platform_list_page @wdio
  Scenario: Full Screenshot Of Platform List Page
    Given I set my screensize to desktop
    When I visit "/platforms"
      And I hide "header[role='banner']"
      And I hide ".footer-container"
    Then I take full page screenshot and add text "platform_list_page" to filename

  @platform_full_page @wdio
  Scenario: Full Screenshot Of Platform Page That Includes Tags
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/platforms/platform-full-page"
      And I hide ".header-container, .breadcrumb, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "platform_full_page" to filename

  @breadcrumb @wdio
  Scenario: Element Screenshot of Platform's Breadcrumb
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/platforms/platform-full-page"
    Then I take screenshot of element ".breadcrumb"

  @app_to_platform @wdio
  Scenario: Element Screenshot Of Platform With Application
    Given I set my screensize to desktop
    When I visit "/platforms/behat-platform1"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @plat_tech_category @wdio
  Scenario: Element Screenshot Of Platform With Techn Category
    Given I set my screensize to desktop
    When I visit "/platforms/behat-plat-tech-category"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @request_access @wdio
  Scenario: Element Screenshot of Platform With Request Access
    Given I set my screensize to desktop
    When I visit "/platforms/behat-platform-request-access"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".button-group"

  @plat_link @wdio
  Scenario: Element Screenshot of Platform Link
    Given I set my screensize to desktop
    When I visit "/platforms/behat-platform-link"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".button-group"

  @use_case @wdio
  Scenario: Element Screenshot Of Platform With Use Case
    Given I set my screensize to desktop
    When I visit "/platforms/behat-usecase"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @plat_multi_select @wdio
  Scenario: Element Screenshot Of Platform With Multi Select Fields
    Given I set my screensize to desktop
    When I visit "/platforms/behat-multi-select-field-plat"
      And I hide ".header-container, .breadcrumb, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "plat_full_page_with_tags" to filename

  @access_link @wdio
  Scenario: Element Screenshot of Link and Access
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/platforms/behat-platform-link"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"
