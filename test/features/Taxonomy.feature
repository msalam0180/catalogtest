Feature: Create And Edit Taxonomy
  As a content creator
  I want to be able to create new Taxonomy
  So that the content is labeled by type

  Background:
    Given "component_category" terms:
      | name           |
      | BEHAT Category |
      And "dataset_registrant_type" terms:
      | name               |
      | BEHAT Entity Type1 |
      And "division_office" terms:
      | name      |
      | division1 |
      | division2 |
      And I create "media" of type "image":
      | name       | field_media_image    | field_caption       |
      | Edgar Logo | behat-edgar-logo.png | Behat Edgar Caption |

  @api
  Scenario Outline: User Can Create New Taxonomy Terms
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/<term>/overview"
    Then I should not see the link "BEHAT Taxonomy edit"
      And I click "Add term"
      And I fill in "Name" with "BEHAT Taxonomy edit"
      And I press "Save"
      And I click "Taxonomy"
      And I click "List terms" in the "<name>" row
    Then I should see the link "BEHAT Taxonomy edit"

    Examples:
      | term                       | name                         |
      | dataset_asset_category     | Asset Type                   |
      | cost_category              | Cost Category                |
      | mission_criticality_mefs_  | Mission Criticality (MEFs)   |
      | quality_completeness       | Quality - Completeness       |
      | quality_consistency        | Quality - Consistency        |
      | quality_timeliness_recency | Quality - Timeliness/Recency |
      | data_structure             | Data Structure               |
      | data_category              | Data Category                |

  @api @javascript
  Scenario: User Can Edit Existing Taxonomy
    Given I am logged in as a user with the "Content Approver" role
      And "dataset_asset_category" terms:
      | name                |
      | BEHAT asset         |
      | BEHAT Taxonomy edit |
      | BEHAT Zelda         |
    When I am on "/admin/structure/taxonomy/manage/dataset_asset_category/overview"
      And I click "Edit" in the "BEHAT Taxonomy edit" row
      And I fill in "Name" with "BEHAT Taxonomy Mod"
      And I press "Save"
    Then I should not see the link "BEHAT Taxonomy edit"
      And I should see the link "BEHAT Taxonomy Mod"

  @api
  Scenario Outline: User Can Delete Taxonomy Terms
    Given I am logged in as a user with the "<role>" role
      And "dataset_asset_category" terms:
      | name                |
      | BEHAT asset         |
      | BEHAT Taxonomy edit |
      | BEHAT Zelda         |
    When I am on "/admin/structure/taxonomy/manage/dataset_asset_category/overview"
      And I click "Edit" in the "BEHAT Taxonomy edit" row
      And I click "Delete"
      And I click "Delete"
    Then I should not see the link "BEHAT Taxonomy edit"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: Authorized Users Can Create New Technology Category Term
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/taxonomy/manage/component_category/add"
      And I fill in "Name" with "BEHAT Component Category Taxonomy"
      And I select the first autocomplete option for "landmark" on the "Icon" field
      And I fill in "Short Description" with "Short Description"
      And I should see the text "Short Description text will show on list pages."
      And I type "This is the description of the topic" in the "Detailed Description" WYSIWYG editor
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/component_category/overview"
    Then I should see the link "BEHAT Component Category Taxonomy"
      And I drag taxonomy term "BEHAT Category" onto "BEHAT Component Category Taxonomy"
      And I press "Save"
      And I should see "The configuration options have been saved."
      And I click "BEHAT Component Category Taxonomy"
      And I should see the "div" element with the "class" attribute set to "fontawesome-icon" in the "icon" region

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario: Content Creator Can Not Add A Component Category Term
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/admin/structure/taxonomy/manage/component_category/add"
    Then I should see the text "You are not authorized to access this page"

  @api
  Scenario: Site Builder Can Create New Role
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/roles/add"
      And I fill in "Name" with "BEHAT Role"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/roles/overview"
    Then I should see the link "BEHAT Role"

  @api @javascript
  Scenario Outline: Authorized Users Can Create/Edit/Delete An Application Type Term
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/taxonomy/manage/application_type/add"
      And I fill in "Name" with "BEHAT App Type Taxonomy"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/application_type/overview"
    Then I should see the link "BEHAT App Type Taxonomy"
    When I click "Edit" in the "BEHAT App Type Taxonomy" row
      And I fill in "Name" with "BEHAT Updated App Type Taxonomy"
      And I press "Save"
    Then I should see the link "BEHAT Updated App Type Taxonomy"
      And I should not see the link "BEHAT App Type Taxonomy"
    When I click "BEHAT Updated App Type Taxonomy"
      And  I navigate to the "/delete" page from the current url
      And I press "Delete"
    Then I should see the text "Deleted term BEHAT Updated App Type Taxonomy."
    When I am on "/admin/structure/taxonomy/manage/application_type/overview"
    Then I should not see the link "BEHAT Updated App Type Taxonomy"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api
  Scenario: Site Builder Can Create New Hosting Location
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "admin/structure/taxonomy/manage/hosting_location/add"
      And I fill in "Name" with "BEHAT hosting"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/hosting_location/overview"
    Then I should see the link "BEHAT hosting"

  @api
  Scenario: Site Builder Can Create New Application Status
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/application_status/add"
      And I fill in "Name" with "BEHAT Status"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/application_status/overview"
    Then I should see the link "BEHAT Status"

  @api @javascript
  Scenario: Site Builder Can Create New Entity Type Term
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/structure/taxonomy/manage/dataset_registrant_type/add"
      And I fill in "Name" with "BEHAT Entity Type2"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/dataset_registrant_type/overview"
    Then I should see the link "BEHAT Entity Type2"
      And I drag taxonomy term "BEHAT Entity Type2" onto "BEHAT Entity Type1"
      And I press "Save"
      And I should see "The configuration options have been saved."

  @api @javascript
  Scenario Outline: Authorized Users Can Create New Status Term
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/taxonomy/manage/status/add"
      And I fill in "Name" with "BEHAT Approve"
      And I type "This is the description of the topic" in the "Description" WYSIWYG editor
      And I select the first autocomplete option for "check" on the "Icon" field
      And I click on the element with css selector "button[value='#AF2525']"
      And I press "Save"
      And I am on "/admin/structure/taxonomy/manage/status/overview"
    Then I should see the link "BEHAT Approve"
    When I click "Edit" in the "BEHAT Approve" row
      And I fill in "Name" with "BEHAT Updated Type Taxonomy"
      And I press "Save"
    Then I should see the link "BEHAT Updated Type Taxonomy"
      And I should not see the link "BEHAT Type Taxonomy"
    When I click "BEHAT Updated Type Taxonomy"
      And  I navigate to the "/delete" page from the current url
      And I press "Delete"
    Then I should see the text "Deleted term BEHAT Updated Type Taxonomy."
    When I am on "/admin/structure/taxonomy/manage/status/overview"
    Then I should not see the link "BEHAT Updated Type Taxonomy"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Content Creator Can Not Create New Status Term
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/admin/structure/taxonomy/manage/status/add"
    Then I should see the text "Access denied"
      And I should see the text "You are not authorized to access this page"

  @api @javascript
  Scenario: View Linked Content On Division Office Page
    Given "application" content:
      | title         | body                      | field_summary          | moderation_state | field_division_office_multi | 	field_owner | field_logo |
      | B Application | This is the body new test | Summary of Application | published        | division1                   |               |            |
      | C Application | This is the body new test | Summary of Application | published        | division1                   |               |            |
      | K Application | This is the body new test | Summary of Application | published        | division1                   |               |            |
      | x Application | This is the body new test | Summary of Application | published        | division1                   |               |            |
      | Application1  | This is the body new test | Summary of Application | published        | division1                   |               |            |
      | Application2  | This is the body Category | Summary of Application | published        | division2                   | division1     | Edgar Logo |
      And "component" content:
      | title           | body                             | field_summary | field_status_usage | moderation_state | field_division_office_multi |
      | BEHAT Component | Description about component test |               | Approved           | published        | division1                   |
      | Q Component     | Description about component test |               | Approved           | published        | division1                   |
      | E Component     | Description about component test |               | Approved           | published        | division1                   |
      | L Component     | Description about component test |               | Approved           | published        | division1                   |
      | Comp 1          | this is the body                 | test summary  | Catalog            | published        | division2                   |
      | Behat 2         | this is the body                 | test summary  | Catalog            | published        | division2                   |
      And "platform" content:
      | title             | body                    | field_summary                 | moderation_state | field_division_office_multi |
      | BEHAT Platform1   | This is the body test   | Summary of platform  category | published        | division1                   |
      | BEHAT A Platform1 | This is the body test   | Summary of platform  category | published        | division1                   |
      | BEHAT C Platform1 | This is the body test   | Summary of platform  category | published        | division1                   |
      | BEHAT B Platform1 | This is the body test   | Summary of platform  category | published        | division1                   |
      | BEHAT Platform2   | This is the description | Summary of platform new       | published        | division2                   |
    When I am logged in as a user with the "authenticated user" role
      And I am on "/divisionoffice/division1"
    Then I should see the heading "division1"
      And I should see the text "Applications Owned by division1"
      And I should see the link "Application2"
      And I should see the text "Summary of Application"
      And I should see the "logo" region
      And I should see the "img" element with the "src" attribute set to "/behat-edgar-logo" in the "logo" region
      And "Application1" should precede "B Application" for the query "//div[contains(@class, 'views-field-title')]"
      And "B Application" should precede "C Application" for the query "//div[contains(@class, 'views-field-title')]"
      And "C Application" should precede "K Application" for the query "//div[contains(@class, 'views-field-title')]"
      And "K Application" should precede "x Application" for the query "//div[contains(@class, 'views-field-title')]"
      And I should see the text "Related Content"
      And I should see the text "Application"
      And I should see the link "Application1"
      And I should see the text "Software"
      And I should see the link "BEHAT Component"
      And "BEHAT Component" should precede "E Component" for the query "//div[contains(@class, 'views-field-title')]"
      And "E Component" should precede "L Component" for the query "//div[contains(@class, 'views-field-title')]"
      And "L Component" should precede "Q Component" for the query "//div[contains(@class, 'views-field-title')]"
      And I should see the text "Platform"
      And "BEHAT A Platform1" should precede "BEHAT B Platform1" for the query "//div[contains(@class, 'views-field-title')]"
      And "BEHAT B Platform1" should precede "BEHAT C Platform1" for the query "//div[contains(@class, 'views-field-title')]"
      And "BEHAT C Platform1" should precede "BEHAT Platform1" for the query "//div[contains(@class, 'views-field-title')]"
      And I should see the link "BEHAT Platform1"
    When I am on "/divisionoffice/division2"
    Then I should see the heading "division2"
      And I should see the text "Related Content"
      And I should not see the text "Applications Owned by division1"
      And I should see the link "Application2"
      And I should see the text "Software"
      And I should see the link "Comp 1"
      And I should see the link "Behat 2"
      And "Behat 2" should precede "Comp 1" for the query "//div[contains(@class, 'views-field-title')]"
      And I should see the text "Platform"
      And I should see the link "BEHAT Platform2"
    When I am on "/admin/structure/taxonomy/manage/division_office/overview"
    Then I should see the text "Access Denied"
      And I should see the text "You are not authorized to access this page."

  @api @javascript
  Scenario: Content Approver Can Update Division Office Taxonomy Full Name
    Given I am logged in as a user with the "Content Approver" role
      And "division_office" terms:
      | name                |
      | BEHAT asset         |
    When I am on "/admin/structure/taxonomy/manage/division_office/overview"
      And I click "Edit" in the "BEHAT asset" row
      And I fill in "Full Name" with "BEHAT Taxonomy Mod"
      And I press "Save"
      And I click "BEHAT asset"
    Then I should see the heading "BEHAT Taxonomy Mod (BEHAT asset)"

  @api
  Scenario: Validate Technology & Dataset Relationship Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy_manager/voc/technology_dataset_relationship"
    Then I should see "Location"
      And I should see "Creation of Source Data"
      And I should see "Ingestion"
      And I should see "Provisioning"
      And I should see "Primary Storage Location"
      And I should see "Transformation"
      And I should see "Data Visualization"
      And I should see "Reporting"
      And I should see "Document Review and Analysis"
      And I should see "Data Analysis"
      And I should see "Operational Tasks"
      And I should see "Dissemination"

  @api
  Scenario: Validate OPEN Government Data Act Access Level Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy_manager/voc/open_government_data_act_access"
    Then I should see "Non-Public"
      And I should see "Public"
      And I should see "Restricted"

  @api
  Scenario: Validate OPEN Government Data Act Data Asset Determination Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/open_government_data_act_classif/overview"
    Then I should see "Public Data Asset"
      And I should see "Standard Public Data Asset"
      And I should see "Priority Data Asset"

  @api
  Scenario: Validate Market Sensitivity Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/market_sensitivity/overview"
    Then I should see "Presence of MNPI"
      And I should see "Presence of MNPI from outside entities"
      And I should see "Presence of MNPI from SEC activities"
      And I should see "Presence of MNPI from both outside entities and SEC activities"
      And I should see "No MNPI present"

  @api
  Scenario: Validate OCDO Classificatiom Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/ocdo_classification/overview"
    Then I should see "Dataset"
      And I should see "Form"

  @api
  Scenario: Validate Data Category Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/data_category/overview"
    Then I should see "Analytical Data"
      And I should see "Forms Data"
      And I should see "Internal Data"
      And I should see "Operational Data"

  @api
  Scenario: Validate Cost Type Default Values
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/admin/structure/taxonomy/manage/cost_type/overview"
    Then I should see "Acquisition including Licenses"
      And I should see "Document Review Labor"
      And I should see "Ingestion Labor"
      And I should see "Provisioning Labor"
      And I should see "Document Creation Labor"
      And I should see "Analytics Labor"
      And I should see "Other"

  @api @javascript
  Scenario: Site Builder Can Create New Taxonomy Term for Manufacturer to populate on components and platform
    Given I am logged in as a user with the "Administrator" role
    When I am on "/admin/structure/taxonomy/manage/manufacturer/overview"
    Then I click "Add term"
      And I fill in "Name" with "Butamax Industries"
      And I press "Save"
      And I should see the text "Created new term Butamax Industries."
    When I visit "/node/add/component"
    Then I select the autocomplete option for "Butamax Industries" on the "Manufacturer" field
      And I visit "/node/add/platform"
    Then I select the autocomplete option for "Butamax Industries" on the "Manufacturer" field
