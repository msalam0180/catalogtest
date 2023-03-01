Feature: Revisions on node pages
  As a Site Visitor or a user I should be able to manage my content versions more effectively by viewing content revisions

  Background:
    Given users:
      | name      | mail              | roles             |
      | approver1 | approver1@test.com | content_approver |
      | approver2 | approver2@test.com | content_approver |
      And "division_office" terms:
        | name         |
        | division1    |
        | division2    |
        | new division |
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
      And "application_status" terms:
        | name           |
        | BEHAT Status A |
        | BEHAT Status B |
      And "status" terms:
        | name           |
        | BEHAT Approve  |
      And "forums" terms:
        | name         |
        | General      |
      And "data_category" terms:
        | name      |
        | category1 |

@api @javascript
Scenario Outline: See changes between article revisions using the diff module including deletion and nav links
  #Create revision 0
  Given "article" content:
      | title             | field_summary | body                | field_category | field_reviewer | moderation_state |
      | BEHAT Article One | Short         | Article description | Other          | approver1      | published        |
  #Editing to create revision 1
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/behat-article-one/edit"
    And I fill in "Title" with "BEHAT Article One - v1"
    And I fill in "Short Description" with "Short - v1"
    And I select "Tools" from "Category"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Article BEHAT Article One - v1 has been updated."
  #Iterating as each role to see differences between revision 0 & 1
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-article-one-v1/revisions"
  Then I should see the heading "Revisions for BEHAT Article One - v1"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Article One - v1"
    And I should see the text "BEHAT Article One - v1" in the "BEHAT Article One" row
    And I should see the text "<p>Article description</p>" in the "Article description" row
    And I should see the text "Tools" in the "Other" row
    And I should see the text "approver2" in the "approver1" row
  #Editing to create revision 2
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/behat-article-one-v1/edit"
    And I fill in "Title" with "BEHAT Article One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I select "None" from "Category"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Article BEHAT Article One - v2 has been updated."
  #Iterating as each role to see differences between revision 1 & 2
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-article-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Article One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Article One - v2"
    And I should see the text "BEHAT Article One - v2" in the "BEHAT Article One - v1" row
    And I should see the text "Tools" in the "revision2_diff_category_col1" region
    And I should not see the text "Tools" in the "revision2_diff_category_col2" region
    And I should see the text "Short - v2" in the "Short - v1" row
  #Editing to create revision 3
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/behat-article-one-v2/edit"
    And I fill in "Title" with "BEHAT Article One - v3"
    And I fill in "Short Description" with "Short - v3"
    And I select "Dashboard" from "Category"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Article BEHAT Article One - v3 has been updated."
  #Iterating as each role to see differences between revisions 1, 2 & 3
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-article-one-v3/revisions"
  Then I should see the heading "Revisions for BEHAT Article One - v3"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Article One - v3"
    And I should see the text "BEHAT Article One - v3" in the "BEHAT Article One - v2" row
    And I should see the text "Short - v3" in the "Short - v2" row
    And I should not see the text "Dashboard" in the "revision3_diff_category_col1" region
    And I should see the text "Dashboard" in the "revision3_diff_category_col2" region
  When I click "Previous change"
  Then I should see the text "BEHAT Article One - v2" in the "BEHAT Article One - v1" row
    And I should see the text "Tools" in the "revision2_diff_category_col1" region
    And I should not see the text "Tools" in the "revision2_diff_category_col2" region
    And I should see the text "Short - v2" in the "Short - v1" row
  When I click "Previous change"
  Then I should see the text "BEHAT Article One - v1" in the "BEHAT Article One" row
    And I should see the text "<p>Article description</p>" in the "Article description" row
    And I should see the text "Tools" in the "Other" row
    And I should see the text "approver2" in the "approver1" row
  When I click "Next change"
  Then I should see the text "BEHAT Article One - v2" in the "BEHAT Article One - v1" row
    And I should see the text "Tools" in the "revision2_diff_category_col1" region
    And I should not see the text "Tools" in the "revision2_diff_category_col2" region
    And I should see the text "Short - v2" in the "Short - v1" row
  When I click "Next change"
    And I click on the element with css selector "#block-adminimal-theme-content > header > div.diff-revision.js-form-item.form-item.js-form-type-item.form-type-item.js-form-item-.form-item- > div > div:nth-child(1) > div"
  Then I should see the heading "BEHAT Article One - v3"
  When I am on "/behat-article-one-v3/revisions"
    And I press the "Compare selected revisions" button
    And I click on the element with css selector "#block-adminimal-theme-content > header > div.diff-revision.js-form-item.form-item.js-form-type-item.form-type-item.js-form-item-.form-item- > div > div:nth-child(2) > div"
  Then I should see the heading "BEHAT Article One - v2"

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between platforms revisions using the diff module
  Given "platform" content:
      | title              | body         | field_summary | field_division_office_multi | field_status_usage | field_reviewer | moderation_state |
      | BEHAT Platform One | description1 | summary1      | division1                   | BEHAT Approve      | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/platforms/behat-platform-one/edit"
    And I fill in "Title" with "BEHAT Platform One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Platform BEHAT Platform One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/platforms/behat-platform-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Platform One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Platform One - v2"
    And I should see the text "BEHAT Platform One - v2" in the "BEHAT Platform One" row
    And I should see the text "<p>description1</p>" in the "description1" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between applications revisions using the diff module
  Given "application" content:
      | title                 | body         | field_summary | field_app_status | field_owner | field_reviewer | moderation_state |
      | BEHAT Application One | description1 | summary1      | BEHAT Status A   | division1   | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/applications/behat-application-one/edit"
    And I fill in "Title" with "BEHAT Application One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Application BEHAT Application One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/applications/behat-application-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Application One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Application One - v2"
    And I should see the text "BEHAT Application One - v2" in the "BEHAT Application One" row
    And I should see the text "<p>description1</p>" in the "description1" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between software revisions using the diff module
  Given "component" content:
      | title               | body                     | field_summary | field_status_usage | field_division_office_multi | field_reviewer | moderation_state |
      | BEHAT Component One | Description of component | summary1      | BEHAT Approve      | division1                   | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/software/behat-component-one/edit"
    And I fill in "Title" with "BEHAT Component One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Software BEHAT Component One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/software/behat-component-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Component One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Component One - v2"
    And I should see the text "BEHAT Component One - v2" in the "BEHAT Component One" row
    And I should see the text "<p>Description of component</p>" in the "Description of component" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between tool revisions using the diff module
  Given "tools" content:
      | title          | field_dataset_description | field_reviewer | moderation_state |
      | BEHAT Tool One | its tool time             | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/tool/behat-tool-one/edit"
    And I fill in "Title" with "BEHAT Tool One - v2"
    And I type "Updating tool - v2" in the "Description" WYSIWYG editor
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Tool BEHAT Tool One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/tool/behat-tool-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Tool One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Tool One - v2"
    And I should see the text "BEHAT Tool One - v2" in the "BEHAT Tool One" row
    And I should see the text "<p>Updating tool - v2its tool time</p>" in the "its tool time" row
    And I should see the text "approver2" in the "approver1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between datasets revisions using the diff module
  Given "data_set" content:
      | title             | field_dataset_description | field_summary | field_owner | field_division_office_multi | field_data_category | field_open_government_data_acces | field_open_government_data_class | field_reviewer | moderation_state |
      | BEHAT Dataset One | this is the body          | summary1      | division1   | division2                   | category1           | DAaccess                         | DAclassification                 | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/datasets/behat-dataset-one/edit"
    And I fill in "Title" with "BEHAT Dataset One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I type "Updating dataset - v2" in the "Description" WYSIWYG editor
    And I click "Governance"
    And I select "new division" from "Owner"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Dataset BEHAT Dataset One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/datasets/behat-dataset-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Dataset One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Dataset One - v2"
    And I should see the text "BEHAT Dataset One - v2" in the "BEHAT Dataset One" row
    And I should see the text "<p>Updating dataset - v2this is the body</p>" in the "this is the body" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between chart revisions using the diff module
  Given "chart" content:
      | title           | body |  field_summary | field_data_search_index | moderation_state |
      | BEHAT Chart One | body |  summary1      | XnY-axis                | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/chart/behat-chart-one/edit"
    And I fill in "Title" with "BEHAT Chart One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I type "Updating chart - v2" in the "Body" WYSIWYG editor
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Chart BEHAT Chart One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/chart/behat-chart-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Chart One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Chart One - v2"
    And I should see the text "BEHAT Chart One - v2" in the "BEHAT Chart One" row
    And I should see the text "<p>Updating chart - v2body</p>" in the "body" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between discussions revisions using the diff module
  Given "forum" content:
      | title                   | body                  | taxonomy_forums | moderation_state |
      | BEHAT General Forum One | This is General Forum | General         | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/discussions/behat-general-forum-one/edit"
    And I fill in "Title" with "BEHAT General Forum One - v2"
    And I select "Technology" from "Category"
    And I type "Updating Forum One - v2" in the "Body" WYSIWYG editor
    And I select "Published" from "Change to"
    And I press "Post Discussion"
  Then I should see the text "Discussion BEHAT General Forum One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/discussions/behat-general-forum-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT General Forum One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT General Forum One - v2"
    And I should see the text "BEHAT General Forum One - v2" in the "BEHAT General Forum One" row
    And I should see the text "<p>Updating Forum One - v2This is General Forum</p>" in the "This is General Forum" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between form revisions using the diff module
  Given "forms" content:
      | title          | body                   | field_further_details | moderation_state |
      | BEHAT Form One | Description about Form | Further Details       | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/forms/behat-form-one/edit"
    And I fill in "Title" with "BEHAT Form One - v2"
    And I type "Updating form - v2" in the "Description" WYSIWYG editor
    And I type "These are" in the "Further Details" WYSIWYG editor
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Forms BEHAT Form One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/forms/behat-form-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Form One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Form One - v2"
    And I should see the text "BEHAT Form One - v2" in the "BEHAT Form One" row
    And I should see the text "<p>Updating form - v2Description about Form</p>" in the "Description about Form" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between reports-statistics revisions using the diff module
  Given "statistics" content:
      | title             | body               | field_summary | field_reviewer | moderation_state |
      | BEHAT Reports One | This is test body  | summary1      | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/reports-statistics/behat-reports-one/edit"
    And I fill in "Title" with "BEHAT Reports One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I type "Updating Rpts+Stats - v2" in the "Description" WYSIWYG editor
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Reports and Statistics BEHAT Reports One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/reports-statistics/behat-reports-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Reports One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Reports One - v2"
    And I should see the text "BEHAT Reports One - v2" in the "BEHAT Reports One" row
    And I should see the text "<p>Updating Rpts+Stats - v2This is test body</p>" in the "This is test body" row
    And I should see the text "BEHAT Reports One - v2" in the "BEHAT Reports One" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between data-insights revisions using the diff module
  Given "data_insight" content:
      | title             | body                  | field_summary | field_reviewer | moderation_state |
      | BEHAT Insight One | This is the body test | summary1      | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/data-insights/behat-insight-one/edit"
    And I fill in "Title" with "BEHAT Insight One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I type "BEHAT Data Insight - v2" in the "Bottom Line Up Front" WYSIWYG editor
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Data Insight BEHAT Insight One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/data-insights/behat-insight-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Insight One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Insight One - v2"
    And I should see the text "BEHAT Insight One - v2" in the "BEHAT Insight One" row
    And I should see the text "<p>BEHAT Data Insight - v2This is the body test</p>" in the "This is the body test" row
    And I should see the text "BEHAT Insight One - v2" in the "BEHAT Insight One" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "summary1" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between landing-page revisions using the diff module
  Given "landing_page" content:
      | title                  | field_summary | field_reviewer | moderation_state |
      | BEHAT Landing Page One | new landing   | approver1      | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/behat-landing-page-one/edit"
    And I fill in "Title" with "BEHAT Landing Page One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I select the autocomplete option for "approver2" on the "Reviewer" field
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Landing Page BEHAT Landing Page One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-landing-page-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Landing Page One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Landing Page One - v2"
    And I should see the text "BEHAT Landing Page One - v2" in the "BEHAT Landing Page One" row
    And I should see the text "approver2" in the "approver1" row
    And I should see the text "Short - v2" in the "new landing" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: See changes between info-page revisions using the diff module
  Given "page" content:
      | title               | body             | field_summary | moderation_state |
      | BEHAT Info Page One | This is the body | page 1234     | published        |
  #Editing to create a revision
  When I am logged in as a user with the "sitebuilder" role
    And I am on "/behat-info-page-one/edit"
    And I fill in "Title" with "BEHAT Info Page One - v2"
    And I fill in "Short Description" with "Short - v2"
    And I type "BEHAT Info Page One - v2" in the "Body" WYSIWYG editor
    And I select "Published" from "Change to"
    And I press the "Save" button
  Then I should see the text "Informational Page BEHAT Info Page One - v2 has been updated."
  #Iterating as each role to see differences between revisions
  When I am logged in as a user with the "<role>" role
    And I am on "/behat-info-page-one-v2/revisions"
  Then I should see the heading "Revisions for BEHAT Info Page One - v2"
    And I should see the text "Current revision"
  When I press the "Compare selected revisions" button
  Then I should see the heading "Changes to BEHAT Info Page One - v2"
    And I should see the text "BEHAT Info Page One - v2" in the "BEHAT Info Page One" row
    And I should see the text "<p>BEHAT Info Page One - v2This is the body</p>" in the "This is the body" row
    And I should see the text "Short - v2" in the "page 1234" row

  Examples:
    | role             |
    | Content Creator  |
    | Content Approver |
    | sitebuilder      |
