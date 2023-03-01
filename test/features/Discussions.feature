Feature: Create A Forum (Discussion) And Add Comments To The Topics/Thread
  As a site builder, I can create forums/discussions that allow users to interact with others to share information about datasets,
  tools, or other topics in the catalog so that knowledge is shared across the agency.
  An authenticated user can create new topic/thread and also can comment on any topics posted in the forum.
  A Site Visitor can view all existing discussions.
  A site user can discover forums related to different content types.

  Background:
    Given users:
      | name              | mail                 | roles            |
      | creator           | creator@test.com     | Content Creator  |
      | approver          | approver@test.com    | Content Approver |
      | user site builder | siteBuilder@test.com | sitebuilder      |
      | moderator         | moderator@email.com  | Forum Moderator  |
      And "forums" terms:
      | name         |
      | Article      |
      | Tool         |
      | Data Insight |
      | Dataset      |
      | General      |
      And "division_office" terms:
      | name      |
      | division1 |

  @api @javascript
  Scenario: Authenticated User Create Discussion Add, Edit, And Delete Comment
    Given "data_set" content:
      | title                | field_summary     | field_dataset_description | field_dataset_last_load_time | moderation_state |
      | test21 D1805         | short description | Bankruptcy Stats          | 2019-09-02T12:00:00          | published        |
      And "application" content:
      | title           | field_summary           | body             | field_summary          | field_division_office_multi | moderation_state |
      | New Application | application description | This is the body | Summary of Application | division1                   | published        |
      And "forum" content:
      | title                | body                      | taxonomy_forums | field_related_content        | moderation_state |
      | BEHAT Dataset Forum1 | This is Dataset Forum one | Datasets        | test21 D1805,New Application | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/node/add/forum"
      And I fill in "Title" with "BEHAT Discussion"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select the first autocomplete option for "test21 D1805" on the "Add Catalog Content Related to this Discussion" field
      And I press "Add another item"
      And I wait for ajax to finish
      And I select the first autocomplete option for "New Application" on the "Add Catalog Content Related to this Discussion (value 2)" field
      And I press "Add another item"
      And I wait for ajax to finish
      And I select the first autocomplete option for "BEHAT Dataset Forum1" on the "Add Catalog Content Related to this Discussion (value 3)" field
      And I press "Post Discussion"
    Then I should see the heading "BEHAT Discussion"
      And I should see the text "This is the summary of the topic"
      And I should see the link "test21 D1805"
      And I should see the link "New Application"
      And I should see the link "BEHAT Dataset Forum1"
    When I am on "/discussions/behat-discussion/edit"
      And fill in "Title" with "BEHAT Edit Discussion"
      And I press "Post Discussion"
    Then I should see the heading "BEHAT Edit Discussion"
    When I click "Reply"
      And I type "This is the reply to the comment" in the "Reply to this Discussion" WYSIWYG editor
    Then I should not see the text "Revision"
    When I press "Post"
      And I am on "/discussions/behat-edit-discussion/edit"
    Then I should see the text "Add Catalog Content Related to this Discussion"
      And I should see the text "Start typing to find other Catalog content (e.g., datasets, applications, and other discussions) to associate here"
      And I should see the text "You may edit or remove content from your discussion post; please contact the Data Catalog team if you would like the post to be deleted."
      And I should not see the text "Revision"
    When I am on "/discussions/behat-discussion"
      And I click "Reply"
      And I type "New comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
    Then I should see the text "New comment"
    When I click "Delete"
      And I wait 5 seconds
      And I press "Delete"
    Then I should see the text "Comment has been successfully removed."

  @api @javascript
  Scenario Outline: Site Builder And Admin Can Create Edit Delete And Comment On A Discussion
    Given "data_set" content:
        | title         | field_summary     | field_dataset_description | moderation_state |
        | BEHAT dataset | short description | This is dataset1          | published        |
      And I am logged in as a user with the "<role>" role
    When I am on "node/add/forum"
      And I should see "Please adhere to the Rules of the Road when engaged in Discussions:"
      And I should see the link "Rules of the Road"
      And I should see "Note that the administrators and moderators of the Discussions may edit, delete, or archive content."
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select the first autocomplete option for "BEHAT dataset" on the "Add Catalog Content Related to this Discussion" field
      And I select "Published" from "Save as"
      And I scroll to the bottom
      And I press "Post Discussion"
      And I wait 2 seconds
      And I scroll to the top
    Then I should see "Discussion BEHAT Topic About Dataset has been created."
      And I should see the heading "BEHAT Topic About Dataset"
      And I should see the text "This is the summary of the topic"
      And I should see the text "Related Content"
      And I should see the link "BEHAT dataset"
      And I should see the text "Reply"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see the text "This is the First Comment"
    When I click "Edit" in the "forum_comment" region
      And I type "This is the edited Comment " in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see the text "This is the edited Comment "
    When I click "Reply" in the "forum_comment" region
      And I type "This is the reply to the comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see the text "This is the reply to the comment"
    When I click "Delete" in the "reply_comment" region
    Then I should see "Are you sure you want to delete the comment This is the reply to the…?"
    When I press "Delete"
    Then I should see "The comment and all its replies have been deleted."
      And I should not see the text "This is the reply"

      Examples:
       | role          |
       | sitebuilder   |
       | administrator |

  @api @javascript
  Scenario: Content Creator Can Create New Topic And Comment On It
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/forum"
      And  I should see "Please adhere to the Rules of the Road when engaged in Discussions:"
      And I should see the link "Rules of the Road"
      And I fill in "Title" with "BEHAT User CC Discussion"
      And I select "General" from "Category"
      And I type "This is the discussion for content creator" in the "Body" WYSIWYG editor
      And I press "Post Discussion"
      And I wait 1 seconds
    Then I should see "Discussion BEHAT User CC Discussion has been created."
      And I should see the heading "BEHAT User CC Discussion"
      And I should see the text "This is the discussion for content creator"
    When I am logged in as a user with the "Content Approver" role
      And I am on "/discussions/behat-user-cc-discussion"
      And I scroll to the bottom
      And I press "Post"
    Then I should see "Reply to this Discussion field is required."
    When I am logged in as a user with the "Content Creator" role
      And I am on "/discussions/behat-user-cc-discussion"
    Then I should see the text "Reply"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I wait 1 seconds
    Then I should see the link "Reply"
      And I should see "Please adhere to the Rules of the Road when engaged in Discussions:"
      And I should see the link "Rules of the Road"
      And I click "Rules of the Road"
      And the link should open in a new tab
      And I should be on "https://theexchange.sec.gov/media/1156/download"
      And I close the current window

  @api @javascript
  Scenario: Authenticated User Can Create New Topic And Comment On It
    Given "data_set" content:
      | title         | field_summary     | field_dataset_description | moderation_state |
      | BEHAT dataset | short description | This is dataset1          | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
    Then I should see the link "Start a New Discussion"
    When I click "Start a New Discussion"
      And I fill in "Title" with "BEHAT User AU Discussion"
      And I select "General" from "Category"
      And I type "This is the discussion for authenticated user" in the "Body" WYSIWYG editor
      And I select the first autocomplete option for "BEHAT dataset" on the "Add Catalog Content Related to this Discussion" field
      And I press "Post Discussion"
    Then I should see "Discussion BEHAT User AU Discussion has been created."
    When I visit "/discussions/behat-user-au-discussion"
    Then I should see the heading "BEHAT User AU Discussion"
      And I should see the text "This is the discussion for authenticated user"
      And I should see the text "Reply"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions/behat-user-au-discussion"
    Then I should see the text "This is the First Comment"
      And I should see the link "Reply"
      And I should see "Edit"
      And I should see "Delete"

  @api @javascript
  Scenario: Authenticated User Can Comment On An Existing Topic In The Forum
    Given "forum" content:
      | title                | body                      | taxonomy_forums | moderation_state |
      | BEHAT Dataset Forum1 | This is Dataset Forum one | Datasets        | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions/behat-dataset-forum1"
    Then I should see the heading "BEHAT Dataset Forum1"
      And I should see the text "This is Dataset Forum one"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      #And I should see the text "An email has been sent to the moderator requesting comment approval."
    When I am on "/discussions/behat-dataset-forum1"
    Then I should see the text "This is the First Comment"
      And I should see the link "Reply"
      And I should see the link "Edit"
      And I should see the link "Delete"

  @api @javascript
  Scenario: Verify User Email/UserName
    Given I am logged in as "user site builder"
    When I am on "/node/add/forum"
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I select "Published" from "Save as"
      And I press "Post Discussion"
    When I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see "user site builder"
    When I am logged in as "creator"
      And I am on "/discussions"
      And I select "Datasets" from "Category"
      And I press "Apply"
      And I click "BEHAT Topic About Dataset"
      And I type "This is the Comment by content creator" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see "creator"
      And I should see the text "Your comment has been posted."

  @api @javascript
  Scenario: Search Using Filters
    Given "forum" content:
      | title                | body                  | taxonomy_forums        | moderation_state | changed  |
      | BEHAT Tools Forum    | This is tools Forum   | Tool                   | published        | -2 days  |
      | BEHAT Article Forum  | This is article Forum | Article                | published        | -2 days  |
      | BEHAT Insight Forum  | This is insight Forum | Data Insight           | published        | -5 days  |
      | BEHAT Datasets       | This isd datasets     | Dataset                | published        | -12 days |
      | BEHAT Reports        | This is Report        | Reports and Statistics | published        | -1 days  |
      | BEHAT Technology     | This is technology    | Technology             | published        | -3 days  |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I select "Article" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Datasets"
      And I should not see the link "BEHAT Reports"
      And I should not see the link "BEHAT Technology"
    When I select "Tool" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Datasets"
      And I should not see the link "BEHAT Reports"
      And I should not see the link "BEHAT Technology"
    When I select "Data Insight" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Datasets"
      And I should not see the link "BEHAT Reports"
      And I should not see the link "BEHAT Technology"
    When I select "Dataset" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Datasets"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Reports"
      And I should not see the link "BEHAT Technology"
    When I select "Reports and Statistics" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Reports"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Datasets"
      And I should not see the link "BEHAT Technology"
    When I select "Technology" from "Category"
      And I press "Apply"
      And I wait 1 seconds
    Then I should see the link "BEHAT Technology"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Reports"
      And I should not see the link "BEHAT Datasets"

  @api @javascript
  Scenario: Sorting Discussions By Posts
    Given "forum" content:
      | title                | body                  | taxonomy_forums        | moderation_state |
      | BEHAT Tools Forum    | This is tools Forum   | Tool                   | published        |
      | BEHAT Article Forum  | This is article Forum | Article                | published        |
      | BEHAT Insight Forum  | This is insight Forum | Data Insight           | published        |
      | BEHAT Datasets       | This isd datasets     | Datasets               | published        |
      | BEHAT Reports        | This is Report        | Reports and Statistics | published        |
      | BEHAT Technology     | This is technology    | Technology             | published        |
      | BEHAT Application    | This is Application   | Technology             | published        |
      | BEHAT Platform       | This is Platform      | Technology             | published        |
      | BEHAT Component      | This is Component     | Technology             | published        |
      | BEHAT 123            | This is Component     | Technology             | published        |
      | BEHAT ABC            | This is Component     | Technology             | published        |
      | BEHAT XYC            | This is Component     | Technology             | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I click "Posts"
      And I wait 3 seconds
    Then "BEHAT 123" should precede "BEHAT ABC" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT ABC" should precede "BEHAT Application" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Application" should precede "BEHAT Article Forum" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Article Forum" should precede "BEHAT Component" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Component" should precede "BEHAT Datasets" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Datasets" should precede "BEHAT Insight Forum" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Insight Forum" should precede "BEHAT Platform" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Platform" should precede "BEHAT Reports" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Reports" should precede "BEHAT Technology" for the query "//td[contains(@class, 'views-field-title')]"
      And I click "last"
      And I wait 1 seconds
      And "BEHAT Tools Forum" should precede "BEHAT XYC" for the query "//td[contains(@class, 'views-field-title')]"
    When I click "First"
      And I wait 1 seconds
      And I click "Posts"
      And I wait 1 seconds
    Then "BEHAT XYC" should precede "BEHAT Tools Forum" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Tools Forum" should precede "BEHAT Technology" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Technology" should precede "BEHAT Reports" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Reports" should precede "BEHAT Platform" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Platform" should precede "BEHAT Insight Forum" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Insight Forum" should precede "BEHAT Datasets" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Datasets" should precede "BEHAT Component" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Component" should precede "BEHAT Article Forum" for the query "//td[contains(@class, 'views-field-title')]"
      And "BEHAT Article Forum" should precede "BEHAT Application" for the query "//td[contains(@class, 'views-field-title')]"

  @api @javascript
  Scenario: Sorting Discussions By Replies
    Given "forum" content:
      | title                | body                  | taxonomy_forums        | moderation_state |
      | BEHAT Technology     | This is technology    | Technology             | published        |
      | BEHAT Reports        | This is Report        | Reports and Statistics | published        |
      | BEHAT ABC            | This is Component     | Technology             | published        |
      | BEHAT Platform       | This is Platform      | Technology             | published        |
      | BEHAT Component      | This is Component     | Technology             | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I click "BEHAT Technology"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 2nd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 3rd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 4th Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I wait 1 seconds
      And I should see the text "This is the First Reply"
      And I click "Reply" in the "forum_comment" region
      And I type "This is the reply to a comment" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions"
      And I click "BEHAT Reports"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 2nd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 3rd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 4th Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions"
      And I click "BEHAT ABC"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 2nd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 3rd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions"
      And I click "BEHAT Component"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I type "This is the 2nd Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions"
      And I click "BEHAT Platform"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/discussions"
      And I click "Replies"
      And I wait 1 seconds
    Then "1" should precede "2" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "2" should precede "3" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "3" should precede "4" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "4" should precede "5" for the query "//td[contains(@class, 'views-field-comment-count')]"
    When I click "Replies"
      And I wait 1 seconds
    Then "5" should precede "4" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "4" should precede "3" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "3" should precede "2" for the query "//td[contains(@class, 'views-field-comment-count')]"
      And "2" should precede "1" for the query "//td[contains(@class, 'views-field-comment-count')]"

  @api @javascript
  Scenario: Sorting Discussions By Category
    Given "forum" content:
      | title                | body                  | taxonomy_forums        | moderation_state |
      | BEHAT Tools Forum    | This is tools Forum   | Tool                   | published        |
      | BEHAT Article Forum  | This is article Forum | Article                | published        |
      | BEHAT Insight Forum  | This is insight Forum | Data Insight           | published        |
      | BEHAT Datasets       | This isd datasets     | Datasets               | published        |
      | BEHAT Reports        | This is Report        | Reports and Statistics | published        |
      | BEHAT Technology     | This is technology    | Technology             | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I click "Category"
      And I wait 1 seconds
    Then "Datasets" should precede "Reports and Statistics" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Reports and Statistics" should precede "Technology" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Technology" should precede "Article" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Article" should precede "Tool" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Tool" should precede "Data Insight" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And I click "Category"
      And I wait 1 seconds
    Then "Data Insight" should precede "Tool" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Tool" should precede "Article" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Article" should precede "Technology" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Technology" should precede "Reports and Statistics" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"
      And "Reports and Statistics" should precede "Datasets" for the query "//td[contains(@class, 'views-field-taxonomy-forums')]"

    @api @javascript
    Scenario: Sorting Discussions By Recent Activity
      Given "forum" content:
        | title                | body                  | taxonomy_forums        | moderation_state | changed  |
        | BEHAT Tools Forum    | This is tools Forum   | Tool                   | published        | -2 days  |
        | BEHAT Article Forum  | This is article Forum | Article                | published        | -2 days  |
        | BEHAT Insight Forum  | This is insight Forum | Data Insight           | published        | -5 days  |
        | BEHAT Datasets       | This isd datasets     | Datasets               | published        | -12 days |
        | BEHAT Reports        | This is Report        | Reports and Statistics | published        | -1 days  |
        | BEHAT Technology     | This is technology    | Technology             | published        | -3 days  |
        | BEHAT Application    | This is Application   | Technology             | published        | -4 days  |
        | BEHAT Platform       | This is Platform      | Technology             | published        | -6 days  |
        | BEHAT Component      | This is Component     | Technology             | published        | -7 days  |
        | BEHAT 123            | This is Component     | Technology             | published        | -8 days  |
        | BEHAT ABC            | This is Component     | Technology             | published        | -9 days  |
        | BEHAT XYC            | This is Component     | Technology             | published        | -11 days |
        And I am logged in as a user with the "authenticated user" role
      When I am on "/discussions"
        And I click "Recent Activity"
      And I wait 1 seconds
    Then "1 day" should precede "2 days" for the query "//em[contains(@class, 'placeholder')]"
      And "2 days" should precede "3 days" for the query "//em[contains(@class, 'placeholder')]"
      And "3 days" should precede "4 days" for the query "//em[contains(@class, 'placeholder')]"
      And "5 days" should precede "6 days" for the query "//em[contains(@class, 'placeholder')]"
      And "6 days" should precede "1 week" for the query "//em[contains(@class, 'placeholder')]"
      And "1 week" should precede "1 week 1 day" for the query "//em[contains(@class, 'placeholder')]"
      And "1 week 1 day" should precede "1 week 2 days" for the query "//em[contains(@class, 'placeholder')]"
      And I click "Last"
      And I wait 1 seconds
      And "1 week 4 days" should precede "1 week 5 days" for the query "//em[contains(@class, 'placeholder')]"
      And I click "First"
      And I wait 1 seconds
    When I click "Recent Activity"
      And I wait 1 seconds
    Then "1 week 5 days" should precede "1 week 4 days" for the query "//em[contains(@class, 'placeholder')]"
      And "1 week 4 days" should precede "1 week 2 days" for the query "//em[contains(@class, 'placeholder')]"
      And "1 week 2 days" should precede "1 week 1 day" for the query "//em[contains(@class, 'placeholder')]"
      And "1 week 1 day" should precede "6 days" for the query "//em[contains(@class, 'placeholder')]"
      And "6 days" should precede "5 days" for the query "//em[contains(@class, 'placeholder')]"
      And "5 days" should precede "4 days" for the query "//em[contains(@class, 'placeholder')]"
      And "4 days" should precede "3 days" for the query "//em[contains(@class, 'placeholder')]"
      And "3 days" should precede "2 days" for the query "//em[contains(@class, 'placeholder')]"
      And I click "Last"
      And I wait 1 seconds
      And "2 days" should precede "1 day" for the query "//em[contains(@class, 'placeholder')]"

  @api @javascript
  Scenario: Search Title, Body And Comment On Discussion Page
    Given "forum" content:
      | title                | body                  | taxonomy_forums        | moderation_state |
      | BEHAT Tools Forum    | This is Forum         | Tool                   | published        |
      | BEHAT Article Forum  | This is article Forum | Article                | published        |
      | BEHAT Insight Forum  | This is body Forum    | Data Insight           | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I click "BEHAT Article Forum"
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
    Then I should see the text "This is the First Reply"
    When I am on "/discussions?search=ToOls&taxonomy_forums_target_id=All"
    Then I should see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Insight Forum"
    When I press "Reset"
      And I am on "/discussions?search=fIrst&taxonomy_forums_target_id=All"
    Then I should see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Tools Forum"
      And I should not see the link "BEHAT Insight Forum"
    When I press "Reset"
      And I am on "/discussions?search=body&taxonomy_forums_target_id=All"
    Then I should see the link "BEHAT Insight Forum"
      And I should not see the link "BEHAT Article Forum"
      And I should not see the link "BEHAT Tools Forum"

  @api @javascript
  Scenario: Site User Can View Discussions Related To A Content
    Given "data_set" content:
      | title         | field_dataset_description | field_vendor_name | field_sales_rep_email_address | moderation_state |
      | BEHAT Dataset | This is dataset1          | New Vendor        | vendor@email.com              | published        |
      And "article" content:
      | title         | body                | field_category | moderation_state |
      | BEHAT Article | Article description | Other          | published        |
      And "tools" content:
      | title      | body             | field_tool_category | moderation_state |
      | BEHAT Tool | Tool description | Software            | published        |
      And "data_insight" content:
      | title         | body                | data_insight_type | moderation_state |
      | BEHAT Insight | Insight description | Educational       | published        |
      And "forum" content:
      | title                | body                      | taxonomy_forums | field_related_content                                | moderation_state |
      | BEHAT Dataset Forum1 | This is Dataset Forum one | Datasets        | BEHAT Dataset,BEHAT Article,BEHAT Tool,BEHAT Insight | published        |
      And I am logged in as a user with the "authenticated user" role
    When I am on "/discussions"
      And I click "BEHAT Dataset Forum1"
    Then I should see "Related Content"
      And I should see the link "BEHAT Dataset"
      And I should see the link "BEHAT Article"
      And I should see the link "BEHAT Tool"
      And I should see the link "BEHAT Insight"
    When I click "BEHAT Dataset"
      And I click "Related Discussions"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Dataset Forum1"
    When I click "BEHAT Dataset Forum1"
      And I wait 1 seconds
      And I click "BEHAT Article"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Dataset Forum1"
      And I wait 1 seconds
    When I click "BEHAT Dataset Forum1"
      And I wait 2 seconds
      And I click "BEHAT Tool"
      And I wait 2 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Dataset Forum1"
    When I click "BEHAT Dataset Forum1"
      And I wait 2 seconds
      And I click "BEHAT Insight"
      And I wait 2 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Dataset Forum1"
      And I click "BEHAT Dataset Forum1"
      And I should see the text "This is Dataset Forum one"

  @api
  Scenario: Edit A Related Content And Verify On Discussions Page
    Given I am logged in as a user with the "sitebuilder" role
      And "article" content:
      | title         | field_summary     | body                | field_category | moderation_state | field_reviewer |
      | BEHAT Article | short description | Article description | Other          | published        | approver       |
    When I am viewing a "forum" content:
      | title                 | BEHAT Forum   |
      | body                  | description   |
      | taxonomy_forums       | Datasets      |
      | field_related_content | BEHAT Article |
      | moderation_state      | published     |
    Then I should see the link "BEHAT Article"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Article" row
      And I fill in "Title" with "BEHAT Edited Article"
      And I press "Save"
    When I am on "/discussions"
      And I click "BEHAT Forum"
    Then I should see the link "BEHAT Edited Article"
      And I should not see the link "BEHAT Article"

  @api @javascript
  Scenario: Delete A Related Content And Verify On Discussions Page
    Given I am logged in as a user with the "sitebuilder" role
      And "article" content:
      | title         | field_summary     | body                | field_category | moderation_state | field_reviewer |
      | BEHAT Article | short description | Article description | Other          | published        | approver       |
    When I am viewing a "forum" content:
      | title                 | BEHAT Forum   |
      | body                  | description   |
      | taxonomy_forums       | Datasets      |
      | field_related_content | BEHAT Article |
      | moderation_state      | published     |
    Then I should see the link "BEHAT Article"
      And I am on "/admin/content"
      And I click "Edit" in the "BEHAT Article" row
      And I click "Delete" in the "node_action" region
      And I press the "Delete" button
      And I should see "The Article BEHAT Article has been deleted."
    When I am on "/discussions"
      And I click "BEHAT Forum"
    Then I should not see the text "Related Content"
      And I should not see the link "BEHAT Article"

  @api @javascript
  Scenario: Forum Moderator Can Create A Discussion
    Given "data_set" content:
      | title         | field_dataset_description | moderation_state |
      | BEHAT dataset | This is dataset1          | published        |
      And I am logged in as a user with the "Forum Moderator" role
    When I am on "/discussions"
    Then I should see the link "Start a New Discussion"
    When I click "Start a New Discussion"
      And I fill in "Title" with "BEHAT User FM Discussion"
      And I select "General" from "Category"
      And I type "This is the discussion for Forum Moderator user" in the "Body" WYSIWYG editor
      And I select the first autocomplete option for "BEHAT dataset" on the "Add Catalog Content Related to this Discussion" field
      And I select "Published" from "Save as"
      And I press "Post Discussion"
    Then I should see "Discussion BEHAT User FM Discussion has been created."
      And I should see the heading "BEHAT User FM Discussion"
      And I should see the text "This is the discussion for Forum Moderator"

  @api @javascript
  Scenario: Forum Moderator Can Edit A Discussion
    Given I am logged in as a user with the "Forum Moderator" role
      And "article" content:
      | title         | body                | field_category | moderation_state | field_reviewer |
      | BEHAT Article | Article description | Other          | published        | approver       |
      And "forum" content:
      | title       | body                      | taxonomy_forums | field_related_content | moderation_state |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | BEHAT Article         | published        |
    When I am on "/discussions/behat-forum"
    Then I should see the heading "BEHAT Forum"
    When I am on "/admin/content/discussions"
      And I click "Edit" in the "BEHAT Forum" row
      And I fill in "Title" with "BEHAT Edited Forum"
      And I press "Post Discussion"
    Then I should see "Discussion BEHAT Edited Forum has been updated."
    When I am on "/discussions"
    Then I should not see the link "BEHAT Forum"
      And I should see the link "BEHAT Edited Forum"

  @api @javascript
  Scenario: Forum Moderator Can Delete A Discussion
    Given I am logged in as a user with the "Forum Moderator" role
      And "article" content:
      | title         | body                | field_category | moderation_state | field_reviewer |
      | BEHAT Article | Article description | Other          | published        | approver       |
      And "forum" content:
      | title       | body                      | taxonomy_forums | field_related_content | moderation_state |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | BEHAT Article         |  published       |
    When I am on "/discussions/behat-forum"
    Then I should see the heading "BEHAT Forum"
    When I am on "/admin/content/discussions"
      And I click "Edit" in the "BEHAT Forum" row
      And I click "Delete" in the "node_action" region
      And I should see "Are you sure you want to delete the content item BEHAT Forum?"
      And I press "Delete"
      And I am on "/discussios/behat-forum"
    Then I should see "Page not found"

  # @api @javascript
  # Scenario: Forum Moderator Can Archive A Discussion
  #   Given I am logged in as a user with the "Forum Moderator" role
  #     And "article" content:
  #     | title         | body                | field_category | moderation_state | field_reviewer |
  #     | BEHAT Article | Article description | Other          | published        | approver       |
  #     And "forum" content:
  #     | title       | body                      | taxonomy_forums | field_related_content | moderation_state |
  #     | BEHAT Forum | This is Dataset Forum one | Datasets        | BEHAT Article         | published        |
  #   When I am on "/discussions"
  #     And I select "Datasets" from "Category"
  #     And I press "Apply"
  #   Then I should see the text "Published" in the "BEHAT Forum" row
  #     And I wait 1 seconds
  #     And I should not see the text "Archived" in the "BEHAT Forum" row
  #     And I click "BEHAT Forum"
  #   Then I should see the heading "BEHAT Forum"
  #   When I am on "/admin/content/discussions"
  #     And I click "Edit" in the "BEHAT Forum" row
  #     And I select "Archived" from "Change to"
  #     And I press "Post Discussion"
  #   Then I should see "Discussion BEHAT Forum has been updated."
  #   When I am on "/discussions"
  #   Then I should see the text "Archived" in the "BEHAT Forum" row
  #   When I click "BEHAT Forum"
  #   Then I should not see the link "Like"
  #     And I should not see the link "Reply"

  # @api @javascript
  # Scenario: Forum Moderator Can Reactivate A Discussion
  #   Given I am logged in as a user with the "Forum Moderator" role
  #     And "forum" content:
  #     | title       | body                      | taxonomy_forums | moderation_state |
  #     | BEHAT Forum | This is Dataset Forum one | Datasets        | archived         |
  #   When I am on "/discussions"
  #   Then I should see the text "Archived" in the "BEHAT Forum" row
  #   When I am on "/admin/content/discussions"
  #     And I click "Edit" in the "BEHAT Forum" row
  #     And I select "Published" from "Change to"
  #     And I press "Post Discussion"
  #   Then I should see "Discussion BEHAT Forum has been updated."
  #   When I am on "/discussions"
  #   Then I should not see the text "Archived" in the "BEHAT Forum" row
  #     And I should see the text "Published" in the "BEHAT Forum" row

  @api @javascript
  Scenario: Forum Moderator Can Delete A Comment
    Given I am logged in as a user with the "Forum Moderator" role
    When I am viewing a "forum" content:
      | title            | BEHAT Forum |
      | body             | description |
      | taxonomy_forums  | Datasets    |
      | moderation_state | published   |
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I should see the text "This is the First Reply"
      And I click "Delete" in the "reply_section" region
    Then I should see the text "Are you sure you want to delete the comment This is the First Reply?"
      And I press "Delete"
      And I should see "The comment and all its replies have been deleted."
      And I should not see the text "This is the First Reply"

  @api @javascript
  Scenario: Forum Moderator Can Reply To A Comment
    Given I am logged in as a user with the "Forum Moderator" role
    When I am viewing a "forum" content:
      | title            | BEHAT Forum |
      | body             | description |
      | taxonomy_forums  | Datasets    |
      | moderation_state | published   |
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I wait 1 seconds
      And I should see the text "This is the First Reply"
      And I click "Reply" in the "forum_comment" region
      And I type "This is the reply to a comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I wait 1 seconds
    Then I should see the text "This is the reply to a comment"

  @api @javascript
  Scenario: Forum Moderator Receives Email When Comments Are Posted On A Forum They Moderate
    Given I am logged in as a user with the "administrator" role
      And "forum" content:
      | title       | body                      | taxonomy_forums | field_forum_moderator |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | moderator             |
    When I am on "/discussions/behat-forum"
      And I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    Then I should see "Your comment has been posted."
    When I am on "/admin/reports/maillog"
    Then I should see the link 'Data Catalog Forum: "BEHAT Forum" has new comments'
      And I click 'Data Catalog Forum: "BEHAT Forum" has new comments'
      And I should see "moderator@email.com"
      And I should see "This is the First Comment"

  @api @javascript
  Scenario Outline: Authorized Users Can Like And UnLike An Existing Discussion
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "forum" content:
      | title            | BEHAT Forum |
      | body             | description |
      | taxonomy_forums  | Datasets    |
      | moderation_state | published   |
    Then I should see the link "Reply"
      And I should see the link "Like"
      And I should see "0"
      And I should not see the link "Unlike"
      And I click "Like"
      And I wait 1 seconds
      And I should not see the link "Like"
      And I should see the link "Unlike"
      And I should see "1"

    Examples:
      | role               |
      | Forum Moderator    |
      | sitebuilder        |
      | administrator      |
      | Content Creator    |
      | Content Approver   |
      | Authenticated user |

  @api @javascript
  Scenario Outline: Authorized Users Can Like And UnLike An Existing Comment
    Given I am logged in as a user with the "<role>" role
    When I am viewing a "forum" content:
      | title            | BEHAT Forum |
      | body             | description |
      | taxonomy_forums  | Datasets    |
      | moderation_state | published   |
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I wait 1 seconds
    Then I should see the link "Like" in the "forum_comment" region
      And I should see the link "Reply" in the "forum_comment" region
      And I should not see the link "Unlike" in the "forum_comment" region
    When I click "Like" in the "forum_comment" region
      And I wait 1 seconds
    Then I should not see the link "Like" in the "forum_comment" region
      And I should see the link "Unlike" in the "forum_comment" region

    Examples:
      | role             |
      | Forum Moderator  |
      | sitebuilder      |
      | administrator    |
      | Content Approver |

  @api @javascript
  Scenario: Content Creator Can Like And UnLike An Existing Comment
    Given I am logged in as a user with the "Content Creator" role
    When I am viewing a "forum" content:
      | title            | BEHAT Forum |
      | body             | description |
      | taxonomy_forums  | Datasets    |
      | moderation_state | published   |
      And I type "This is the First Reply" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I am on "/discussions/behat-forum"
    Then I should see the link "Like" in the "forum_comment" region
      And I should see the link "Reply" in the "forum_comment" region
      And I should not see the link "Unlike" in the "forum_comment" region
    When I click "Like" in the "forum_comment" region
      And I wait 1 seconds
    Then I should not see the link "Like" in the "forum_comment" region
      And I should see the link "Unlike" in the "forum_comment" region

  @api @javascript
  Scenario: Number Of Likes Displayed Near Like Button
    Given "forum" content:
      | title       | body                      | taxonomy_forums | moderation_state |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | published        |
    When I am logged in as a user with the "sitebuilder" role
      And I am on "/discussions/behat-forum"
    Then I click "Like" in the "like_discussion" region
      And I wait 1 seconds
      And I should see "1" in the "like_discussion" region
      And I am logged in as a user with the "Forum Moderator" role
      And I am on "/discussions/behat-forum"
      And I click "Like" in the "like_discussion" region
      And I wait 1 seconds
      And I should see "2" in the "like_discussion" region
      And I am logged in as a user with the "Content Creator" role
      And I am on "/discussions/behat-forum"
      And I click "Like"
      And I wait 1 seconds
      And I should see "3" in the "like_discussion" region
      And I click "Unlike"
      And I wait 1 seconds
      And I should not see "3" in the "like_discussion" region
      And I should see "2" in the "like_discussion" region

  @api @javascript
  Scenario Outline: Authorized Users Can View Forum Statistics
    Given "forum" content:
      | title         | body                      | taxonomy_forums | moderation_state |
      | BEHAT Forum   | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 1 | This is Dataset Forum one | Datasets        | published        |
    When I am logged in as a user with the "<role>" role
      And I am on "/admin/content/discussions"
      And I should see the text "Moderation state"
      And I should see the text "Title"
      And I should see the text "Category"
      And I should see the button "Filter"
      And I should see the text "Total Discussions"
      And I should see the text "Total Comments"
      And I should see the text "Total Participants"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 2"
      And I should see the text "Total Comments: 0"
      And I should see the text "Total Participants: 0"
      And I should see the text "0" in the "BEHAT Forum" row
      And I click "BEHAT Forum"
      And I type "This is the First Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    When I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 2"
      And I should see the text "Total Comments: 1"
      And I should see the text "Total Participants: 1"
      And I should see the text "1" in the "BEHAT Forum" row
      And I click "BEHAT Forum"
      And I type "This is the Second Comment" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
    When I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 2"
      And I should see the text "Total Comments: 2"
      And I should see the text "Total Participants: 1"
      And I should see the text "2" in the "BEHAT Forum" row
      And I am on "/discussions/behat-forum"
      And I click "Delete" in the "reply_section" region
      And I should see "Are you sure you want to delete the comment This is the First Comment?"
      And I press "Delete"
    When I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 2"
      And I should see the text "Total Comments: 2"
      And I should see the text "Total Participants: 1"
      And I am on "/discussions/behat-forum"
      And I click "Delete" in the "reply_section" region
      And I should see "Are you sure you want to delete the comment"
      And I press "Delete"
    When I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 2"
      And I should see the text "Total Comments: 2"
      And I should see the text "Total Participants: 1"

    Examples:
      | role             |
      | Forum Moderator  |
      | sitebuilder      |
      | administrator    |
      | Content Approver |

  @api @javascript
  Scenario: Verify Forum Statistics With Pagination
    Given "forum" content:
      | title          | body                      | taxonomy_forums | moderation_state |
      | BEHAT Forum    | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 1  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 2  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 3  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 4  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 5  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 6  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 7  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 8  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 9  | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 11 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 11 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 12 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 13 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 14 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 15 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 16 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 17 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 18 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 19 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 20 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 21 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 22 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 23 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 24 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 25 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 26 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 27 | This is Dataset Forum one | Datasets        | published        |
      | BEHAT Forum 28 | This is Dataset Forum one | Datasets        | published        |
    When I am logged in as a user with the "Forum Moderator" role
      And I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
    Then I should see the text "Total Discussions: 28"
      And I should see the text "Total Comments: 0"
      And I should see the text "Total Participants: 0"
      And I click "Last"
      And I should see the text "Total Discussions: 28"
      And I should see the text "Total Comments: 0"
      And I should see the text "Total Participants: 0"
      And I am on "/discussions/behat-forum"
      And I type "This is the behat forum Comment1" in the "Reply to this Discussion" WYSIWYG editor
      And I scroll to the bottom
      And I press "Post"
      And I type "This is the behat forum Comment2" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
      And I should see the text "Total Discussions: 28"
      And I should see the text "Total Comments: 2"
      And I should see the text "Total Participants: 1"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/discussions/behat-forum"
      And I type "This is the behat forum Comment3" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
      And I should see the text "Total Discussions: 28"
      And I should see the text "Total Comments: 3"
      And I should see the text "Total Participants: 2"
      And I am logged in as a user with the "authenticated user" role
      And I am on "/discussions/behat-forum"
      And I type "This is the behat forum Comment4" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am logged in as a user with the "Content Approver" role
      And I am on "/admin/content/discussions"
      And I fill in "Title" with "BEHAT Forum"
      And I press "Filter"
      And I should see the text "Total Discussions: 28"
      And I should see the text "Total Comments: 4"
      And I should see the text "Total Participants: 3"

  @api @javascript
  Scenario: Verify Related Discussions On Content Type Detailed Page
    Given I am logged in as a user with the "authenticated user" role
      And "data_set" content:
      | title         | field_dataset_description | moderation_state |
      | BEHAT Dataset | This is dataset1          | published        |
      And "article" content:
      | title         | body        | field_category | moderation_state |
      | BEHAT Article | article one | FAQ            | published        |
      And "tools" content:
      | title      | field_tool_category | field_dataset_description | moderation_state |
      | BEHAT Tool | Data Systems        | test                      | published        |
      And "data_insight" content:
      | title         | body             | moderation_state |
      | BEHAT Insight | This is the body | published        |
      And "statistics" content:
      | title         | Body          | field_r_and_s_category | moderation_state |
      | BEHAT R&S     | Testing r&s   | REPORTS                | published        |
      And "forum" content:
      | title       | body                      | taxonomy_forums | field_related_content                                              | moderation_state |
      | BEHAT Forum | This is Dataset Forum one | Datasets        | BEHAT Dataset, BEHAT Article, BEHAT Tool, BEHAT Insight, BEHAT R&S | published        |
    When I am on "/discussions/behat-forum"
    Then I should see "Related Content"
      And I should see the link "BEHAT Dataset"
      And I should see the link "BEHAT Article"
      And I should see the link "BEHAT Tool"
      And I should see the link "BEHAT Insight"
      And I should see the link "BEHAT R&S"
    When I click "BEHAT Dataset"
      And I wait 1 seconds
      And I click "Related Discussions"
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I should see the link "Start a New Discussion"
    When I click "BEHAT Forum"
      And I wait 1 seconds
      And I click "BEHAT Article"
      And I wait 1 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I should see the link "Start a New Discussion"
      And I wait 1 seconds
    When I click "BEHAT Forum"
      And I wait 1 seconds
      And I click "BEHAT Tool"
      And I wait 1 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I should see the link "Start a New Discussion"
    When I click "BEHAT Forum"
      And I wait 1 seconds
      And I click "BEHAT Insight"
      And I wait 1 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I should see the link "Start a New Discussion"
    When I click "BEHAT Forum"
      And I wait 1 seconds
      And I click "BEHAT R&S"
      And I wait 1 seconds
    Then I should see the text "Related Discussions"
      And I should see the link "BEHAT Forum"
      And I should see the link "Start a New Discussion"

  @api @javascript
  Scenario: Promote Discussion To Top Of List
    Given I am logged in as a user with the "authenticated user" role
      And "forum" content:
      | title                             | body                               | taxonomy_forums        | moderation_state | sticky | created  | changed  |
      | BEHAT Datasets Discussion         | This is Dataset Forum one          | Datasets               | published        | 1      | -9 days  | -6 days  |
      | BEHAT General Discussion          | This is General Forum one          | General                | published        | 1      | -9 days  | -5 days  |
      | BEHAT Tools Discussion            | This is Tools Forum one            | Tools                  | published        | 1      | -9 days  | -4 days  |
      | BEHAT Report and Stats Discussion | This is Report and Stats Forum one | Reports and Statistics | published        | 1      | -9 days  | -3 days  |
      | BEHAT Data Insights Discussion    | This is Data Insights Forum one    | Data Insights          | published        | 1      | -9 days  | -2 days  |
      | BEHAT Articles Discussion         | This is Articles Forum one         | Article                | published        | 1      | -9 days  | -1 days  |
    When I am on "/discussions"
    Then "BEHAT Articles Discussion" should precede "BEHAT Data Insights Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Data Insights Discussion" should precede "BEHAT Report and Stats Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Report and Stats Discussion" should precede "BEHAT Tools Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Tools Discussion" should precede "BEHAT General Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT General Discussion" should precede "BEHAT Datasets Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"

  @api @javascript
  Scenario: Promote Commented Discussion To Top Of List
    Given I am logged in as a user with the "authenticated user" role
      And "forum" content:
      | title                             | body                               | taxonomy_forums        | moderation_state | sticky | created  | changed  |
      | BEHAT Datasets Discussion         | This is Dataset Forum one          | Datasets               | published        | 1      | -9 days  | -6 days  |
      | BEHAT General Discussion          | This is General Forum one          | General                | published        | 1      | -9 days  | -5 days  |
      | BEHAT Tools Discussion            | This is Tools Forum one            | Tools                  | published        | 1      | -9 days  | -4 days  |
      | BEHAT Report and Stats Discussion | This is Report and Stats Forum one | Reports and Statistics | published        | 1      | -9 days  | -3 days  |
      | BEHAT Data Insights Discussion    | This is Data Insights Forum one    | Data Insights          | published        | 1      | -9 days  | -2 days  |
      | BEHAT Articles Discussion         | This is Articles Forum one         | Article                | published        | 1      | -9 days  | -1 days  |
    When I am on "/discussions"
    Then "BEHAT Articles Discussion" should precede "BEHAT Data Insights Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Data Insights Discussion" should precede "BEHAT Report and Stats Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Report and Stats Discussion" should precede "BEHAT Tools Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Tools Discussion" should precede "BEHAT General Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT General Discussion" should precede "BEHAT Datasets Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
    When I am logged in as a user with the "Content Approver" role
      And I visit "/discussions/behat-datasets-discussion"
      And I type "This is my comment so float me to the top" in the "Reply to this Discussion" WYSIWYG editor
      And I press "Post"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/discussions"
    Then "BEHAT Datasets Discussion" should precede "BEHAT Articles Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Data Insights Discussion" should precede "BEHAT Report and Stats Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Report and Stats Discussion" should precede "BEHAT Tools Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Tools Discussion" should precede "BEHAT General Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Articles Discussion" should precede "BEHAT Data Insights Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"

  @api @javascript
  Scenario: Undo Sticky To Top Of List For Discussion Topic
    Given I am logged in as a user with the "authenticated user" role
      And "forum" content:
      | title                             | body                               | taxonomy_forums        | moderation_state | sticky | created  | changed  |
      | BEHAT Datasets Discussion         | This is Dataset Forum one          | Datasets               | published        | 1      | -9 days  | -6 days  |
      | BEHAT General Discussion          | This is General Forum one          | General                | published        | 1      | -9 days  | -5 days  |
      | BEHAT Tools Discussion            | This is Tools Forum one            | Tools                  | published        | 1      | -9 days  | -4 days  |
      | BEHAT Report and Stats Discussion | This is Report and Stats Forum one | Reports and Statistics | published        | 1      | -9 days  | -3 days  |
      | BEHAT Data Insights Discussion    | This is Data Insights Forum one    | Data Insights          | published        | 1      | -9 days  | -2 days  |
      | BEHAT Articles Discussion         | This is Articles Forum one         | Article                | published        | 1      | -9 days  | -1 days  |
    When I am on "/discussions"
    Then "BEHAT Articles Discussion" should precede "BEHAT Data Insights Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Data Insights Discussion" should precede "BEHAT Report and Stats Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Report and Stats Discussion" should precede "BEHAT Tools Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Tools Discussion" should precede "BEHAT General Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT General Discussion" should precede "BEHAT Datasets Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
    When I am logged in as a user with the "administrator" role
      And I visit "/discussions/behat-articles-discussion/edit"
      And I press "Promotion options"
      And I uncheck "edit-sticky-value"
      And I press "Post Discussion"
      And I am logged in as a user with the "authenticated user" role
      And I visit "/discussions"
    Then "BEHAT Data Insights Discussion" should precede "BEHAT Report and Stats Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Report and Stats Discussion" should precede "BEHAT Tools Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Tools Discussion" should precede "BEHAT General Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT General Discussion" should precede "BEHAT Datasets Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"
      And "BEHAT Datasets Discussion" should precede "BEHAT Articles Discussion" for the query "//td[contains(@class, 'views-field views-field-title')]"

  @api @javascript
  Scenario: Site Visitor Can View Discussions Related To Application, Software And Platform
    Given I am logged in as a user with the "authenticated user" role
      And "forums" terms:
      | name             |
      | BEHAT Technology |
      And "application" content:
      | title             | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Application | description | summary       | division1                   | published        |
      And "component" content:
      | title           | field_summary | body                  | field_division_office_multi | moderation_state |
      | BEHAT Component | Summary       | Component description | division1                   | published        |
      And "platform" content:
      | title          | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Platform | description | summary       | division1                   | published        |
      And "forum" content:
      | title             | body                      | taxonomy_forums  | field_related_content                              | moderation_state |
      | BEHAT Discussions | This is Dataset Forum one | BEHAT Technology | BEHAT Application, BEHAT Component, BEHAT Platform | published        |
    When I visit "/discussions"
    Then I should see the link "BEHAT Discussions"
    When I click "BEHAT Discussions"
    Then I should see the text "Related Content"
      And I should see the link "BEHAT Application"
      And I should see the link "BEHAT Component"
      And I should see the link "BEHAT Platform"

  @api @javascript
  Scenario: Authenticated Users Can Add Image Using WYSIWYG On Discussion
    Given I am logged in as a user with the "authenticated user" role
      And I create "media" of type "image":
      | name              | field_media_image    | field_caption     |
      | SQL Logo          | behat-sql-logo.png   | Behat SQL Caption |
    When I am on "node/add/forum"
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I click "Image"
      And I wait for ajax to finish
      And I attach the file "behat-sql-logo.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "SQL"
      And I check "Caption"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.editor-image-dialog.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I press "Post Discussion"
    Then I should see the link "Rules of the Road"
      And I should see the "img" element with the "alt" attribute set to "SQL" in the "forum_content" region

  @api @javascript
  Scenario: Authenticated Users Adding Image And Caption Using Source WYSIWYG On Discussion
    Given I am logged in as a user with the "authenticated user" role
      And I create "media" of type "image":
      | name              | field_media_image    | field_caption     |
      | SQL Logo          | behat-sql-logo.png   | Behat SQL Caption |
    When I am on "node/add/forum"
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I click "Source"
      And I set css selector ".cke_source" with "<img alt='SQL' data-caption='new captions' data-entity-type='file' src='/sites/datacatalog01.dev.dd/files/inline-images/behat-sql-logo_60.png' />"
      And I press "Post Discussion"
    Then I should see the text "new captions"

  @api @javascript
  Scenario Outline: Authenticated Users Can Add File Using WYSIWYG On Discussion
    Given I am logged in as a user with the "authenticated user" role
    When I am on "node/add/forum"
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I click "File"
      And I wait for ajax to finish
      And I attach the file "<file>" to "File"
      And I wait for ajax to finish
      And I fill in "attributes[title]" with "Attachment"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.editor-file-dialog.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I press "Post Discussion"
    Then I should see the link "SEC Git"
      And I should see the link "<file>" in the "forum_content" region

      Examples:
        | name        | file                         |
        | PDF Format  | behat-file.pdf               |
        | DOC Format  | behat-file.doc               |
        | DOCX Format | behat-file.docx              |
        | XLS Format  | behat-file.xls               |
        | XLSX Format | behat-file.xlsx              |
        | PPT Format  | behat-file.ppt               |
        | PPTX Format | behat-file.pptx              |
        | CSV Format  | behat-file.csv               |
        | TXT Format  | behat-file.txt               |
        | WAVE Format | behat-Ascent.wav             |
        | JPG Format  | behat-black_rabbit.jpg       |
        | MSG Format  | behat-review.msg             |
        | ZIP Format  | behat-Newreview.zip          |
        | MP3 Format  | behat-Hair.mp3               |
        | DB Format   | behat-cversions.2.db         |
        | JSON Format | behat-TestJSON.json          |

  @api @javascript
  Scenario: Authenticated Users Can Add Link Using WYSIWYG On Discussion
    Given I am logged in as a user with the "authenticated user" role
    When I am on "node/add/forum"
      And I fill in "Title" with "BEHAT Topic About Dataset"
      And I select "Datasets" from "Category"
      And I click "Link (Ctrl+K)"
      And I wait for ajax to finish
      And I fill in "URL" with "www.google.com"
      And I fill in "attributes[title]" with "Link"
      And I click "Advanced"
      And I wait for ajax to finish
      And I check "Open in new window/tab"
      And I click on the element with css selector "body > div.ui-dialog.ui-corner-all.ui-widget.ui-widget-content.ui-front.editor-link-dialog.ui-dialog--narrow.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button"
      And I wait for ajax to finish
      And I press "Post Discussion"
    Then I should see the link "code snippets"
      And I should see the link "www.google.com"
    When I am on "/discussions/behat-topic-about-dataset/edit"
    Then I should see the text "You may edit or remove content from your discussion post; please contact the Data Catalog team if you would like the post to be deleted."
      And I should see the link "Data Catalog team"

  @api @javascript
  Scenario: Validate Content Panel On Discussion
    Given I am logged in as a user with the "authenticated user" role
     And "application" content:
     | title             | body        | field_summary | field_division_office_multi | moderation_state |
     | BEHAT Application | description | summary       | division1                   | published        |
     And "data_set" content:
     | title         | field_dataset_description | moderation_state |
     | BEHAT dataset | This is dataset1          | published        |
     And "component" content:
     | title           | field_summary | body                  | field_division_office_multi | moderation_state |
     | BEHAT Component | Summary       | Component description | division1                   | published        |
    When I am on "/discussions"
    Then I should see the link "Start a New Discussion"
    When I click "Start a New Discussion"
     And I fill in "Title" with "BEHAT User AU Discussion"
     And I select "Datasets" from "Category"
     And I type "This is the discussion for authenticated user" in the "Body" WYSIWYG editor
     And I select the first autocomplete option for "BEHAT Application" on the "Add Catalog Content Related to this Discussion" field
     And I press "Add another item"
     And I wait for ajax to finish
     And I select the first autocomplete option for "BEHAT dataset" on the "Add Catalog Content Related to this Discussion (value 2)" field
     And I press "Add another item"
     And I wait for ajax to finish
     And I select the first autocomplete option for "BEHAT Component" on the "Add Catalog Content Related to this Discussion (value 3)" field
     And I press "Post Discussion"
    Then I should see "Discussion BEHAT User AU Discussion has been created."
     And I should see "BEHAT User AU Discussion"
     And I should see "Related Content"
     And I should see the link "BEHAT Application"
     And I should see the text "(Application)"
     And I should see the link "BEHAT Component"
     And I should see the text "(Software)"
     And I should see the link "BEHAT Component"
     And I should see the link "BEHAT dataset"
     And I should see the text "(Dataset)"
