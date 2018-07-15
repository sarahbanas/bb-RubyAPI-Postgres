FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /railsapi
WORKDIR /railsapi

COPY Gemfile /railsapi/Gemfile
COPY Gemfile.lock /railsapi/Gemfile.lock

RUN bundle install

COPY . /railsapi