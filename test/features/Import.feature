Feature: Import Content Nodes
  As a content creator, importer (feeds)_admin
  I want to be able to import content using csv file
  So that I can easily bring in content into system

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
      | name   |
      | Friday |
      And "open_government_data_act_access" terms:
      | name     | parent   |
      | DAaccess |          |
      | DAAchild | DAaccess |
      And "open_government_data_act_classif" terms:
      | name             |
      | DAclassification |
      And "open_government_data_asset_compl" terms:
      | name             |
      | Machine readable |
      | Open license     |
      And "controlled_unclassified_informat" terms:
      | name       |
      | test term1 |
      | test term2 |
      And "data" terms:
      | name       | parent     |
      | automation |            |
      | scripting  | automation |

@api
Scenario Outline: CSV Import Access
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/config/development/csv-importer"
  Then the response status code should be <status_code>

    Examples:
    | role             | status_code |
    | Content Creator  | 403         |
    | Content Approver | 403         |
    | sitebuilder      | 200         |
    | administrator    | 200         |

@api @javascript
Scenario Outline: Import Dataset Content
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/config/development/csv-importer"
    And I select "Content" from "Select entity type"
    And I wait for ajax to finish
    And I select "Dataset" from "entity_type_bundle"
    And I attach the file "behat-file-csv-importer.csv" to "Select CSV file"
    And I wait for ajax to finish
    And I press the "Import" button
    And I wait for ajax to finish
  Then I should see the text "3 content added and 0 updated"
  When I visit "/admin/content"
  Then I should see the link "Arches"
    And I should see the link "Hawai'i Volcanoes"
    And I should see the link "Zion"
  When I click "Arches"
  Then I should see the text "Millions of years of erosion have created these structures in a desert climate where the arid ground has life-sustaining biological soil crusts and potholes that serve as natural water-collecting basins."
  When I visit "/admin/content"
    And I click "Hawai'i Volcanoes"
  Then I should see the text "This park on the Big Island protects the Ki'lauea and Mauna Loa volcanoes, two of the world's most active geological features."
  When I visit "/admin/content"
    And I click "Zion"
  Then I should see the text "Located at the junction of the Colorado Plateau, Great Basin, and Mojave Desert, this park contains sandstone features such as mesas, rock towers, and canyons, including the Virgin River Narrows."

    Examples:
      | role          |
      | sitebuilder   |
      | administrator |

@api @javascript
Scenario: Import Dataset Content via Feeds
  #Create a new feed for dataset csv import & run the import
  Given I am logged in as a user with the "Content Approver, importer_feeds_admin" role
  When I am on "/feed/add/dataset_feed"
    And I fill in "Title" with "Behat Dataset Feed Importer 1"
    And I attach the file "behat_dataset_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Dataset Feed Importer 1 has been created."
    And I should see the text "Behat Dataset Feed Importer 1: Created 1 Dataset."
  When I am on "/admin/content"
  Then I should see the text "Feeds Imported Dataset X Title" in the "Dataset" row
  When I click "Edit" in the "Feeds Imported Dataset X Title" row
  Then I should see the text "Review" in the "edit_page_status" region
  When I am on "/datasets/feeds-imported-dataset-x-title"
  Then I should see the heading "Feeds Imported Dataset X Title"
    And I should see the text "Feeds Imported Dataset X Description"
    And I should see the link "division1"
    And I should see the link "SEC"
    And I should see the link "automation"
    And I should see the text "06/03/2022"
  When I click "Access & Use" in the "horizotal_tabs" region
  Then I should see the text "444"
  When I click "Governance" in the "horizotal_tabs" region
  Then I should see the link "division2"
    And I should see the link "Friday"
    And I should see the text "Non-Public"
    And I should see the text "Public Data Asset"
  #Import and Edit csv
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Dataset Feed Importer 1" row
    And I press "Remove"
    And I wait for ajax to finish
    And I attach the file "behat_dataset_feed_importer_2.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Dataset Feed Importer 1 has been updated."
    And I should see the text "Behat Dataset Feed Importer 1: Updated 1 Dataset."
  When I am on "/admin/content"
  Then I should see the text "Feeds Imported Dataset X" in the "Dataset" row
  When I click "Edit" in the "Feeds Imported Dataset X" row
  Then I should see the text "Published" in the "edit_page_status" region
  When I am on "/datasets/feeds-imported-dataset-x-title"
  Then I should see the heading "Feeds Imported Dataset X Title"
    And I should see the text "Feeds Imported Dataset X Description-updated"
    And I should see the link "division1"
    And I should see the link "SEC"
    And I should see the link "automation"
    And I should see the text "06/03/2022"
  When I click "Access & Use" in the "horizotal_tabs" region
  Then I should see the text "444"
  When I click "Governance" in the "horizotal_tabs" region
  Then I should see the link "division2"
    And I should see the link "Friday"
    And I should see the text "Non-Public"
    And I should see the text "Public Data Asset"
  #Cleanup
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Dataset Feed Importer 1" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Dataset Feed Importer 1 has been deleted."

