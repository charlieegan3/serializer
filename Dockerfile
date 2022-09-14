FROM ruby:2.7.1

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

RUN bundle config set force_ruby_platform true
RUN bundle config set without 'development test'

WORKDIR /app

ADD Gemfile* ./
RUN bundle install

ENV RAILS_ENV production
ENV SECRET_KEY_BASE 1
ENV DATABASE_URL postgres://postgres:postgres@db:5432

RUN rails assets:precompile

COPY . .

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server"]