FROM rails:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

CMD bundle exec rails s -b 0.0.0.0 -p 3000
