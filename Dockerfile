FROM ruby:2.7.1-alpine
MAINTAINER Marnen Laibow-Koser <marnen@marnen.org>

RUN apk --no-cache add build-base git nodejs yarn tzdata

ARG workdir=/covid_tracking_charts
ARG rails_port=3000

ENV BUNDLE_PATH=/bundle
ENV BUNDLE_BIN=/bundle/bin
ENV GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

WORKDIR ${workdir}
COPY . ${workdir}/

EXPOSE ${rails_port}
ENV PORT ${rails_port}
