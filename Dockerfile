FROM ruby:2.7.1

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

RUN bundle config set force_ruby_platform true
RUN bundle config set without 'development test'

WORKDIR /app

ADD Gemfile* ./
RUN bundle install

COPY . .

RUN RAILS_ENV=production \
     SECRET_KEY_BASE=1 \
     DATABASE_URL="postgres://db" \
     bundle exec rails assets:precompile

ENV RAILS_ENV=production

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server"]