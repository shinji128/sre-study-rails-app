# ARG RUBY_VERSION
# ARG RAILS_ENV

FROM ruby:3.3.6
ENV APP_HOME=/var/www/sre-study/ \
    RAILS_ENV=development

WORKDIR $APP_HOME

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips default-mysql-client

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN if [ $RAILS_ENV = "staging" ] || [ $RAILS_ENV = "production" ]; then \
  bundle config set --local without 'development test'; fi && \
  echo bundle install $RAILS_ENV && bundle install;
RUN bundle install

COPY . .

CMD ["bundle", "exec", "pumactl", "start"]
