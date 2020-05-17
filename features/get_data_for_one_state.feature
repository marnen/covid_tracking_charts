Feature: Get data for one state
  As a user
  I can see data for one state
  So that I can track recent activity in that state

@vcr
Scenario Outline:
  Given today is <date>
  When I visit the page for <state>
  Then I should see a graph for <state> for the 30 days ending on <date>

  Examples:
    | date        | state |
    | 12 Apr 2020 | MA    |
    | 2 Apr 2020  | NY    |
    # TODO: 12 April is now the earliest date for which we have 30 days of historical data in MA (it was 2 April, so I'm not sure what happened...). We should figure out what to do for older days, and also test with other days as time goes on.
