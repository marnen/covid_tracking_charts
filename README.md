# COVID Tracking Charts

## Overview

This application presents data on the incidence of COVID-19. Currently, the data comes from [The COVID Tracking Project](http://covidtracking.com), and the primary focus is on presenting time series charts of U.S. data by state, but we are trying to expand the scope as the project grows.

The application is hosted at http://covid-tracking-charts.herokuapp.com, and the code is available under GPL 3.

BTW, this is a labor of love developed for the purpose of public service. Currently we're getting by with a free Heroku account, but if any hosting provider wants to donate additional resources, get in touch—we could use a little more infrastructure capacity!

## Technical details

This is a Rails 6 application, but since all the data comes from the COVID Tracking Project API, we're not using ActiveRecord at the moment (though we could always add it if it became necessary to implement some particular feature). Instead, we're pulling all the data with [Typhoeus](https://github.com/typhoeus/typhoeus), and caching it (currently for 6 hours), then feeding it to the [svg-graph](https://github.com/lumean/svg-graph2) gem to draw nice charts.

### Development

The easiest way to run a development instance of this application is probably to use Docker. The project already contains Docker configuration files, so `docker-compose up` should start both a Rails server for the Web application and a Redis server to run the cache. Modify the paths in docker-compose.yml as necessary for your local filesystem bindings.

### Hosting

Currently, this application is hosted on the free tier of Heroku, with a free-tier RedisCloud add-on for caching. The application automatically deploys from the `deploy` branch in this repo, as long as tests pass.

### Testing

We develop test-first and story-first. Our normal workflow is to write a Cucumber scenario to document a new feature, and then develop each component necessary to make it pass test-first with RSpec. We run tests locally with Guard, and every branch and pull request is [tested automatically on Travis](https://travis-ci.org/github/marnen/covid_tracking_charts).

We use [WebMock](https://github.com/bblimke/webmock) and [VCR](https://github.com/vcr/vcr) to record interactions with remote services for testing. If you've never used these gems, [this overview](http://marnen.github.io/webmock-presentation/webmock.html) might be helpful.

## Contributing

Contributions are welcome! Please follow the following general guidelines if possible:

* Check our product backlog at https://github.com/marnen/covid_tracking_charts/projects/1.
* Use feature branches and pull requests to contribute code.
* Try to keep the website accessible to visually impaired users and those with minimal browser support. If adding JavaScript, try to follow the progressive enhancement pattern so that those users without JavaScript support have a reasonable UX too.
* For a pull request to be accepted, it must have *passing* RSpec tests, and (if the UI is affected) *passing* Cucumber scenarios. If you don't know how to test something, please feel free to ask for ideas; we'll be happy to help.
* Also, please make sure to put an entry in the "unreleased changes" section of the [change log][CHANGELOG.md] with a brief human-readable description of your change. A reference to the relevant issue or pull request would also be great (something like `[#123]` is sufficient). When in doubt, follow existing entries.
* Please keep the code readable and maintainable. Feel free to refactor and rearrange what's already here, as long as you've got tests in place to make sure that nothing got broken in the process.
* Above all, have fun and be bold! When in doubt, err on the side of audacity. We can always scale things back if we need to.
