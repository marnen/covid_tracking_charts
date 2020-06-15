@vcr
Feature: Link header to welcome page

Background:
  Given I am using cassettes from 6 June 2020

Scenario:
  Given I am on the page for MA
  When I click on the header
  Then I should be on the welcome page
