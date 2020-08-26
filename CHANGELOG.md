# Unreleased changes

# v2.6.0 / 2020-08-26

- Change all API requests to use new api.covidtracking.com hostname. [#55]

# v2.5.3 / 2020-06-28

- Update Rails to 6.0.3.2 for security. [#64]

# v2.5.2 / 2020-06-28

- Update Rack to 2.2.3 for security. [#63]

# v2.5.1 / 2020-06-15

- Update Puma to 4.3.5 for security. [#53]
- Update Rails to 6.0.3.1 for security. [#61]
- Update websocket-extensions gem and NPM module to avoid a security issue. [#54, #57]
- Mock date so cassettes don't expire. [#58]

# v2.5.0 / 2020-06-06

- Make state code lowercase in API calls now that COVID Tracking API requires that. [#55]

# v2.4.1 / 2020-05-17

- Set up Rollbar for error handling. [#51]

# v2.4.0 / 2020-05-17

- Update API client code for new URL scheme. [#49]

# v2.3.0 / 2020-04-13

- Introduce Cells gem to make views and controllers more manageable. [#47]

# v2.2.0 / 2020-04-10

- Set default time zone to Eastern, since that's what the covidtracking.com API uses for all states. [#38]

# v2.1.1 / 2020-04-09

- Fix a bug in asset compilation on Heroku.

# v2.1.0 / 2020-04-09

- Use choices.js to provide a more attractive UI for state selector. [#42]

# v2.0.0 / 2020-04-09

- Show multiple states on graph at once. [#37]

# v1.3.1 / 2020-04-07

- Run multiple requests through hydra. [#15]

# v1.3.0 / 2020-04-07

- Set default time zone to Pacific so that current date will be correct for more of the US. [#33]
- Use released version of guard-cucumber now that it supports Cucumber 3. [#35]

# v1.2.0 / 2020-04-07

- Use SVG instead of externally generated images for charts. [#5]

# v1.1.0 / 2020-04-06

- Put all display text in translatable strings and install fast_gettext so we can translate the UI easily. [#9]

# v1.0.0 / 2020-04-05

First public release.
