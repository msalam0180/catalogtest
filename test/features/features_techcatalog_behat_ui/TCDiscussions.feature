Feature: Create A Discussion
  As a Content Creator, I should be able to create Discussion page.

  Background:
    Given "division_office" terms:
      | name      |
      | division1 |
      And users:
      | name | mail          | pass | roles  |
      | auth | auth@test.com | auth |        |

  @ui @api @javascript @wdio
  Scenario: Discussions Page For WDIO
    Given "forums" terms:
      | name             |
      | BEHAT Technology |
      And "application" content:
      | title                     | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT App With Discussion | description | summary       | division1                   | published        |
      And "component" content:
      | title                      | field_summary | body                  | field_division_office_multi | moderation_state |
      | BEHAT Comp With Discussion | Summary       | Component description | division1                   | published        |
      And "platform" content:
      | title                      | body        | field_summary | field_division_office_multi | moderation_state |
      | BEHAT Plat With Discussion | description | summary       | division1                   | published        |
      And "forum" content:
      | title             | body                                                          | taxonomy_forums  | field_related_content                                                              | moderation_state |
      | BEHAT Discussions | This is a discusion for Applications, Component and Platforms | BEHAT Technology | BEHAT App With Discussion , BEHAT Comp With Discussion, BEHAT Plat With Discussion | published        |
    When I am logged in as a user with the "authenticated user" role
    Then I take a screenshot using "discussion.feature" file with "@discussion" tag
      And I take a screenshot using "discussion.feature" file with "@app_discussion" tag
      And I take a screenshot using "discussion.feature" file with "@comp_discussion" tag
      And I take a screenshot using "discussion.feature" file with "@plat_discussion" tag
      And I take a screenshot using "discussion.feature" file with "@landing_discussions" tag

  @api @javascript @wdio
  Scenario: Discussion With Image For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And I create "media" of type "image":
      | name              | field_media_image    | field_caption     |
      | SQL Logo          | behat-sql-logo.png   | Behat SQL Caption |
    When I am on "node/add/forum"
      And I fill in "Subject" with "Discussion with Image"
      And I select "Datasets" from "Category"
      And I click "Image"
      And I wait for ajax to finish
      And I attach the file "behat-sql-logo.png" to "Image"
      And I wait for ajax to finish
      And I fill in "Alternative text" with "SQL"
      And I click on the element with css selector "button[class='button js-form-submit form-submit btn-success btn icon-before ui-button ui-corner-all ui-widget']"
      And I press "Save"
    Then I take a screenshot using "discussion.feature" file with "@discussion_image" tag
    When I click on the element with css selector ".comment-reply"
      And I click "Edit"
      And I type "New comment" in the "Reply" WYSIWYG editor
      And I press "Save"

  @api @javascript @wdio
  Scenario: Discussion With Attachment For WDIO
    Given I am logged in as a user with the "authenticated user" role
      And I create "media" of type "files":
      | KEY   | name       |
      | Behat | PDF Format |
    When I am on "node/add/forum"
      And I fill in "Subject" with "Discussion with file"
      And I select "Datasets" from "Category"
      And I click "File"
      And I wait for ajax to finish
      And I attach the file "behat-file.pdf" to "File"
      And I wait for ajax to finish
      And I fill in "Title" with "Attachment"
      And I click on the element with css selector "button[class='button js-form-submit form-submit btn-success btn icon-before ui-button ui-corner-all ui-widget']"
      And I wait for ajax to finish
      And I press "Save"
    Then I take a screenshot using "discussion.feature" file with "@discussion_file" tag

  @api @javascript @wdio
  Scenario: Discussion With Link For WDIO
    Given I am logged in as a user with the "authenticated user" role
    When I am on "node/add/forum"
      And I fill in "Subject" with "Discussion with link"
      And I select "Datasets" from "Category"
      And I click "Link (Ctrl+K)"
      And I wait for ajax to finish
      And I fill in "URL" with "www.google.com"
      And I fill in "Title" with "Link"
      And I click "Advanced"
      And I wait for ajax to finish
      And I check "Open in new window/tab"
      And I click on the element with css selector "button[class='button js-form-submit form-submit btn-success btn icon-before ui-button ui-corner-all ui-widget']"
      And I wait for ajax to finish
      And I press "Save"
    Then I take a screenshot using "discussion.feature" file with "@discussion_link" tag

  @api @javascript @wdio
  Scenario: Comments For WDIO
    Given I am logged in as a user with the "authenticated user" role
    When I am on "node/add/forum"
      And I fill in "Subject" with "Discussion with Comment"
      And I select "Datasets" from "Category"
      And I type "This is the summary of the topic" in the "Body" WYSIWYG editor
      And I press "Save"
      And I type "This is the reply to the comment" in the "Reply" WYSIWYG editor
      And I press "Save"
    Then I take a screenshot using "discussion.feature" file with "@discussion_comment" tag
