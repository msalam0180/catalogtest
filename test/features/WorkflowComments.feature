Feature: Workflow Comments
  As an admin
  I want to be add comments to content during the workflow process
  An email log should be created and sent when the workflow is changed.

Background:
    Given users:
      | name     | mail              | roles            |
      | approver | approver@test.com | Content Approver |
      | creator  | create@test.com   | Content Creator  |

  @api
  Scenario: Draft To Published Comments
    Given "article" content:
      | title                      | body | field_category | field_reviewer |
      | draft to published comment | test | FAQ            | approver       |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
      And I click "draft to published comment"
      And I select "Published" from "Change to"
      And I fill in "Log message" with "Content looks great"
      And I press "Apply"
      And I am on "/admin/content"
      And I click "Edit" in the "draft to published comment" row
      And I click "Revisions"
    Then I should see the text "Revision"
      And I should see the text "Content looks great"
      And I should see the text "by Anonymous"
      And I should see the Text "Operations"
      And I should see the text "Current revision"
      And I should see the text "Revert"

  @api
  Scenario: Draft To Rejected Comments
    Given "article" content:
      | title                     | body | field_category |
      | draft to rejected comment | test | FAQ            |
      And I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
      And I click "draft to rejected comment"
      And I select "Review" from "Change to"
      And I fill in "Log message" with "Content needs review"
      And I press "Apply"
      And I select "Reject" from "Change to"
      And I fill in "Log message" with "Content needs work"
      And I press "Apply"
      And I am on "/admin/content"
      And I click "Edit" in the "draft to rejected comment" row
      And I click "Revisions"
    Then I should see the text "Revision"
      And I should see the text "Content needs work (Rejected)"
      And I should see the text "by Anonymous"
      And I should see the Text "Operations"
      And I should see the text "Current revision"
      And I should see the text "Revert"

  @api @javascript
  Scenario: Comments Maillog
    Given I am logged in as a user with the "administrator" role
    When I am on "/admin/reports/maillog/delete/all"
      And I press "Clear"
    Then I should see the text "All maillog entries have been deleted."
    When I am logged in as "creator"
      And I am on "/node/add/article"
      And I fill in "Title" with "maillog comments"
      And I type "BEHAT Dataset Description" in the "Body" WYSIWYG editor
      And I fill in "Short Description" with "BEHAT Short Description"
      And I select the autocomplete option for "approver" on the "Reviewer" field
      And I select "Review" from "Save as"
      And I press "Save"
      And I am logged in as a user with the "administrator" role
      And I am on "/admin/reports/maillog"
    Then I should see the text "Content by creator is ready for review" in the "create@test.com" row
      And I should see the text "Content by creator is ready for review" in the "approver@test.com" row
    When I click "Content by creator is ready for review" in the "approver@test.com" row
    Then I should see the text "Updated by: creator"
    When I am on "/admin/content"
      And I click "Edit" in the "maillog comments" row
      And I select "Published" from "Change to"
      And I press "Save"
      And I am on "/admin/reports/maillog"
    Then I should see the text "Your content has been published" in the "create@test.com" row
