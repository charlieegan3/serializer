FROM ruby:2.4.1

WORKDIR /app

RUN gem install bundler -v 1.17.3
RUN gem install rake -v 12.3.1
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app
RUN rm -rf tmp || true

RUN DATABASE_URL=none bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0 -p 3000
