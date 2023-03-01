Feature: Create Component Screenshot
  As a Content Creator, I should be able to create or edit a component page.

  @new_component @wdio
  Scenario: Element Screenshot Of New Component
    Given I set my screensize to desktop
    When I visit "/software/behat-component"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @app_to_component @wdio
  Scenario: Element Screenshot Of Component Application Relationship
    Given I set my screensize to desktop
    When I visit "/software/behat-component-application"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @contact_to_component @wdio
  Scenario: Element Screenshot Of Component With Contacts
    Given I set my screensize to desktop
    When I visit "/software/behat-contact"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @article_to_comp @wdio
  Scenario: Element Screenshot Of Softare With Related Article
    Given I set my screensize to desktop
    When I visit "/software/behat-component-article"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @comp_with_logo @wdio
  Scenario: Element Screenshot Of Software With Logo
    Given I set my screensize to desktop
    When I visit "/software/behat-component-logo"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @contact_guidance_to_component @wdio
  Scenario: Element Screenshot Of Software With Contact Guidance
    Given I set my screensize to desktop
    When I visit "/software/behat-component-contact-guidance"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @document_to_comp @wdio
  Scenario: Element Screenshot Of Software With Document
    Given I set my screensize to desktop
    When I visit "/software/behat-document"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @technology-standard @wdio
  Scenario: Current Window Screenshot Of Software Icon On Technology Standards
    Given I set my screensize to desktop
    When I visit "/technology-category"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element "div.tech-view-box--header"

  @category_icon @wdio
  Scenario: Element Screenshot Of Software Category Icon
    Given I set my screensize to desktop
    When I visit "/technology-standards/a1-behat-category"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-platformssoftwareandtools > div:nth-child(2)"
      And I remove "#block-feedbacklinkblock"
     Then I take screenshot of element ".main-container"

  @component_full_page @wdio
  Scenario: Full Screenshot Of Software Page
    Given I set my screensize to desktop
    When I visit "/software/component-full-page"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "component_full_page" to filename

  @breadcrumb @wdio
  Scenario: Element Screenshot Of Component's Breadcrumb
    Given I set my screensize to desktop
    When I visit "/software/component-full-page"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element ".breadcrumb"

  @status_order @wdio
  Scenario: Full Screenshot Of Component And Platform Status Order
    Given I set my screensize to desktop
    When I visit "/technology-standards/behat-cc-header-1"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".footer-container"
      And I hide ".header-container"
      And I hide "header[role='banner']"
      And I hide "#block-platformssoftwareandtools > div"
    Then I take full page screenshot and add text "comp_plat_order" to filename

  @component_approve_version @wdio
  Scenario: Element Screenshot Of Approved Version
    Given I set my screensize to desktop
    When I visit "/software/component-full-page"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element ".field--name-field-approved-version"

  @component_restriction @wdio
  Scenario: Element Screenshot Of Restrictions Page
    Given I set my screensize to desktop
    When I visit "/software/component-full-page"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
    Then I take screenshot of element ".field--name-field-restrictions"

  @software @wdio
  Scenario: Full Screenshot Of Software Search Page
    Given I set my screensize to desktop
    When I visit "/software"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
      And I hide ".block-field-blocknodelanding-pagebody"
      And I hide ".footer-container"
      And I hide ".header-container"
      And I hide "header[role='banner']"
    Then I take full page screenshot and add text "software_list_page" to filename

  @request_installation @wdio
  Scenario: Element Screenshot Of Request Install
    Given I set my screensize to desktop
    When I visit "/software/behat-request-install"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @use_case @wdio
  Scenario: Element Screenshot Of Component With Use Case
    Given I set my screensize to desktop
    When I visit "/software/behat-usecase"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @comp_multi_select @wdio
  Scenario: Element Screenshot Of Component With Multi Select Fields
    Given I set my screensize to desktop
    When I visit "/software/behat-multi-select-field-comp"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide ".header-container, .breadcrumb, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "comp_full_page_with_tags" to filename
