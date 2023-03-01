Feature: Create Dataset Screenshot
  As a Content Creator, I should be able to create application page.

  @tech_to_dataset @wdio
  Scenario: Element Screenshot Of Dataset to Technology Relationships
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/behat-dataset#edit-group-tools"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @breadcrumb @wdio
  Scenario: Element Screenshot Of Dataset Breadcrumb
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/behat-dataset#edit-group-tools"
    Then I take screenshot of element ".breadcrumb"

  @application_to_dataset @wdio
  Scenario: Element Screenshot Of Application to Dataset Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/applications/behat-application1"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @platform_to_dataset @wdio
  Scenario: Element Screenshot Of Platform to Dataset Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/platforms/behat-platform0"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @software_to_dataset @wdio
  Scenario: Element Screenshot Of Software to Dataset Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/software/behat-software1"
      And I hide ".created-or-updated-date"
      And I remove "#block-feedbacklinkblock"
    Then I take screenshot of element ".main-container"

  @dataset_contact @wdio
  Scenario: Element Screenshot Of Dataset Contact
    Given I set my screensize to desktop
    When I visit "/datasets/BEHAT-Dataset-Contact"
      And I wait for "10" seconds
    Then I take screenshot of element "#edit-group-who-to-contact--content"

  @dataset_DI @wdio
  Scenario: Element Screenshot Dataset With Division And Office
    Given I set my screensize to desktop
    When I visit "/datasets/dataset1"
      And I wait for "10" seconds
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @dataset_allaccess @wdio
  Scenario: Full Screenshot Dataset All Fields
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "ca2" in "#edit-name"
      And I type "ca2" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/behat-general-dataset"
      And I remove "#toolbar-administration, .header-container, #environment-indicator, #navbar, .tabs-container, .created-or-updated-date, .region-masq, #block-feedbacklinkblock, .footer-container"
    Then I take full page screenshot

  @dataset_governance @wdio
  Scenario: Full Screenshot Dataset Governance
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "ca2" in "#edit-name"
      And I type "ca2" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/behat-dataset-title"
      And I remove "#toolbar-administration, .header-container, #environment-indicator, #navbar, .tabs-container, .created-or-updated-date, .region-masq, #block-feedbacklinkblock, .footer-container"
    Then I take full page screenshot

  @dataset_search_page @wdio
  Scenario: Full Page Screenshot Dataset Search Page
    Given I set my screensize to desktop
    When I visit "/datasets"
      And I wait for "10" seconds
      And I remove "#toolbar-administration"
      And I remove ".header-container"
      And I remove "#environment-indicator"
      And I remove "#navbar"
      And I remove ".tabs-container"
      And I remove ".block-field-blocknodelanding-pagebody"
      And I remove ".region-masq"
      And I remove "#block-feedbacklinkblock"
      And I remove ".footer-container"
    Then I take full page screenshot

  @dataset_app @wdio
  Scenario: Element Screenshot Dataset Sync Application
    Given I set my screensize to desktop
    When I visit "/datasets/dataset-30"
      And I wait for "10" seconds
    Then I take screenshot of element ".tab-content"
    When I visit "/applications/BEHAT-Application1"
    Then I take screenshot of element ".side-grouping"

  @dataset_di @wdio
  Scenario: Element Screenshot Dataset Sync Data Insight
    Given I set my screensize to desktop
    When I visit "/datasets/BEHAT-Dataset-Title"
      And I wait for "10" seconds
    Then I take screenshot of element ".tab-content"
    When I visit "/data-insights/behat-insight1"
    Then I take screenshot of element ".field--name-field-associated-datasets"

  @dataset_dataset @wdio
  Scenario: Element Screenshot Dataset Link To Dataset
    Given I set my screensize to desktop
    When I visit "/datasets/Dataset-Title1"
      And I wait for "10" seconds
    Then I take screenshot of element ".main-content-display-section"
    When I visit "/datasets/Dataset-Title2"
    Then I take screenshot of element ".main-content-display-section"

  @dataset_tags @wdio
  Scenario: Element Screenshot Of Dataset Tags
    Given I set my screensize to desktop
    When I visit "/datasets/behat-test-data-set"
    Then I take screenshot of element ".main-content-display-section"

  @dataset_rs @wdio
  Scenario: Element Screenshot of Dataset and Reports & Statistics Relationship
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/behat-dataset"
      And I remove "#navbar, #block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
    Then I take screenshot of element ".main-container"

  @requestaccess_dataset @wdio
  Scenario: Element Screenshot of Dataset With Request Access Button
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/request-access-dataset"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"

  @requestvisit_dataset @wdio
  Scenario: Element Screenshot of Dataset With Request Access And Visit Link Button
    Given I set my screensize to desktop
    When I visit "/user"
      And I type "auth" in "#edit-name"
      And I type "auth" in "#edit-pass"
      And I click on "#edit-submit"
      And I visit "/datasets/request-and-visit-link-dataset"
      And I hide "#block-feedbacklinkblock"
      And I hide ".created-or-updated-date"
      And I hide ".breadcrumb"
    Then I take screenshot of element ".main-container"
