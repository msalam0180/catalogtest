Feature: Charts or Graphs
  As a Content Creator,
  I want add graphs and charts to Drupal so that I let users view data in a way that is easy to understand.

  @api @javascript
  Scenario: Authorized Users Can Create, Edit And Delete A Bar Chart
    Given I am logged in as a user with the "Content Creator" role
      And "tags" terms:
        | name       |
        | automation |
    When I am on "/node/add/chart"
      And I fill in "Title" with "BEHAT Bar Chart"
      And I fill in "Short Description" with "Behat Short"
      And I type "BEHAT bar chart body" in the "Body" WYSIWYG editor
      And I fill in "Graph Name" with "BEHAT Graph"
      And I should see the text "Leaving this field empty will delete this graph."
      And I press "Series 1"
      And I select "Bar Chart" from "Series Type"
      And I should see "The type of series which this graph entry represents. Configuration options for this series type will be available after you select this option and save. Choosing `None` will have the effect of deleting this series. For more information on series types, see https://plot.ly/javascript/#basic-charts"
      And I press "Save"
      And I wait for ajax to finish
      And I hover over the element "article.contextual-region > div:nth-child(1) > button"
      And I press "Open configuration options"
      And I click on the element with css selector ".entitynodeedit-form"
      And I wait for ajax to finish
      And I press "Series 1"
      And I fill in "Name" with "BEHAT Chart Name"
      And I should see the text "Documentation name `name`. Sets the trace name. The trace name appear as the legend item and on hover."
      And I should see the text "Documentation name `visible`. Determines whether or not this trace is visible. If `legendonly`, the trace is not drawn, but can appear as a legend item (provided that the legend itself is visible)."
      And I should see the text "Documentation name `x`. Data should be input in the format VALUE1,VALUE2,VALUE3,VALUE4,etc... Multiple arrays should be entered one on each line. Sets the x coordinates."
      And I should see the text "Documentation name `y`. Data should be input in the format VALUE1,VALUE2,VALUE3,VALUE4,etc... Multiple arrays should be entered one on each line. Sets the y coordinates."
      And I fill in "X Values" with "Brocoli, Zukini, Carrots, Peas"
      And I fill in "Y Values" with "60, 56, 40, 52"
      And I select the autocomplete option for "automation" on the "Tags" field
      And I press "Save"
    Then I should see the heading "BEHAT Bar Chart"
      And I should see the text "BEHAT Graph"
      And I should see the text "Brocoli"
      And I should see the text "60"
      And I should see the text "Zukini"
      And I should see the text "Carrots"
      And I should see the text "Peas"
      And I should see the text "Tags"
      And I should see the link "automation"
    When I visit "/chart/behat-bar-chart/edit"
      And I click on the element with css selector "#edit-field-graph-0-series-data-0 > summary"
      And I fill in "X Values" with "Grapes, Apple, Strawberry, Blueberry"
      And I press "Save"
    Then I should not see the text "Brocoli"
      And I should not see the text "Zukini"
      And I should not see the text "Carrots"
      And I should not see the text "Peas"
      And I should see the text "Grapes"
      And I should see the text "Apple"
      And I should see the text "Strawberry"
      And I should see the text "Blueberry"
      And I wait 5 seconds
    When I press "configuration options"
      And I click on the element with css selector ".entitynodedelete-form"
    Then I should see the heading "Are you sure you want to delete the content item BEHAT Bar Chart?"
      And I press "Delete"
      And I should see "The Chart BEHAT Bar Chart has been deleted."
    When I am on "/chart/behat-bar-chart"
    Then I should see "Page not found"

  @api @javascript
  Scenario: Content Creator Can Create A Line Chart
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/chart"
      And I fill in "Title" with "BEHAT Line Chart"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT chart body" in the "Body" WYSIWYG editor
      And I fill in "Graph Name" with "BEHAT Line Graph"
      And I press "Series 1"
      And I select "Scatter Plot" from "Series Type"
      And I press "Save"
      And I wait 4 seconds
      And I am on "/chart/behat-line-chart/edit"
      And I wait 1 seconds
      And I press "Series 1"
      And I fill in "Name" with "BEHAT Chart Name"
      And I fill in "X Values" with "Brocoli, Zukini, Carrots, Peas"
      And I fill in "Y Values" with "60, 56, 40, 52"
      And I press "Save"
    Then I should see the heading "BEHAT Line Chart"
      And I should see the text "BEHAT Line Graph"
      And I should see the text "Brocoli"
      And I should see the text "60"
      And I should see the text "Zukini"
      And I should see the text "Carrots"
      And I should see the text "Peas"

  @api @javascript
  Scenario: Create A Chart With Out Graph Name
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/chart"
      And I fill in "Title" with "BEHAT Line Chart"
      And I fill in "Short Description" with "behat short"
      And I type "BEHAT chart body" in the "Body" WYSIWYG editor
      And I fill in "Graph Name" with "BEHAT Line Graph"
      And I press "Series 1"
      And I select "Scatter Plot" from "Series Type"
      And I press "Save"
      And I wait 4 seconds
      And I visit "/chart/behat-line-chart/edit"
      And I wait 1 seconds
      And I press "Series 1"
      And I fill in "Name" with "BEHAT Chart Name"
      And I fill in "X Values" with "Brocoli, Zukini, Carrots, Peas"
      And I fill in "Y Values" with "60, 56, 40, 52"
      And I press "Save"
    Then I should see the heading "BEHAT Line Chart"
      And I should see the text "BEHAT chart body"
      And I should see the text "BEHAT Line Graph"
      And I should see the text "Brocoli"
      And I should see the text "60"
      And I should see the text "Zukini"
      And I should see the text "Carrots"
      And I should see the text "Peas"
    When I visit "/chart/behat-line-chart/edit"
      And I fill in "Graph Name" with ""
      And I press "Save"
    Then I should see the heading "BEHAT Line Chart"
      And I should not see the text "BEHAT Line Graph"
      And I should not see the text "Brocoli"
      And I should not see the text "Zukini"
      And I should not see the text "Carrots"
      And I should not see the text "Peas"

  @api
  Scenario: Verify Chart Labels, Help Texts And Required Fields
    Given I am logged in as a user with the "Content Creator" role
    When I am on "/node/add/chart"
    Then I should see the text "Title"
      And I should see the text "Short Description"
      And I should see the text "Body"
      And I should see the text "Graph Name"
      And I should see the text "Leaving this field empty will delete this graph."
      And I should see the text "Responsive"
      And I should see the text "Search Keywords"
      And I should see the text "Tags"
      And I should see the text "Short Description text will show in search results and list pages"
      And I should see the text "Add search index terms to improve search results. Include spelling variations, common spelling errors, and high priority keywords."
      And I should see the text "Start typing to find and select subject terms that describe this content. If the term does not exist, you can add it as a new tag."
    When I press "Save"
    Then I should see the text "Title field is required."
