@vcr
Feature: Get data for multiple states together
  As a user
  I can see data for multiple states together
  So that I can compare recent activity in those states

Scenario Outline:
  Given today is <date>
  When I visit the page for <states>
  Then I should see a graph for <states> for the 30 days ending on <date>

  Examples:
    | date        | states     |
    | 10 Apr 2020 | MA, NY, CT |
    # TODO: 2 April is the earliest date for which we have 30 days of historical data. We should figure out what to do for older days, and also test with other days as time goes on.

Scenario: Normalize state parameters alphabetically by abbreviation
  When I visit the page for AL, WY, AK
  Then I should be on the page for AK, AL, WY
