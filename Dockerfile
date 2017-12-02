FROM ruby:2.4

RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
