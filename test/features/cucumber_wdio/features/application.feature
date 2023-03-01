Feature: Create Application Screenshot
  As a Content Creator, I should be able to create application page.

  @new_application_ca @wdio
  Scenario: Element Screenshot of New Application For Logged-In Users
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "approver" in "#edit-name"
      And I type "ca" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/application1"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb, .region-masq"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @new_application_au @wdio
  Scenario: Element Screenshot of New Application For End Users
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/application2"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @search_application @wdio
  Scenario: Element Screenshot Search Of Application
    Given I set my screensize to desktop
    When I visit "/results?term=messy"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @filter_application @wdio
  Scenario: Element Screenshot Filter Of Application
    Given I set my screensize to desktop
    When I visit "/applications?search_api_fulltext=bacon"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I hide "#block-feedbacklinkblock"
      And I hide ".block-field-blocknodelanding-pagebody"
    Then I take screenshot of element ".main-container"

  @applications_search @wdio
  Scenario: Element Screenshot Of Application's Search Filter
    Given I set my screensize to desktop
    When I visit "/applications"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I scroll to "#views-exposed-form-applications-block-1"
    Then I take screenshot of element "#views-exposed-form-applications-block-1"

  @integrate_application @wdio
  Scenario: Element Screenshot Filter Of Integrated Applications
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/zee-application"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @dataset_to_app @wdio
  Scenario: Element Screenshot Of Application Dataset Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-dataset-application"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @component_to_app @wdio
  Scenario: Element Screenshot Of Application Component Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-component-application"
      And I hide ".header-container, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @contact_to_app @wdio
  Scenario: Element Screenshot Of Application With Contacts
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-contact"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
      And I hide "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @article_to_app @wdio
  Scenario: Element Screenshot Of Application With Related Article
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-article-application"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @contact_guidance_to_app @wdio
  Scenario: Element Screenshot Of Application With Contact Guidance
    Given I set my screensize to desktop
    When I visit "/applications/behat-application-contact-guidance"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @app_link @wdio
  Scenario: Element Screenshot Of Application With Link
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/wdio-application-link"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @app_with_logo @wdio
  Scenario: Element Screenshot Of Application With Logo
    Given I set my screensize to desktop
    When I visit "/applications/behat-application-logo"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @app_with_screenshot @wdio
  Scenario: Element Screenshot of Application With Screenshot
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-application-screenshot"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @request_access @wdio
  Scenario: Element Screenshot of Application With Request Access
    Given I set my screensize to desktop
    When I visit "/applications/behat-application-request-access"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @document_to_app @wdio
  Scenario: Element Screenshot Of Application With Document
    Given I set my screensize to desktop
    When I visit "/applications/behat-document"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @application_full_page @wdio
  Scenario: Full Screenshot Of Application Page With Tags
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/application-full-page"
      And I hide ".header-container, .breadcrumb, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "application_full_page" to filename

  @breadcrumb @wdio
  Scenario: Element Screenshot Of Application's Breadcrumb
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/application-full-page"
    Then I take screenshot of element ".breadcrumb"

  @application_type @wdio
  Scenario: Element Screenshot Of Application Type
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-app-type"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @type_of_external_user @wdio
  Scenario: Element Screenshot Of Type Of External Users
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-app-external"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @application_fields @wdio
  Scenario: Element Screenshot Of Application's Status
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/application-full-page"
    Then I take screenshot of element ".field--name-field-division-office-multi"
      And I take screenshot of element ".field--name-field-app-status"
      And I take screenshot of element ".field--name-field-hosting-location"

  @permissions_usage @wdio
  Scenario: Element Screenshot Of Permissions and Usage
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-permissions"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @tech_category @wdio
  Scenario: Element Screenshot Of Application With Tech Category
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-tech-category"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @use_case @wdio
  Scenario: Element Screenshot Of Application With Use Case
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-usecase"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @use_case_taxonomy @wdio
  Scenario: Element Screenshot Of Application UseCase Taxonomy Page
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/use-case/behat-use-case3"
      And I hide "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @app_multi_select @wdio
  Scenario: Element Screenshot Of Application With Multi Select Fields
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-multi-select-field-app"
      And I hide ".header-container, .breadcrumb, .footer-container, .created-or-updated-date"
      And I remove "#navbar, #block-feedbacklinkblock"
    Then I take full page screenshot and add text "app_full_page_with_tags" to filename

  @WYSIWYGmedialibrary_image @wdio
  Scenario: WYSIWYG media library Application for image
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/dsite-6748-behat-image"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @WYSIWYGmedialibrary_file @wdio
  Scenario: WYSIWYG media library Application for file
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/dsite-6748-behat-file"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @Application_Integration @wdio
  Scenario: Element Screenshot Of Application Integration
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-integration-application"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @request_Visit @wdio
  Scenario: Element Screenshot of Application With Request And Visit Button
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-application-link"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"
