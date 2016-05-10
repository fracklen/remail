FROM ruby:2.3

RUN mkdir -p /var/www/app

WORKDIR /var/www/app
EXPOSE 8080

ADD Gemfile Gemfile.lock /var/www/app/

RUN bundle

ADD . /var/www/app/
ENV RAILS_ENV production
