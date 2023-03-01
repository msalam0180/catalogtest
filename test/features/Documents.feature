Feature: Admin And Content Creator Can Upload Documents Into The Data Catalog
  As a content creator
  I want to be able to upload documents to the data sets
  So that a site visitor will have access to documentation related to the application

  Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      And "division_office" terms:
      | name         |
      | division1    |
      | division2    |
      | new division |
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

  @api @javascript
  Scenario: Users Can Upload Documents
    Given I am logged in as a user with the "Content Approver" role
      And "open_government_data_act_classif" terms:
        | name             |
        | DAclassification |
        And "open_government_data_act_access" terms:
        | name     |
        | DAaccess |
        And I create "media" of type "files":
        | KEY   | name              |
        | Behat | Behat File Upload |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Document upload test"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Uploaded Document"
      And I attach the file "behat-file.txt" to "File"
      And I wait for ajax to finish
      And I select "Article" from "field_documents[form][0][field_document_category]"
      And I fill in "Description" with "Test" in the "form_area"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I publish it
      And I click "Related Documentation"
    Then I should see the link "Uploaded Document"
      And I should see the text "Test"

  @api @javascript
  Scenario: Users Can Add Existing Documents
    Given I am logged in as a user with the "Content Approver" role
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Document upload test"
      And I fill in "Short Description" with "behat short"
      And I select "category1" from "Data Category"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I click "Related Documentation"
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
      And I select the first autocomplete option for "approver" on the "Reviewer" field
      And I press "Save"
      And I should see the text "Dataset Document upload test has been created."
      And I click "Related Documentation"
    Then I should see the link "Behat File Upload"

  @api @javascript
  Scenario: Verify Media Help Texts
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/media/add/files"
    Then I should see the text "Name"
      And I should see the text 'Please name the document with the type of document that it is, for example: "User Guide: A Guide to Using My Dataset"'
      And I should see the text "One file only."
      And I should see the text "100 MB limit."
      And I should see the text "Allowed types: pdf doc docx xls xlsx ppt pptx csv txt json avi wmv jpg dm1 msg zip sas db dbf mpeg mp3 wav."
      And I should see the text "Description"
      And I should see the text "Describe this document briefly so the user can clearly understand the contents of the file. Only 300 characters will appear as a summary on a dataset and 600 in search results."
      And I should see the text "Document Category"
      And I should see the text "Revision log message"
      And I should see the text "Briefly describe the changes you have made. "

  @api @javascript
  Scenario Outline: Content Creator And Admin Can Upload Video Files To A Dataset
    Given I am logged in as a user with the "<role>" role
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_act_access" terms:
      | name     |
      | DAaccess |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Video Upload Test"
      And I fill in "Short Description" with "Behat Short"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I select "category1" from "Data Category"
      And I select "division1" from "Divisions/Offices that use this " for the "1" option of the "1" row
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I scroll to the top
      And I click "Access & Use"
      And I fill in "Request Access URL" with "http://test.com"
      And I click "Related Documentation"
      And I press "Add new Document"
      And I wait for ajax to finish
      And I fill in "Name" with "Video Media File"
      And I attach the file "<file>" to "File"
      And I wait 15 seconds
      And I fill in "Description" with "Test" in the "form_area"
      And I select "Other" from "field_documents[form][0][field_document_category]"
      And I scroll to the top
      And I click "Governance"
      And I select "new division" from "Owner"
      And I select "DAaccess" from "OPEN Government Data Act Access Level Level 0"
      And I select "DAclassification" from "OPEN Government Data Act Data Asset Determination Level 0"
      And I publish it
      And I click "Related Documentation"
    Then I should see the link "Video Media File"
      And I should see the text "Other"

    Examples:
      | role            | file                         |
      | Content Creator | behat-CIRA_ENF_FINANCIAL.wmv |
      | administrator   | behat-FlickAnimation.avi     |

  @api @javascript
  Scenario Outline: Content Creator Can Add Different File Types
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/media/add/files"
      And I fill in "Name" with "<FileType>"
      And I attach the file "<FileName>" to "File"
      And I wait for ajax to finish
      And I wait 5 seconds
      And I select "Article" from "Document Category"
      And I fill in "Description" with "This is '<FileType>'"
      And I publish it
    Then I should see the text "has been created."
      And I should see the link "<FileType>"

    Examples:
      | FileType    | FileName               |
      | WAVE Format | behat-Ascent.wav       |
      | JPG Format  | behat-black_rabbit.jpg |
      | MSG Format  | behat-review.msg       |
      | ZIP Format  | behat-Newreview.zip    |
      | MP3 Format  | behat-Hair.mp3         |
      | DB Format   | behat-cversions.2.db   |
      | JSON Format | behat-TestJSON.json    |

  @api @javascript
  Scenario Outline: Content Approver Can Add Different File Types
    Given I am logged in as a user with the "Content Approver" role
    When I am on "/media/add/files"
      And I fill in "Name" with "<FileType>"
      And I attach the file "<FileName>" to "File"
      And I wait for ajax to finish
      And I wait 5 seconds
      And I select "Article" from "Document Category"
      And I fill in "Description" with "This is '<FileType>'"
      And I publish it
    Then I should see the text "has been created."
      And I should see the link "<FileType>"

    Examples:
      | FileType    | FileName               |
      | WAVE Format | behat-Ascent.wav       |
      | JPG Format  | behat-black_rabbit.jpg |
      | MSG Format  | behat-review.msg       |
      | ZIP Format  | behat-Newreview.zip    |
      | MP3 Format  | behat-Hair.mp3         |
      | DB Format   | behat-cversions.2.db   |
      | JSON Format | behat-TestJSON.json    |

  @api @javascript
  Scenario: Add Unsupported File Type
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/media/add/files"
      And I fill in "Name" with "Unsupported File"
      And I attach the file "behat-bird.gif" to "File"
      And I wait for ajax to finish
      And I wait 2 seconds
      And I select "Article" from "Document Category"
      And I fill in "Description" with "This is an Unsupported File"
    Then I should see the text "The selected file behat-bird.gif cannot be uploaded."
      And I should see the text "Only files with the following extensions are allowed: pdf, doc, docx, xls, xlsx, ppt, pptx, csv, txt, json, avi, wmv, jpg, dm1, msg, zip, sas, db, dbf, mpeg, mp3, wav."

  @api @javascript
  Scenario: Duplicate Selection To Add Existing Documents
    Given I am logged in as a user with the "Content Approver" role
      And I create "media" of type "files":
      | KEY   | name              |
      | Behat | Behat File Upload |
    When I am on "/node/add/data_set"
      And I fill in "Title" with "Document upload test"
      And I type "BEHAT Dataset Description" in the "Description" WYSIWYG editor
      And I click "Related Documentation"
      And I press "Add existing Document"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for ajax to finish
      And I should see the text "Select Files"
      And I wait for ajax to finish
      And I switch to the "files" selector
      And I fill in "Media name" with "Behat File Upload"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat File Upload" on the files selector
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I press "Add existing Document"
      And I wait for ajax to finish
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the "files" selector
      And I wait 1 seconds
      And I fill in "Media name" with "Behat File Upload"
      And I press "Apply"
      And I wait for ajax to finish
      And I check "Behat File Upload" on the files selector
      And I press "Select Files"
      And I wait for ajax to finish
      And I switch to the main window
      And I wait 2 seconds
    Then I should see the text "The selected Document has already been added."

  @api
  Scenario Outline: Updating Alt Text For Image Media
    Given I create "media" of type "image":
      | name   | field_media_image      | field_caption | mid |
      | Bird   | behat-bird.gif         | canary        | 1   |
      | Rabbit | behat-black_rabbit.jpg | rabbit        | 2   |
      | Cat    | behat-cat.png          | cat           | 3   |
      | Dog    | behat-dog.jpeg         | dog           | 4   |
    When I am logged in as a user with the "Content Creator" role
      And I am on "<edit_link>"
      And I fill in "Alternative text" with "<old_alttext>"
      And I publish it
      And I am on "<edit_link>"
      And I fill in "Name" with "<new_name>"
      And I fill in "Alternative text" with "<new_alttext>"
      And I publish it
    Then I should see the link "<new_name>"
      But I should not see the link "<file_name>"

    Examples:
      | edit_link     | old_alttext  | new_name | new_alttext  | file_name              |
      | /media/1/edit | yellow bird  | Wings    | green canary | behat-bird.gif         |
      | /media/2/edit | blick rabbit | Hops     | dirty carpet | behat-black_rabbit.jpg |
      | /media/3/edit | walking cat  | Claws    | wild cat     | behat-cat.png          |
      | /media/4/edit | white dog    | Smells   | crazy dog    | behat-dog.jpeg         |
