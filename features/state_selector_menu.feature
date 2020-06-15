@vcr
Feature: State selector menu
  As a user
  I can select the states I'm interested in from a menu
  So I can quickly jump from one region's dataset to another

Background:
  Given I am using cassettes from 6 June 2020
  And I am on the page for CA
  When I deselect "California" from the state menu

Scenario Outline: Select single state
  When I select "<state>" from the state menu
  And I click "Go"
  Then I should be on the page for <state_abbr>
  And "<state>" should be selected in the state menu

  Examples:
    | state    | state_abbr |
    | Arkansas | AR         |

Scenario Outline: Select multiple states
  When I select "<state1>" from the state menu
  And I select "<state2>" from the state menu
  And I click "Go"
  Then I should be on the page for <state_abbr1>, <state_abbr2>
  And "<state1>" should be selected in the state menu
  And "<state2>" should be selected in the state menu

  Examples:
    | state1      | state_abbr1 | state2   | state_abbr2 |
    | Connecticut | CT          | Delaware | DE          |
