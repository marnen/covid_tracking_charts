FROM ruby:2.7.1-alpine
MAINTAINER Marnen Laibow-Koser <marnen@marnen.org>

ARG workdir=/covid_tracking_charts
ARG rails_port=3000

WORKDIR ${workdir}
COPY . ${workdir}/

EXPOSE ${rails_port}
ENV PORT ${rails_port}