@api @javascript
Scenario: Error Message When CSV File Contains Missing Required Field Values
  Given I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
  When I am on "/feed/add/dataset_feed"
    And I fill in "Title" with "Behat Dataset Feed Importer 2"
    #Removed Short Description purposely from csv to validate error message
    And I attach the file "behat_missingValue_dataset_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Dataset Feed Importer 2 has been created."
    And I should see the text "The content Feeds Imported Dataset X Title failed to validate with the following errors:"
    And I should see the text "Short Description (field_summary): This value should not be null."
    And I should see the text "Behat Dataset Feed Importer 2: Failed importing 1 Dataset."
    #Cleanup Feeds
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Dataset Feed Importer 2" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Dataset Feed Importer 2 has been deleted."

@api @javascript
Scenario: Error Message When CSV File Contains Invalid Values
  Given I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
  When I am on "/feed/add/dataset_feed"
    And I fill in "Title" with "Behat Dataset Feed Importer 3"
    #OPEN Government Data Act Access Level (required field) and Associated Inventories (not required) purposely contains invalid values
    And I attach the file "behat_wrongValue_dataset_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Dataset Feed Importer 3 has been created."
    And I should see the text "Referenced entity not found for field name with value 100."
    And I should see the text "The content Feeds Imported New Dataset Title failed to validate with the following errors:"
    And I should see the text "OPEN Government Data Act Access Level (field_open_government_data_acces): This value should not be null."
    And I should see the text "Behat Dataset Feed Importer 3: Failed importing 1 Dataset."
    #Cleanup Feeds
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Dataset Feed Importer 3" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Dataset Feed Importer 3 has been deleted."

@api @javascript
Scenario: Error Message When Non-Required Fields in CSV File Contains Invalid Value
  Given I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
  When I am on "/feed/add/dataset_feed"
    And I fill in "Title" with "Behat Dataset Feed Importer 4"
    #Associated Inventories (not required) purposely contains invalid values in CSV
    And I attach the file "behat_missingvalue_nonrequired_dataset_feed_importer.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Dataset Feed Importer 4 has been created."
    And I should see the text "Referenced entity not found for field name with value Bingo."
    And I should see the text "Behat Dataset Feed Importer 4: Created 1 Dataset."
  When I am on "/admin/content"
  Then I should see the text "Feeds Imported Dataset Z Title" in the "Dataset" row
    And I should see the text "Draft" in the "Feeds Imported Dataset Z Title" row
    #Cleanup Feeds
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Dataset Feed Importer 4" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Dataset Feed Importer 4 has been deleted."

@api @javascript
Scenario: Import New Contacts via Add New Contact Feeds
  Given I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
  When I am on "/feed/add/add_new_contact"
    And I fill in "Title" with "Behat Add New Contact Feed Importer 5"
    And I attach the file "behat_new_contact_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Add New Contact Feed Importer 5 has been created."
    And I should see the text "Behat Add New Contact Feed Importer 5: Created 1 Contact."
  When I am on "/admin/content"
  Then I should see the text "Fname Lname" in the "Contact" row
    And I click "Edit" in the "Fname Lname" row
    And I click on the element with css selector "#block-adminimal-theme-primary-local-tasks > nav > nav > ul > li:nth-child(1) > a"
    And I should see the heading "Fname Lname"
    And I should see the text "Fname"
    And I should see the text "Lname"
    And I should see the text "fnamelname@SEC.GOV"
  #Cleanup
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Add New Contact Feed Importer 5" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Add New Contact Feed Importer 5 has been deleted."
  #Cleanup Content
  When I am on "/admin/content"
    And I click "Edit" in the "Fname Lname" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "The Contact Fname Lname has been deleted."

