Feature: Get data for one state
  As a user
  I can see data for one state
  So that I can track recent activity in that state

@vcr
Scenario Outline:
  Given today is <date>
  When I visit the page for <state>
  Then I should see data for <state> on <date>

  Examples:
 | date        | state |
 | 15 Mar 2020 | MA    |
