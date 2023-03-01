Feature: Users Have Different Permissions Based On What Their User Role Is
  As an Anonymous user I should only be able to view content
  As a content creator I want to be able to create content
  As a Content Approver I should be able to create and publish Content
  As an Admin I should have all user permissions and access

  Background:
    Given "division_office" terms:
      | name         |
      | division1    |
      | division2    |
      | New division |
      And users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "data_category" terms:
      | name      |
      | category1 |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |
      And "data" terms:
      | name            | parent          |
      | BEHAT Use Case1 |                 |
      | BEHAT Use Case2 | BEHAT Use Case1 |
      And "sensitivity_classification" terms:
      | name           |
      | very sensitive |

  @api
  Scenario: Content Creators Can Create Content
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/data_set"
    Then the response status code should be 200

  @api
  Scenario: Content Creators Can Edit Content
    Given I am logged in as a user with the "Content Creator" role
      And I am viewing a "data_set" content:
      | title                            | BEHAT Test Data Set       |
      | field_dataset_description        | Test                      |
      | field_summary                    | Behat short des           |
      | field_dataset_source_type        | SEC/EDGAR, SRO            |
      | field_time_period_covered        | 5days                     |
      | field_dataset_registrant_type    | Investment Advisors (IA)  |
      | field_insights                   | insights                  |
      | field_how_to_request_access      | '' - http://test.com      |
      | field_dataset_use                | BEHAT Use Case2           |
      | field_dataset_category           | Mergers & Acquisitions    |
      | field_dataset_asset_category     | Commodity                 |
      | field_dataset_name_old           | leagacy                   |
      | field_date_acquired              | 08/02/2018                |
      | field_dataset_date_archive       | 08/05/2018                |
      | field_data_size_in_gb            | ~7GB                      |
      | field_delivery_frequency_to_sec  | Quarterly                 |
      | field_dataset_path               | sec location              |
      | field_number_of_licenses_held    | 8                         |
      | field_number_of_licenses_assigne | 5                         |
      | field_fips_security_classificati | Moderate                  |
      | field_fips_category_justificatio | Legal Investigation       |
      | field_sensitivity_classification | very sensitive            |
      | field_sensitive_pii              | Yes                       |
      | field_purchased                  | Yes                       |
      | field_externally_hosted          | Externally                |
      | field_license_types              | IP Authentication         |
      | field_delivery_method_to_sec     | DVD                       |
      | field_vendor_name                | Nintendo                  |
      | field_sales_rep_email_address    | DonkeyKong@gmail.com      |
      | field_dataset_sales_rep_name     | Donkey Kong               |
      | field_sales_rep_phone_number     | 12345678901               |
      | field_support_email_address      | DrMario@gmail.com         |
      | field_support_phone_number       | 18002553700               |
      | field_notes_regarding_permission | permission                |
      | field_license_required           | No                        |
      | field_notes_regarding_permission | This is permission        |
      | field_vendor_website             | URLTest - http://test.com |
      | field_open_government_data_act_i | External                  |
      | field_open_government_data_acces | DAaccess                  |
      | field_open_government_data_class | DAclassification          |
      | field_division_office_multi      | division1                 |
      | field_data_category              | category1                 |
      | field_owner                      | New division              |
      | moderation_state                 | published                 |
      | field_reviewer                   | approver                  |
    When I am on "/admin/content"
      And I click "Edit" in the "BEHAT Test Data Set" row
      And I fill in "Title" with "This content has been changed"
      And I press "Save"
    Then I should see the text "Dataset This content has been changed has been updated"

  @api
  Scenario: Content Approvers Can Review Content And Publish It
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
      | title                            | Content Review test  |
      | field_summary                    | Behat short des      |
      | field_dataset_description        | test                 |
      | field_dataset_source_type        | SEC/EDGAR, SRO       |
      | field_time_period_covered        | 5days                |
      | field_dataset_datastore          | Hadoop               |
      | field_division_office_multi      | division1            |
      | field_data_category              | category1            |
      | field_owner                      | New division         |
      | field_how_to_request_access      | '' - http://test.com |
      | field_open_government_data_act_i | External             |
      | field_open_government_data_acces | DAaccess             |
      | field_open_government_data_class | DAclassification     |
      | field_reviewer                   | approver             |
    When I am on "/admin/content"
      And I click "Moderated content"
      And I click "Edit" in the "Content Review test" row
      And I fill in "Title" with "This content is ready to be published"
      And I publish it
    Then I should not see the link "Content Review test"
      And I should see the link "This content is ready to be published"

  @api
  Scenario: Content Creators Can Create Some Types Of Content
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
    Then the response status code should be 200

  @api
  Scenario: Admins Have No Restrictions With Their Permissions
    Given I am logged in as a user with the "administrator" role
    When I am on "/node/add/faq"
    Then the response status code should be 404

  @api
  Scenario: Site Builder Can Edit Rules Of Road Custom Block And Access Denied Page
    Given I am logged in as a user with the "sitebuilder" role
    When I am on "/block/441?destination=/admin/structure/block/block-content"
    Then the response status code should be 200
      And I should see the heading "Edit custom block Discussion Rules of the Road Help Text"
    When I am on "/access-denied/edit"
    Then I should see the text "Edit Landing Page Access Denied"

  @api
  Scenario: Only Admin Can View List Of Existing Users And filter Users On Peoples
    Given I am logged in as a user with the "administrator" role
    When I am on "/admin/people"
    Then I should see the heading "People"
    When I should see the link "Username"
      And I should see the text "Roles"
      And I fill in "Name or email contains" with "approver"
      And I press the "Filter" button
    Then I should see the text "approver"

  @api
  Scenario Outline: Accessing Publications Content
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/publications"
    Then I should see the heading "<result1>"
      And I should see the text "<result2>"

    Examples:
      | role             | result1             | result2                                         |
      | administrator    | Create Publications | Fields marked with an asterisk(*) are required. |
      | sitebuilder      | Access denied       | You are not authorized to access this page.     |
      | Content Approver | Access denied       | You are not authorized to access this page.     |
      | Content Creator  | Access denied       | You are not authorized to access this page.     |

  @api @javascript
  Scenario Outline: Authorized User Can Change User Profile
    Given I am logged in as a user with the "<role>" role
      And I navigate to the "/edit" page from the current url
      And I select "division1" from "Division/Office"
      And I select "<type>" from "Employment Type"
      And I press "Save"
    Then I should see "The changes have been saved."
    When I am on "/user"
    Then I should see the text "Division/Office"
      And I should see the link "division1"
      And I should see the text "Employment Type"
      And I should see the text "<typeResult>"

    Examples:
      | role               | type          | typeResult    |
      | administrator      | Federal Staff | Federal Staff |
      | Content Creator    | Contractor    | Contractor    |
      | Content Approver   | Federal Staff | Federal Staff |
      | sitebuilder        | Contractor    | Contractor    |
      | authenticated user | Federal Staff | Federal Staff |

  @api
  Scenario Outline: Unauthorized Users Can Not Access User Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/people"
    Then I should see the text "Access Denied"
      And I should see "You are not authorized to access this page."

    Examples:
      | role               |
      | Content Creator    |
      | Content Approver   |
      | authenticated user |
      | Forum Moderator    |
      | sitebuilder        |

  @api @javascript
  Scenario: Admin Can Create And Delete A New User
    Given I am logged in as a user with the "administrator" role
    When I am on "/admin/people/create"
      And I fill in "Email address" with "user@email.com"
      And I fill in "Username" with "new test user"
      And I fill in "Password" with "password"
      And I fill in "Confirm password" with "password"
      And I check the box "Sitebuilder"
      And I select "LARO" from "Division/Office"
      And I select "Contractor" from "Employment Type"
      And I press "Create new account"
    Then I should see "Created a new user account for new test user."
    When I click "new test user"
    Then I should see "Division/Office"
      And I should see the link "LARO"
      And I should see "Employment Type"
      And I should see "Contractor"
    When I click "Edit" in the "node_action" region
      And I scroll to the bottom
      And I click "Cancel account"
      And I select the radio button "Delete the account and its content. This action cannot be undone."
      And I press "Confirm"
      And I wait for ajax to finish
    Then I should see the text "new test user has been deleted."
      And I should not see the link "new test user"

  @api
  Scenario: Verify AutoLogin
    Given "data_set" content:
      | title         | field_dataset_description |
      | BEHAT dataset | This is dataset1          |
      And "tools" content:
      | title      | field_dataset_description |
      | BEHAT Tool | Tool description          |
      And "data_insight" content:
      | title         | body             |
      | BEHAT Insight | This is the body |
      And "forum" content:
      | title       | body                      |
      | BEHAT Forum | This is Dataset Forum one |
    When I am on "/dataset/behat-dataset"
      And I should see the text "The requested page could not be found."
      And I am on "/tools/behat-tool"
      And I should see the text "The requested page could not be found."
      And I am on "/data-insight/behat-insight"
      And I should see the text "The requested page could not be found."
      And I am on "/discussion/behat-forum"
      And I should see the text "The requested page could not be found."

  @api @javascript
  Scenario Outline: Authorized Users Can Access Contents List Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
    Then I should see the text "Published status"
      And I should see the text "Content type"
      And I should see the text "Title"
      And I should see the text "Language"
      And I should see the button "Filter"
      And I should see the text "Action"
      And I should see the button "Apply to selected items"
    When I click on the element with css selector "#edit-type"
    Then I should see "Application"
      And I should see "Article"
      And I should see "Informational page"
      And I should see "Chart"
      And I should see "Software"
      And I should see "Contact"
      And I should see "Data Insight"
      And I should see "Dataset"
      And I should see "Forms"
      And I should see "Landing Page"
      And I should see "Platform"
      And I should see "Reports and Statistics"
      And I should see "Tool"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: Media Published Status Filtering
    Given I am logged in as a user with the "<role>" role
      And I create "media" of type "files":
      | KEY    | name            |
      | Behat  | Behat Publish   |
      | Behat1 | Behat Unpublish |
    When I visit "/admin/content/media"
      And I click "Edit" in the "Behat Unpublish" row
      And I wait 1 seconds
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I fill in "Description" with "Testing 3325"
      And I uncheck "Published"
      And I scroll to the bottom
      And I press the "Save" button
      And I should see the text "File Behat Unpublish has been updated."
      And I select "Unpublished" from "Published status"
      And I press the "Filter" button
    Then I should see the text "Unpublished" in the "Behat Unpublish" row
      And I should not see the text "Behat Publish"
    When I select "Published" from "Published status"
      And I press the "Filter" button
    Then I should see the text "Published" in the "Behat Publish" row
      And I should not see the text "Behat Unpublish"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api
  Scenario Outline: Verify Access To Site Settings And Themes
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/config/system/site-information"
    Then I should see the heading "<result1>"
    When I am on "/admin/appearance/settings/dlp"
    Then I should see the heading "<result2>"

  Examples:
      | role             | result1             | result2       |
      | Administrator    | Basic site settings | DLP           |
      | Sitebuilder      | Basic site settings | DLP           |
      | Content Creator  | Access denied       | Access denied |
      | Content Approver | Access denied       | Access denied |
      | Forum Moderator  | Access denied       | Access denied |

  @api @javascript
  Scenario: Verify Update Of Homepage
    Given I am logged in as a user with the "Sitebuilder" role
    When I visit "/admin/config/system/site-information"
      And I fill in "Default front page" with "/technology-category"
      And I press "Save configuration"
    Then I visit "/"
      And I should see the heading "Technology Category"
      And I visit "/admin/config/system/site-information"
      And I fill in "Default front page" with "/home"
      And I press "Save configuration"

  @api @javascript
  Scenario: Filter Content Types By Assigned Reviewer
    Given I am logged in as "approver"
      And "application" content:
      | title              | body             | field_summary          | field_division_office_multi | moderation_state | field_reviewer |
      | BEHAT Application1 | This is the body | Summary of Application | division1                   | draft            | approver       |
      And "tools" content:
      | title | body         | field_tool_category | moderation_state |
      | Tool1 | this is tool | Data Systems        | draft            |
      And "data_set" content:
      | title    | field_dataset_description | field_dataset_source_type | moderation_state | field_reviewer |
      | Dataset1 | description               | FINRA                     | draft            | approver       |
      And "article" content:
      | title    | body               | field_category | moderation_state |
      | Article1 | article report one | FAQ            | draft            |
      And "statistics" content:
      | title              | body                  | field_data_search_index | moderation_state | field_reviewer |
      | BEHAT Reports Test | This is the body test | myReportTerm            | draft            | approver       |
      And "data_insight" content:
      | title          | body                   | moderation_state |
      | BEHAT Insight1 | This is the body  test | published        |
      And "component" content:
      | title           | body                             | field_status | field_division_office_multi | moderation_state |
      | BEHAT Component | Description about component test | Approved     | division1                   | draft            |
      And "platform" content:
      | title           | body                  | field_summary       | field_division_office_multi | moderation_state |
      | BEHAT Platform1 | This is the body test | Summary of platform | division1                   | draft            |
      And "page" content:
      | title          | body             | field_summary | moderation_state |
      | BEHAT Page One | This is the body | page test     | draft            |
      And "landing_page" content:
      | title              | body                           | field_summary                  | moderation_state |
      | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | draft            |
    When I visit "/admin/content/moderated"
    Then I should see the link "Tool1"
      And I should see the link "Article1"
    When I select "approver" from "Reviewer"
      And I press "Filter"
    Then I should see the link "BEHAT Application1"
      And I should see the link "Dataset1"
      And I should see the link "BEHAT Reports Test"
      And I should not see the link "Tool1"
      And I should not see the link "Article1"

  @api
  Scenario Outline: Authorized Users Can Access Moderated Content Dashboard
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content/moderated"
    Then I should see the heading "<access>"

    Examples:
      | role               | access            |
      | Content Creator    | Access denied     |
      | Content Approver   | Moderated content |
      | authenticated user | Access denied     |
      | Forum Moderator    | Access denied     |
      | sitebuilder        | Moderated content |
      | administrator      | Moderated content |

  @api
  Scenario Outline: Authorized Users Can Filter Content By Moderation State On Moderated Content Dashboard
    Given I am logged in as a user with the "<role>" role
      And "application" content:
        | title              | body             | field_summary          | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Application1 | This is the body | Summary of Application | division1                   | draft            | approver       |
      And "tools" content:
        | title | body         | field_tool_category | moderation_state |
        | Tool1 | this is tool | Data Systems        | draft            |
      And "data_set" content:
        | title    | field_dataset_description | field_dataset_source_type | moderation_state | field_reviewer |
        | Dataset1 | description               | FINRA                     | published        | approver       |
      And "article" content:
        | title    | body               | field_category | moderation_state |
        | Article1 | article report one | FAQ            | published        |
      And "statistics" content:
        | title              | body                  | field_data_search_index | moderation_state | field_reviewer |
        | BEHAT Reports Test | This is the body test | myReportTerm            | rejected         | approver       |
      And "data_insight" content:
        | title          | body                   | moderation_state |
        | BEHAT Insight1 | This is the body  test | rejected         |
      And "component" content:
        | title           | body                             | field_status | field_division_office_multi | moderation_state |
        | BEHAT Component | Description about component test | Approved     | division1                   | archived         |
      And "platform" content:
        | title           | body                  | field_summary       | field_division_office_multi | moderation_state |
        | BEHAT Platform1 | This is the body test | Summary of platform | division1                   | archived         |
      And "page" content:
        | title          | body             | field_summary | moderation_state |
        | BEHAT Page One | This is the body | page test     | published        |
      And "landing_page" content:
        | title              | body                           | field_summary                  | moderation_state |
        | BEHAT Landing Page | This is the BEHAT landing page | Landing Page Short Description | rejected         |
    When I visit "/admin/content/moderated"
    Then I should see the heading "Moderated content"
    When I select "Draft" from "Moderation state"
      And I press "Filter"
    Then I should see the link "BEHAT Application1"
      And I should see the link "Tool1"
      And I should not see the link "BEHAT Reports Test"
      And I should not see the link "Dataset1"
      And I should not see the link "Article1"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Component"
      And I should not see the link "BEHAT Platform1"
      And I should not see the link "BEHAT Page One"
      And I should not see the link "BEHAT Landing Page"
    When I select "Published" from "Moderation state"
      And I press "Filter"
    Then I should see the link "BEHAT Page One"
      And I should see the link "Dataset1"
      And I should see the link "Article1"
      And I should not see the link "Tool1"
      And I should not see the link "BEHAT Reports Test"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Component"
      And I should not see the link "BEHAT Platform1"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "BEHAT Landing Page"
    When I select "Rejected" from "Moderation state"
      And I press "Filter"
    Then I should see the link "BEHAT Reports Test"
      And I should see the link "BEHAT Insight1"
      And I should see the link "BEHAT Landing Page"
      And I should not see the link "Tool1"
      And I should not see the link "BEHAT Page One"
      And I should not see the link "Dataset1"
      And I should not see the link "BEHAT Component"
      And I should not see the link "BEHAT Platform1"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "Article1"
    When I select "Archived" from "Moderation state"
      And I press "Filter"
    Then I should see the link "BEHAT Component"
      And I should see the link "BEHAT Platform1"
      And I should not see the link "BEHAT Landing Page"
      And I should not see the link "Tool1"
      And I should not see the link "BEHAT Page One"
      And I should not see the link "Dataset1"
      And I should not see the link "BEHAT Reports Test"
      And I should not see the link "BEHAT Insight1"
      And I should not see the link "BEHAT Application1"
      And I should not see the link "Article1"

    Examples:
      | role             |
      | content_approver |
      | sitebuilder      |
      | administrator    |

  @api
  Scenario Outline: Users With Higher Roles Can Use Maquerade
    Given "landing_page" content:
      | title              | body                             | moderation_state |
      | BEHAT Landing Page | This is the body of landing page | published        |
      And "data_set" content:
        | title          | field_dataset_description | moderation_state |
        | BEHAT Dataset1 | this is the body          | published        |
      And "component" content:
        | title           | body                             | moderation_state |
        | BEHAT Component | Description about component test | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/"
      And I press "Preview as Enduser"
    Then I should see the text "You are masquerading as enduser"
      And I should see the text "Welcome"
      And I should not see the link "Structure"
      And I should not see the link "Content"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Structure"
      And I should see the link "Content"
      And I should see the text "Welcome"
    When I am on "/behat-landing-page"
      And I press "Preview as Enduser"
    Then I should see the text "You are masquerading as enduser"
      And I should see the heading "BEHAT Landing Page"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the heading "BEHAT Landing Page"
    When I am on "/datasets/behat-dataset1"
      And I press "Preview as Enduser"
    Then I should see the text "You are masquerading as enduser"
      And I should see the heading "BEHAT Dataset1"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the heading "BEHAT Dataset1"
    When I am on "/software/behat-component"
      And I press "Preview as Enduser"
    Then I should see the text "You are masquerading as enduser"
      And I should see the heading "BEHAT Component"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the heading "BEHAT Component"

    Examples:
      | role             |
      | content_creator  |
      | content_approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: Permissions To Exclude Dataset From Dataset/Global Search
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/data_set"
    Then I should <permission> the text "EXCLUDE FROM DATASET SEARCH" in the "edit_advanced" region
      And I should <permission> the text "EXCLUDE FROM GLOBAL SEARCH" in the "edit_advanced" region

    Examples:
      | role             | permission |
      | Content Creator  | not see    |
      | Content Approver | see        |
      | sitebuilder      | see        |
      | administrator    | see        |

  @api @javascript
  Scenario: Granting Access To Informational And Landing Page
    Given users:
      | name       | mail              | roles |
      | behat ocdo | ocdotest@test.com | OCDO  |
      And "page" content:
        | title      | body        | field_summary | moderation_state |
        | BEHAT Page | description | summary       | draft            |
      And "landing_page" content:
        | title              | body                           | moderation_state |
        | BEHAT Landing Page | This is the BEHAT landing page | draft            |
    When I am logged in as "behat ocdo"
      And I am on "/behat-page"
    Then I should see the heading "Access Denied"
    When I am on "/behat-landing-page"
    Then I should see the heading "Access Denied"
    When I am logged in as a user with the "sitebuilder" role
      And I visit "/behat-page/grants"
      And I click on the element with css selector "#edit-rid-4-grant-view"
      And I press "Save Grants"
    Then I should see the text "Grants saved"
    When I visit "/behat-landing-page/grants"
      And I click on the element with css selector "#edit-rid-4-grant-view"
      And I press "Save Grants"
    Then I should see the text "Grants saved"
    When I am logged in as "behat ocdo"
    Then I visit "/behat-page"
      And I should see the heading "BEHAT Page"
      And I visit "/behat-landing-page"
      And I should see the heading "BEHAT Landing Page"

  @api @javascript
  Scenario: Granting Individual Access To Landing Page And Reset
    Given users:
      | name       | mail              | roles           | uid    |
      | behat au   | autest@test.com   |                 | 111111 |
      | behat cc   | cctest@test.com   | content_creator | 111112 |
      | behat ocdo | ocdotest@test.com | OCDO            |        |
      And "landing_page" content:
        | title              | body                           | moderation_state |
        | BEHAT Landing Page | This is the BEHAT landing page | draft            |
    When I am logged in as "behat au"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access denied"
    When I am logged in as "behat cc"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access denied"
    When I am logged in as "behat ocdo"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access Denied"
    When I am logged in as a user with the "sitebuilder" role
      And I visit "/behat-landing-page/grants"
      And I click on the element with css selector "#edit-rid-4-grant-view"
      And I fill in "edit-keys" with "behat au"
      And I press "Search"
      And I click on the element with css selector "#edit-uid-111111-grant-view"
      And I fill in "edit-keys" with "behat cc"
      And I press "Search"
      And I click on the element with css selector "#edit-uid-111112-grant-view"
      And I press "Save Grants"
    Then I should see the text "Grants saved"
    When I am logged in as "behat au"
      And I visit "/behat-landing-page"
    Then I should see the heading "BEHAT Landing Page"
    When I am logged in as "behat cc"
      And I visit "/behat-landing-page"
    Then I should see the heading "BEHAT Landing Page"
    When I am logged in as "behat ocdo"
      And I visit "/behat-landing-page"
    Then I should see the heading "BEHAT Landing Page"
    When I am logged in as a user with the "sitebuilder" role
      And I visit "/behat-landing-page/grants"
      And I press "Reset to Default Grants"
    Then I should see the text "Grants has been reset"
    When I am logged in as "behat au"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access denied"
    When I am logged in as "behat cc"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access denied"
    When I am logged in as "behat ocdo"
      And I am on "/behat-landing-page"
    Then I should see the heading "Access Denied"

  @api
  Scenario Outline: Verify Roles With Granting Access
    Given I am logged in as a user with the "<role>" role
      And "page" content:
      | title      | body        | field_summary | moderation_state |
      | BEHAT Page | description | summary       | draft            |
    When I am on "/behat-page"
    Then I should <access1> the link "Grant"

      Examples:
      | role             | access1 | access2 |
      | content_creator  | not see | not see |
      | content_approver | not see | not see |
      | sitebuilder      | see     | see     |
      | administrator    | see     | see     |

  @api
  Scenario: Verify Content Types With Grant Access
    Given I am logged in as a user with the "sitebuilder" role
       And "application" content:
      | title        | body                      | moderation_state |
      | Application1 | This is the body new test | published        |
      And "tools" content:
      | title       | moderation_state |
      | BEHAT Tool1 | published        |
      And "data_set" content:
      | title          | field_dataset_description | moderation_state |
      | BEHAT Dataset1 | this is the body          | published        |
      And "article" content:
      | title          | body                         | moderation_state |
      | BEHAT Article1 | article report test Category | published        |
      And "statistics" content:
      | title         | body                           | moderation_state |
      | BEHAT Reports | This is test new Category body | published        |
      And "data_insight" content:
      | title          | body                  | moderation_state |
      | BEHAT Insight1 | This is the body test | published        |
      And "component" content:
      | title           | body                             | moderation_state |
      | BEHAT Component | Description about component test | published        |
      And "platform" content:
      | title           | body                  | moderation_state |
      | BEHAT Platform1 | This is the body test | published        |
      And "landing_page" content:
      | title              | body                             | moderation_state |
      | BEHAT Landing Page | This is the body of landing page | published        |
      And "page" content:
      | title         | body             | moderation_state |
      | Info Page One | This is the body | published        |
    When I visit "/info-page-one"
    Then I should see the link "Grant"
    When I visit "/behat-landing-page"
    Then I should see the link "Grant"
    When I visit "/applications/application1"
    Then I should not see the link "Grant"
    When I visit "/tool/behat-tool1"
    Then I should not see the link "Grant"
    When I visit "/datasets/behat-dataset1"
    Then I should not see the link "Grant"
    When I visit "/behat-article1"
    Then I should not see the link "Grant"
    When I visit "/data-insights/behat-insight1"
    Then I should not see the link "Grant"
    When I visit "/software/behat-component"
    Then I should not see the link "Grant"
    When I visit "/platforms/behat-platform1"
    Then I should not see the link "Grant"

  @api @javascript
  Scenario: Site Builder Has Access To Users Page
    Given users:
      | name           | mail              | roles   | status |
      | behat ocdo     | ocdotest@test.com | OCDO    | 1      |
      | behat user1    | user1@test.com    | Enduser | 0      |
      | behat user2    | user2@test.com    | OCDO    | 0      |
      | behat user3    | user3@test.com    |         | 1      |
      | user4@test.com | user4@test.com    | OCDO    | 1      |
      And I am logged in as "behat ocdo"
      And I am logged in as "behat user3"
      And I am logged in as a user with the "sitebuilder" role
    When I am on "/admin/reports/users"
    Then I should see the link "Last Access"
      And I should see the link "behat ocdo"
      And I should not see the text "never" in the "behat ocdo" row
      And I should see the text "never" in the "user4@test.com" row
      And I should see the text "behat user1"
      And I should see the text "behat user2"
      And I should see the link "behat user3"
      And I should see the link "user4@test.com"
    When I click "Last Access"
    Then "behat user3" should precede "behat ocdo" for the query "//td[contains(@class, 'views-field-name')]"
    When I click "Last Access"
      And I scroll to the bottom
      And I click "Last page"
    Then "behat ocdo" should precede "behat user3" for the query "//td[contains(@class, 'views-field-name')]"
    When I select "OCDO" from "Role"
      And I press "Filter"
    Then I should see the link "behat ocdo"
      And I should see the text "behat user2"
      And I should see the link "user4@test.com"
      And I should not see the text "behat user1"
      And I should not see the link "behat user3"
    When I select "Blocked" from "Status"
      And I press "Filter"
    Then I should see the text "behat user2"
      And I should not see the link "behat user3"
      And I am logged in as a user with the "administrator" role
      And I am on "/admin/reports/users"
    When I fill in "Username contains" with "user3"
      And I press "Filter"
    Then I should see the link "behat user3"
      And I should not see the link "behat ocdo"
      And I should not see the link "behat user1"
      And I should not see the link "behat user2"
      And I should not see the link "user4@test.com"
      And I press "Reset"
    When I fill in "Username contains" with "user4"
      And I press "Filter"
    Then I should see the link "user4@test.com"
      And I should not see the link "behat ocdo"
      And I should not see the link "behat user1"
      And I should not see the link "behat user2"
      And I should not see the link "behat user3"
      And I press "Reset"

  @api
  Scenario Outline: Verify Roles Access To User Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/reports/users"
    Then I should see the heading "<result>"

    Examples:
      | role             | result        |
      | administrator    | Users         |
      | sitebuilder      | Users         |
      | Content Approver | Access denied |
      | Content Creator  | Access denied |

  @api
  Scenario Outline: Authorized Users Can Access Synced Content Page
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content/synced"
    Then I should see the heading "Synced Content"
      And I should see the link "Synced Content" in the "secondary_links" region
      And I should see the link "Title"
      And I should see the text "Approved Version"
      And I should see the link "Status"
      And I should see the link "Sync Date"
      And I should see the text "Operations"
      And I should see the text "Published status"
      And I should see the button "Filter"

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: Authorized Users Can Download/Export Dataset and Tools CSVs
    Given "tool_types" terms:
      | name           |
      | BEHAT Software |
      And "data_set" content:
        | title          | field_dataset_description | field_how_to_request_access | moderation_state |
        | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And "tools" content:
        | title      | field_dataset_description | field_tool_category | field_dataset_related_datasets | moderation_state |
        | BEHAT Tool | Tool description          | BEHAT Software      | BEHAT dataset1                 | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
      And I press the "List additional actions" button
    Then I should see the link "Download Dataset Data"
      And I should see the link "Download Tools Data"
      And I should see the link "Download Applications Data"
      And I should see the link "Download Software Data"
      And I should see the link "Download Platforms Data"
    When I click "Download Tools Data"
    Then I should not see the text "error occured"
    When I am on "/admin/content"
      And I press the "List additional actions" button
      And I click "Download Dataset Data"
      And I wait for ajax to finish
    Then I should not see the text "http error"
      And I should not see the text "error page"
      And I should not see the text "unexpected error"
      And I should see the text "Export complete. Download the file here."
      And I should see the link "here"

    Examples:
      | role          |
      | sitebuilder   |
      | administrator |

  @api @javascript
  Scenario Outline: Authorized Users Can Download/Export Applications, Software And Platforms CSVs
    Given "division_office" terms:
      | name      |
      | division1 |
      And "application" content:
      | title           | body             | field_summary          | field_division_office_multi | moderation_state |
      | New Application | This is the body | Summary of Application | division1                   | published        |
      And "component" content:
      | title           | body             | field_summary     | field_status | field_division_office_multi | moderation_state |
      | BEHAT Component | This is the body | Component Summary | Approved     | division1                   | published        |
      And "platform" content:
      | title        | body             | field_summary       | field_division_office_multi | moderation_state |
      | New Platform | This is the body | Summary of platform | division1                   | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
      And I press the "List additional actions" button
    Then I should see the link "Download Applications Data"
      And I should see the link "Download Software Data"
      And I should see the link "Download Platforms Data"
    When I click "Download Applications Data"
    Then I should not see the text "error occured"
    When I am on "/admin/content"
      And I press the "List additional actions" button
      And I click "Download Software Data"
    Then I should not see the text "error occured"
    When I am on "/admin/content"
      And I press the "List additional actions" button
      And I click "Download Platforms Data"
    Then I should not see the text "error occured"

    Examples:
      | role             |
      | Content Approver |
      | sitebuilder      |
      | administrator    |

  @api @javascript
  Scenario Outline: OPEN Data Moderator Additive Role Can Transition To Published-Public State
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "data_set":
      | title                            | <title>          |
      | field_summary                    | short            |
      | field_dataset_description        | This is the body |
      | field_division_office_multi      | division1        |
      | field_owner                      | new division     |
      | field_data_category              | category1        |
      | field_open_government_data_act_i | External         |
      | field_open_government_data_acces | DAaccess         |
      | field_open_government_data_class | DAclassification |
      | field_reviewer                   | approver         |
      | moderation_state                 | published        |
    #AC: Only way to get TO "Published-Public" is from "Published"
      And I am on "/datasets/<url_title>/edit"
    Then I should see the text "Published" in the "edit_page_status" region
    When I scroll to the bottom
    Then I should see the text "Published" in the "current_state" region
    When I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should see the text "Draft" in the "save_as_state" region
      And I should see the text "Review" in the "save_as_state" region
      And I should see the text "Published" in the "save_as_state" region
      And I should see the text "Archived" in the "save_as_state" region
      And I should see the text "Published-Public" in the "save_as_state" region
    When I select "Published-Public" from "Change to"
      And I press the "Save" button
    Then I should see the text "has been updated."
    When I am on "/datasets/<url_title>/edit"
    Then I should see the text "Published-Public" in the "edit_page_status" region
    #AC: Only options FROM "Published-Public" are to "Published" and "Draft"
    #1) Going from Published-Public to Published
    When I scroll to the bottom
    Then I should see the text "Published-Public" in the "current_state" region
    When I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should see the text "Draft" in the "save_as_state" region
      And I should see the text "Published" in the "save_as_state" region
      And I should not see the text "Review" in the "save_as_state" region
      And I should not see the text "Archived" in the "save_as_state" region
      And I should not see the text "Published-Public" in the "save_as_state" region
    When I select "Published" from "Change to"
      And I press the "Save" button
    Then I should see the text "has been updated."
    When I am on "/datasets/<url_title>/edit"
    Then I should see the text "Published" in the "edit_page_status" region
    #2) Going from Published-Public to Draft
      And I scroll to the bottom
      And I select "Published-Public" from "Change to"
      And I press the "Save" button
    Then I should see the text "has been updated."
    When I am on "/datasets/<url_title>/edit"
      And I scroll to the bottom
      And I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "has been updated."
    When I am on "/datasets/<url_title>/edit"
    Then I should see the text "Draft" in the "edit_page_status" region
    When I scroll to the bottom
      And I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should see the text "Draft" in the "save_as_state" region
      And I should see the text "Published" in the "save_as_state" region
      And I should see the text "Review" in the "save_as_state" region
      And I should see the text "Archived" in the "save_as_state" region
      And I should not see the text "Published-Public" in the "save_as_state" region

    Examples:
      | role                                  | title           | url_title       |
      | open_data_moderator, Content Approver | BEHAT Dataset 1 | behat-dataset-1 |
      | open_data_moderator, sitebuilder      | BEHAT Dataset 2 | behat-dataset-2 |

  @api @javascript
  Scenario Outline: Any Other Role Plus Content Creator Additive With OPEN Data Moderator Role Cannot Transition To Published-Public State
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "data_set":
      | title                            | <title>          |
      | field_summary                    | short            |
      | field_dataset_description        | This is the body |
      | field_division_office_multi      | division1        |
      | field_owner                      | new division     |
      | field_data_category              | category1        |
      | field_open_government_data_act_i | External         |
      | field_open_government_data_acces | DAaccess         |
      | field_open_government_data_class | DAclassification |
      | field_reviewer                   | approver         |
      | moderation_state                 | published        |
      And I am on "/datasets/<url_title>/edit"
    Then I should see the text "Published" in the "edit_page_status" region
    When I scroll to the bottom
      And I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should not see the text "Published-Public" in the "save_as_state" region

    Examples:
      | role             | title           | url_title       |
      | Content Creator  | BEHAT Dataset 1 | behat-dataset-1 |
      | Content Approver | BEHAT Dataset 2 | behat-dataset-2 |
      | sitebuilder      | BEHAT Dataset 3 | behat-dataset-3 |

  @api @javascript
  Scenario Outline: A Role With OPEN Data Moderator Role Cannot Transition To Published-Public State From Any Non-Published State
    Given I am logged in as a user with the "open_data_moderator, Content Approver" role
    When I am viewing a "data_set":
      | title                            | <title>            |
      | field_summary                    | short              |
      | field_dataset_description        | This is the body   |
      | field_division_office_multi      | division1          |
      | field_owner                      | new division       |
      | field_data_category              | category1          |
      | field_open_government_data_act_i | External           |
      | field_open_government_data_acces | DAaccess           |
      | field_open_government_data_class | DAclassification   |
      | field_reviewer                   | approver           |
      | moderation_state                 | <moderation_state> |
      And I am on "/datasets/<url_title>/edit"
      And I scroll to the bottom
      And I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should not see the text "Published-Public" in the "save_as_state" region

    Examples:
      | title           | url_title       | moderation_state |
      | BEHAT Dataset 1 | behat-dataset-1 | draft            |
      | BEHAT Dataset 2 | behat-dataset-2 | archived         |
      | BEHAT Dataset 3 | behat-dataset-3 | review           |
      | BEHAT Dataset 4 | behat-dataset-4 | rejected         |

  @api
  Scenario Outline: Authenticated Users Can Access Published Contacts
    Given "contact" content:
      | field_first_name | field_last_name | field_email     | moderation_state | field_division_office | nid |
      | Tom Jeffrey      | Yanks           | user1@email.com | published        | new division          | 1   |
    When I am logged in as a user with the "<role>" role
      And I am on "/node/1"
    Then I should see the text "Tom Jeffrey Yanks"

    Examples:
      | role            |
      | content_creator |
      | authenticated   |

  @api @javascript
  Scenario: Content Creator & Content Approver can access Metadata Dashboard
    Given I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
    When I am logged in as a user with the "Content Creator" role
      And I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Node ID" in the "Title" row
      And I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I click on the element with css selector "#dataset-dashboard-container > div.mb-2.mt-4 > select"
    Then I should see the text "Save and Review"
      And I should not see the text "Save and Publish"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/admin/dataset-dashboard"
    Then I should see the heading "Dataset Dashboard"
      And I should see the text "Node ID" in the "Title" row
      And I should see the text "1234501" in the "BEHAT Test Dataset 1" row
      And I click on the element with css selector "#dataset-dashboard-container > div.mb-2.mt-4 > select"
    Then I should see the text "Save and Review"
      And I should see the text "Save and Publish"

  @api
  Scenario: Sitebuilder and Authenticated user cannot access Metadata Dashboard
    Given I am viewing a "data_set":
      | title                            | BEHAT Test Dataset 1         |
      | field_summary                    | short                        |
      | field_dataset_description        | description                  |
      | field_division_office_multi      | division1                    |
      | field_owner                      | new division                 |
      | field_data_category              | category1                    |
      | field_open_government_data_acces | DAaccess                     |
      | field_open_government_data_class | DAclassification             |
      | field_reviewer                   | approver                     |
      | moderation_state                 | published                    |
      | nid                              | 1234501                      |
    When I am logged in as a user with the "Sitebuilder" role
      And I am on "/admin/dataset-dashboard"
    Then I should see the heading "Access denied"
    When I am logged in as a user with the "authenticated" role
      And I am on "/admin/dataset-dashboard"
    Then I should see the heading "Access denied"

  @api @javascript
  Scenario Outline: Additive Role for the Importer (Feeds) Access
    #Add a feed type (for dataset)
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/structure/feeds"
    Then I click on the element with css selector "#block-adminimal-theme-local-actions > ul > li"
      And I fill in "Name" with "Behat Feed"
      And I select "Upload file" from "Fetcher"
      And I select "CSV" from "Parser"
      And I select "Node" from "Processor"
      And I select "Dataset" from "Content type"
      And I click on the element with css selector "#feeds-ajax-form-wrapper > div > div > ul > li.vertical-tabs__menu-item.last > a"
      And I select the autocomplete option for "approver" on the "Owner" field
      And I press "Save and add mappings"
    Then I should see the text "Your changes have been saved."
    When I am on "/admin/structure/feeds"
    Then I should see the text "Behat Feed"
    #Modify the feed type
    When I click "Edit" in the "Behat Feed" row
      And I press "Basic settings"
      And I fill in "Name" with "Behat Feed - updated"
      And I press "Save feed type"
    Then I should see the text "Your changes have been saved."
      And I should see the text "Behat Feed - updated"
    #Delete the feed type
    When I click "Edit" in the "Behat Feed - updated" row
      And I click on the element with css selector "#edit-actions-delete"
      And I press the "Delete" button
    Then I should see the text "Behat Feed - updated has been deleted."
    When I am on "/admin/structure/feeds"
    Then I should not see the text "Behat Feed - updated"

    Examples:
      | role                                   |
      | Content Creator, importer_feeds_admin  |
      | Content Approver, importer_feeds_admin |
      | sitebuilder, importer_feeds_admin      |

  @api
  Scenario Outline: Roles without additive Importer (Feeds) Module role cannot access nor administer feeds importer
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content/feed"
    Then the response status code should be 403
    When I am on "/admin/structure/feeds"
    Then the response status code should be 403

    Examples:
      | role             |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |
