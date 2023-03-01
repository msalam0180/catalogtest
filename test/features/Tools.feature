Feature: Tools, System And Applications
  As a site visitor I want to have the ability to view listings of
  Tools catagorized by Analytical tools, business applications, or data systems

  Background:

    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "tool_types" terms:
      | name                           |
      | BEHAT Data Systems             |
      | BEHAT Software                 |
      | BEHAT Platforms / Applications |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
      And  "article" content:
      | title         | body | moderation_state |
      | BEHAT Article | test | published        |
      And "forums" terms:
      | name           |
      | Behat Datasets |
      And "division_office" terms:
      | name      |
      | division1 |
      | ndivision |
      And "tags" terms:
      | name  |
      | bingo |

  @api @javascript
  Scenario Outline: Authorized Users Can Create New Toolsets
    Given I am logged in as a user with the "<role>" role
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
    When I am on "/node/add/tools"
      And I fill in "Title" with "New tool test"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "BEHAT Data Systems" from "field_tool_category"
      And I fill in "How to Request Access" with "http://google.com"
      And I fill in "Contact Guidance" with "New Guidance"
      And I click on the element with css selector "#edit-field-technical-owner-actions-ief-add"
      And I wait for ajax to finish
      And I fill in "Technical" for "First Name"
      And I fill in "Owner" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "EEO" from "field_technical_owner[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I click on the element with css selector "#edit-field-technical-subject-matter-e-actions-ief-add"
      And I wait for ajax to finish
      And I fill in "Subject" for "First Name"
      And I fill in "Expert" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "OA" from "field_technical_subject_matter_e[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I click on the element with css selector "#edit-field-point-s-of-contact-actions-ief-add"
      And I wait for ajax to finish
      And I fill in "PointOf" for "First Name"
      And I fill in "Contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "ARO" from "field_point_s_of_contact[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I click on the element with css selector "#edit-field-contact-actions-ief-add"
      And I wait for ajax to finish
      And I fill in "Other" for "First Name"
      And I fill in "Contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I select "ARO" from "field_contact[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I press "Add existing Document"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for ajax to finish
      And I should see the text "Select Files"
      And I wait for ajax to finish
      And I switch to the "files" selector
      And I wait 2 seconds
      And I fill in "Media name" with "Behat File Upload"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat File Upload" on the files selector
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait 2 seconds
      And I switch to the "articles" selector
      And I fill in "Title" with "BEHAT Article"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "BEHAT Article" on the files selector
      And I press "Select Articles"
      And I wait for ajax to finish
      And I switch to the main window
      And I select the autocomplete option for "BEHAT dataset1" on the "Related Datasets" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I wait for ajax to finish
    Then I should see the text "New tool test"
      And I should see the link "BEHAT Data Systems" in the "tools_details" region
      And I should see the link "Request Access"
      And I should see the text "Contact Guidance"
      And I should see the text "New Guidance"
      And I should see the link "Technical Owner"
      And I should see the link "Subject Expert"
      And I should see the link "PointOf Contact"
      And I should see the link "Other Contact"
      And I should see the link "Behat File Upload"
      And I should see the link "BEHAT Article"
      And I should see the text "Related Datasets"
      And I should see the text "BEHAT dataset1"
      And I click "BEHAT Data Systems" in the "tools_details" region
      And I should see the heading "BEHAT Data Systems"
    Examples:
      | role             |
      | administrator    |
      | Content Creator  |
      | Content Approver |
      | sitebuilder      |

  @api @javascript
  Scenario: Tools Verify User Can Click On The Edit Pencil Icon
    Given I am logged in as a user with the "Content Approver" role
      And I am viewing a "tools" content:
      | title                     | Behat Tool         |
      | field_tool_category       | BEHAT Data Systems |
      | field_dataset_description | test               |
      | moderation_state          | published          |
      And I wait 3 seconds
      And I press the "Edit" button
      And I press "configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait 1 seconds
      And I should see the text "Edit Tool Behat Tool"

  @api @javascript
  Scenario: Tools Can Be Associated With Datasets
    Given I am logged in as a user with the "Content Approver" role
      And "tools" content:
      | title             | field_tool_category | field_dataset_description | moderation_state |
      | Behat Tool Upload | BEHAT Data Systems  | test                      | published        |
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
      | name     |
      | DAaccess |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Document upload test"
      And I fill in "Short Description" with "BEHAT Short Description"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "Dataset" from "OCDO Classification"
      And I select "category1" from "Data Category for Landing Page Display"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I scroll to the top
      And I click "Related Content" in the "tools_tab" region
      And I press "Add existing Tool"
      And I wait for ajax to finish
      And I press "Select Tools"
      And I wait for ajax to finish
      And I should see the text "Select Tools"
      And I wait for ajax to finish
      And I switch to the "tools" selector
      And I wait 1 seconds
      And I fill in "Title" with "Behat Tool Upload"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat Tool Upload" on the files selector
      And I press "Select Tools"
      And I switch to the main window
      And I wait 2 seconds
      And I scroll to the top
      And I click "Governance"
      And I select "ndivision" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
      And I wait 2 seconds
      And I click "Related Content" in the "horizotal_tabs" region
      And I scroll to the bottom
    Then I should see the text "Behat Tool Upload"
      And I click "Behat Tool Upload" in the "tools" region
      And I should see the text "BEHAT Data Systems"

  @api
  Scenario: Users Can View The Software Tool Category Page
    Given I am logged in as a user with the "authenticated user" role
    When I am on "/tools/Software"
      And I should see the text "Software"
    Then I should see the text "Programming Languages"

  @api
  Scenario: Users Can View The Platforms-applications Category Page
    Given I am logged in as a user with the "authenticated user" role
    When I am on "/tools/platforms-applications"
      And I should see the text "Platforms / Applications"
    Then I should see the text "Data / Analysis"

  @api @javascript
  Scenario: Existing Articles Can Be Associated With A Tool
    Given I am logged in as a user with the "Content Creator" role
      And "article" content:
      | title        | body | field_category | moderation_state |
      | tool article | test | FAQ            | published        |
    When I am on "/node/add/tools"
      And I fill in "Title" with "tool with article"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I press "Add existing Article"
      And I wait for ajax to finish
      And I press "Select Articles"
      And I wait for ajax to finish
      And I should see the text "Select Articles"
      And I wait for ajax to finish
      And I switch to the "articles" selector
      And I fill in "Title" with "tool article"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "tool article" on the files selector
      And I press "Select Articles"
      And I switch to the main window
      And I wait 2 seconds
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I should see the text "tool with article"
      And I wait 1 seconds
      And I should see the text "Articles"
    Then I should see the link "tool article"

  @api
  Scenario Outline: Verify Tools Page URL
    Given "tools" content:
      | title        | body             | field_tool_category | moderation_state |
      | Tool Title 1 | Tool description | BEHAT Software      | published        |
      | TOOLs.TITLE  | this is tool 2   | BEHAT Data Systems  | published        |
      And I am logged in as a user with the "Content Creator" role
      And I am on "<URL>"
    Then the response status code should be 200
    Examples:
      | URL                |
      | /tool/tool-title-1 |
      | /tool/toolstitle   |

  @api
  Scenario: Tools Page Visual Distinction
    Given I am viewing a "tools" content:
      | title                     | Behat DS Tool      |
      | field_tool_category       | BEHAT Data Systems |
      | field_dataset_description | test               |
      | moderation_state          | published          |
      And I should see the text "Data System" in the "sub_title" region
      And I am viewing a "tools" content:
      | title                     | Behat BA Tool                  |
      | field_tool_category       | BEHAT Platforms / Applications |
      | field_dataset_description | test                           |
      | moderation_state          | published                      |
      And I should see the text "BEHAT Platforms / Applications" in the "sub_title" region
      And I am viewing a "tools" content:
      | title                     | Behat BA Tool  |
      | field_tool_category       | BEHAT Software |
      | field_dataset_description | test           |
      | moderation_state          | published      |
      And I should see the text "Software" in the "sub_title" region
      And I am viewing a "tools" content:
      | title                     | Behat Tool |
      | field_dataset_description | test       |
      | moderation_state          | published  |
      And I should see the text "Tool" in the "sub_title" region

  @api
  Scenario: Verify Tools Help Texts And Required Fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
    Then I should see the text "Title"
      And I should see the text "Provide commonly used name"
      And I should see the text "Description"
      And I should see the text "Briefly describe the tool, system, or application for the user. Only 300 characters will appear as a summary and 600 in search results."
      And I should see the text "Category"
      And I should see the text "How to Request Access"
      And I should see the text "Start typing the title of a piece of content to select it. You can also enter an internal path such as /node/add or an external URL such as http://example.com. Enter <front> to link to the front page."
      And I should see the text "Contact Guidance"
      And I should see the text "This field can be used to provide more specific guidance to users as to who to contact in Offices and Divisions, as needed"
      And I should see the text "Contacts"
      And I should see the text "Documents"
      And I should see the text "Articles"
      And I should see the text "Reviewer"
      And I press "Save"
    Then I should see the text "Title field is required."
      And I should see the text "Description field is required."
      And I should see the text "Reviewer (value 1) field is required."

  @api @javascript
  Scenario: Tools Character Test
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
      And I wait 1 seconds
      And I should see the text "Characters: 0"
      And I type "Character test" in the "Description" WYSIWYG editor
      And I wait 1 seconds
      And I should see the text "Characters: 14"
      And I should see the text "Only 300 characters will appear as a summary and 600 in search results."

  @api
  Scenario: Verifying the Tools fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
      And I should see the text "Title"
      And I should see the text "Description"
      And I should see the text "Category"
      And I should see the text "How to Request Access"
      And I should see the text "Contact Guidance"
      And I should see the text "TECHNICAL OWNER"
      And I should see the text "TECHNICAL/SUBJECT MATTER EXPERT(S)"
      And I should see the text "POINT(S) OF CONTACT"
      And I should see the text "OTHER CONTACTS"
      And I should see the text "DOCUMENTS"
      And I should see the text "ARTICLES"
    Then I should see the text "Reviewer"

  @api @javascript
  Scenario: Tools Contact
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
      And I fill in "Title" with "New tool test"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "BEHAT Data Systems" from "field_tool_category"
      And I press "Add new Contact"
      And I wait for ajax to finish
      And I fill in "First Name" with "Bob"
      And I fill in "Last Name" with "Barker"
      And I fill in "Email" with "ThePriceIsWrong@gmail.com"
      And I press "Create Contact"
      And I wait for Ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I should see the text "Technical Owner"
      And I should see the Link "Bob Barker"

  @api @javascript
  Scenario: Viewing A Tool
    Given I am logged in as a user with the "authenticated user" role
      And "contact" content:
      | field_first_name | field_last_name | field_email     | field_division_office | moderation_state |
      | Bob              | Barker          | email@email.com | DERA                  | published        |
      | Happy            | Gilmore         | email@email.com | DERA                  | published        |
      | Goku             | Son             | email@email.com | DERA                  | published        |
      | Mario            | Super           | email@email.com | DERA                  | published        |
      And I am viewing a "tools":
      | title                            | Behat Tool         |
      | field_tool_category              | BEHAT Data Systems |
      | field_dataset_description        | test               |
      | moderation_state                 | published          |
      | field_contact                    | Bob Barker         |
      | field_point_s_of_contact         | Happy Gilmore      |
      | field_technical_subject_matter_e | Happy Gilmore      |
      | field_technical_owner            | Bob Barker         |
      And I should see the text "Behat Tool"
      And I should see the text "Category"
      And I should see the link "BEHAT Data Systems" in the "tools_details" region
      And I should see the text "Technical Owner"
      And I should see the link "Bob Barker"
      And I should see the text "Technical/Subject Matter Expert(s)"
      And I should see the link "Happy Gilmore"
      And I should see the text "Point(s) of Contact"
      And I should see the text "Other Contacts"

  @api
  Scenario: Verify Tools Created/Updated Label
    Given  I am logged in as a user with the "Content Creator" role
      And I am viewing a "tools" content:
      | title                     | Behat Tool Created |
      | field_tool_category       | BEHAT Data Systems |
      | field_dataset_description | test               |
      | moderation_state          | published          |
      And I should see the text "Created"
      And I am viewing a "tools" content:
      | title                     | Behat Tool Updated |
      | field_tool_category       | BEHAT Data Systems |
      | field_dataset_description | test               |
      | changed                   | +5 day             |
      | moderation_state          | published          |
    Then I should see the text "Updated"

  @api @javascript
  Scenario: Admin Can Create Tool with a New Contact
    Given I am logged in as a user with the "administrator" role
    When I am on "/node/add/tools"
      And I fill in "Title" with "New tool test"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "BEHAT Data Systems" from "field_tool_category"
      And I fill in "Contact Guidance" with "New Guidance"
      And I press "Add new Contact" in the "technical_owner" region
      And I wait for ajax to finish
      And I fill in "Behat" for "First Name"
      And I fill in "Contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I wait 1 seconds
      And I select "EEO" from "field_technical_owner[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
      And I wait for ajax to finish
      And I should see the text "New tool test"
      And I should see the link "BEHAT Data Systems" in the "tools_details" region
      And I should see the text "Contact Guidance"
      And I should see the text "New Guidance"
    Then I should see the link "Behat Contact"

  @api @javascript
  Scenario: Content Creator Can Create Tool with a New Contact
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
      And I fill in "Title" with "New tool test"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "BEHAT Data Systems" from "field_tool_category"
      And I fill in "Contact Guidance" with "New Guidance"
      And I press "Add new Contact" in the "technical_owner" region
      And I wait for ajax to finish
      And I fill in "Behat" for "First Name"
      And I fill in "Contact" for "Last Name"
      And I fill in "Contact@email.com" for "Email"
      And I wait 1 seconds
      And I select "EEO" from "field_technical_owner[form][0][field_division_office]"
      And I click the input with the value "Create Contact"
      And I wait for ajax to finish
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
      And I wait for ajax to finish
      And I should see the text "New tool test"
      And I should see the link "BEHAT Data Systems" in the "tools_details" region
      And I should see the text "Contact Guidance"
      And I should see the text "New Guidance"
    Then I should see the link "Behat Contact"

  @api @javascript
  Scenario: Create A Tool With Related Dataset
    Given "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/node/add/tools"
      And I fill in "Title" with "BEHAT Tool"
      And I type "BEHAT Tools Description" in the "Description" WYSIWYG editor
      And I select "BEHAT Data Systems" from "Category"
      And I select the autocomplete option for "BEHAT dataset1" on the "Related Datasets" field
      And I select "Published" from "Save as"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
    Then I should see the heading "BEHAT Tool"
      And I should see the text "Category"
      And I should see the link "BEHAT Data Systems" in the "tools_details" region
      And I should see the text "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I click "BEHAT dataset1"
      And I should see the heading "BEHAT dataset1"
      And I click "Related Documentation"
      And I should see the text "Tools Referencing this Dataset"
      And I should see the link "BEHAT Tool"

  @api @javascript
  Scenario: View Related Datasets In Tools Page
    Given "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      | BEHAT dataset2 | This is dataset2          | '' - http://test.com        | published        |
      And "tools" content:
      | title      | field_dataset_description | field_tool_category | field_dataset_related_datasets | moderation_state |
      | BEHAT Tool | Tool description          | BEHAT Software      | BEHAT dataset1, BEHAT dataset2 | published        |
    When I am logged in as a user with the "sitebuilder" role
      And I am on "/tool/behat-tool"
    Then I should see "Related Datasets"
      And I should see the link "BEHAT dataset1"
      And I should see the link "BEHAT dataset2"
      And I click "BEHAT dataset1"
      And I should see the heading "BEHAT dataset1"
      And I click "Related Documentation"
      And I should see the text "Tools Referencing this Dataset"
      And I should see the link "BEHAT Tool"
      And I am on "/tool/behat-tool"
      And I click "BEHAT dataset2"
      And I should see the heading "BEHAT dataset2"
      And I click "Related Documentation"
      And I should see the text "Tools Referencing this Dataset"
      And I should see the link "BEHAT Tool"

  @api @javascript
  Scenario: Edit Tools Title And Verify On Realted Dataset Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And "tools" content:
      | title      | field_dataset_description | field_tool_category | field_dataset_related_datasets | moderation_state |
      | BEHAT Tool | Tool description          | BEHAT Software      | BEHAT dataset1                 | published        |
    When I am on "datasets/behat-dataset1"
      And I click "Related Documentation"
    Then I should see the text "Tools Referencing this Dataset"
      And I should see the link "BEHAT Tool"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Tool" row
      And I fill in "Title" with "Tool Edited"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I click "BEHAT dataset1"
      And I click "Related Documentation"
      And I should not see the link "BEHAT Tool"
      And I should see the link "Tool Edited"

  @api @javascript
  Scenario: Delete Tool And Verify On Related Dataset Page
    Given I am logged in as a user with the "Content Approver" role
      And "data_set" content:
      | title          | field_dataset_description | field_how_to_request_access | moderation_state |
      | BEHAT dataset1 | This is dataset1          | '' - http://test.com        | published        |
      And "tools" content:
      | title      | field_dataset_description | field_tool_category | field_dataset_related_datasets | moderation_state |
      | BEHAT Tool | Tool description          | BEHAT Software      | BEHAT dataset1                 | published        |
    When I am on "datasets/behat-dataset1"
      And I click "Related Documentation"
    Then I should see the text "Tools Referencing this Dataset"
      And I should see the link "BEHAT Tool"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Tool" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
      And I am on "datasets/behat-dataset1"
      And I should not see the link "Related Documentation"

  @api @javascript
  Scenario: Start A New Discussion From Tools Detailed Page
    Given I am logged in as a user with the "Content Approver" role
    When I am viewing a "tools" content:
      | title                     | BEHAT Tool              |
      | field_dataset_description | This is the description |
      | moderation_state          | published               |
    Then I should not see "Related Discussions"
      And I should see the link "Start a New Discussion"
      And I should see "Rules of the Road govern all discussions."
      And I should see the link "Rules of the Road"
      And I click "Start a New Discussion"
      And the link should open in a new tab
      And I fill in "Title" with "BEHAT Forum"
      And I select "Behat Datasets" from "Category"
      And I wait 2 seconds
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
      And I should see the text "Related Content"
      And I should see the link "BEHAT Tool"
      And I click "BEHAT Tool"
      And I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I close the current window

  @api @javascript
  Scenario: Tags field on Tools content type
    #CC creates new Tools content & saves as Draft & sends for Review
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/tools"
      And I fill in "Title" with "New tool page with tag"
      And I type "Creating a Tool page with Tag" in the "Description" WYSIWYG editor
      And I select the autocomplete option for "bingo" on the "Tags" field
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Draft" from "Save as"
      And I press "Save"
    Then I should see the heading "New tool page with tag"
      And I should see the text "Creating a Tool page with Tag"
    When I select "Review" from "Change to"
      And I fill in "Log message" with "Sending for Review"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated."
    #CA reviews then Publishes
    When I am logged in as a user with the "Content Approver" role
      And I am on "/tool/new-tool-page-tag"
      And I select "Published" from "Change to"
      And I fill in "Log message" with "Reviewed and approved and sending for publication"
      And I press "Apply"
    Then I should see the text "The moderation state has been updated."
    #Tag displays on frontend for site visitor
    When I am logged in as a user with the "authenticated user" role
      And I am on "/tool/new-tool-page-tag"
    Then I should see the text "Tags" in the "tools_details" region
      And I should see the link "bingo" in the "tools_details" region
      And I should see "bingo" followed by "Start a New Discussion"
    #Global and homepage search of Tool by Tag
    When I am on "/home"
      And I fill in "edit-term--2" with "bingo"
      And I press "edit-submit-search-results--2"
    Then I should see the link "New tool page with tag" in the "results_view" region
    When I am on "/home"
      And I select the first autocomplete option for "bingo" on the "edit-term" field in the "homepage_search" region
    Then I should see the text "New tool page with tag"
    #CC revises Tools content with Phrased Tag & sends for Review
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/tool/new-tool-page-tag/edit"
      And I fill in "Tags" with "buttery popcorn"
      And I select "Review" from "Change to"
      And I press "Save"
    Then I should see the text "Tool New tool page with tag has been updated."
    #CA reviews then Publishes with Phrased Tag
    When I am logged in as a user with the "Content Approver" role
      And I am on "/tool/new-tool-page-tag/edit"
      And I select "Published" from "Change to"
      And I press "Save"
    Then I should see the text "Tool New tool page with tag has been updated."
    #Global and homepage search of Tool by Phrased Tag
    When I am on "/home"
      And I fill in "edit-term--2" with "buttery popcorn"
      And I press "edit-submit-search-results--2"
    Then I should see the link "New tool page with tag" in the "results_view" region
    When I am on "/home"
      And I select the first autocomplete option for "buttery popcorn" on the "edit-term" field in the "homepage_search" region
    Then I should see the text "New tool page with tag"
