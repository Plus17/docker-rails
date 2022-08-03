FROM ruby:3.1.2-slim-bullseye

# This sets the environment variable DEBIAN_FRONTEND that
# all subsequent commands will see in their environments.
# This particular variable tells the `apt-get` command
# to run in a non-iteractive way, so we don't have to provide
# user input when using `apt-get`
ENV DEBIAN_FRONTEND noninteractive

ENV LANG=C.UTF-8

# Common dependencies
RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    libpq-dev \
    libvips42 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# In order to use Postgres 12, we have to add their package repo to install it from there.
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/" \
    bullseye-pgdg main 12 | tee /etc/apt/sources.list.d/postgres.list > /dev/null
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-12 \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# We need to install bundler explicitly,
# to use a updated version
RUN gem install bundler

# This configures RubyGems to not install documentation,
# which will speed up gem installs. It also sets vi mode
# for bash (I'm a vim person so I need this :), and finally
# installs Rails.
RUN echo "gem: --no-document" >> ~/.gemrc && echo "set -o vi" >> ~/.bashrc && gem install rails --version ">= 7.0.3"

RUN echo "RUBYOPT=-W:no-deprecated" >> /etc/environment &&  echo "export RUBYOPT=-W:no-deprecated" >> ~/.profile