@api @javascript
Scenario: Validation Message When Import Existing Contact via New Contact CSV Importer Feeds
  Given I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
  When I am on "/feed/add/add_new_contact"
    And I fill in "Title" with "Behat Add New Contact Feed Importer 6"
    And I attach the file "behat_new_contact_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
    And I should see the text "Behat Add New Contact Feed Importer 6 has been created."
    And I should see the text "Behat Add New Contact Feed Importer 6: Created 1 Contact."
    And I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Add New Contact Feed Importer 6" row
    And I press "Remove"
    And I wait for ajax to finish
    And I attach the file "behat_existing_contact_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Add New Contact Feed Importer 6 has been updated."
    And I should see the text "Behat Add New Contact Feed Importer 6: There are no new Contact Items."
    #Clean up
  When I am on "/admin/content"
    And I click "Edit" in the "Fname Lname" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "The Contact Fname Lname has been deleted."
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Add New Contact Feed Importer 6" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Add New Contact Feed Importer 6 has been deleted."

@api @javascript
Scenario: Import Related Contacts via Relate Contact Feeds
  Given "data_set" content:
    | title                               | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_reviewer | field_division_office_multi | field_data_category | field_owner  | field_open_government_data_class | field_open_government_data_acces | nid    |
    | Feeds Imported Dataset X Title New  | short         | This is dataset1          | '' - http://test.com        | published        | approver       | division1                   | category1           | new division | DAclassification                 | DAaccess                         | 999999 |
  When I am logged in as a user with the "Content Approver, importer_feeds_admin" role
    And I am on "/feed/add/add_new_contact"
    And I fill in "Title" with "Behat Add New Contact Feed Importer 7"
    And I attach the file "behat_new_contact_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Add New Contact Feed Importer 7 has been created."
    And I should see the text "Behat Add New Contact Feed Importer 7: Created 1 Contact."
  When I am on "/admin/content"
    And I am on "/feed/add/add_existing_contact"
    And I fill in "Title" with "Behat Relate Contact Feed Importer 7"
    And I attach the file "behat_relate_contact_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Relate Contact Feed Importer 7 has been created."
  When I am on "/datasets/feeds-imported-dataset-x-title-new/edit"
    And I click on the element with css selector "#block-adminimal-theme-primary-local-tasks > nav > nav > ul > li:nth-child(1) > a"
    And I click "Contacts" in the "horizotal_tabs" region
  Then I should see the link "Fname Lname"
    And I should see the text "Business Owner"
  #Cleanup Feeds
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Add New Contact Feed Importer 7" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Add New Contact Feed Importer 7 has been deleted."
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Relate Contact Feed Importer 7" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Relate Contact Feed Importer 7 has been deleted."
  #Cleanup Content
  When I am on "/admin/content"
  Then I should see the text "Fname Lname" in the "Contact" row
  When I click "Edit" in the "Fname Lname" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "The Contact Fname Lname has been deleted."

@api @javascript
Scenario: Import Related Technologies via Related Technology Feed Importer
  Given "data_set" content:
    | title          | field_summary | field_dataset_description | field_how_to_request_access | moderation_state | field_reviewer | field_division_office_multi | field_data_category | field_owner  | field_open_government_data_class | field_open_government_data_acces | nid    |
    | BEHAT Dataset  | short         | This is dataset1          | '' - http://test.com        | published        | approver       | division1                   | category1           | new division | DAclassification                 | DAaccess                         | 999999 |
    And "component" content:
    | title           | field_summary       | body                  | field_status_usage | field_division_office_multi | moderation_state |nid      |
    | BEHAT Software  | This is the Summary | Component description | Approved           | division1                   | published        |120120120|
    And "application" content:
    | title             | field_summary       | body                  | field_division_office_multi | field_owner | moderation_state | field_reviewer |nid      |
    | BEHAT Application | This is the Summary | Component description | division1                   | division1   | published        | approver       |130130130|
  When I am logged in as a user with the "sitebuilder, importer_feeds_admin" role
    And I am on "/feed/add/related_technology"
    And I fill in "Title" with "Behat Related Technology Feed Importer 8"
    And I attach the file "behat_related_Technology_feed_importer_1.csv" to "File"
    And I press "Save and import"
    And I wait for ajax to finish
  Then I should see the text "Behat Related Technology Feed Importer 8 has been created."
  When I am on "/datasets/behat-dataset"
    And I click "Related Content" in the "horizotal_tabs" region
  Then I should see the link "BEHAT Software"
    And I should see the link "BEHAT Application"
    #Cleanup
  When I am on "/admin/content/feed"
    And I click "Edit" in the "Behat Related Technology Feed Importer 8" row
    And I click on the element with css selector "#edit-delete"
    And I press the "Delete" button
  Then I should see the text "Behat Related Technology Feed Importer 8 has been deleted."
