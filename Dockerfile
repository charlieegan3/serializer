FROM ruby:3.4.7

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

RUN bundle config set force_ruby_platform true
RUN bundle config set without 'development test'

WORKDIR /app

ADD Gemfile* .ruby-version ./
RUN bundle install

COPY . .
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN RAILS_ENV=production \
     SECRET_KEY_BASE=1 \
     DATABASE_URL="postgres://db" \
     bundle exec rails assets:precompile

ENV RAILS_ENV=production

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server"]