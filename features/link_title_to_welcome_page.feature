Feature: Link header to welcome page

@vcr
Scenario:
  Given I am on the page for MA
  When I click on the header
  Then I should be on the welcome page
