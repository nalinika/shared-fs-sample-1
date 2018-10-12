FROM ruby:2.5.1-alpine

RUN apk add --no-cache build-base imagemagick \
  postgresql-client postgresql-dev nodejs tzdata

COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN bundle install
