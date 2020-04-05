Feature: State selector menu
  As a user
  I can select the state I'm interested in from a menu
  So I can quickly jump from one region's dataset to another

@vcr
Scenario Outline:
  Given I am on the page for <state_abbr1>
  When I select "<state2>" from the state menu
  And I click "Go"
  Then I should be on the page for <state_abbr2>
  And "<state2>" should be selected in the state menu

  Examples:
    | state_abbr1 | state2   | state_abbr2 |
    | CA          | Arkansas | AR          |
