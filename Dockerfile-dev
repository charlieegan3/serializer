FROM ruby:2.4.1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . /app
RUN rm tmp || true

CMD bundle exec rails s -b 0.0.0.0 -p 3000
