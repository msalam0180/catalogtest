Feature: Workflow For Content Types
  As a content creator
  I want to be able to upload documents to the data sets
  So that a site visitor will have access to documentation related to the application

  Background:
    Given "manufacturer" terms:
      | name                 |
      | Sony                 |
      | Adobe Acrobatic      |
      | Meta                 |
      | Microsoft Wordz      |
      | Microsoft Powerpoint |
      And users:
      | name           | mail                    | roles                         |
      | approver       | approver@test.com       | Content Approver              |
      | approver_sb-ca | approver_sb-ca@test.com | Content Approver, sitebuilder |
      And "division_office" terms:
      | name         |
      | division1    |
      | new division |
      And "application_status" terms:
      | name           |
      | BEHAT Status A |
      And "data_category" terms:
      | name      |
      | category1 |
      And "open_government_data_act_interna" terms:
      | name     |
      | External |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |

  @api
  Scenario: Tools Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "tools" content:
      | title               | Tool workflow |
      | body                | test          |
      | field_tool_category | Data Systems  |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Tool workflow" row

  @api
  Scenario: Dataset Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_set" content:
      | title                       | Dataset Workflow     |
      | field_dataset_description   | description          |
      | field_dataset_source_type   | SEC/EDGAR, SRO       |
      | field_time_period_covered   | 5days                |
      | field_dataset_datastore     | Hadoop               |
      | field_how_to_request_access | '' - http://test.com |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Dataset Workflow" row

  @api
  Scenario: Article Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "article" content:
      | title          | Article workflow |
      | field_summary  | Behat short des  |
      | body           | test             |
      | field_category | FAQ              |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Article workflow" row

  @api
  Scenario: Content Rejected Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "article" content:
      | title          | Article workflow - Rejected |
      | body           | test                        |
      | field_category | FAQ                         |
      And I select "Review" from "Change to"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
      And I select "Rejected" from "Change to"
      And I press "Apply"
    Then I should see the text "Revision log message required if content is being rejected"
    When I fill in "Log message" with "Is being rejected"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
      And I click "Moderated content"
    Then I should see the text "Rejected" in the "Article workflow - Rejected" row
    When I am on "/article-workflow-rejected/revisions"
    Then I should see the text "Is being rejected (Rejected)" in the "Current revision" row

  @api
  Scenario: DataInsight Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "data_insight" content:
      | title | Insight Workflow |
      | body  | This is the body |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Insight Workflow" row

  @api
  Scenario: Form Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "forms" content:
      | title | Forms Workflow         |
      | body  | Description about Form |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Forms Workflow" row

  @api
  Scenario: Reports Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "statistics" content:
      | title | Reports Workflow |
      | body  | Description      |
    When I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "Reports Workflow" row

  @api
  Scenario: Discussions Workflow
    Given I am logged in as a user with the "Content Approver" role
      And "forum" content:
      | title       | body          | moderation_state |
      | BEHAT Forum | This is Forum | draft            |
    When I am on "/discussions"
    Then I should not see the link "BEHAT Forum"
    When I am on "/discussions/behat-forum"
      And I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/discussions"
    Then I should see the link "BEHAT Forum"

  @api
  Scenario: Software Workflow
    Given users:
      | name          | mail               | roles            | status |
      | user_approver | approver@email.com | Content Approver | 1      |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "component" content:
      | title           | body                  | field_status | field_reviewer | moderation_state | field_documents   |
      | BEHAT Component | Component description | Evaluation   | user_approver  | draft            | Behat File Upload |
    When I am logged in as "user_approver"
      And  I am on "/admin/content"
    Then I should see the text "Unpublished" in the "BEHAT Component" row
    When I click "BEHAT Component"
      And I select "Published" from "new_state"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated"
    When I am on "/admin/content"
    Then I should see the text "Published" in the "BEHAT Component" row

  @api
  Scenario: Application Workflow
    Given I am logged in as a user with the "Content Approver" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "application" content:
      | title             | body        | field_summary | moderation_state | field_documents   |
      | BEHAT Application | description | Evaluation    | draft            | Behat File Upload |
    When I am on "/admin/content"
      And I should see the text "Unpublished" in the "BEHAT Application" row
      And I click "BEHAT Application"
      And I select "Published" from "new_state"
      And I press "Apply"
      And I should see the text "The moderation state has been updated"
      And I am on "/admin/content"
      And I should see the text "Published" in the "BEHAT Application" row

  @api @javascript
  Scenario: Platform Workflow
    Given I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And "division_office" terms:
      | name      |
      | division1 |
      And "platform" content:
      | title          | body        | field_summary | field_division_office_multi | field_documents   | moderation_state |
      | BEHAT Platform | description | summary       | division1                   | Behat File Upload | draft            |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/platforms/behat-platform"
    Then I should see the text "Access denied"
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
      And I should see the text "Unpublished" in the "BEHAT Platform" row
      And I click "BEHAT Platform"
      And I select "Published" from "new_state"
      And I press "Apply"
      And I should see the text "The moderation state has been updated"
      And I am on "/admin/content"
      And I should see the text "Published" in the "BEHAT Platform" row
      And I am logged in as a user with the "authenticated user" role
    When I am on "/platforms/behat-platform"
    Then I should see the heading "BEHAT Platform"

  @api @javascript
  Scenario Outline: Discussion Board Workflow
    Given I am logged in as a user with the "<role>" role
    When I visit "/discussions"
      And I should see the text "Discussions"
      And I click "Start a New Discussion"
    Then I should see the heading "Create Discussion"
    When I fill in "Title" with "WorkFlow Issue"
      And I select "Datasets" from "Category"
      And I type "Testing for bug" in the "Body" WYSIWYG editor
      And I scroll to the bottom
      And I press the "Post Discussion" button
    Then I should see the text "Discussion WorkFlow Issue has been created."
    When I visit "/discussions"
    Then I should see the link "WorkFlow Issue"
    When I am logged in as a user with the "content_approver" role
      And I am on "/admin/content/discussions"
      And I click "Edit" in the "WorkFlow Issue" row
      And I scroll to the bottom
      And I select "draft" from "Change to"
      And I press the "Post Discussion" button
    Then I should see the text "Discussion WorkFlow Issue has been updated"
      And I should see the text "published" in the "WorkFlow Issue" row
    When I am logged in as a user with the "<role>" role
      And I visit "/discussions"
    Then I should see the link "WorkFlow Issue"
    When I am logged in as a user with the "content_approver" role
      And I am on "/admin/content/discussions"
      And I click "Edit" in the "WorkFlow Issue" row
      And I scroll to the bottom
      And I select "archived" from "Change to"
      And I press the "Post Discussion" button
    Then I should see the text "Discussion WorkFlow Issue has been updated"

      Examples:
       | role             |
       | authenticated    |
       | content_creator  |
       | content_approver |
       | forum_moderator  |

  @api @javascript
  Scenario Outline: Authorized Users Can Send Feedback
    Given I am logged in as a user with the "<role>" role
    When I visit "/"
      And I click on the element with css selector "#block-feedbacklinkblock > a"
      And I wait for ajax to finish
      And I fill in "Message" with "Testing Message"
      And check "Send yourself a copy"
      And I click on the element with css selector ".ui-dialog-buttonset"
      And I wait for ajax to finish
    Then I should see the text "Thank you for your feedback!"
      And I should see the link "Join the Catalog as a Contributor"

      Examples:
       | role             |
       | authenticated    |
       | Content Creator  |
       | Content Approver |

  @api @javascript
  Scenario: Review Feedback Admin Page
    Given users:
      | name     | mail              | roles           |
      | feedback | feedback@test.com | Content Creator |
      And "application" content:
      | title             | field_reviewer | moderation_state |
      | BEHAT Application | approver       | published        |
      And I am logged in as "feedback"
    When I visit "/applications/behat-application"
      And I click "Feedback"
      And I wait for ajax to finish
      And I fill in "Message" with "Testing Message"
      And check "Send yourself a copy"
      And I click on the element with css selector ".ui-dialog-buttonset"
      And I wait for ajax to finish
    Then I should see the text "Thank you for your feedback!"
      And I should see the link "Join the Catalog as a Contributor"
    When I am logged in as a user with the "administrator" role
      And I visit "/admin/content/feedback"
    Then I should see the heading "Feedback"
    When I select "False" from "Reviewed"
      And I press "Apply"
      And I select "Mark as Reviewed" from "Action"
      And I check "Update this item"
      And I press "Apply to selected items"
    Then I should see the text "Mark as Reviewed was applied to 1 item."
    When I press "Reset"
      And I select "approver" from "Feedback Reviewer"
      And I press "Apply"
      And I click on the element with css selector ".dropbutton-toggle"
      And I click on the element with css selector ".secondary-action"
      And I fill in "Reviewer Notes" with "Behat Review1"
      And I press "Save"
      And I click on the element with css selector ".dropbutton-toggle"
      And I click on the element with css selector ".secondary-action"
      And I click on the element with css selector "#block-adminimal-theme-breadcrumbs > nav > ol > li:nth-child(6) > a"
      And I should see the text "The sender's name"
      And I should see the link "feedback@test.com"
      And I should see the text "The sender's email"
      And I should see the text "URL"
      And I should see the text "Message"
      And I should see the text "Reviewer Notes"
      And I should see the text "Behat Review1"
      And I click "Mark as Needs Review"
      And I wait for ajax to finish
    Then I should see "Mark as Reviewed"
    When I am on "/admin/content/feedback"
    Then I should see the text "False" in the "feedback@test.com" row
    When I click "View" in the "feedback@test.com" row
      And I click "Mark as Reviewed"
      And I wait 3 seconds
    Then I should see "Mark as Needs Review"
    When I am on "/admin/content/feedback"
    Then I should see the text "True" in the "feedback@test.com" row
    When I select "Delete contact message" from "Action"
      And I check "Update this item"
      And I press "Apply to selected items"
      And I press "Delete"
    Then I should see the text "Deleted 1 item."
      And I should not see the link "http://datacatalog01.dev.dd:8083/applications/behat-application"

  @api
  Scenario Outline: Access Denied To Feedback
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content/feedback"
    Then I should see the text "You are not authorized to access this page"

      Examples:
        | role            |
        | authenticated   |
        | content_creator |

  @api @javascript
  Scenario: Add Manufacturer to Admin Content Dashboard Search & Column Updates
    Given "component" content:
      | title       | body     | field_summary | field_manufacturer | field_status_usage | moderation_state |
      | BEHAT Comp1 | somebody | test summary  | Sony               | Approved           | published        |
      | BEHAT Comp2 | somebody | test summary  | Adobe Acrobatic    | Approved           | published        |
      And "platform" content:
      | title             | body     | field_summary                | field_manufacturer   | moderation_state |
      | BEHAT Platform1   | somebody | Summary of platform new      | Meta                 | published        |
      | BEHAT Platform2   | somebody | Summary of platform category | Microsoft Wordz      | published        |
      | BEHAT Plat title1 | somebody | Summary of platform category | Microsoft Powerpoint | published        |
    #Add Manufacturer to the search on the admin content page
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
      And I enter "Sony" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Comp1" in the "Sony" row
      And I should see "Sony" in the "BEHAT Comp1" row
      And I should not see "BEHAT Comp2"
    #Search more than one field at a time (AND Search)
    When I enter "Adobe Acrobatic" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Comp2" in the "Adobe Acrobatic" row
      And I should not see "BEHAT Comp1"
    When I enter "ADOBE" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Comp2" in the "Adobe Acrobatic" row
    When I enter "acrobatic" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Comp2" in the "Adobe Acrobatic" row
    When I enter "Meta" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Platform1" in the "Meta" row
    When I enter "microsoft Wordz" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Platform2" in the "Microsoft Wordz" row
    When I enter "Microsoft" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Platform2" in the "Microsoft Wordz" row
    When I enter "Wordz" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Platform2" in the "Microsoft Wordz" row
    #Search more than one field at a time (AND Search with title search)
    When I enter "plat micro" for "Search"
      And I press "Filter"
    Then I should see "BEHAT Platform2" in the "Microsoft Wordz" row
      And I should see "BEHAT Plat title1" in the "Microsoft Powerpoint" row
      And I should not see "BEHAT Platform1"
    #Update the Author field to be an "Updated By" field  &  Add "Manufacturer" column to the Admin Content page
      And I should see the link "Updated By" in the "admincontent_view" region
      And I should not see the link "Author" in the "admincontent_view" region
      And I should see "Anonymous (not verified)" in the "BEHAT Platform2" row
      And I should see the link "Manufacturer" in the "admincontent_view" region
      And I should see "Microsoft Wordz" in the "BEHAT Platform2" row

  @api @javascript
  Scenario Outline: Content Workflows - New > Draft > Review > Published
    #CC or Author creates new & saves as Draft
    Given I am logged in as a user with the "<role1>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver_sb-ca" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the text "Draft" in the "moderation_state_status" region
      And I should see the heading "<title>"
      And I should see the text "Creating a draft article as a <role1> or Author"
    #CC, CA & SB or RS-Review Submitter Send for Review
    When I select "Review" from "Change to"
      And I fill in "Log message" with "Sending for Review as a <role1> or Author"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated."
      And I should see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region
    When I am on "<url2>/revisions"
    Then I should see the text "Sending for Review as a <role1> or Author" in the "Current revision" row
    #CA & SB reviews then Publishes
    When I am logged in as a user with the "<role2>" role
      And I am on "/admin/content/moderated"
    Then I should see the text "<title>" in the "approver_sb-ca" row
      And I should see the text "Review" in the "approver_sb-ca" row
    When I am on "<url1>"
      And I type "This has been reviewed for publication by <role2> or Reviewer" in the "Body" WYSIWYG editor
      And I select "Published" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "This has been reviewed for publication by <role2> or Reviewer"
    When I am logged in as a user with the "authenticated user" role
      And I am on "<url2>"
    Then I should see the text "<title>"
      And I should see the text "This has been reviewed for publication by <role2> or Reviewer"

    Examples:
      | role1            | role2            | title           | url1                  | url2             |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1/edit | /behat-article-1 |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2/edit | /behat-article-2 |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3/edit | /behat-article-3 |

  @api @javascript
  Scenario Outline: Content Workflows - New > Draft > Published
    #CC or Author creates new & saves as Draft
    Given I am logged in as a user with the "<role1>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the text "Creating a draft article as a <role1> or Author"
      And I should see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region
    #CA and SB then Publishes
    When I am logged in as a user with the "<role2>" role
      And I am on "<url1>"
      And I type "This is ready to publish by <role2>" in the "Body" WYSIWYG editor
      And I select "Published" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "This is ready to publish by <role2>"
    When I am logged in as a user with the "authenticated user" role
      And I am on "<url2>"
    Then I should see the text "<title>"
      And I should see the text "This is ready to publish by <role2>"

    Examples:
      | role1            | role2            | title           | url1                  | url2             |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1/edit | /behat-article-1 |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2/edit | /behat-article-2 |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3/edit | /behat-article-3 |

  @api @javascript
  Scenario Outline: Content Workflows - New > Draft > Review > Draft
    #CC or Author creates new & saves as Draft
    Given I am logged in as a user with the "<role1>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the text "Draft" in the "moderation_state_status" region
      And I should see the heading "<title>"
      And I should see the text "Creating a draft article as a <role1> or Author"
    #CC, CA & SB or RS-Review Submitter Send for Review
    When I am on "<url2>"
      And I type "Sending for Review as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select "Review" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "Sending for Review as a <role1> or Author"
    When I am logged in as a user with the "<role2>" role
      And I am on "<url1>"
    Then I should see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region
    #CA & SB Send back to Draft
    When I am logged in as a user with the "<role2>" role
      And I am on "<url2>"
      And I type "Sending back to Draft by <role2> or Reviewer" in the "Body" WYSIWYG editor
      And I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "Sending back to Draft by <role2> or Reviewer"
      And I should see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region

    Examples:
      | role1            | role2            | title           | url1             | url2                  |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1 | /behat-article-1/edit |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2 | /behat-article-2/edit |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3 | /behat-article-3/edit |

  @api @javascript
  Scenario Outline: Content Workflows - New > Draft > Review > Rejected > Draft
    #CC or Author creates new & saves as Draft
    Given I am logged in as a user with the "<role1>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the text "Draft" in the "moderation_state_status" region
      And I should see the heading "<title>"
      And I should see the text "Creating a draft article as a <role1> or Author"
    #CC, CA & SB or RS-Review Submitter Send for Review
    When I am on "<url2>"
      And I type "Sending for Review as a <role1> or Author" in the "Body" WYSIWYG editor
      And I select "Review" from "Change to"
      And I fill in "Revision log message" with "sending content to review"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "Sending for Review as a <role1> or Author"
    When I am logged in as a user with the "<role2>" role
      And I am on "<url1>"
    Then I should see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region
    #CA & SB Send to Rejected
    When I am logged in as a user with the "<role2>" role
      And I am on "<url2>"
      And I type "Rejected since it needs revision by <role1> or Author" in the "Body" WYSIWYG editor
      And I select "Rejected" from "Change to"
      And I press the "Save" button
    Then I should see the text "Revision log message required if content is being rejected"
    When I fill in "Revision log message" with "Is being rejected"
      And I select "Rejected" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "Rejected since it needs revision by <role1> or Author"
      And I should see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region
    #CA & SB Send back to Draft
    When I am logged in as a user with the "<role2>" role
      And I am on "<url2>"
      And I type "Sending back to Draft by <role2> or Author" in the "Body" WYSIWYG editor
      And I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
      And I should see the text "Sending back to Draft by <role2> or Author"
      And I should see the text "Draft" in the "moderation_state_status" region
      And I should not see the text "Review" in the "moderation_state_status" region
      And I should not see the text "Published" in the "moderation_state_status" region
      And I should not see the text "Rejected" in the "moderation_state_status" region
      And I should not see the text "Archived" in the "moderation_state_status" region

    Examples:
      | role1            | role2            | title           | url1             | url2                  |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1 | /behat-article-1/edit |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2 | /behat-article-2/edit |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3 | /behat-article-3/edit |

  @api @javascript
  Scenario Outline: Content Workflows - Published > Draft
    #CA or SB creates published content
    Given I am logged in as a user with the "<role2>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "An article" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the heading "<title>"
      And I should see the text "An article"
    When I am on "<url>"
    Then I should see the text "Published" in the "edit_page_status" region
    #CC, CA, SB transition from Published to Draft
    When I am logged in as a user with the "<role1>" role
      And I am on "<url>"
      And I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
    When I am on "<url>"
    Then I should see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Review" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Archived" in the "edit_page_status" region

    Examples:
      | role1            | role2            | title           | url                   |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1/edit |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2/edit |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3/edit |

  @api @javascript
  Scenario Outline: Content Workflows - Published > Review
    #CA or SB creates published content
    Given I am logged in as a user with the "<role2>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "An article" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the heading "<title>"
      And I should see the text "An article"
    When I am on "<url>"
    Then I should see the text "Published" in the "edit_page_status" region
    #CC, CA, SB transition from Published to Review
    When I am logged in as a user with the "<role1>" role
      And I am on "<url>"
      And I select "Review" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
    When I am on "<url>"
    Then I should see the text "Review" in the "edit_page_status" region
      And I should not see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Archived" in the "edit_page_status" region

    Examples:
      | role1            | role2            | title           | url                   |
      | Content Creator  | Content Approver | BEHAT Article 1 | /behat-article-1/edit |
      | Content Approver | Content Approver | BEHAT Article 2 | /behat-article-2/edit |
      | sitebuilder      | sitebuilder      | BEHAT Article 3 | /behat-article-3/edit |

  @api @javascript
  Scenario Outline: Content Workflows - Archived > Draft
    #CA or SB creates archived content
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "An article" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Archived" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the heading "<title>"
      And I should see the text "An article"
    When I am on "<url>"
    Then I should see the text "Archived" in the "edit_page_status" region
    #CA, SB transition from Archived to Draft
    When I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
    When I am on "<url>"
    Then I should see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Review" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Archived" in the "edit_page_status" region

    Examples:
      | role             | title           | url                   |
      | Content Approver | BEHAT Article 1 | /behat-article-1/edit |
      | sitebuilder      | BEHAT Article 2 | /behat-article-2/edit |

  @api @javascript
  Scenario Outline: Content Workflows - Archived > Review
    #CA or SB creates archived content
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "An article" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Archived" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the heading "<title>"
      And I should see the text "An article"
    When I am on "<url>"
    Then I should see the text "Archived" in the "edit_page_status" region
    #CA, SB transition from Archived to Review
    When I am on "<url>"
      And I select "Review" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article <title> has been updated."
    When I am on "<url>"
    Then I should see the text "Review" in the "edit_page_status" region
      And I should not see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Archived" in the "edit_page_status" region

    Examples:
      | role             | title           | url                   |
      | Content Approver | BEHAT Article 1 | /behat-article-1/edit |
      | sitebuilder      | BEHAT Article 2 | /behat-article-2/edit |

  @api @javascript
  Scenario Outline: Content Workflows - Content Approver can update from all states > Archived
    Given "landing_page" content:
        | title           | body                           | field_summary                  | moderation_state | field_reviewer |
        | BEHAT Landing 1 | This is the BEHAT landing page | Landing Page Short Description | draft            | approver       |
      And "tools" content:
        | title        | body         | field_dataset_description | field_tool_category | moderation_state | field_reviewer |
        | BEHAT Tool 1 | this is tool | description               | Data Systems        | review           | approver       |
      And "platform" content:
        | title            | body                  | field_summary       | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Platform 1 | This is the body test | Summary of platform | Approved           | division1                   | rejected         | approver       |
      And "component" content:
        | title             | body                             | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Component 1 | Description about component test | Summary       | Approved           | division1                   | published        | approver       |
      And "page" content:
        | title        | body             | field_summary | moderation_state |
        | BEHAT Page 1 | This is the body | page test     | archived         |
    #CA transition from any state to Archived
    When I am logged in as a user with the "Content Approver" role
      And I am on "<url>"
      And I select "Archived" from "Change to"
      And I press the "Save" button
    Then I should see the text "<title> has been updated."
    When I am on "<url>"
    Then I should see the text "Archived" in the "edit_page_status" region
      And I should not see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Review" in the "edit_page_status" region

    Examples:
      | title             | url                              |
      | BEHAT Landing 1   | /behat-landing-1/edit            |
      | BEHAT Tool 1      | /tool/behat-tool-1/edit          |
      | BEHAT Platform 1  | /platforms/behat-platform-1/edit |
      | BEHAT Component 1 | /software/behat-component-1/edit |
      | BEHAT Page 1      | /behat-page-1/edit               |

  @api @javascript
  Scenario Outline: Content Workflows - Sitebuilder can update from all states > Archived
    Given "landing_page" content:
        | title           | body                           | field_summary                  | moderation_state | field_reviewer |
        | BEHAT Landing 1 | This is the BEHAT landing page | Landing Page Short Description | draft            | approver       |
      And "tools" content:
        | title        | body         | field_dataset_description | field_tool_category | moderation_state | field_reviewer |
        | BEHAT Tool 1 | this is tool | description               | Data Systems        | review           | approver       |
      And "platform" content:
        | title            | body                  | field_summary       | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Platform 1 | This is the body test | Summary of platform | Approved           | division1                   | rejected         | approver       |
      And "component" content:
        | title             | body                             | field_summary | field_status_usage | field_division_office_multi | moderation_state | field_reviewer |
        | BEHAT Component 1 | Description about component test | Summary       | Approved           | division1                   | published        | approver       |
      And "page" content:
        | title        | body             | field_summary | moderation_state |
        | BEHAT Page 1 | This is the body | page test     | archived         |
    #CA transition from any state to Archived
    When I am logged in as a user with the "sitebuilder" role
      And I am on "<url>"
      And I select "Archived" from "Change to"
      And I press the "Save" button
    Then I should see the text "<title> has been updated."
    When I am on "<url>"
    Then I should see the text "Archived" in the "edit_page_status" region
      And I should not see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Published" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Review" in the "edit_page_status" region

    Examples:
      | title             | url                              |
      | BEHAT Landing 1   | /behat-landing-1/edit            |
      | BEHAT Tool 1      | /tool/behat-tool-1/edit          |
      | BEHAT Platform 1  | /platforms/behat-platform-1/edit |
      | BEHAT Component 1 | /software/behat-component-1/edit |
      | BEHAT Page 1      | /behat-page-1/edit               |

  @api @javascript
  Scenario Outline: Content Workflows - New > Published
    #CA and SB creates new then directly publishes without saving as Draft
    Given I am logged in as a user with the "<role>" role
    When I am on "/node/add/article"
      And I fill in "Title" with "<title>"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Published article as a <role> or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the text "Article <title> has been created."
      And I should see the text "Published article as a <role> or Author"
    When I am on "<url1>"
    Then I should see the text "Published" in the "edit_page_status" region
      And I should not see the text "Draft" in the "edit_page_status" region
      And I should not see the text "Archived" in the "edit_page_status" region
      And I should not see the text "Rejected" in the "edit_page_status" region
      And I should not see the text "Review" in the "edit_page_status" region
    When I am logged in as a user with the "authenticated user" role
      And I am on "<url2>"
    Then I should see the text "<title>"
      And I should see the text "Published article as a <role> or Author"

    Examples:
      | role             | title           | url1                  | url2             |
      | Content Approver | BEHAT Article 1 | /behat-article-1/edit | /behat-article-1 |
      | sitebuilder      | BEHAT Article 2 | /behat-article-2/edit | /behat-article-2 |

  @api @javascript
  Scenario: Content Creator does not have the ability to archive, publish or reject
    #CC creates new & saves as Draft
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article 1"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Created a draft article as a Content Creator" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the text "Draft" in the "moderation_state_status" region
      And I should see the heading "BEHAT Article 1"
      And I should see the text "Created a draft article as a Content Creator"
    #CC sees restricted state transition droplist choices on the view node page
    When I click on the element with css selector "#edit-new-state"
    Then I should see the text "Review" in the "moderation_state" region
      And I should not see the text "Published" in the "moderation_state" region
      And I should not see the text "Archived" in the "moderation_state" region
      And I should not see the text "Rejected" in the "moderation_state" region
    #CC sees restricted state transition droplist choices on the edit node page
    When I am on "/behat-article-1/edit"
      And I scroll to the bottom
      And I click on the element with css selector "#edit-moderation-state-0-state"
    Then I should see the text "Draft"
      And I should see the text "Review"
      And I should not see the text "Published"
      And I should not see the text "Archived"
      And I should not see the text "Rejected"

  @api @javascript
  Scenario: Content Workflows - Needs Review
    Given I am logged in as a user with the "content_creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "Behat Article 1"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a content creator or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver_sb-ca" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
      And I select "Review" from "Change to"
      And I fill in "Log message" with "Sending for Review as a content creator or Author"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated."
      And I should see the text "Review" in the "moderation_state_status" region
    When I am on "/behat-article-1/revisions"
    Then I should see the text "Sending for Review as a content creator or Author" in the "Current revision" row
      #Check that assigned review content is going to the reviewer's needs review view
    When I am logged in as "approver_sb-ca"
      And I am on "/admin/content/mymoderated"
    Then I should see the text "Behat Article 1" in the "approver_sb-ca" row
      And I should see the text "Review" in the "approver_sb-ca" row

  @api @javascript
  Scenario: Review > Draft - Content Creator role can send back from Review to Draft while other fields are locked in Review state
    #CC Creates their content and sends for Review
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "BEHAT Article One"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating an article" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Review" from "Save as"
      And I press "Save"
    Then I should see the text "Article BEHAT Article One has been created."
      And I should see the text "Review" in the "moderation_state_status" region
    #CC Sends back to Draft
    When I am on "/behat-article-one/edit"
    Then I should see the text "This node is under review and editing has been disabled."
    When I select "Draft" from "Change to"
      And I press the "Save" button
    Then I should see the text "Article BEHAT Article One has been updated."

  @api @javascript
  Scenario: Content Workflows - Content Creators Cannot Edit Content in Review State, But Can Change Workflow State Back to Draft
    Given I am logged in as a user with the "content_creator" role
    When I am on "/node/add/article"
      And I fill in "Title" with "Behat Article 1"
      And I fill in "Short Description" with "BEHAT Short"
      And I type "Creating a draft article as a content creator or Author" in the "Body" WYSIWYG editor
      And I select the autocomplete option for "approver_sb-ca" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
      And I select "Review" from "Change to"
      And I fill in "Log message" with "Sending for Review as a content creator or Author"
      And I press "Apply"
      And I click "Edit"
    Then I should see "Behat Article 1"
      And I should see the field "Title" is disabled
      And I should see the field "Short Description" is disabled
      And I should see the field "Body" is disabled
      And I should see the field "Category" is disabled
    When I press "Save"
      And I click "Edit"
      And I type "Version 2 " in the "Body" WYSIWYG editor
      And I press "Save"
    Then I should see the text "Article Behat Article 1 has been updated."
      And I should see the text "Version 2"

  @api @javascript
  Scenario Outline: Content Workflows - Content Creators With an Additive Role Can Edit Content in Review State
    Given  "tools" content:
      | title        | body         | field_dataset_description | field_tool_category | moderation_state | field_reviewer |
      | BEHAT Tool 1 | this is tool | description               | Data Systems        | review           | approver       |
      And I am logged in as a user with the "<role>" role
    When I am on "/tool/behat-tool-1/edit"
      And I fill in "Title" with "<new_tittle>"
      And I should see the text "Review" in the "tools_moderation_status" region
      And I press "Save"
    Then I should see "<new_tittle>"

    Examples:
      | role                              | new_tittle    |
      | Content Creator, Content Approver | Tools Title 1 |
      | Content Creator, sitebuilder      | Tools Title 2 |
      | Content Creator, Administrator    | Tools Title 3 |

  @api @javascript
  Scenario: Content Ready to Review Email Links
    Given I am logged in as a user with the "Content Approver, migration_admin" role
    When I am on "/node/add/component"
      And I fill in "Title" with "Planview Enterprise One Vision Plugin 17.0 email test for software testing"
      And I fill in "Short Description" with "The Planview Enterprise"
      And I type "Vision plugin allows creation of EA models using Microsoft Vision and update PlanView repository" in the "Detailed Description" WYSIWYG editor
      And I select "Catalog" from "Approval Status"
      And I select "Enterprise" from "Divisions/Offices that use this" for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Published" from "Save as"
      And I press "Save"
    Then I should see the text "Software Planview Enterprise One Vision Plugin 17.0 email test for software testing has been created."
    When I click "Edit" in the "node_action" region
      And I select "Review" from "Change to"
      And I press "Save"
      And I check notification
      And I click on the element with css selector "div > div.col-md-10.col-sm-9.content > div.messages.container-fluid.ng-scope > div:nth-child(1) > div.col-md-5.col-sm-5 > span"
    Then I should see the link "http://catalog.lndo.site/software/planview-enterprise-one-vision-plugin-170-email-test-software-testing/revisions"
    When I click "http://catalog.lndo.site/software/planview-enterprise-one-vision-plugin-170-email-test-software-testing/revisions"
    Then the link should open in a new tab
      And I should see the heading "Revisions for Planview Enterprise One Vision Plugin 17.0 email test for software testing"
      And I close the current tab

  @api
  Scenario Outline: Add State to Admin Content Dashboard Table
    Given "data_set" content:
      | title           | field_summary | field_dataset_description | field_division_office_multi | field_owner  | field_data_category | field_open_government_data_act_i | field_open_government_data_acces | field_open_government_data_class | field_reviewer | moderation_state |
      | BEHAT Dataset 1 | short         | This is the body          | division1                   | new division | category1           | External                         | DAaccess                         | DAclassification                 | approver       | draft            |
      | BEHAT Dataset 2 | short         | This is the body          | division1                   | new division | category1           | External                         | DAaccess                         | DAclassification                 | approver       | review           |
      | BEHAT Dataset 3 | short         | This is the body          | division1                   | new division | category1           | External                         | DAaccess                         | DAclassification                 | approver       | published        |
      | BEHAT Dataset 4 | short         | This is the body          | division1                   | new division | category1           | External                         | DAaccess                         | DAclassification                 | approver       | rejected         |
      | BEHAT Dataset 5 | short         | This is the body          | division1                   | new division | category1           | External                         | DAaccess                         | DAclassification                 | approver       | archived         |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content"
    Then I should see the text "State" in the "Title" row
      And I should see the text "<state>" in the "<row>" row

    Examples:
      | role             | state     | row             |
      | Content Creator  | Published | BEHAT Dataset 3 |
      | Content Approver | Draft     | BEHAT Dataset 1 |
      | Content Approver | Review    | BEHAT Dataset 2 |
      | Content Approver | Published | BEHAT Dataset 3 |
      | Content Approver | Rejected  | BEHAT Dataset 4 |
      | sitebuilder      | Archived  | BEHAT Dataset 5 |
