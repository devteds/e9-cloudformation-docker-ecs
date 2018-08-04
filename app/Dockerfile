FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /sapp
WORKDIR /sapp

ADD Gemfile /sapp/Gemfile
ADD Gemfile.lock /sapp/Gemfile.lock

RUN bundle install

ADD . /sapp

CMD ["ruby", "service.rb", "-o", "0.0.0.0"]
